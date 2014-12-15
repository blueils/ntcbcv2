//
//  NSAttributedString+IntegralSizing.h
//  AldoMCEv1
//
//  Created by Austin Chen on 2014-10-03.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (IntegralSizing)

+ (NSAttributedString *)attributedStringWithText:(NSString *)text withColor:(UIColor *)color withFont:(UIFont *)font withKern:(NSNumber *)kern;

- (CGSize)integralSizeWithMaxSize:(CGSize)maxSize lineBreakMode: (NSLineBreakMode)lineBreakMode;

@end
