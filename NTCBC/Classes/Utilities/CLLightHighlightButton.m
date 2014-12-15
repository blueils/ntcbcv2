//
//  CLLightHighlightButton.m
//  NTCBC
//
//  Created by Michael Lan on 2014-12-15.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "CLLightHighlightButton.h"

@implementation CLLightHighlightButton

@synthesize overlay = _overlay;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        _overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        _overlay.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        _overlay.hidden = YES;
        [self addSubview:_overlay];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGRect f = _overlay.frame;
    f.size = frame.size;
    _overlay.frame = f;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    _overlay.hidden = !highlighted;
}

- (void)addSubview:(UIView *)view {
    [self insertSubview:view belowSubview:_overlay];
}

@end
