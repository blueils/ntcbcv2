//
//  NSManagedObjectContext+ChildContext.m
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-10.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "NSManagedObjectContext+ChildContext.h"

@implementation NSManagedObjectContext (ChildContext)

- (NSManagedObjectContext *) newChildManagedObjectContext
{
	NSManagedObjectContext * child = [NSManagedObjectContext new];
#if 0
	if ( [self respondsToSelector: @selector(concurrencyType)] && [self concurrencyType] != NSConfinementConcurrencyType )
	{
		[child setParentContext: self];
	}
	else
#endif
	{
		[child setPersistentStoreCoordinator: [self persistentStoreCoordinator]];
	}
	
	return ( child );
}

@end
