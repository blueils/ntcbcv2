//
//  CLCommonToolkits.m
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-03.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "CLCommonToolkits.h"
#import <sys/utsname.h>

BOOL OSVersionAtLeast( int major, int minor )
{
	static int osMajor=0, osMinor=0, osBuild=0, osRevision=0;
	
	if ( osMajor == 0 )
	{
		NSString *systemVersion		= [UIDevice currentDevice].systemVersion;
		
		NSArray *versionComponents	= [systemVersion componentsSeparatedByString: @"."];
		
		if ( [versionComponents count] > 0 )
			osMajor = [[versionComponents objectAtIndex:0] intValue];
		
		if ( [versionComponents count] > 1 )
			osMinor = [[versionComponents objectAtIndex:1] intValue];
		
		if ( [versionComponents count] > 2 )
			osBuild = [[versionComponents objectAtIndex:2] intValue];
		
		if ( [versionComponents count] > 3 )
			osRevision = [[versionComponents objectAtIndex:3] intValue];
	}
	
	if ( osMajor > major ) return YES;
	else if ( osMajor == major && osMinor >= minor ) return YES;
	
	return NO;
}

BOOL IsPad()
{
	UIDevice* device = [UIDevice currentDevice];
	if ([device respondsToSelector: @selector(userInterfaceIdiom)]) {
		return device.userInterfaceIdiom == UIUserInterfaceIdiomPad;
	}
	return NO;
}

BOOL HasTallScreen()
{
    return ([[UIScreen mainScreen] bounds].size.height == 568);
}

BOOL IsBlurringAvailable()
{
    static dispatch_once_t onceToken;
    static BOOL __blurringAvailable;
    dispatch_once(&onceToken, ^{
        if (IsPad()) {
            struct utsname u;
            uname(&u);
            NSString *model = [NSString stringWithFormat:@"%s", u.machine];
            if ([model isEqualToString:@"iPad2,1"] || [model isEqualToString:@"iPad2,2"] || [model isEqualToString:@"iPad2,3"] || [model isEqualToString:@"iPad2,4"] || [model isEqualToString:@"iPad3,1"] || [model isEqualToString:@"iPad3,2"] || [model isEqualToString:@"iPad3,3"]) {
                __blurringAvailable = NO;
            }
            else {
                __blurringAvailable = YES;
            }
        }
        else {
            __blurringAvailable = [[NSProcessInfo processInfo] processorCount] > 1;
        }
    });
    
    return __blurringAvailable;
}

@implementation CLCommonToolkits

@end
