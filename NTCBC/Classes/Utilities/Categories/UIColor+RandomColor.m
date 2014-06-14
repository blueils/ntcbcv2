//
//  UIColor+RandomColor.m
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-06-12.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)

+ (UIColor *)randomColor {
    CGFloat hue = ( (arc4random() % 256) / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (NSArray *)listOfRandomColorWithLength: (NSInteger) length {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < length; i++) {
        [array addObject:[[self class] randomColor]];
    }
    return array;
}

@end
