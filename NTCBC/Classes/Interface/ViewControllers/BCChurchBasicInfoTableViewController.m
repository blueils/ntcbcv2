//
//  BCChurchBasicInfoTableViewController.m
//  ntcbcv1
//
//  Created by Chung-Ching Lan on 12-03-31.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import "BCChurchBasicInfoTableViewController.h"
#import "UIFont+NTCBC.h"
#import "NSString+IntegralSizing.h"


@implementation BCChurchBasicInfoTableViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"My NTCBC";
    
    _backgroundScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _backgroundScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _backgroundScrollView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    _backgroundScrollView.scrollEnabled = YES;
    [self.view addSubview:_backgroundScrollView];
    
    CGRect f = CGRectZero;
    CGFloat yOffset = 0.0;
    
    UIImageView *bannerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome_banner.jpg"]];
    [bannerImageView sizeToFit];
    CGFloat ratio = _backgroundScrollView.frame.size.width / bannerImageView.frame.size.width;
    if (ratio > 0) {
        f = bannerImageView.frame;
        f.size = CGSizeMake(ceilf(f.size.width * ratio), ceilf(f.size.height * ratio));
        bannerImageView.frame = f;
    }
    [_backgroundScrollView addSubview:bannerImageView];
    
    _welcomeView = [self createWelcomeView];
    [_backgroundScrollView addSubview:_welcomeView];
    
    f = _welcomeView.frame;
    f.origin = CGPointMake(floorf((_backgroundScrollView.frame.size.width - f.size.width) / 2.0), CGRectGetMaxY(bannerImageView.frame) + 10.0);
    _welcomeView.frame = f;
    
    _missionView = [self createOurMissionView];
    [_backgroundScrollView addSubview:_missionView];
    
    f = _missionView.frame;
    f.origin = CGPointMake(floorf((_backgroundScrollView.frame.size.width - f.size.width) / 2.0), CGRectGetMaxY(_welcomeView.frame) + 10.0);
    _missionView.frame = f;
    
    _contactInfoView = [self createChurchContactInfoView];
    [_backgroundScrollView addSubview:_contactInfoView];
    
    f = _contactInfoView.frame;
    f.origin = CGPointMake(floorf((_backgroundScrollView.frame.size.width - f.size.width) / 2.0), CGRectGetMaxY(_missionView.frame) + 10.0);
    _contactInfoView.frame = f;
    
    yOffset = CGRectGetMaxY(_contactInfoView.frame) + 10.0;
    
    _backgroundScrollView.contentSize = CGSizeMake(_backgroundScrollView.contentSize.width, yOffset);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIView *)createWelcomeView {
    UIView *welcomeView = [self createHomeBaseTileViewWithTitle:NSLocalizedString(@"Welcome To NTCBC", @"") andBody:NSLocalizedString(@"We’re glad you are here! Our worship service is designed for those in their teen years to adults. If you have children, we invite them to join our Nursery, Toddlers’, Pre-schoolers’ or Children’s programs as listed on the English Ministry bulletin board in the foyer.", @"")];
    
    return welcomeView;
}

- (UIView *)createOurMissionView {
    UIView *missionView = [self createHomeBaseTileViewWithTitle:NSLocalizedString(@"Our Mission", @"") andBody:NSLocalizedString(@"The purpose of the Church is to glorify God. We are to discern God’s vision for evangelism and mission, adopt it, and then to participate in it by praying, sending and proclaiming the Gospel by the power of the Holy Spirit.", @"")];
    
    return missionView;
}

- (UIView *)createChurchContactInfoView {
    UIView *infoView = [self createHomeBaseTileViewWithTitle:NSLocalizedString(@"Our Address", @"") andBody:NSLocalizedString(@"88 Finch Avenue West, North York. Ontario. Canada. M2N 2H7 \n\nTel: (416) 733-8088 \nFax: (416) 733-2974 \nE-mail: info@ntcbc.org \nWebsite: www.ntcbc.org", @"")];
    
    return infoView;
}

- (UIView *)createHomeBaseTileViewWithTitle: (NSString *)titleString andBody: (NSString *)bodyString {
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectZero];
    baseView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.layer.borderWidth = 0.5;
    baseView.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
    baseView.layer.cornerRadius = 3.0;
    baseView.layer.shadowColor = [[UIColor blackColor] CGColor];
    baseView.layer.shadowRadius = 3.0;
    baseView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    
    CGRect f = baseView.frame;
    f.size = CGSizeMake(self.view.bounds.size.width - 10.0, f.size.height);
    baseView.frame = f;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = [UIFont bcPrimaryFontOfSize:18.0];
    titleLabel.text = titleString;
    [baseView addSubview:titleLabel];
    
    [titleLabel sizeToFit];
    f = titleLabel.frame;
    f.origin = CGPointMake(10.0, 10.0);
    titleLabel.frame = f;
    
    UILabel *bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bodyLabel.backgroundColor = [UIColor whiteColor];
    bodyLabel.font = [UIFont bcSecondaryFontOfSize:16.0];
    bodyLabel.text = bodyString;
    bodyLabel.numberOfLines = 0;
    [baseView addSubview:bodyLabel];
    
    f = bodyLabel.frame;
    f.size.width = baseView.bounds.size.width - 20.0;
    f.size.height = [bodyLabel.text integralSizeWithFont:bodyLabel.font constrainedToSize:CGSizeMake(f.size.width, CGFLOAT_MAX) lineBreakMode:bodyLabel.lineBreakMode].height;
    f.origin = CGPointMake(floorf((baseView.frame.size.width - f.size.width) / 2.0), CGRectGetMaxY(titleLabel.frame) + 3.0);
    bodyLabel.frame = f;
    
    f = baseView.frame;
    f.size.height = CGRectGetMaxY(bodyLabel.frame) + 10.0;
    baseView.frame = f;
    
    return baseView;
}

@end
