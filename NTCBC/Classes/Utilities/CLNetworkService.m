//
//  CLNetworkService.m
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-05-24.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "CLNetworkService.h"
#import "CLBlockOperation.h"

static CLNetworkService *_service = nil;
static NSUInteger kServiceConnectionSerialNum = 1000;

typedef void (^KBServiceRequestHandler)(CLServiceConnection *connection, NSURLResponse *response, NSData * data, NSError *error);

#pragma mark KBServiceConnection

@interface CLServiceConnection : NSObject <NSURLConnectionDelegate>

@property (nonatomic, retain) NSMutableURLRequest *request;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, copy) KBServiceRequestHandler handler;
@property (nonatomic, retain) NSHTTPURLResponse *response;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, assign) NSInteger conID;
@end

@implementation CLServiceConnection
@synthesize request = _request;
@synthesize data = _data;
@synthesize handler = _handler;
@synthesize response = _response;
@synthesize error = _error;
@synthesize conID = _conID;

- (CLServiceConnection *) initWithRequest: (NSMutableURLRequest *) request completionHandler: (KBServiceRequestHandler)handler {
    self = [super init];
    if (self) {
        self.error = nil;
        self.data = nil;
        self.response = nil;
        self.request = request;
        _handler = [handler copy];
    }
    return self;
}

- (BOOL) startWithSynchronousRequest: (BOOL) isSync {
    if (_request != nil) {
        //Logging for the request
        /*
        if ([KBUserSettings logAllXML]) {
            ASLogDebug(@"Start Service Connection: %@", [_request URL]);
            ASLogDebug(@"Request Header: %@", [_request allHTTPHeaderFields]);
            NSString *body = [[NSString alloc] initWithData:[_request HTTPBody] encoding:NSUTF8StringEncoding];
            ASLogDebug(@"Request Body: %@", body);
        }*/
        
        if (isSync) {
            self.error = nil;
            self.response = nil;
            
            NSError *error = nil;
            NSHTTPURLResponse *response = nil;
            
            self.data = [NSURLConnection sendSynchronousRequest:self.request returningResponse:&response error:&error];
            
            _response = response;
            _error = error;
            
            if (_error) {
                // TO DO: May handle different error codes here
                NSLog(@"Service Connection has failed with request to %@", _response.URL);
                NSLog(@"Error: %@", _error);
                
            }
            _handler(self, _response, _data, _error);
            
        } else {
            [NSURLConnection sendAsynchronousRequest:self.request
                                               queue:[CLNetworkService asyncNetworkOperationQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       [self completeAsyncWithResponse:(NSHTTPURLResponse *)response data:data error:error];
                                   }];
        }
        return YES;
        
    } else {
        NSLog(@"KBServiceConnection: Request has not been initiated! Aborting ...");
        return NO;
    }
}

- (void)completeAsyncWithResponse: (NSHTTPURLResponse *)response data: (NSData *)data error: (NSError *)error {
    self.error = error;
    if (_error) {
        NSLog(@"Service Connection has failed with request to %@", response.URL);
        NSLog(@"Error: %@", error);
        
    } else {
        self.response = response;
        self.data = data;
    }
    _handler(self, response, data, error);
}

@end

@implementation CLNetworkService
@synthesize networkOperations = _networkOperations;

+ (CLNetworkService *)sharedInstance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _service = [[CLNetworkService alloc] init];
    });
    
    return _service;
}

- (id)init {
    self = [super init];
    
    if (self) {
        _networkOperations = [[NSMutableArray alloc] init];
        _serviceNetworkOperationQ = dispatch_queue_create("com.kobo.service.networkQ", DISPATCH_QUEUE_CONCURRENT);
        
        _asyncNetworkOperationQ = [[NSOperationQueue alloc] init];
        _asyncNetworkOperationQ.name = @"com.kobo.service.asyncQ";
        _asyncNetworkOperationQ.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (dispatch_queue_t) serviceNetworkOperationQueue {
    return _serviceNetworkOperationQ;
}

- (NSOperationQueue *) asyncNetworkOperationQueue {
    //API 5 testing
    //ASLogDebug(@"# of operations in the queue: %d", _asyncNetworkOperationQ.operationCount);
    return _asyncNetworkOperationQ;
}

+ (dispatch_queue_t) serviceNetworkOperationQueue
{
	return ([[self sharedInstance] serviceNetworkOperationQueue]);
}

+ (NSOperationQueue *) asyncNetworkOperationQueue {
    return [[self sharedInstance] asyncNetworkOperationQueue];
}

+ (BOOL)checkEtagInResponse: (NSURLResponse *) response {
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
    if (httpResponse == nil)
        return NO;
    
    return ([httpResponse statusCode] != 304);
}

#pragma mark Request functions

+ (NSString *)addOperationToQueueWithBlock: (void (^)(void)) block {
    NSString *operationID = nil;
    __block CLBlockOperation *operation = [[CLBlockOperation alloc] initWithOperationID:[[CLNetworkService sharedInstance] generateOperationID]];
    if (operation == nil)
        return nil;
    
    __weak CLBlockOperation *weakOp = operation;
    
    [operation addExecutionBlock:^{
        if (![weakOp isCancelled]) {
            block();
        }
    }];
    operationID = operation.operationID;
    
    [[CLNetworkService asyncNetworkOperationQueue] addOperation:operation];
    return operationID;
}

+ (void)cancelOperationFromQueueWithID: (NSString *)operationID {
    NSArray * operations = [[CLNetworkService asyncNetworkOperationQueue] operations];
    for (CLBlockOperation *operation in operations) {
        if ([operation.operationID isEqualToString:operationID]) {
            [operation cancel];
            NSLog(@"KBService: Operation %@ has been cancelled.", operationID);
            NSLog(@"KBService: Operation Detail: %@", operation.description);
            return;
        }
    }
    
    NSLog(@"KBService: Operation %@ cannot be found. It not longer exists in the queue.", operationID);
}

+ (CLServiceConnection *) startWithServiceRequest:(NSMutableURLRequest *)request synchronous: (BOOL)isSync completionHandler:(CLServiceResponseHandler)handler {
    KBServiceRequestHandler requestHandler = ^(CLServiceConnection *connection, NSURLResponse * response, NSData *data, NSError *error) {
        //TO DO
        [[CLNetworkService sharedInstance] completeWithConnection: connection completionHandler: handler];
    };
    
    CLServiceConnection *connection = [[CLServiceConnection alloc] initWithRequest:request completionHandler:requestHandler];
    if (connection != nil) {
        connection.conID = [[CLNetworkService sharedInstance] getConnectionSerialNumber];
        [[CLNetworkService sharedInstance] networkOperationInitiatedWithConnection:connection];
        if ([connection startWithSynchronousRequest:isSync] == NO) {
            NSLog(@"KBService Failed: request is not created properly. ");
            return nil;
        }
    }
    
    return connection;
}

+ (NSString *)allOperationsInNetworkQueue {
    NSArray * operations = [[CLNetworkService asyncNetworkOperationQueue] operations];
    NSString * operationDescription = nil;
    if ([operations count] <= 0) {
        NSLog(@"KBService: No operation in the queue at this moment");
        return nil;
    } else {
        operationDescription = @"KBService: operations in the queue: \n";
    }
    
    for (CLBlockOperation * operation in operations) {
        operationDescription = [operationDescription stringByAppendingString:operation.description];
    }
    NSLog(@"%@", operationDescription);
    return operationDescription;
}

- (void)resetServiceNetworkQueue {
    if (_serviceNetworkOperationQ) {
        dispatch_suspend(_serviceNetworkOperationQ);
        _serviceNetworkOperationQ = nil;
    }
    
    _serviceNetworkOperationQ = dispatch_queue_create("com.kobo.service.networkQ", DISPATCH_QUEUE_CONCURRENT);
}

- (void)resetAsyncNetworkQueue {
    if (_asyncNetworkOperationQ) {
        [_asyncNetworkOperationQ cancelAllOperations];
        _asyncNetworkOperationQ = nil;
    }
    _asyncNetworkOperationQ = [[NSOperationQueue alloc] init];
    _asyncNetworkOperationQ.name = @"com.kobo.service.asyncQ";
    _asyncNetworkOperationQ.maxConcurrentOperationCount = 1;
}

- (void)pauseAllNetworkActivities{
    [_asyncNetworkOperationQ setSuspended: YES];
    dispatch_suspend([self serviceNetworkOperationQueue]);
}

- (void)resumeAllNetworkActivities {
    [_asyncNetworkOperationQ setSuspended: NO];
    dispatch_resume([self serviceNetworkOperationQueue]);
}

- (void)cancelAllNetworkActivities {
    [self pauseAllNetworkActivities];
    
    [self resetAsyncNetworkQueue];
    [self resetServiceNetworkQueue];
}

#pragma mark -

- (NSInteger)getConnectionSerialNumber {
    return kServiceConnectionSerialNum++;
}

- (NSString *)generateOperationID {
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef.
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

- (void)networkOperationInitiatedWithConnection: (CLServiceConnection *)connection {
    //TO DO
    [_networkOperations addObject:connection];
}

- (void)completeWithConnection: (CLServiceConnection *)connection completionHandler: (CLServiceResponseHandler) handler{
    //TO DO
    NSURLResponse *response = connection.response;
    NSData * data = connection.data;
    NSError *error = connection.error;
    NSLog(@"Response: %@", response);
    
    handler(response, data, error);
    
    [_networkOperations removeObject:connection];
}

@end
