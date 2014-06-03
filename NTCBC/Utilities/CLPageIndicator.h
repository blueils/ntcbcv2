//
//  CLPageIndicator.h
//  ALDOPrototype
//
//  Created by Michael Chung-Ching Lan on 2014-05-29.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLPageIndicator : UIView {
	NSUInteger pages_;
	NSUInteger page_;
	
	//NSMutableArray *pips_;
	CGPathRef _pipPath;
    
	CGFloat pipRadius_;
	CGFloat pipThickness_;
	
	UIColor * emptyColor_;
	UIColor * fillColor_;
}

@property (nonatomic, assign) NSUInteger pages;
@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) CGFloat pipRadius;
@property (nonatomic, assign) CGFloat pipThickness;

@property (nonatomic, retain) UIColor * emptyColor;
@property (nonatomic, retain) UIColor * fillColor;
@end
