//
//  CLLightHighlightButton.h
//  NTCBC
//
//  Created by Michael Lan on 2014-12-15.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLLightHighlightButton : UIButton {
    UIView *_overlay;
}

@property (nonatomic, retain) UIView *overlay;

@end
