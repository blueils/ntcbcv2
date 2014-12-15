//
//  CLModalViewController.h
//  AldoMCEv1
//
//  Created by Michael Lan on 2014-07-30.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kKBModalViewWidth 540.0

enum {
	CLModalViewTransitionTypeSlide,
	CLModalViewTransitionTypeGrow,
    CLModalViewTransitionTypeFade
};
typedef NSUInteger CLModalViewTransitionType;

@class CLModalViewController;

@protocol CLModalViewControllerDataSource
- (CGPoint)originPointForModalViewController:(CLModalViewController *)modalViewController;
@end

@protocol CLModalViewControllerDelegate
- (void)modalViewControllerDidDismiss:(CLModalViewController *)modalViewController;
@end

@interface CLModalViewController : UIViewController {
	UIView *modalView_;	//IMPORTANT: the height of this view MUST be an even number
	UIView *tintView_;
	BOOL tapOffToDismiss_;
    BOOL recalculateOriginPoint_;
	CLModalViewTransitionType transitionType_;
    CGPoint originPoint_;
	
	__weak id<CLModalViewControllerDataSource> dataSource_;
	__weak id<CLModalViewControllerDelegate> delegate_;
}

+ (CGFloat) tintViewAlpha; // subclasses can override this to specify a different alpha value. Default = 0.6
+ (CGFloat) animationDuration; // subclasses can override this to specify different animation durations. Default = 0.3

@property (nonatomic, assign) BOOL tapOffToDismiss;
@property (nonatomic, assign) BOOL tintBackground;
@property (nonatomic, assign) CLModalViewTransitionType transitionType;
@property (nonatomic, weak) id<CLModalViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<CLModalViewControllerDelegate> delegate;

@property (nonatomic, readonly) UIView *modalView;

@property (nonatomic, copy) NSArray *passthroughViews;

- (void)displayAnimated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
- (void)displayAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion;
- (void)dismissAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion;
- (void)offsetTintView:(UIOffset)offset;

//For subclasses to override
- (BOOL)shouldResizeOnRotation; //default is NO
- (CGSize)sizeForOrientation:(UIInterfaceOrientation)orientation;
- (CGPoint)onScreenCenterPointForOrientation:(UIInterfaceOrientation)orientation;
- (void)changeOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
@end
