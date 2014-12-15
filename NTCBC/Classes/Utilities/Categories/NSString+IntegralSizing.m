//
//  NSString+IntegralSizing.m
//
//  Created by Michael Chung-Ching Lan on 2/13/2014.
//  Copyright (c) 2014 Kobo Inc. All rights reserved.
//

#import "NSString+IntegralSizing.h"

@implementation NSString (IntegralSizing)

- (CGSize)integralSizeWithFont: (UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGSize size = [self sizeWithAttributes:attributes];
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGSize)integralSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)maxSize
{
    return [self integralSizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByTruncatingTail];
}

- (CGSize)integralSizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self integralSizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
}


- (CGSize)integralSizeWithFont: (UIFont *)font constrainedToSize:(CGSize)maxSize lineBreakMode: (NSLineBreakMode)lineBreakMode {
    NSDictionary *attributes = font != nil ? @{NSFontAttributeName: font} : nil;
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
    
    CGRect rect = CGRectIntegral([self boundingRectWithSize:maxSize options:options attributes:attributes context:nil]);
    return rect.size;
}
@end
