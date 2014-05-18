//
//  BCWorshipScheduleTableViewController.h
//  ntcbcv1
//
//  Created by Chung-Ching Lan on 12-03-31.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCWorshipScheduleTableViewController : UITableViewController {
    NSArray *_sections;
    NSMutableDictionary * _data;
    NSDictionary * _serviceTeams;
    NSDictionary * _pastors;
    
    BOOL _isNextWeek;
}

@property (nonatomic, assign) BOOL isNextWeek;

@end
