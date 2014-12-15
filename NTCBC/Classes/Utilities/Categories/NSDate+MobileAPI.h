//
//  NSDate+MobileAPI.h
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-10.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MobileAPI)

+ (NSDate *) dateFromMobileAPIDateString: (NSString *) dateString;
+ (NSDate *)dateFromAldoDateString: (NSString *)dateString;
- (NSString *) mobileAPIDateString;
- (NSString *) fractionalMobileAPIDateString;

@end
