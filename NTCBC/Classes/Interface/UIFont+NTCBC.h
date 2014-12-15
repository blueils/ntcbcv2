//
//  UIFont+NTCBC.h
//  NTCBC
//
//  Created by Michael Lan on 2014-06-28.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (NTCBC)

+ (UIFont *) bcPrimaryFontOfSize:(CGFloat)fontSize;
+ (UIFont *) bcPrimaryBoldFontOfSize:(CGFloat)fontSize;
+ (UIFont *) bcPrimaryItalicFontOfSize:(CGFloat)fontSize;

+ (UIFont *) bcSecondaryFontOfSize:(CGFloat)fontSize;
+ (UIFont *) bcSecondaryBoldFontOfSize:(CGFloat)fontSize;
+ (UIFont *) bcSecondaryItalicFontOfSize:(CGFloat)fontSize;

+ (UIFont *) bcLightSecondaryFontOfSize:(CGFloat)fontSize;
+ (UIFont *) bcLightSecondaryItalicFontOfSize:(CGFloat)fontSize;

+ (UIFont *) bcSansSerifFontOfSize: (CGFloat)fontSize;
+ (UIFont *) bcSansSerifHeaderFontOfSize: (CGFloat)fontSize;
+ (UIFont *) bcSansSerifLightFontOfSize: (CGFloat)fontSize;

- (CGFloat)heightForNumberOfLines:(NSUInteger)numberOfLines;

@end
