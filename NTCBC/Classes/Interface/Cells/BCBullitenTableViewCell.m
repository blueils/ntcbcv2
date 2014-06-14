//
//  BCBullitenTableViewCell.m
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-06-12.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "BCBullitenTableViewCell.h"
#import "UIColor+RandomColor.h"

@implementation BCBullitenTableViewCell

+ (CGFloat)cellHeight {
    return 160.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backgroundView = [[UIView alloc] initWithFrame:self.contentView.frame];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_backgroundView];
        
        _labelBackgroundView = [[UIToolbar alloc] initWithFrame:CGRectZero];
        _labelBackgroundView.barStyle = UIBarStyleDefault;
        _labelBackgroundView.translucent = YES;
        _labelBackgroundView.clipsToBounds = YES;
        [self.contentView addSubview:_labelBackgroundView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:16.0];
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.numberOfLines = 0;
        [_labelBackgroundView addSubview:_titleLabel];
        
        _funLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _funLabel.backgroundColor = [UIColor clearColor];
        _funLabel.font = [UIFont fontWithName:@"Avenir-Book" size:96.0];
        _funLabel.textColor = [UIColor whiteColor];
        _funLabel.hidden = YES;
        [_backgroundView addSubview:_funLabel];
        
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, _backgroundView.frame.size.width, _backgroundView.frame.size.height)];
        _backgroundImage.autoresizingMask = _backgroundView.autoresizingMask;
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
        _backgroundImage.hidden = YES;
        [_backgroundView addSubview:_backgroundImage];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect f = _backgroundView.frame;
    f.size = CGSizeMake(self.frame.size.width, 160.0);
    _backgroundView.frame = f;
    
    f.origin = CGPointMake(0.0, 0.0);
    _backgroundImage.frame = f;
    
    [_funLabel sizeToFit];
    f = _funLabel.frame;
    f.origin = CGPointMake((arc4random() % (int)(self.frame.size.width - f.size.width)), (arc4random() % (int)(self.frame.size.height - f.size.height)));
    _funLabel.frame = f;
    
    f = _labelBackgroundView.frame;
    f.size = CGSizeMake(self.frame.size.width, 50.0);
    f.origin = CGPointMake(0.0, self.frame.size.height - 50.0);
    _labelBackgroundView.frame = f;
    
    f.origin = CGPointMake(0.0, 0.0);
    _titleLabel.frame = f;
}

- (void)setTitle: (NSString *)title withImage: (UIImage *)image {
    if (title == nil) {
        NSLog(@"Error in BCBullitenTableViewCell: setting nil for cell title is not allowed.");
        return;
    }
    
    [_titleLabel setText:title];
    
    if (image != nil) {
        [_backgroundImage setImage:image];
        _backgroundImage.hidden = NO;
        _funLabel.hidden = YES;
        
    } else {
        _backgroundView.backgroundColor = _funColor;
        NSString *singleCharString = [title substringToIndex:1];
        _funLabel.text = singleCharString;
        _funLabel.hidden = NO;
        _backgroundImage.hidden = YES;
    }
    
    [self setNeedsLayout];
}

- (void)setFunColor:(UIColor *)funColor {
    _funColor = [funColor copy];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _funLabel.hidden = YES;
    _backgroundImage.hidden = YES;
    _funColor = nil;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
