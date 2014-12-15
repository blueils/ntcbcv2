//
//  CLPerThreadManagedObjectContext.h
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-10.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import <CoreData/NSManagedObjectContext.h>

#define COUNT_OBJECT_CONTEXTS	0

#if COUNT_OBJECT_CONTEXTS
extern volatile int32_t __context_count;
@interface CLCountedNSManagedObjectContext : NSManagedObjectContext
{
	NSString *	_creationBacktrace;
}
@end
#endif

extern NSManagedObjectContext * PerThreadManagedObjectContext( void );

// SPI-- used only by the above method and the app delegate
extern void StoreManagedObjectContextForCurrentThread( NSManagedObjectContext * context );
extern void ClearAllThreadsManagedObjectContexts();