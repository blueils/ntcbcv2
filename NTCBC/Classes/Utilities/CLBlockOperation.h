//
//  CLBlockOperation.h
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-05-24.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLBlockOperation : NSBlockOperation {
    NSString * _operationID;
}

@property (nonatomic, copy) NSString * operationID;

- (id)initWithOperationID: (NSString *)operationID;

@end
