//
//  CLEmptyStateScreen.m
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-16.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "CLEmptyStateScreen.h"
#import "NSString+IntegralSizing.h"
#import "CLCommon.h"
#import "UIFont+Aldo.h"

#define kTipInteriorGap 7.0
#define kTipExteriorGap 30.0
#define kIconGap 10.0
#define kTipMargin 20.0
#define kLineMargin 5.0

#define kIPadIconGap 32.0
#define kIPadLineWidth 420.0
#define kIPadTipMargin 10.0
#define kIPadTipExteriorGap 20.0

@implementation CLEmptyStateScreen
@synthesize bottomButton = _bottomButton;

- (id)initWithFrame:(CGRect)frame iconFile:(NSString *)iconFile message:(NSString *)message tip:(NSString *)tip {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.tintColor = [UIColor grayColor];
        
        _icon = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:iconFile] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
		[self addSubview:_icon];
        
		_messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_messageLabel.text = message;
		_messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:(IsPad() ? 26.0 : 18.0)];
		_messageLabel.backgroundColor = [UIColor clearColor];
		_messageLabel.numberOfLines = 0;
		_messageLabel.textAlignment = NSTextAlignmentCenter;
		_messageLabel.textColor = [UIColor darkTextColor];
		[self addSubview:_messageLabel];
		
		_topLine = [[UIView alloc] initWithFrame:CGRectZero];
		_topLine.backgroundColor = [UIColor grayColor];
		[self addSubview:_topLine];
		
		_tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_tipLabel.text = tip;
		_tipLabel.numberOfLines = 0;
		_tipLabel.textColor = [UIColor grayColor];
		_tipLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
		_tipLabel.textAlignment = NSTextAlignmentCenter;
		_tipLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_tipLabel];
		
		_bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
		_bottomLine.backgroundColor = [UIColor grayColor];
        [self addSubview:_bottomLine];
		
        
        if (tip == (id)[NSNull null] || tip.length == 0 ) {
            _tipLabel.hidden = YES;
            _topLine.hidden = YES;
            _bottomLine.hidden = YES;
        }
    }
    
    return self;
}

- (void)layoutSubviews {
	
	CGSize insetSize = CGRectInset(self.bounds, 15.0, 15.0).size;
	CGSize messageSize = [_messageLabel sizeThatFits: insetSize];
	CGRect f = _messageLabel.frame;
	f.size = messageSize;
	_messageLabel.frame = f;
	
	CGFloat tipHeight = [_tipLabel.font heightForNumberOfLines:2];
	
	CGSize maxSize;
	if( IsPad() ) {
		maxSize = CGSizeMake(kIPadLineWidth - (2 * kIPadTipMargin), CGFLOAT_MAX);
	} else {
		maxSize = CGSizeMake(self.frame.size.width - 2 * kTipMargin, CGFLOAT_MAX);
	}
	CGSize actualSize = [_tipLabel.text integralSizeWithFont:_tipLabel.font constrainedToSize:maxSize lineBreakMode:_tipLabel.lineBreakMode];
	
	CGFloat totalHeight;
	if( IsPad() ) {
		totalHeight = _icon.frame.size.height + kIPadIconGap + _messageLabel.frame.size.height + kIPadTipExteriorGap + 1.0 + kTipInteriorGap + tipHeight + kTipInteriorGap + 1.0;
	} else {
		totalHeight = _icon.frame.size.height + kIconGap + _messageLabel.frame.size.height + kTipExteriorGap + 1.0 + kTipInteriorGap + tipHeight + kTipInteriorGap + 1.0;
	}
    
    if (_bottomButton != nil) {
        totalHeight += _bottomButton.frame.size.height + 20;
    }
	
	CGRect iconRect = _icon.frame;
	
	if( IsPad() ) {
        iconRect.origin = CGPointMake(floorf((self.frame.size.width - iconRect.size.width) / 2.0), floorf((self.frame.size.height - totalHeight) / 2.0) - 45.0);
    } else {
        iconRect.size = CGSizeMake(ceilf(iconRect.size.width * 0.8), ceilf(iconRect.size.height * 0.8));
        iconRect.origin = CGPointMake(floorf((self.frame.size.width - iconRect.size.width) / 2.0), floorf((self.frame.size.height - totalHeight) / 2.0));
    }
	_icon.frame = iconRect;
	
	CGRect messageRect = _messageLabel.frame;
	messageRect.origin = CGPointMake(floorf((self.frame.size.width - messageRect.size.width) / 2.0), iconRect.origin.y + iconRect.size.height + (IsPad() ? kIPadIconGap : kIconGap) );
	_messageLabel.frame = messageRect;
	
	CGRect topLineRect;
	if( IsPad() ) {
		topLineRect = CGRectMake(0.0, 0.0, kIPadLineWidth, 1.0);
		topLineRect.origin = CGPointMake(floorf((self.frame.size.width - kIPadLineWidth) / 2), messageRect.origin.y + messageRect.size.height + kIPadTipExteriorGap);
	} else {
		topLineRect = CGRectMake(0.0, 0.0, self.frame.size.width - 2 * kLineMargin, 1.0);
		topLineRect.origin = CGPointMake(kLineMargin, messageRect.origin.y + messageRect.size.height + kTipExteriorGap);
	}
	_topLine.frame = topLineRect;
	
	CGRect tipRect;
	if( IsPad() ) {
		tipRect = CGRectMake(floorf((self.frame.size.width - kIPadLineWidth) / 2) + kIPadTipMargin, topLineRect.origin.y + topLineRect.size.height + kIPadTipExteriorGap, kIPadLineWidth - (2 * kIPadTipMargin), actualSize.height);
	} else {
		tipRect = CGRectMake(kTipMargin, topLineRect.origin.y + topLineRect.size.height + kTipInteriorGap, self.frame.size.width - 2 * kTipMargin, actualSize.height);
	}
    
	_tipLabel.frame = tipRect;
	
	CGRect bottomLineRect = topLineRect;
	bottomLineRect.origin.y = tipRect.origin.y + tipRect.size.height + kTipInteriorGap;
	_bottomLine.frame = bottomLineRect;
    
    if (_bottomButton != nil) {
        CGRect buttonRect = _bottomButton.frame;
        buttonRect.origin.y = CGRectGetMaxY(_bottomLine.frame) + (IsPad()? 20.0 : 10.0);
        buttonRect.origin.x = floorf((self.bounds.size.width - buttonRect.size.width) / 2.0);
        _bottomButton.frame = buttonRect;
    }
}

- (void)setBottomButton:(UIButton *)newBottomButton {
    [_bottomButton removeFromSuperview];
    _bottomButton = newBottomButton;
    
    [self addSubview:_bottomButton];
    [self setNeedsLayout];
}

@end
