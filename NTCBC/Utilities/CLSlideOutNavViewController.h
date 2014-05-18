//
//  CLSlideOutNavViewController.h
//  NTCBC
//
//  Created by Chung-Ching Lan on 2014-05-15.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLSlideOutMenu : UIToolbar {
    UITableView *_tableView;
}

@property (nonatomic, readonly) UITableView *tableView;

@end

@interface CLSlideOutNavViewController : UIViewController {
    CLSlideOutMenu * _slideOutView;
    UIView *_dimmerView;
    UIScreenEdgePanGestureRecognizer *_slideOutPanGestureRecognizer;
    UIPanGestureRecognizer *_dismissingPanGestureRecognizer;
    CGPoint _dismissingTouchLocation;
}

@property (nonatomic, assign, getter = isShowingSlideOutMenu) BOOL showSlideOutMenu;

- (void)toggleSlideOutMenu;

@end

@interface KBSlideOutMenuCell : UITableViewCell

@property (nonatomic, assign) BOOL adjustImageOnSelection;
@property (nonatomic, retain) UIColor *imageColor;

@end
