//
//  NSDate+MobileAPI.m
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-10.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "NSDate+MobileAPI.h"

static NSString * const KCMobileAPIDateFormatUTCWithoutTime = @"yyyy-MM-dd";
static NSString * const KCMobileAPIDateFormatUTC = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
static NSString * const KCMobileAPIDateFormatUTCWithFraction = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
static NSString * const KCMobileAPIDateFormatWithZone = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
static NSString * const KCMobileAPIDateFormatWithZoneAndFraction = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ";

static NSString * const KCAldoPublishDateFormat = @"EEE MMM dd HH:mm:ss zzz yyyy";

@implementation NSDate (MobileAPI)

+ (NSDateFormatter *) rfc3339DateFormatterWithoutTime
{
	static NSDateFormatter * volatile __rfc3339 = nil;
	if ( __rfc3339 == nil )
	{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSDateFormatter * m = [[NSDateFormatter alloc] init];
            NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
            [m setLocale: locale];
            [m setDateFormat: KCMobileAPIDateFormatUTCWithoutTime];
            [m setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: 0]];
            __rfc3339 = m;
        });
	}
	
	return ( __rfc3339 );
}

+ (NSDateFormatter *) rfc3339DateFormatter
{
	static NSDateFormatter * volatile __rfc3339 = nil;
	if ( __rfc3339 == nil )
	{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSDateFormatter * m = [[NSDateFormatter alloc] init];
            NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
			[m setLocale: locale];
			[m setDateFormat: KCMobileAPIDateFormatUTC];
			[m setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: 0]];
            __rfc3339 = m;
        });
	}
	
	return ( __rfc3339 );
}

+ (NSDateFormatter *) rfc3339DateFormatterWithZone
{
	static NSDateFormatter * volatile __rfc3339_zone = nil;
	if ( __rfc3339_zone == nil )
	{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSDateFormatter * m = [[NSDateFormatter alloc] init];
            NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
            [m setLocale: locale];
            [m setDateFormat: KCMobileAPIDateFormatWithZone];
            __rfc3339_zone = m;
        });
	}
	
	return ( __rfc3339_zone );
}

+ (NSDateFormatter *) rfc3339FractionalDateFormatter
{
	static NSDateFormatter * volatile __rfc3339 = nil;
	if ( __rfc3339 == nil )
	{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSDateFormatter * m = [[NSDateFormatter alloc] init];
            NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
            [m setLocale: locale];
            [m setDateFormat: KCMobileAPIDateFormatUTCWithFraction];
            [m setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: 0]];
            __rfc3339 = m;
        });
	}
	
	return ( __rfc3339 );
}

+ (NSDateFormatter *) rfc3339FractionalDateFormatterWithZone
{
	static NSDateFormatter * volatile __rfc3339_zone = nil;
	if ( __rfc3339_zone == nil )
	{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSDateFormatter * m = [[NSDateFormatter alloc] init];
            NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
            [m setLocale: locale];
            [m setDateFormat: KCMobileAPIDateFormatWithZoneAndFraction];
            __rfc3339_zone = m;
        });
	}
	
	return ( __rfc3339_zone );
}

+ (NSDate *) dateFromMobileAPIDateString: (NSString *) dateString
{
	if ( dateString.length == 0 )
		return ( nil );
	
	NSDateFormatter * formatter = nil;
	
	if ( [dateString hasSuffix: @"Z"] )
	{
        NSUInteger fractionLoc = [dateString rangeOfString: @"."].location;
		if ( fractionLoc != NSNotFound )
		{
			// it has a fractional second
			formatter = [self rfc3339FractionalDateFormatter];
            
            NSUInteger endFractionLocation = [dateString rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"+Z"] options: 0 range: NSMakeRange(fractionLoc+1, [dateString length] - (fractionLoc+1))].location;
            
            NSUInteger diff = endFractionLocation - (fractionLoc + 1);
            if ( diff > 4 )
            {
                NSUInteger start = fractionLoc+4;       // allow for three characters of floating-point precision
                NSRange rng = NSMakeRange(start, endFractionLocation-start);
                dateString = [dateString stringByReplacingCharactersInRange: rng withString: @""];
            }
		}
		else
		{
			formatter = [self rfc3339DateFormatter];
		}
	}
	else
	{
		NSRange r = [dateString rangeOfString: @"T"];
		if ( r.location == NSNotFound )
		{
			formatter = [self rfc3339DateFormatterWithoutTime];
		}
		else
		{
			r.length = [dateString length] - r.location;
            r = [dateString rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"-+"] options: 0 range: r];
			if ( r.location == NSNotFound )
			{
				dateString = [dateString stringByAppendingString: @"Z"];
				if ( [dateString rangeOfString: @"."].location != NSNotFound )
				{
					// it has a fractional second
					formatter = [self rfc3339FractionalDateFormatter];
				}
				else
				{
					formatter = [self rfc3339DateFormatter];
				}
			}
			else
			{
                dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@"" options:NSBackwardsSearch range:NSMakeRange(r.location, dateString.length - r.location)];
                
				if ( [dateString rangeOfString: @"."].location != NSNotFound )
				{
					// it has a fractional second
					formatter = [self rfc3339FractionalDateFormatterWithZone];
				}
				else
				{
					formatter = [self rfc3339DateFormatterWithZone];
				}
			}
			
		}
        
		
	}
	
	NSDate * result = nil;
	
	@try
	{
		@synchronized(formatter)
		{
			result = [formatter dateFromString: dateString];
		}
	}
	@catch (NSException * e)
	{
		NSLog( @"Caught %@ converting date from '%@': %@", e.name, dateString, e.reason );
		
		// OUCH. I pray this is never used...
		result = [NSDate date];
	}
	
	return ( result );
}

+ (NSDate *)dateFromAldoDateString: (NSString *)dateString {
    if ( dateString.length == 0 )
        return ( nil );
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:KCAldoPublishDateFormat];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
    [dateFormatter setLocale: locale];
    [dateFormatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: 0]];
    
    NSDate * result = nil;
    
    @try
    {
        @synchronized(dateFormatter)
        {
            result = [dateFormatter dateFromString: dateString];
        }
    }
    @catch (NSException * e)
    {
        NSLog( @"Caught %@ converting date from '%@': %@", e.name, dateString, e.reason );
        
        // OUCH. I pray this is never used...
        result = [NSDate date];
    }
    
    return ( result );
}

- (NSString *) mobileAPIDateString
{
	NSString * result = nil;
	
	NSDateFormatter * formatter = [[self class] rfc3339DateFormatter];
	@synchronized(formatter)
	{
		result = [formatter stringFromDate: self];
	}
	
	return ( result );
}

- (NSString *) fractionalMobileAPIDateString
{
	NSString * result = nil;
	
	NSDateFormatter * formatter = [[self class] rfc3339FractionalDateFormatter];
	@synchronized(formatter)
	{
		result = [formatter stringFromDate: self];
	}
	
	return ( result );
}

@end
