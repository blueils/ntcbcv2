//
//  CLEmptyStateScreen.h
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-16.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLEmptyStateScreen : UIView {
    UIImageView *_icon;
    UILabel *_messageLabel, *_tipLabel;
    UIView *_topLine, *_bottomLine;
    UIButton *_bottomButton;
}
    
- (id)initWithFrame:(CGRect)frame iconFile:(NSString *)iconFile message:(NSString *)message tip:(NSString *)tip;

@property (nonatomic, retain) UIButton *bottomButton;

@end
