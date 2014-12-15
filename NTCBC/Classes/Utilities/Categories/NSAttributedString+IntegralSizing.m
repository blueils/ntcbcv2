//
//  NSAttributedString+IntegralSizing.m
//  AldoMCEv1
//
//  Created by Austin Chen on 2014-10-03.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "NSAttributedString+IntegralSizing.h"
#import "UIColor+Aldo.h"
#import "UIFont+Aldo.h"

@implementation NSAttributedString (IntegralSizing)

+ (NSAttributedString *)attributedStringWithText:(NSString *)text withColor:(UIColor *)color withFont:(UIFont *)font withKern:(NSNumber *)kern {
    NSDictionary *attributes = @{NSForegroundColorAttributeName: color,
                                 NSFontAttributeName: font,
                                 NSKernAttributeName: kern};
    return [[NSAttributedString alloc] initWithString:text.uppercaseString attributes:attributes];
}

- (CGSize)integralSizeWithMaxSize:(CGSize)maxSize lineBreakMode: (NSLineBreakMode)lineBreakMode {
    NSStringDrawingOptions options;
    
    switch (lineBreakMode) {
        case NSLineBreakByWordWrapping:
        case NSLineBreakByCharWrapping:
            options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |  NSStringDrawingTruncatesLastVisibleLine;
            break;
        case NSLineBreakByTruncatingTail:
            options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            break;
        default:
            options = NSStringDrawingUsesLineFragmentOrigin;
            break;
    }
    
    CGRect rect = CGRectIntegral([self boundingRectWithSize:maxSize options:options context:nil]);
    return rect.size;
}

@end
