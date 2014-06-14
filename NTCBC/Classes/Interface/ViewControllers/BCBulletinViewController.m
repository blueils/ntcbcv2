//
//  BCBulletinViewController.m
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-06-12.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "BCBulletinViewController.h"
#import "BCChurchBasicInfoTableViewController.h"
#import "BCWorshipScheduleTableViewController.h"
#import "BCAnnouncementsTableViewController.h"
#import "BCPrayerRequestsViewController.h"
#import "BCBuildFaithTableViewController.h"
#import "BCBullitenTableViewCell.h"
#import "UIColor+RandomColor.h"

@interface BCBulletinViewController ()

@end

@implementation BCBulletinViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bulletinSections = @[@"Church Info", @"Worship Schedules", @"Announcements", @"Weekly Prayer Requests", @"Build Up Your Faith", @"General Information"];
        _funColorList = [UIColor listOfRandomColorWithLength:[_bulletinSections count]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"Sunday Bulletin", @"Bulletin page title");
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bulletinSections count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BCBullitenTableViewCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"bulletinMainCellIdentifier";
    BCBullitenTableViewCell *cell = (BCBullitenTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BCBullitenTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setFunColor: [_funColorList objectAtIndex:indexPath.row]];
    [cell setTitle:[_bulletinSections objectAtIndex:[indexPath row]] withImage:nil];
    return cell;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController * viewController = nil;
    switch (indexPath.row) {
        case BCBulletinIndexBasicInfo: {
            viewController = [[BCChurchBasicInfoTableViewController alloc] init];
            
            break;
        }
        case BCBulletinIndexSchedule: {
            viewController = [[BCWorshipScheduleTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            break;
        }
        case BCBulletinIndexAnnouncements: {
            viewController = [[BCAnnouncementsTableViewController alloc] initWithStyle:UITableViewStylePlain];
            break;
        }
        case BCBulletinIndexPrayers: {
            viewController = [[BCPrayerRequestsViewController alloc] init];
            break;
        }
        case BCBulletinIndexBuildFaith: {
            viewController = [[BCBuildFaithTableViewController alloc] initWithStyle:UITableViewStylePlain];
            break;
        }
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
