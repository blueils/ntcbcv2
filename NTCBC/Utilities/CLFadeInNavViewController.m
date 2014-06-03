//
//  CLFadeInNavViewController.m
//  ALDOPrototype
//
//  Created by Michael Chung-Ching Lan on 2014-05-28.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "CLFadeInNavViewController.h"
#import "CLCommon.h"

@implementation CLFadeInMenu

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.barStyle = UIBarStyleDefault;
    }
    return self;
}

@end


@interface CLFadeInNavViewController ()

@end


@implementation CLFadeInNavViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect f = self.view.bounds;
    
    _fadeInView = [[CLFadeInMenu alloc] initWithFrame:f];
    _fadeInView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
    _fadeInView.hidden = YES;
    _fadeInView.alpha = 0.0;
    /*
    NSInteger parallaxOffset = IsPad() ? 30 : 20;
    
    UIInterpolatingMotionEffect *motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffect.minimumRelativeValue = @(-parallaxOffset);
    motionEffect.maximumRelativeValue = @(parallaxOffset);
    [_fadeInView addMotionEffect:motionEffect];*/
    [self.view addSubview: _fadeInView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleFadeInMenu {
    self.showFadeInMenu = !self.isShowingFadeInMenu;
}

- (BOOL)isShowingFadeInMenu {
    return !_fadeInView.hidden;
}

- (void)setShowFadeInMenu:(BOOL)showFadeInMenu {
    if (showFadeInMenu == self.isShowingFadeInMenu)
        return;
    
    if (showFadeInMenu) {
        _fadeInView.hidden = NO;
    }
    NSTimeInterval duration = 0.3;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _fadeInView.alpha = showFadeInMenu ? 1.0 : 0.0;
    } completion:^(BOOL finished){
        if (showFadeInMenu == NO) {
            _fadeInView.hidden = YES;
        }
    }];
}

- (UITableView *)slideOutTableView {
    return _fadeInView.tableView;
}

@end

@implementation KCSlideOutMenuCell

@synthesize imageColor = _imageColor;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"Avenir-Book" size:16];
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.highlightedTextColor = [UIColor colorWithRed: 25.0/255.0 green: 175.0/255.0 blue: 199.0/255.0 alpha: 1.0];
        self.imageView.tintColor = self.imageColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.adjustImageOnSelection = YES;
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.textLabel.highlighted = self.isSelected || highlighted;
    if (_adjustImageOnSelection)
        self.imageView.tintColor = highlighted || self.isSelected ? self.textLabel.highlightedTextColor : self.imageColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.textLabel.highlighted = self.isHighlighted || selected;
    if (_adjustImageOnSelection)
        self.imageView.tintColor = self.isHighlighted || selected ? self.textLabel.highlightedTextColor : self.imageColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect f = self.imageView.frame;
    f.origin.x = (IsPad() ? 25 : 20);
    self.imageView.frame = f;
    
    CGFloat spacing = IsPad() ? 17 : 12;
    
    f = self.textLabel.frame;
    f.origin.x = CGRectGetMaxX(self.imageView.frame) + spacing;
    f.size.width = self.contentView.bounds.size.width - f.origin.x - spacing;
    self.textLabel.frame = f;
}

- (UIColor *)imageColor {
    if (_imageColor == nil)
        return self.textLabel.textColor;
    else
        return _imageColor;
}

- (void)setImageColor:(UIColor *)imageColor {
    if (imageColor == _imageColor)
        return;
    
    _imageColor = imageColor;
    
    if ((_adjustImageOnSelection == NO) || ((self.selected || self.highlighted) == NO))
        self.imageView.tintColor = self.imageColor;
}

@end
