//
//  CLCoreDataStack.m
//  AldoMCEv1
//
//  Created by Michael Lan on 2014-10-28.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "CLCoreDataStack.h"
#import "NSManagedObjectContext+ChildContext.h"
#import "ASLogger.h"

@implementation CLCoreDataStack
@synthesize  managedObjectModel = _managedObjectModel, persistentStoreCoordinator = _persistentStoreCoordinator, persistentStore = _persistentStore, managedObjectContext = _managedObjectContext, shouldRemoveStoreOnDealloc = _shouldRemoveStoreOnDealloc;

+ (CLCoreDataStack *) temporaryStackWithModelName: (NSString *) modelName configuration: (NSString *) configuration
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidStr = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    NSString * path = [[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_%@", (configuration == nil ? @"Default" : configuration), uuidStr]] stringByAppendingPathExtension: @"tmpstore"];
    CFRelease(uuidStr);
    
    CLCoreDataStack * stack = [[self alloc] initWithModelName: modelName configuration: configuration storeURL: [NSURL fileURLWithPath: path]];
    stack.shouldRemoveStoreOnDealloc = YES;
    
    return ( stack );
}

- (id) initWithModelName:(NSString *)modelName configuration:(NSString *)configuration storeURL:(NSURL *)storeURL {
    return [self initWithModelName:modelName configuration:configuration storeURL:storeURL options:nil];
}

- (id) initWithModelName: (NSString *) modelName configuration: (NSString *) configuration storeURL: (NSURL *) storeURL options:(NSDictionary *)options
{
    self = [super init];
    if ( self == nil )
        return ( nil );
    
    _monitoringContexts = [NSMutableSet new];
    
    NSString * path = [[NSBundle mainBundle] pathForResource: modelName ofType: @"momd"];
    if ( path == nil )
        path = [[NSBundle mainBundle] pathForResource: modelName ofType: @"mom"];
    if ( path == nil )
    {
        return ( nil );
    }
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path]];
    if ( _managedObjectModel == nil )
    {
        return ( nil );
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: _managedObjectModel];
    if ( _persistentStoreCoordinator == nil )
    {
        return ( nil );
    }
    
    NSError * error = nil;
    _persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType: NSSQLiteStoreType configuration: configuration URL: storeURL options: options error: &error];
    if ( _persistentStore == nil )
    {
        ASLogError( @"Error adding persistent store at URL %@ : %@", storeURL, error);
        return ( nil );
    }
    
    _managedObjectContext = [NSManagedObjectContext new];
    if ( _managedObjectContext == nil )
    {
        return ( nil );
    }
    
    [_managedObjectContext setMergePolicy: NSMergeByPropertyObjectTrumpMergePolicy];
    [_managedObjectContext setPersistentStoreCoordinator: _persistentStoreCoordinator];
    
    return ( self );
}

- (void) dealloc
{
    for ( NSManagedObjectContext * moc in _monitoringContexts )
    {
        [[NSNotificationCenter defaultCenter] removeObserver: self name: NSManagedObjectContextDidSaveNotification object: moc];
    }
    
    if ( _persistentStore != nil && _shouldRemoveStoreOnDealloc )
        [_persistentStoreCoordinator removePersistentStore: _persistentStore error: NULL];
}

- (BOOL) save: (NSError **) error
{
    return ( [_managedObjectContext save: error] );
}

- (BOOL) removeStore: (NSError **) error
{
    if ( _persistentStore == nil )
        return ( NO );
    
    if ( [_persistentStoreCoordinator removePersistentStore: _persistentStore error: error] == NO )
        return ( NO );
    
    BOOL result = [[NSFileManager defaultManager] removeItemAtPath: [[_persistentStore URL] path] error: error];
    _persistentStore = nil;
    
    return ( result );
}

- (NSManagedObjectContext *) newChildContext
{
    NSManagedObjectContext * result = [_managedObjectContext newChildManagedObjectContext];
    if ( [result respondsToSelector: @selector(parentContext)] == NO || [result parentContext] != _managedObjectContext )
        [self mergeChangesFromContext: result];
    return ( result );
}

- (void) mergeChangesFromContext: (NSManagedObjectContext *) context
{
    if ( [_monitoringContexts containsObject: context] )
        return;
    if ( context == _managedObjectContext )
        return;
    if ( context == nil)
        return;
    
    [_monitoringContexts addObject:context];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(contextDidSave:)
                                                 name: NSManagedObjectContextDidSaveNotification
                                               object: context];
}

- (void) contextDidSave: (NSNotification *) note
{
    [_managedObjectContext mergeChangesFromContextDidSaveNotification: note];
}

@end
