//
//  CLCoreDataStack.h
//  AldoMCEv1
//
//  Created by Michael Lan on 2014-10-28.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLCoreDataStack : NSObject {
    NSManagedObjectModel * _managedObjectModel;
    NSPersistentStoreCoordinator * _persistentStoreCoordinator;
    NSPersistentStore * _persistentStore;
    NSManagedObjectContext * _managedObjectContext;
    BOOL _shouldRemoveStoreOnDealloc;
    NSMutableSet * _monitoringContexts;
}

+ (CLCoreDataStack *) temporaryStackWithModelName: (NSString *) modelName configuration: (NSString *) configuration;
- (id) initWithModelName: (NSString *) modelName configuration: (NSString *) configuration storeURL: (NSURL *) storeURL;
- (id) initWithModelName: (NSString *) modelName configuration: (NSString *) configuration storeURL: (NSURL *) storeURL options: (NSDictionary *) options;
- (BOOL) save: (NSError **) error;
- (BOOL) removeStore: (NSError **) error;

- (NSManagedObjectContext *) newChildContext NS_RETURNS_NOT_RETAINED;
- (void) mergeChangesFromContext: (NSManagedObjectContext *) context;

@property (nonatomic, assign) BOOL shouldRemoveStoreOnDealloc;

@property (nonatomic, readonly) NSManagedObjectModel * managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (nonatomic, readonly) NSPersistentStore * persistentStore;
@property (nonatomic, readonly) NSManagedObjectContext * managedObjectContext;

@end
