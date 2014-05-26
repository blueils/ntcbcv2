//
//  CLNetworkService.h
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-05-24.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLServiceConnection;

typedef void (^CLServiceResponseHandler)(NSURLResponse *response, NSData * data, NSError *error);

@interface CLNetworkService : NSObject {
    NSMutableArray *_networkOperations;
    
	dispatch_queue_t _serviceNetworkOperationQ;
    NSOperationQueue * _asyncNetworkOperationQ;
}

@property (nonatomic, readonly) NSMutableArray *networkOperations;

+ (CLNetworkService *)sharedInstance;

// Network Operation Core
- (NSString *)generateOperationID;
+ (NSString *)addOperationToQueueWithBlock: (void (^)(void)) block;
+ (NSString *)allOperationsInNetworkQueue;
+ (dispatch_queue_t) serviceNetworkOperationQueue;
+ (NSOperationQueue *) asyncNetworkOperationQueue;
- (void)resetServiceNetworkQueue;
- (void)resetAsyncNetworkQueue;
- (void)pauseAllNetworkActivities;
- (void)resumeAllNetworkActivities;
- (void)cancelAllNetworkActivities;
+ (void)cancelOperationFromQueueWithID: (NSString *)operationID;

@end
