//
//  CLBlockOperation.m
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-05-24.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "CLBlockOperation.h"

NSString *KBBlockOperationHasFinishedExecuting = @"KBBlockOperationHasFinishedExecuting";

@implementation CLBlockOperation
@synthesize operationID = _operationID;

- (id)initWithOperationID: (NSString *)operationID{
    self = [super init];
    if (self) {
        self.operationID = operationID;
        MAKE_WEAK_SELF();
        self.completionBlock = ^{
            USE_WEAK_SELF();
            //TO DO: Fire a notification with the operationID to indicate that this operation has finished executing.
            NSLog(@"KBBlockOperation: operation %@ has finished!", me->_operationID);
            NSString *operationID = me.operationID;
            [[NSNotificationCenter defaultCenter] postNotificationName:KBBlockOperationHasFinishedExecuting object:operationID userInfo:nil];
        };
        [self setQueuePriority:NSOperationQueuePriorityNormal];
    }
    return self;
}

- (NSString *)queuePriorityDescription {
    NSString *priority = nil;
    switch ([self queuePriority]) {
        case NSOperationQueuePriorityVeryHigh:
            priority = @"Highest Priority";
            break;
        case NSOperationQueuePriorityHigh:
            priority = @"High Priority";
            break;
        case NSOperationQueuePriorityLow:
            priority = @"Low Priority";
            break;
        case NSOperationQueuePriorityVeryLow:
            priority = @"Lowest Priority";
            break;
        case NSOperationQueuePriorityNormal:
        default:
            priority = @"Normal Priority";
            break;
    }
    return priority;
}

- (NSString *)threadPriorityDescription {
    double priority = [self threadPriority];
    if (priority == 1.0)
        return @"Highest Priority";
    else if (priority == 0.0)
        return @"Lowest Priority";
    else if (priority == 0.5)
        return @"Normal Priority";
    else if (priority > 0.5)
        return @"High Priority";
    else if (priority < 0.5)
        return @"Low Priority";
    else
        return @"N/A";
    
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"KBBlockOperation = {\n"
                             "\toperationID: %@\n"
                             "\tqueue priority: %@\n"
                             "\tthread priority: %@\n"
                             "}\n", self.operationID, [self queuePriorityDescription], [self threadPriorityDescription]];
    return description;
}

@end
