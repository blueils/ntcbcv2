//
//  UIFont+NTCBC.m
//  NTCBC
//
//  Created by Michael Lan on 2014-06-28.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "UIFont+NTCBC.h"

@implementation UIFont (NTCBC)

+ (UIFont *) bcPrimaryFontOfSize:(CGFloat)fontSize {
	return [UIFont fontWithName:@"Helvetica" size:fontSize];
}

+ (UIFont *) bcPrimaryBoldFontOfSize:(CGFloat)fontSize {
	return [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
}

+ (UIFont *) bcPrimaryItalicFontOfSize:(CGFloat)fontSize {
	return [UIFont fontWithName:@"Helvetica-Oblique" size:fontSize];
}

+ (UIFont *) bcSecondaryFontOfSize:(CGFloat)fontSize {
	return [UIFont fontWithName:@"Helvetica-Light" size:fontSize];
}

+ (UIFont *) bcSecondaryBoldFontOfSize:(CGFloat)fontSize {
	return [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
}

+ (UIFont *) bcSecondaryItalicFontOfSize:(CGFloat)fontSize {
	return [UIFont fontWithName:@"Helvetica-LightOblique" size:fontSize];
}

+ (UIFont *) bcLightSecondaryFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize];
}
+ (UIFont *) bcLightSecondaryItalicFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:fontSize];
}

+ (UIFont *) bcSansSerifFontOfSize: (CGFloat)fontSize {
    return [UIFont fontWithName:@"Avenir-Book" size:fontSize];
}

+ (UIFont *) bcSansSerifHeaderFontOfSize: (CGFloat)fontSize {
    return [UIFont fontWithName:@"Avenir-Medium" size:fontSize];
}

+ (UIFont *) bcSansSerifLightFontOfSize: (CGFloat)fontSize {
    return [UIFont fontWithName:@"Avenir-Light" size:fontSize];
}

@end
