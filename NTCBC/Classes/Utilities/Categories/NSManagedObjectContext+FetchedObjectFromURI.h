//
//  NSManagedObjectContext+FetchedObjectFromURI.h
//  AldoMCEv1
//
//  Created by Michael Lan on 2014-07-08.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (FetchedObjectFromURI)
- (NSManagedObject *)objectWithURI:(NSURL *)uri;
@end
