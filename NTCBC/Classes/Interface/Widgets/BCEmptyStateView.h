//
//  BCEmptyStateView.h
//  NTCBC
//
//  Created by Michael Lan on 2014-12-15.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCEmptyStateView : UIView {
    UIImageView *_iconImage;
    UILabel *_titleLabel, *_messageLabel;
    
    //We might need this in the future
    UIButton *_bottomButton;
}

- (id)initWithFrame:(CGRect)frame iconFile:(NSString *)iconFile message:(NSString *)message tip:(NSString *)tip;

@end
