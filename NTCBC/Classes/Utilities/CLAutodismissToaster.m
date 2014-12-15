//
//  CLAutodismissToaster.m
//  AldoMCEv1
//
//  Created by Michael Lan on 2014-07-14.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "CLAutodismissToaster.h"
#import "UIFont+Aldo.h"
#import "CLCommon.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Aldo.h"
#import "NSString+IntegralSizing.h"

static CLAutodismissToaster * volatile _toaster = nil;

@interface CLAutodismissToaster (Private)
- (void)displayToastWithTitle:(NSString *)title message:(NSString *)message duration:(float)duration delay:(float)delay;
- (void)dismissToast;
- (void)orientationWillChange:(NSNotification *)note;
- (void)changeOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
- (float)duration;
@property (nonatomic, readonly) UIView *view;
@end

@implementation CLAutodismissToaster

+ (CLAutodismissToaster *)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _toaster = [[CLAutodismissToaster alloc] init];
    });
    
    return _toaster;
}

#pragma mark -

+ (void)displayNoNetworkToast {
    [CLAutodismissToaster displayToastWithMessage:NSLocalizedString( @"You're not connected to the Internet.", @"No network toast message." ) forDuration:kToasterDefaultDuration withDelay:kToasterDefaultDelay];
}

+ (void)displayLoginToFacebookToast {
    [CLAutodismissToaster displayToastWithMessage:NSLocalizedString(@"Sign into Facebook to join the conversation", @"Facebook login required for Pulse toast")];
}

#pragma mark -

+ (void)displayToastWithTitle:(NSString *)title message:(NSString *)message
{
    [CLAutodismissToaster displayToastWithTitle:title message:message forDuration:kToasterDefaultDuration withDelay:kToasterDefaultDelay shouldInterruptCurrentToast:YES];
}

+ (void)displayToastWithMessage:(NSString *)message
{
    [CLAutodismissToaster displayToastWithMessage:message forDuration:kToasterDefaultDuration withDelay:kToasterDefaultDelay];
}

+ (void)displayToastWithMessage:(NSString *)message forDuration:(float)duration
{
    [CLAutodismissToaster displayToastWithMessage:message forDuration:duration withDelay:kToasterDefaultDelay];
}

+ (void)displayToastWithMessage:(NSString *)message forDuration:(float)duration withDelay:(float)delay
{
    [CLAutodismissToaster displayToastWithTitle:nil message:message forDuration:duration withDelay:delay shouldInterruptCurrentToast:YES];
}

+ (void)displayToastWithTitle:(NSString *)title message:(NSString *)message forDuration:(float)duration withDelay:(float)delay shouldInterruptCurrentToast:(BOOL)interrupt
{
    CLAutodismissToaster *toaster = [CLAutodismissToaster sharedInstance];
    if(interrupt == NO && toaster.view.superview != nil)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, ([toaster duration] + kToasterAnimationTime) * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void)
                       {
                           [CLAutodismissToaster displayToastWithTitle:title message:message forDuration:duration withDelay:delay shouldInterruptCurrentToast:interrupt];
                       });
    }
    else
    {
        [toaster displayToastWithTitle:title message:message duration:duration delay:delay];
    }
}

#pragma mark -

- (id)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

- (void)createViewsIfNeeded {
    if (self.view != nil)
        return;
    
    _view = [[UIView alloc] initWithFrame:CGRectZero];
    _view.backgroundColor = [UIColor clearColor];
    _view.userInteractionEnabled = NO;
    _view.alpha = 0.0;
    
    /*
     _tintView = [[UIView alloc] initWithFrame:CGRectZero];
     _tintView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
     _tintView.backgroundColor = [UIColor blackColor];
     _tintView.alpha = 0.4;
     [_view addSubview:_tintView];
     */
    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    //_backgroundView.layer.cornerRadius = 5.0;
    _backgroundView.layer.masksToBounds = YES;
    //_backgroundView.backgroundColor = [UIColor colorWithWhite:240.0/255.0 alpha:1.0];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    _backgroundView.layer.shouldRasterize = YES;
    _backgroundView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    [_view addSubview:_backgroundView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont aldoHeaderTitleFont];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [_backgroundView addSubview:_titleLabel];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _messageLabel.font = [UIFont aldoHeaderTitleFont];
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.numberOfLines = 0;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.textColor = [UIColor aldoToastMessageColor];
    [_backgroundView addSubview:_messageLabel];
}

- (void)layoutViews {
    CGFloat width = 262, offset = 29;
    CGRect f = CGRectZero;
    
    //_tintView.frame = _view.bounds;
    
    if (_titleLabel.text.length > 0) {
        _titleLabel.hidden = NO;
        f.size = [_titleLabel.text integralSizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(width - 80, CGFLOAT_MAX) lineBreakMode:_titleLabel.lineBreakMode];
        f.size.width = roundf(f.size.width) + 10;
        f.origin.x = roundf((width - f.size.width) / 2.0);
        f.origin.y = offset;
        _titleLabel.frame = f;
        offset = CGRectGetMaxY(f) + 13;
    }
    else {
        _titleLabel.hidden = YES;
    }
    
    if (_messageLabel.text.length > 0) {
        _messageLabel.hidden = NO;
        f.size = [_messageLabel.text integralSizeWithFont:_messageLabel.font constrainedToSize:CGSizeMake(width - 60, CGFLOAT_MAX) lineBreakMode:_messageLabel.lineBreakMode];
        f.origin.x = roundf((width - f.size.width) / 2.0);
        f.origin.y = offset;
        _messageLabel.frame = f;
        offset = CGRectGetMaxY(f) + 13;
    }
    else {
        _messageLabel.hidden = YES;
    }
    
    offset += 16;
    
    if (((int)offset % 2) == 1)
        offset++;
    
    f.size = CGSizeMake(width, offset);
    f.origin.x = roundf((_view.bounds.size.width - f.size.width) / 2.0);
    f.origin.y = roundf((_view.bounds.size.height - f.size.height) / 2.0);
    _backgroundView.frame = f;
}

- (void)displayToastWithTitle:(NSString *)title message:(NSString *)message duration:(float)duration delay:(float)delay
{
    [self createViewsIfNeeded];
    
    BOOL resetOrientation = (self.view.superview == nil);
    
    if (resetOrientation) {
        _backgroundView.transform = CGAffineTransformIdentity;
        
        UIView *window = [[UIApplication sharedApplication] keyWindow];
        self.view.frame = window.frame;
        [window addSubview:self.view];
    }
    
    _titleLabel.text = title;
    _messageLabel.text = message;
    _duration = duration;
    
    if (resetOrientation)
    {
        [self layoutViews];
        [self changeOrientation:[[UIApplication sharedApplication] statusBarOrientation] animated:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(orientationWillChange:)
                                                 name: UIApplicationWillChangeStatusBarOrientationNotification
                                               object: nil];
    
    // Dismissal block - only fires if there hasn't been a more recent toast
    static unsigned int toasterIndex = 0;
    unsigned int localIndex = ++toasterIndex;
    void (^completionBlock)(BOOL success) = ^(BOOL success)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * _duration), dispatch_get_main_queue(), ^
                       {
                           if(success && localIndex == toasterIndex)
                           {
                               [UIView animateWithDuration:kToasterAnimationTime
                                                     delay:0
                                                   options:UIViewAnimationOptionBeginFromCurrentState
                                                animations:^
                                {
                                    self.view.alpha = 0.0;
                                }
                                                completion:^(BOOL finished)
                                {
                                    if (self.view.alpha == 0)
                                    {
                                        [self.view removeFromSuperview];
                                        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
                                    }
                                    _isAnimationInProgress = NO;
                                }];
                           }
                       });
    };
    
    if(self.view.alpha != 1.0f)
    {
        [UIView animateWithDuration:kToasterAnimationTime
                              delay:delay
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^
         {
             self.view.alpha = 1.0;
         }
                         completion:completionBlock];
    }
    else
    {
        [self layoutViews];
        completionBlock(YES);
    }
}

- (float)duration {
    return _duration;
}

- (UIView *)view {
    return _view;
}

- (void)orientationWillChange:(NSNotification *)note {
    UIInterfaceOrientation orientation = [[[note userInfo] objectForKey: UIApplicationStatusBarOrientationUserInfoKey] integerValue];
    [self changeOrientation:orientation animated:YES];
}

- (void)changeOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated; {
    // direction and angle
    CGFloat angle = 0.0;
    switch ( orientation )
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = (CGFloat)M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = (CGFloat)(M_PI*-90.0)/180.0;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = (CGFloat)(M_PI*90.0)/180.0;
            break;
        default:
            break;
    }
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.4];
    }
    
    _backgroundView.transform = CGAffineTransformMakeRotation( angle );
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)didReceiveMemoryWarning {
    if (self.view.superview == nil) {
        _view = nil;
        //_tintView = nil;
        _backgroundView = nil;
        _titleLabel = nil;
        _messageLabel = nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
