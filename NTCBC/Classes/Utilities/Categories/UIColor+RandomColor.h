//
//  UIColor+RandomColor.h
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-06-12.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RandomColor)

+ (UIColor *)randomColor;
+ (NSArray *)listOfRandomColorWithLength: (NSInteger) length;
@end
