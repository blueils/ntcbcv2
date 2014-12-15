//
//  BCEmptyStateView.m
//  NTCBC
//
//  Created by Michael Lan on 2014-12-15.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "BCEmptyStateView.h"

#import "UIFont+NTCBC.h"
#import "NSString+IntegralSizing.h"

@implementation BCEmptyStateView

- (id)initWithFrame:(CGRect)frame iconFile:(NSString *)iconFile message:(NSString *)message tip:(NSString *)tip
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessibilityLabel:@"empty state view"];
        
        if (iconFile != nil) {
            UIImage *image = [UIImage imageNamed:iconFile];
            _iconImage = [[UIImageView alloc]initWithFrame:CGRectZero];
            [_iconImage setImage:image];
            _iconImage.clipsToBounds = YES;
            _iconImage.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:_iconImage];
        }
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont bcPrimaryFontOfSize:17.0];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = message;
        _titleLabel.backgroundColor = self.backgroundColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.font = [UIFont bcSecondaryFontOfSize:14.0];
        _messageLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
        _messageLabel.text = tip;
        _messageLabel.backgroundColor = self.backgroundColor;
        _messageLabel.numberOfLines = 0;
        [_messageLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect f = CGRectZero;
    CGFloat yOffset = 0.0;
    if (_iconImage != nil) {
        f = _iconImage.frame;
        f.size = CGSizeMake(90.0, 90.0);
        f.origin.x = floorf((self.bounds.size.width - f.size.width) / 2.0);
        f.origin.y = floorf((self.bounds.size.height - f.size.height) / 2.0) - 40.0;
        _iconImage.frame = f;
        
        yOffset = CGRectGetMaxY(_iconImage.frame);
    } else {
        yOffset = floorf((self.bounds.size.height - f.size.height) / 2.0) + 5.0;
    }
    
    f = _titleLabel.frame;
    f.size = [_titleLabel.text integralSizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) lineBreakMode:_titleLabel.lineBreakMode];
    f.origin.x = floorf((self.bounds.size.width - f.size.width) / 2.0);
    f.origin.y = yOffset + 20.0;
    _titleLabel.frame = f;
    
    f = _messageLabel.frame;
    f.size = [_messageLabel.text integralSizeWithFont:_messageLabel.font constrainedToSize:CGSizeMake(ceilf(self.bounds.size.width / 2.0), CGFLOAT_MAX) lineBreakMode:_messageLabel.lineBreakMode];
    f.origin = CGPointMake(floorf((self.bounds.size.width - f.size.width) / 2.0), CGRectGetMaxY(_titleLabel.frame));
    _messageLabel.frame = f;
}

@end
