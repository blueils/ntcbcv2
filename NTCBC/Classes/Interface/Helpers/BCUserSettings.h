//
//  BCUserSettings.h
//  NTCBC
//
//  Created by Michael Chung-Ching Lan on 2014-05-27.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCUserSettings : NSObject

+ (void) initialize;

+ (void) clearUserSettings;

+ (void) setLatestNavIndex: (NSInteger) navIndex;
+ (NSInteger) latestNavIndex;

@end
