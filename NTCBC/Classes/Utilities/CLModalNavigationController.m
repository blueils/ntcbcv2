//
//  CLModalNavigationController.m
//  AldoMCEv1
//
//  Created by Michael Lan on 2014-07-30.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "CLModalNavigationController.h"


@implementation CLModalNavigationController
@synthesize navController = navController_;

- (id)init {
    return [self initWithRootViewController:nil];
}

- (id)initWithRootViewController:(UIViewController *)viewController {
    if ( (self = [super init]) ) {
        if (viewController == nil)
            navController_ = [[UINavigationController alloc] init];
        else
            navController_ = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        navController_.delegate = self;
//        if (IsPad()) {
//            navController_.navigationBar.barStyle = UIBarStyleDefault;
//            navController_.navigationBar.barTintColor = [UIColor whiteColor];
//            navController_.navigationBar.translucent = NO;
//            navController_.navigationBar.tintColor = [UIColor blackColor];
//            navController_.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont koboSansSerifFontOfSize:20.0], NSForegroundColorAttributeName : [UIColor koboDarkText]};
//        }
        
        modalView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kKBModalViewWidth, 650)];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	modalView_.backgroundColor = [UIColor whiteColor];
	modalView_.layer.cornerRadius = 10;
	modalView_.layer.masksToBounds = YES;
	[self.view addSubview:modalView_];
    
    [self addChildViewController:navController_];
    navController_.view.frame = modalView_.bounds;
    navController_.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [modalView_ addSubview:navController_.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
    //return YES;
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [navController_ viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [navController_ viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navController_ viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [navController_ viewDidDisappear:animated];
}

- (void)close {
    [self dismissAnimated:YES];
}

- (CGSize)sizeForOrientation:(UIInterfaceOrientation)orientation {
    return CGSizeMake(600, UIInterfaceOrientationIsPortrait(orientation) ? 868 : 612);
}

#pragma mark -

- (void)setNavFrame:(CGRect)frame {
    modalView_.frame = frame;
}


@end
