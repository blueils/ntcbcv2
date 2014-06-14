//
//  BCBullitenTableViewCell.h
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-06-12.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCBullitenTableViewCell : UITableViewCell {
    UIToolbar *_labelBackgroundView;
    UILabel *_titleLabel;
    UIView *_backgroundView;
    
    UIImageView *_backgroundImage;
    UILabel *_funLabel;
    UIColor *_funColor;
}

+ (CGFloat)cellHeight;
- (void)setTitle: (NSString *)title withImage: (UIImage *)image;
- (void)setFunColor: (UIColor *)funColor;

@end
