//
//  BCUserSettings.m
//  NTCBC
//
//  Created by Michael Chung-Ching Lan on 2014-05-27.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "BCUserSettings.h"

@implementation BCUserSettings

static NSString * const BCLatestBCNavIndex = @"BCLatestBCNavIndex";

+ (void) initialize {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (defaults != nil) {
        [defaults setInteger:0 forKey:BCLatestBCNavIndex];
        [defaults synchronize];
    }
}

+ (void) clearUserSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults removeObjectForKey:<#(NSString *)#>];
    [defaults synchronize];
}


#pragma mark Global setting access

+ (void) setLatestNavIndex: (NSInteger) navIndex {
    [[NSUserDefaults standardUserDefaults] setInteger:navIndex forKey:BCLatestBCNavIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger) latestNavIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:BCLatestBCNavIndex];
}

@end
