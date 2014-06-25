//
//  BCBulletinViewController.h
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-06-12.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    BCBulletinIndexService = 0,
    BCBulletinIndexNotes,
    BCBulletinIndexSS,
    BCBulletinIndexEvents,
    BCBulletinIndexPrayerRequests,
    
    BCBulletinIndexTotal
};
typedef NSInteger BCBulletinIndex;

@interface BCBulletinViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSArray *_bulletinSections;
    NSArray *_funColorList;
}

@end
