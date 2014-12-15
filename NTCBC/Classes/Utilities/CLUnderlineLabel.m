//
//  CLUnderlineLabel.m
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-13.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "CLUnderlineLabel.h"

@implementation CLUnderlineLabel

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    _underlineColor = textColor;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    if ([self.textColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    
    CGContextSetRGBStrokeColor(ctx, red, green, blue, 1.0f); // RGBA
    CGContextSetLineWidth(ctx, 1.0f);
    
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height - 1);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height - 1);
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];
}

@end
