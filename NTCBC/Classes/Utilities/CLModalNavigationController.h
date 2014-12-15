//
//  CLModalNavigationController.h
//  AldoMCEv1
//
//  Created by Michael Lan on 2014-07-30.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "CLModalViewController.h"

@interface CLModalNavigationController : CLModalViewController<UINavigationControllerDelegate> {
    UINavigationController *navController_;
}

@property (nonatomic, readonly) UINavigationController *navController;
@property (nonatomic, assign) BOOL shouldResizeOnRotation;

- (id)init;
- (id)initWithRootViewController:(UIViewController *)viewController;
- (void)setNavFrame: (CGRect) frame;
@end
