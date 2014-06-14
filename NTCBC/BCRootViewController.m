//
//  BCRootViewController.m
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-05-18.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "BCRootViewController.h"
#import "BCBulletinViewController.h"
#import "CLCommon.h"
#import "NSString+IntegralSizing.h"
#import "BCUserSettings.h"


@interface BCRootViewController ()

@end

@implementation BCRootViewController

- (id)init
{
    self = [super init];
    if (self) {
        BCBulletinViewController *bulletinController = [[BCBulletinViewController alloc] init];
        bulletinController.navigationItem.leftBarButtonItems = [self leftBarButtonItems];
        UINavigationController *bulletinNavController = [[UINavigationController alloc] initWithRootViewController:bulletinController];
        _viewControllers = @[bulletinNavController];
        _sideNavTitles = @[@"Sunday Bulletin", @"Prayer Request", @"Special Event", @"My Account", @"Feedback"];
        _selectedIndex = [BCUserSettings latestNavIndex];
        
        [self addChildViewController:self.currentViewController];
    }
    return self;
}

#pragma mark
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsBlurringAvailable() == NO) {
        _slideOutView.barTintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    } else {
        _slideOutView.barStyle = UIBarStyleDefault;
    }
    _slideOutView.tintColor = [UIColor darkTextColor];
    _slideOutView.tableView.dataSource = self;
    _slideOutView.tableView.delegate = self;
    
    [self.view addSubview:self.currentViewController.view];
    [_slideOutView.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.currentViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.currentViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.currentViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.currentViewController viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark
#pragma mark Utilities

- (UIViewController *)currentViewController {
    return _viewControllers[_selectedIndex];
}

- (void)setSelectedIndex:(BCNavIndex)newIndex {
    [self setSelectedIndex:newIndex andUpdateSideMenu:YES];
}

- (void)setSelectedIndex:(BCNavIndex)newIndex andUpdateSideMenu:(BOOL)updateSideMenu {
	if ((newIndex == _selectedIndex) || (newIndex >= BCNavIndexTotal) ) {
        if (self.presentedViewController != nil)
            [self dismissViewControllerAnimated:YES completion:nil];
        
		return;
    }
	
	UIViewController *previousViewController = _viewControllers[_selectedIndex];
	UIViewController *currentViewController = _viewControllers[newIndex];
	_selectedIndex = newIndex;
    [BCUserSettings setLatestNavIndex:_selectedIndex];
	currentViewController.view.frame = self.view.bounds;
	
	[previousViewController viewWillDisappear:NO];
	[currentViewController viewWillAppear:YES];
	
	previousViewController.view.userInteractionEnabled = NO;
	currentViewController.view.userInteractionEnabled = NO;
	
    [self addChildViewController:currentViewController];
    
    currentViewController.view.alpha = 0.0;
    
    [self.view insertSubview:currentViewController.view belowSubview:_dimmerView];
	
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        currentViewController.view.alpha = 1.0;
    } completion:^(BOOL finished){
        [currentViewController viewDidAppear:YES];
        [previousViewController viewDidDisappear:YES];
        [previousViewController.view removeFromSuperview];
        [previousViewController removeFromParentViewController];
        
        previousViewController.view.alpha = 1.0;
        currentViewController.view.userInteractionEnabled = YES;
        previousViewController.view.userInteractionEnabled = YES;
    }];
    
    if (self.presentedViewController != nil)
		[self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)leftBarButtonItems {
    NSString *homeButtonTitle = NSLocalizedString(@"Home", @"Nav home button");
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[homeButton addTarget:self action:@selector(toggleSlideOutMenu) forControlEvents:UIControlEventTouchUpInside];
    [homeButton setTitle:homeButtonTitle forState:UIControlStateNormal];
    
    CGRect f = homeButton.bounds;
    f.size = [homeButtonTitle integralSizeWithFont:homeButton.titleLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 44.0) lineBreakMode:homeButton.titleLabel.lineBreakMode];
    homeButton.frame = f;
    
    UIView *itemView = [[UIView alloc] initWithFrame:f];
    itemView.backgroundColor = [UIColor clearColor];
    
    [itemView addSubview:homeButton];
    return @[[[UIBarButtonItem alloc] initWithCustomView:itemView]];
}

#pragma mark
#pragma mark Table View Data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return BCNavIndexTotal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SideNavCellIdentifier = @"BCSideNavCell";
    KBSlideOutMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:SideNavCellIdentifier];
    if (cell == nil) {
        cell = [[KBSlideOutMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SideNavCellIdentifier];
        cell.imageColor = [UIColor colorWithWhite:124.0/255.0 alpha:1.0];
        cell.textLabel.text = [_sideNavTitles objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark
#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BCNavIndex index = indexPath.row;
    [self setSelectedIndex:index andUpdateSideMenu:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        self.showSlideOutMenu = NO;
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
