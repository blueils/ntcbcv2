//
//  CLModalViewController.m
//  AldoMCEv1
//
//  Created by Michael Lan on 2014-07-30.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "CLModalViewController.h"
#import "CLCommon.h"

@interface CLSelectivePassthroughView : UIView
@property (nonatomic, copy) NSArray *passthroughViews;
@end

@implementation CLSelectivePassthroughView
@synthesize passthroughViews;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *passthroughView in self.passthroughViews) {
        CGRect f = [self convertRect:passthroughView.frame fromView:passthroughView.superview];
        if (CGRectContainsPoint(f, point))
            return nil;
    }
    
    return [super hitTest:point withEvent:event];
}
@end

@interface CLModalViewController ()
@property (nonatomic, assign) BOOL isShowing; // Used to prevent multiple dismisses - crash found
- (void)orientationWillChange:(NSNotification *)note;
- (void)moveOffScreen;
@end

@implementation CLModalViewController

@synthesize tapOffToDismiss = tapOffToDismiss_, transitionType = transitionType_, dataSource = dataSource_, delegate = delegate_, modalView = modalView_, isShowing;

+ (CGFloat) tintViewAlpha
{
	return ( 0.6 );
}

+ (CGFloat)animationDuration {
    return 0.3;
}

- (void)loadView {
	[super loadView];
	UIView *window = [[UIApplication sharedApplication] keyWindow];
	self.view = [[CLSelectivePassthroughView alloc] initWithFrame:window.bounds];
	self.view.opaque = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	tintView_ = [[UIView alloc] initWithFrame:self.view.bounds];
	tintView_.backgroundColor = [UIColor blackColor];
	tintView_.opaque = NO;
    tintView_.userInteractionEnabled = NO;
	[self.view addSubview:tintView_];
}

- (BOOL)shouldResizeOnRotation {
    return NO;
}

- (CGSize)sizeForOrientation:(UIInterfaceOrientation)orientation {
    return CGSizeZero;
}

- (CGPoint)onScreenCenterPointForOrientation:(UIInterfaceOrientation)orientation {
    return self.view.center;
}

- (void)orientationWillChange:(NSNotification *)note {
	UIInterfaceOrientation orientation = [[[note userInfo] objectForKey: UIApplicationStatusBarOrientationUserInfoKey] integerValue];
	[self changeOrientation:orientation animated:YES];
    recalculateOriginPoint_ = YES;
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
	
	modalView_.transform = CGAffineTransformMakeRotation( angle );
    if ([self shouldResizeOnRotation]) {
        CGRect bounds = modalView_.bounds;
        bounds.size = [self sizeForOrientation:orientation];
        modalView_.bounds = bounds;
    }
    
//    if ([self isKindOfClass:[CLModalPopoverController class]] == NO) {
//        modalView_.center = [self onScreenCenterPointForOrientation:orientation];
//    }
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)moveOffScreen {
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	CGPoint point;
	UIView *window = [[UIApplication sharedApplication] keyWindow];
	
	if (transitionType_ == CLModalViewTransitionTypeSlide) {
		switch (orientation) {
			case UIInterfaceOrientationPortraitUpsideDown:
				point = CGPointMake(window.center.x, -floorf(self.view.frame.size.height/2));
				break;
			case UIInterfaceOrientationLandscapeLeft:
				point = CGPointMake(CGRectGetMaxX(window.frame) + floorf(self.view.frame.size.width/2), window.center.y);
				break;
			case UIInterfaceOrientationLandscapeRight:
				point = CGPointMake(-floorf(self.view.frame.size.width/2), window.center.y);
				break;
			default:
				point = CGPointMake(window.center.x, CGRectGetMaxY(window.frame) + floorf(self.view.frame.size.height/2));
				break;
		}
		modalView_.center = point;
	}
	else if (transitionType_ == CLModalViewTransitionTypeGrow) {
		modalView_.center = originPoint_;
		modalView_.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.005, 0.005), modalView_.transform);
		modalView_.alpha = 0.0;
	}
    else if (transitionType_ == CLModalViewTransitionTypeFade) {
		modalView_.alpha = 0.0;
	}
}

- (void)displayAnimated:(BOOL)animated {
	return ( [self displayAnimated:animated completion:NULL] );
}

- (void)dismissAnimated:(BOOL)animated {
	return ( [self dismissAnimated:animated completion:NULL] );
}

- (void)displayAnimated:(BOOL)animated completion: (void (^)(BOOL)) completion {
    self.isShowing = YES;
    
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(orientationWillChange:)
												 name: UIApplicationWillChangeStatusBarOrientationNotification
											   object: nil];

	UIView *window = [[UIApplication sharedApplication] keyWindow];
	(void)self.view; //Trigger viewDidLoad
	[self changeOrientation:[[UIApplication sharedApplication] statusBarOrientation] animated:NO];
    if (self.dataSource != nil) {
        originPoint_ = [dataSource_ originPointForModalViewController:self];
    }
	[self moveOffScreen];
	tintView_.alpha = 0.0;
    
    [window addSubview:self.view];
    [[[UIApplication sharedApplication] delegate].window.rootViewController addChildViewController:self];
    [self didMoveToParentViewController:[[UIApplication sharedApplication] delegate].window.rootViewController];
	//[window addSubview:self.view];
	
	[self viewWillAppear: animated];
	
	dispatch_block_t displayBlock = ^{
		tintView_.alpha = [[self class] tintViewAlpha];
		modalView_.alpha = 1.0;
		
//		if ([self isKindOfClass:[CLModalPopoverController class]] == NO)
//			modalView_.center = [self onScreenCenterPointForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
		
		[self changeOrientation:[[UIApplication sharedApplication] statusBarOrientation] animated:NO];
	};
	
	if ( animated )
	{
		[UIView animateWithDuration: [[self class] animationDuration] animations: displayBlock completion:^(BOOL finished) {
			[self viewDidAppear: animated];
			if ( completion != NULL )
				completion(finished);
		}];
	}
	else
	{
		displayBlock();
		[self viewDidAppear: animated];
		if ( completion != NULL )
			completion(YES);
	}
}

- (void)dismissAnimated:(BOOL)animated completion: (void (^)(BOOL)) completion {
    if( !self.isShowing ) {
        return;
    }
    
    self.isShowing = false;
    
    if (self.dataSource != nil && recalculateOriginPoint_) {
        originPoint_ = [dataSource_ originPointForModalViewController:self];
    }
	
	dispatch_block_t displayBlock = ^{
		[self moveOffScreen];
		tintView_.alpha = 0.0;
	};
	
	[self viewWillDisappear: animated];
	
	if ( animated )
	{
		[UIView animateWithDuration: [[self class] animationDuration] animations: displayBlock completion: ^(BOOL finished) {
			[self.view removeFromSuperview];
			[self viewDidDisappear: animated];
            if (OSVersionAtLeast(5, 0))
                [self removeFromParentViewController];
			if ( completion != NULL )
				completion(finished);
		}];
	}
	else
	{
		displayBlock();
		[self.view removeFromSuperview];
		[self viewDidDisappear: animated];
        if (OSVersionAtLeast(5, 0))
            [self removeFromParentViewController];
		if ( completion != NULL )
			completion(YES);
	}
	
	
	if (delegate_ != nil) {
		[delegate_ modalViewControllerDidDismiss:self];
	}
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLCommentsTableViewKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLCommentsTableViewKeyboardDidHideNotification object:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	if (self.tapOffToDismiss) {
		UITouch *touch = [touches anyObject];
        
		if (!CGRectContainsPoint(modalView_.frame, [touch locationInView:self.view])) {
			if (!CGRectContainsPoint(modalView_.frame, [touch previousLocationInView:self.view]))
				[self dismissAnimated:YES];
		}
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPassthroughViews:(NSArray *)passthroughViews {
    ((CLSelectivePassthroughView *)self.view).passthroughViews = passthroughViews;
}

- (NSArray *)passthroughViews {
    return ((CLSelectivePassthroughView *)self.view).passthroughViews;
}

- (BOOL)tintBackground {
    [self view]; // ensure view is loaded
    return (tintView_.hidden == NO);
}

- (void)setTintBackground:(BOOL)tintBackground {
    [self view]; // ensure view is loaded
    tintView_.hidden = !tintBackground;
}

- (void)offsetTintView:(UIOffset)offset{
    tintView_.frame = CGRectOffset(tintView_.frame, offset.horizontal,offset.vertical);
}
@end
