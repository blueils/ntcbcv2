//
//  NSString+IntegralSizing.h
//  Kobov3
//
//  Created by Michael Chung-Ching Lan on 2/13/2014.
//  Copyright (c) 2014 Kobo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IntegralSizing)

- (CGSize)integralSizeWithFont:(UIFont *)font;
- (CGSize)integralSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)maxSize;
- (CGSize)integralSizeWithFont:(UIFont *)font forWidth: (CGFloat)width lineBreakMode: (NSLineBreakMode)lineBreakMode;

- (CGSize)integralSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)maxSize lineBreakMode: (NSLineBreakMode)lineBreakMode;

@end
