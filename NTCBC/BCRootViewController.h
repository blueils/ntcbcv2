//
//  BCRootViewController.h
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-05-18.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "CLSlideOutNavViewController.h"

enum {
    BCNavIndexBulletin = 0,
    BCNavIndexPrayerRequest,
    BCNavIndexEvents,
    BCNavIndexAccount,
    BCNavIndexFeedback,
//    BCNavIndexSchedule,
//    BCNavIndexAnnouncements,
//    BCNavIndexPrayers,
//    BCNavIndexBuildFaith,
    
    BCNavIndexTotal
};
typedef NSInteger BCNavIndex;

@interface BCRootViewController : CLSlideOutNavViewController<UITableViewDataSource, UITableViewDelegate> {
    NSArray *_viewControllers;
    NSArray *_sideNavTitles;
    
    BCNavIndex _selectedIndex;
    
    
}

@property (nonatomic, readonly) UIViewController *currentViewController;

@end
