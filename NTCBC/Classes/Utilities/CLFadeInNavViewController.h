//
//  CLFadeInNavViewController.h
//  ALDOPrototype
//
//  Created by Michael Chung-Ching Lan on 2014-05-28.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSlideOutNavViewController.h"

@interface CLFadeInMenu : CLSlideOutMenu
@end

@interface CLFadeInNavViewController : UIViewController {
    CLFadeInMenu * _fadeInView;
}

@property (nonatomic, assign, getter = isShowingFadeInMenu) BOOL showFadeInMenu;

- (void)toggleFadeInMenu;

@end

@interface KCSlideOutMenuCell : UITableViewCell

@property (nonatomic, assign) BOOL adjustImageOnSelection;
@property (nonatomic, retain) UIColor *imageColor;

@end