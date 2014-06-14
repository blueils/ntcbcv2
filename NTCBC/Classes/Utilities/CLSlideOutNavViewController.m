//
//  CLSlideOutNavViewController.m
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-05-15.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "CLSlideOutNavViewController.h"
#import "CLCommon.h"

#define CL_SLIDE_OUT_NAV_PADDING (IsPad() ? 80.0 : 60.0)

@interface CLSlideOutNavViewController ()

@end

@implementation CLSlideOutMenu

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.barStyle = UIBarStyleBlack;
        self.translucent = YES;
        self.clipsToBounds = YES;
        
        CGRect f = self.bounds;
        f.origin.y = 20;
        f.size.height -= f.origin.y;
        
        _tableView = [[UITableView alloc] initWithFrame:f style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        _tableView.contentInset = UIEdgeInsetsMake(IsPad() ? 18 : 17, 0, 0, 0);
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_tableView];
    }
    return self;
}

@end

@implementation CLSlideOutNavViewController

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
    
    _dimmerView = [[UIView alloc] initWithFrame:f];
    _dimmerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _dimmerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.45];
    _dimmerView.hidden = YES;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSlideOutMenu)];
    [_dimmerView addGestureRecognizer:tapRecognizer];
    
    f.size.width = (IsPad() ? 300 : 260) + CL_SLIDE_OUT_NAV_PADDING;
    
    _slideOutView = [[CLSlideOutMenu alloc] initWithFrame:f];
    _slideOutView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
    _slideOutView.hidden = YES;
    
    NSInteger parallaxOffset = IsPad() ? 30 : 20;
    
    UIInterpolatingMotionEffect *motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffect.minimumRelativeValue = @(-parallaxOffset);
    motionEffect.maximumRelativeValue = @(parallaxOffset);
    [_slideOutView addMotionEffect:motionEffect];
    
    _slideOutPanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSlideOutPanGesture:)];
    _slideOutPanGestureRecognizer.edges = UIRectEdgeLeft;
    _slideOutPanGestureRecognizer.maximumNumberOfTouches = 1;
    _slideOutPanGestureRecognizer.enabled = YES;
    [self.view addGestureRecognizer:_slideOutPanGestureRecognizer];
    
    _dismissingPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSlideOutPanGesture:)];
    _dismissingPanGestureRecognizer.maximumNumberOfTouches = 1;
    _dismissingPanGestureRecognizer.enabled = NO;
    [self.view addGestureRecognizer:_dismissingPanGestureRecognizer];
}

- (void)handleSlideOutPanGesture:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.view];
    
    __block CGRect f = _slideOutView.frame;
    
    if (_dimmerView.hidden) {
        _dimmerView.frame = self.view.bounds;
        _dimmerView.alpha = 0;
        _dimmerView.hidden = NO;
        [self.view addSubview:_dimmerView];
    }
    
    if (_slideOutView.hidden) {
        f.origin = CGPointMake(0 - f.size.width, 0);
        f.size.height = self.view.bounds.size.height;
        _slideOutView.frame = f;
        _slideOutView.hidden = NO;
        [self.view addSubview:_slideOutView];
    }
    
    if ((gestureRecognizer == _slideOutPanGestureRecognizer) && (location.x < (CGRectGetMaxX(_slideOutView.frame) - 50)))
        return;
    else if ((gestureRecognizer == _dismissingPanGestureRecognizer) && (gestureRecognizer.state == UIGestureRecognizerStateBegan))
        _dismissingTouchLocation = location;
    
    if ((gestureRecognizer.state == UIGestureRecognizerStateEnded) || (gestureRecognizer.state == UIGestureRecognizerStateCancelled)) {
        BOOL shouldClose = NO;
        if (gestureRecognizer == _slideOutPanGestureRecognizer) {
            shouldClose = location.x < ((f.size.width - CL_SLIDE_OUT_NAV_PADDING) / 2.0);
        }
        else if (gestureRecognizer == _dismissingPanGestureRecognizer) {
            shouldClose = (_dismissingTouchLocation.x - location.x) > 50;
        }
        
        if (shouldClose) {
            self.showSlideOutMenu = NO;
        }
        else {
            CGFloat damping = 0.6;
            CGFloat initialVelocity = 0.4;
            CGFloat duration = (location.x / (f.size.width - CL_SLIDE_OUT_NAV_PADDING)) * 0.8;
            UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseOut;
            
            [UIView animateWithDuration:duration delay:0.1 usingSpringWithDamping:damping initialSpringVelocity:initialVelocity options:options animations:^{
                f.origin = CGPointMake(0 - CL_SLIDE_OUT_NAV_PADDING, 0);
                _slideOutView.frame = f;
            } completion:^(BOOL finished){
                _dismissingPanGestureRecognizer.enabled = YES;
                _slideOutPanGestureRecognizer.enabled = NO;
                [_slideOutView.tableView flashScrollIndicators];
            }];
            
            [UIView animateWithDuration:duration animations:^{
                _dimmerView.alpha = 1.0;
            }];
        }
    }
    else {
        if (gestureRecognizer == _slideOutPanGestureRecognizer)
            f.origin.x = location.x - f.size.width;
        else if ((gestureRecognizer == _dismissingPanGestureRecognizer) && (location.x <= _dismissingTouchLocation.x))
            f.origin.x = 0 - CL_SLIDE_OUT_NAV_PADDING - (_dismissingTouchLocation.x - location.x);
        
        if (f.origin.x > -30) {
            f.origin.x = -30 + MIN(30, (f.origin.x + 30) * 0.07);
        }
        
        _dimmerView.alpha = MIN(1.0, location.x / (f.size.width - CL_SLIDE_OUT_NAV_PADDING));
        _slideOutView.frame = f;
    }
}

- (void)toggleSlideOutMenu {
    self.showSlideOutMenu = !self.isShowingSlideOutMenu;
}

- (BOOL)isShowingSlideOutMenu {
    return !_slideOutView.hidden;
}

- (void)setShowSlideOutMenu:(BOOL)showSlideOutMenu {
    if (showSlideOutMenu == self.isShowingSlideOutMenu)
        return;
    
    __block CGRect f = _slideOutView.frame;
    
    if (showSlideOutMenu) {
        f.origin = CGPointMake(0 - f.size.width, 0);
        f.size.height = self.view.bounds.size.height;
        _slideOutView.frame = f;
        _slideOutView.hidden = NO;
        [self.view addSubview:_slideOutView];
        
        f = self.view.bounds;
        _dimmerView.frame = f;
        _dimmerView.alpha = 0.0;
        _dimmerView.hidden = NO;
        [self.view insertSubview:_dimmerView belowSubview:_slideOutView];
        
        f = _slideOutView.frame;
    }
    
    CGFloat damping = showSlideOutMenu ? 0.6 : 1.0;
    CGFloat initialVelocity = showSlideOutMenu ? 0.4 : 0.0;
    UIViewAnimationOptions options = showSlideOutMenu ? UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveEaseIn;
    NSTimeInterval duration = showSlideOutMenu ? 0.6 : 0.4;
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:initialVelocity options:options animations:^{
        if (showSlideOutMenu) {
            f.origin = CGPointMake(0 - CL_SLIDE_OUT_NAV_PADDING, 0);
        }
        else {
            f.origin = CGPointMake(0 - f.size.width, 0);
        }
        
        _slideOutView.frame = f;
    } completion:^(BOOL finished){
        if (showSlideOutMenu == NO) {
            _slideOutView.hidden = YES;
            [_slideOutView removeFromSuperview];
            _dismissingPanGestureRecognizer.enabled = NO;
            _slideOutPanGestureRecognizer.enabled = YES;
        }
        else {
            _dismissingPanGestureRecognizer.enabled = YES;
            _slideOutPanGestureRecognizer.enabled = NO;
            [_slideOutView.tableView flashScrollIndicators];
        }
    }];
    
    [UIView animateWithDuration:(duration * 0.5) delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _dimmerView.alpha = showSlideOutMenu ? 1.0 : 0.0;
    } completion:^(BOOL finished){
        if (showSlideOutMenu == NO) {
            _dimmerView.hidden = YES;
            [_dimmerView removeFromSuperview];
        }
    }];
}

- (UITableView *)slideOutTableView {
    return _slideOutView.tableView;
}

@end


@implementation KBSlideOutMenuCell

@synthesize imageColor = _imageColor;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"Avenir-Book" size:16];
        self.textLabel.textColor = [UIColor darkTextColor];
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
    f.origin.x = CL_SLIDE_OUT_NAV_PADDING + (IsPad() ? 25 : 20);
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
