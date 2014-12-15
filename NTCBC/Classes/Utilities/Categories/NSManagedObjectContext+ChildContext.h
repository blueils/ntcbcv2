//
//  NSManagedObjectContext+ChildContext.h
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-10.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (ChildContext)

- (NSManagedObjectContext *) newChildManagedObjectContext NS_RETURNS_NOT_RETAINED;

@end
