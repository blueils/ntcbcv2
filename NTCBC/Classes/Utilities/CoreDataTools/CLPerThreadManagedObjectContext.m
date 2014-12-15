//
//  CLPerThreadManagedObjectContext.m
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-10.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "CLPerThreadManagedObjectContext.h"
#import "CLCommon.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+ChildContext.h"
#import <objc/runtime.h>

static NSString * const CLPerThreadManagedObjectContext = @"CLPerThreadManagedObjectContext";
static NSString * const CLPerThreadStoreManagedObjectContext = @"CLPerThreadStoreManagedObjectContext";

#if COUNT_OBJECT_CONTEXTS

#import <libkern/OSAtomic.h>

volatile int32_t __context_count = 0;
static CFMutableSetRef __allContexts = NULL;

@implementation CLCountedNSManagedObjectContext

+ (void) initialize
{
	if ( self != [CLCountedNSManagedObjectContext class] )
		return;
	
	CFSetCallBacks cbs = {
		.version = 0,
		.retain = NULL,
		.release = NULL,
		.copyDescription = CFCopyDescription,
		.equal = CFEqual,
		.hash = CFHash
	};
	
	__allContexts = CFSetCreateMutable( kCFAllocatorDefault, 0, &cbs );
}

- (id) init
{
	self = [super init];
	if ( self == nil )
		return ( nil );
	
	_creationBacktrace = [BacktraceString(1) copy];
	CFSetAddValue(__allContexts, self);
	NSLog( @"%d managed object contexts in use", OSAtomicIncrement32Barrier(&__context_count) );
	
	return ( self );
}

- (void) dealloc
{
	CFSetRemoveValue(__allContexts, self);
	NSLog( @"%d managed object contexts in use", OSAtomicDecrement32Barrier(&__context_count) );
	[_creationBacktrace release];
	[super dealloc];
}

@end

#define NSManagedObjectContext CLCountedNSManagedObjectContext

#endif
NSMutableSet *threadsManagedObjectContexts = nil;
NSManagedObjectContext * PerThreadManagedObjectContext( void )
{
    NSManagedObjectContext * result = [[[NSThread currentThread] threadDictionary] objectForKey: CLPerThreadManagedObjectContext];
    if ( result != nil )
        return ( result );
    NSManagedObjectContext * moc = [GetMainObjectContext() newChildManagedObjectContext];
	[moc setMergePolicy: NSMergeByPropertyObjectTrumpMergePolicy];
    StoreManagedObjectContextForCurrentThread( moc );
    
    return ( moc );
}

void StoreManagedObjectContextForCurrentThread( NSManagedObjectContext * context )
{
    if (threadsManagedObjectContexts == nil) {
        threadsManagedObjectContexts = [NSMutableSet new];
    }
    
    NSThread *currentThread = [NSThread currentThread];
	if (context == nil) {
		[[currentThread threadDictionary] removeObjectForKey:CLPerThreadManagedObjectContext];
        @synchronized(threadsManagedObjectContexts) {
            [threadsManagedObjectContexts removeObject:currentThread];
        }
	} else {
		[[currentThread threadDictionary] setObject: context forKey: CLPerThreadManagedObjectContext];
        @synchronized(threadsManagedObjectContexts) {
            [threadsManagedObjectContexts addObject:currentThread];
        }
	}
    
}

void ClearAllThreadsManagedObjectContexts() {
    @synchronized(threadsManagedObjectContexts) {
        for (NSThread *thread in threadsManagedObjectContexts) {
            [[thread threadDictionary] removeObjectForKey:CLPerThreadManagedObjectContext];
        }
        [threadsManagedObjectContexts removeAllObjects];
    }
}
