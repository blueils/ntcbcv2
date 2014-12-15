//
//  NSString+HTMLEntities.m
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-23.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "NSString+HTML.h"
#import "HTMLEntities.h"

@implementation NSString (HTMLEntities)


- (NSString *)stringByRemovingHTMLtags {
	NSMutableString *newString = [NSMutableString stringWithString:self];
	NSString *temp = nil;
	NSScanner *scanner = [NSScanner scannerWithString:newString];
	
	while (![scanner isAtEnd]) {
		[scanner scanUpToString:@"<" intoString:NULL];
		[scanner scanUpToString:@">" intoString:&temp];
		
		if (temp != nil) {
			[newString replaceOccurrencesOfString:[NSString stringWithFormat:@"%@>", temp] withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, newString.length)];
			temp = nil;
		}
	}
	
	return newString;
}

- (NSString *)stringByReplacingHTMLentities {
	NSMutableString *newString = [NSMutableString stringWithString:self];
	NSString *temp = nil;
	NSScanner *scanner = [NSScanner scannerWithString:newString];
	
	while (![scanner isAtEnd]) {
		[scanner scanUpToString:@"&" intoString:NULL];
		[scanner scanString:@"&" intoString:NULL];
		[scanner scanUpToString:@";" intoString:&temp];
		
		if (temp != nil) {
			NSString *replacementStr = nil;
			
			if (([temp characterAtIndex:0] == '#') && (temp.length > 1)) {
				unichar newChar = [[temp substringFromIndex:1] intValue];
				replacementStr = [NSString stringWithFormat:@"%C", newChar];
			}
			else {
				replacementStr = LookupEntity(temp);
			}
            
			if (replacementStr != nil)
				[newString replaceOccurrencesOfString:[NSString stringWithFormat:@"&%@;", temp] withString:replacementStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, newString.length)];
			temp = nil;
		}
	}
	
	return newString;
}

@end
