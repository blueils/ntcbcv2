//
//  BCChurchBasicInfoTableViewController.h
//  ntcbcv1
//
//  Created by Chung-Ching Lan on 12-03-31.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCChurchBasicInfoTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSArray * _titles;
    UITableView *_tableView;
    NSDictionary * _churchInfo;
}

@end
