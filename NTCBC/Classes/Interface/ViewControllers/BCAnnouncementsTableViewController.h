//
//  BCAnnouncementsTableViewController.h
//  ntcbcv1
//
//  Created by Chung-Ching Lan on 12-03-31.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCAnnouncementsTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_items;
    
    UITableView *_tableView;
}

@end
