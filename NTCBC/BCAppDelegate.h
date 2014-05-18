//
//  BCAppDelegate.h
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-05-15.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// App Startup Tasks
- (void) dataLoading: (UIApplication *) application withOptions: (NSDictionary*) launchOptions;
- (void) dataLoadingDidComplete: (NSDictionary *) params;
- (void) setupApplication: (UIApplication *) application withOptions: (NSDictionary*) launchOptions;

@end
