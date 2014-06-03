//
//  CLPageIndicator.m
//  ALDOPrototype
//
//  Created by Michael Chung-Ching Lan on 2014-05-29.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//
#import "CLPageIndicator.h"
#import "CLCommon.h"

#define kPipColor [UIColor grayColor]

#pragma mark CLPip
@interface CLPip : UIView {
	UIColor *color_;
	CGFloat radius_;
	CGFloat thickness_;
	BOOL fill_;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat thickness;
@property (nonatomic, assign) BOOL fill;

@end


@implementation CLPip
@synthesize color = color_, radius = radius_, thickness = thickness_, fill = fill_;

+ (Class)layerClass {
	return [CAShapeLayer class];
}

- (CGSize)sizeThatFits:(CGSize)aSize {
	CGFloat size = radius_ * 2;
	return CGSizeMake(size, size);
}

- (void)setColor:(UIColor *)color {
	color_ = color;
	
	CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
	shapeLayer.strokeColor = [color_ CGColor];
	shapeLayer.fillColor = (fill_?[color_ CGColor]:nil);
}

- (void)setRadius:(CGFloat)radius {
	radius_ = radius;
	
	CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddEllipseInRect(path, nil, CGRectInset(CGRectMake(0.0, 0.0, radius * 2, radius * 2), thickness_ / 2.0, thickness_ / 2.0));
	shapeLayer.path = path;
	CGPathRelease(path);
	
}

- (void)setThickness:(CGFloat)thickness {
	thickness_ = thickness;
	
	CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddEllipseInRect(path, nil, CGRectInset(CGRectMake(0.0, 0.0, radius_ * 2, radius_ * 2), thickness_ / 2.0, thickness_ / 2.0));
	shapeLayer.path = path;
	shapeLayer.lineWidth = thickness;
	CGPathRelease(path);
}

- (void)setFill:(BOOL)fill {
	fill_ = fill;
	
	CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
	shapeLayer.fillColor = (fill?[color_ CGColor]:nil);
	
}

@end

#pragma mark CLPageIndicator

@interface CLPageIndicator (CLPipPath)
- (void) updatePipPath;
@end

@implementation CLPageIndicator
@synthesize pages = pages_, page = page_, pipRadius = pipRadius_, pipThickness = pipThickness_, emptyColor=emptyColor_, fillColor=fillColor_;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		//pips_ = [[NSMutableArray alloc] initWithCapacity:10];
		self.pipRadius = 6.0;
		self.pipThickness = 2.0;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.emptyColor = kPipColor;
		self.fillColor = kPipColor;
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if ( (self = [super initWithFrame:frame]) ) {
		//pips_ = [[NSMutableArray alloc] initWithCapacity:10];
		self.pipRadius = 6.0;
		self.pipThickness = 2.0;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.emptyColor = kPipColor;
		self.fillColor = kPipColor;
	}
	
	return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)dealloc {
	CGPathRelease(_pipPath);
}

#pragma mark - Accessibility

- (BOOL) isAccessibilityElement
{
	// overridden, since UIView isn't normally an accessibility element
	return ( YES );
}

- (NSString *) accessibilityLabel
{
	return ( [NSString stringWithFormat: NSLocalizedString(@"Page %1$lu of %2$lu", @"Page indicator accessibility label. Args are 1 = current page, 2 = total pages"), (unsigned long)page_+1, (unsigned long)pages_] );
}

- (NSString *) accessibilityHint
{
	return ( NSLocalizedString(@"Displays the position of the current page in the current range", @"Page indicator accessibility hint") );
}

- (UIAccessibilityTraits) accessibilityTraits
{
	if ( OSVersionAtLeast(4, 0) )
		return ( UIAccessibilityTraitAdjustable );
	return ( UIAccessibilityTraitNone );
}

- (void) accessibilityIncrement
{
	[self setPage: page_ + 1];
}

- (void) accessibilityDecrement
{
	[self setPage: page_ - 1];
}

#pragma mark -
#pragma mark Drawing

- (CGFloat)pipGap {
	CGFloat gap = floor(60 / (double)pages_);
	gap = MIN(gap, 20);
	gap = MAX(gap, 6);
	return gap;
}

- (CGRect) rectForPipAtIndex: (NSUInteger) index
{
	CGFloat pipGap = [self pipGap];
	CGFloat contentSize = pages_ * 2 * pipRadius_ + (pages_ - 1) * pipGap;
	CGFloat contentOffset = (self.bounds.size.width - contentSize) * 0.5;
	
	CGRect pipFrame = CGRectZero;
	pipFrame.size.height = pipFrame.size.width = pipRadius_ * 2.0;
	pipFrame.origin.x = contentOffset + index * (2.0 * pipRadius_ + pipGap);
	
	return ( pipFrame );
}

- (CGSize) sizeThatFits: (CGSize) aSize
{
	CGFloat pipGap = [self pipGap];
	CGSize ideal = CGSizeZero;
	ideal.width = pages_ * (2 * pipRadius_) + (pages_ - 1) * pipGap;
	ideal.height = 2 * pipRadius_;
	
	if ( CGSizeEqualToSize(aSize, CGSizeZero) )
		return ( ideal );
	
	if ( aSize.width > ideal.width )
		aSize.width = ideal.width;
	if ( aSize.height > ideal.height )
		aSize.height = ideal.height;
	
	return ( aSize );
}

- (void)setPages:(NSUInteger)pages {
	/*NSInteger difference = pages - pages_;
     
     if (difference < 0) {
     for (NSInteger i = 0; i > difference; i--) {
     [[pips_ lastObject] removeFromSuperview];
     [pips_ removeLastObject];
     [self setNeedsLayout];
     }
     } else {
     for (NSInteger i = 0; i < difference; i++) {
     KBPip *newPip = [[KBPip alloc] initWithFrame:CGRectZero];
     newPip.backgroundColor = [UIColor clearColor];
     newPip.radius = self.pipRadius;
     newPip.thickness = self.pipThickness;
     newPip.fill = (pages_ + i) == page_;
     newPip.color = kPipColor;
     [pips_ addObject:newPip];
     [self addSubview:newPip];
     [newPip release];
     [self setNeedsLayout];
     }
     }
     
     if (pages == 1) {
     [[pips_ objectAtIndex:0] setAlpha:0.0];
     } else if (pages > 1) {
     [[pips_ objectAtIndex:0] setAlpha:1.0];
     }
     
     */
	if ( pages_ == pages )
		return;
	
	pages_ = pages;
	[self setNeedsDisplay];
}

- (void)setPage:(NSUInteger)page {
	if ( page >= pages_ )		// this will catch 0 - 1 too, since that will overflow to UINT_MAX, which is normally > pages_
		return;
	/*
     if (page_ < pages_) {
     KBPip *pip = [pips_ objectAtIndex:page_];
     pip.fill = NO;
     }
     
     if (page < pages_) {
     KBPip *pip = [pips_ objectAtIndex:page];
     pip.fill = YES;
     }
     */
	if ( page_ == page )
		return;
	
	[self setNeedsDisplayInRect: [self rectForPipAtIndex: page_]];
	
	page_ = page;
	[self setNeedsDisplayInRect: [self rectForPipAtIndex: page_]];
	
	if ( OSVersionAtLeast(4, 2) )
		UIAccessibilityPostNotification( UIAccessibilityPageScrolledNotification, self.accessibilityLabel );
}
/*
 - (void)layoutSubviews {
 CGFloat pipGap = [self pipGap];
 CGFloat contentSize = pages_ * 2 * self.pipRadius + (pages_ - 1) * pipGap;
 CGFloat contentOffset = (self.bounds.size.width - contentSize) / 2.0;
 
 for (NSInteger i = 0; i < pips_.count; i++) {
 KBPip *pip = [pips_ objectAtIndex:i];
 [pip sizeToFit];
 CGRect frame = pip.frame;
 frame.origin = CGPointMake(contentOffset + i * (2 * self.pipRadius + pipGap), 0.0);
 pip.frame = frame;
 }
 }
 */

- (void)setPipRadius:(CGFloat)newRadius {
	/*
     for (KBPip *pip in pips_) {
     pip.radius = newRadius;
     }
	 */
	if ( pipRadius_ == newRadius )
		return;
	pipRadius_ = newRadius;
	[self updatePipPath];
	[self setNeedsDisplay];
}

- (void)setPipThickness:(CGFloat)newThickness {
	/*
     for (KBPip *pip in pips_) {
     pip.thickness = newThickness;
     }
	 */
	
	if ( pipThickness_ == newThickness )
		return;
	
	pipThickness_ = newThickness;
	[self updatePipPath];
	[self setNeedsDisplay];
}

- (void) drawRect: (CGRect) rect
{
	[self.backgroundColor setFill];
	UIRectFill( self.bounds );
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	for ( NSUInteger i = 0; i < pages_; i++ )
	{
		CGRect pipRect = [self rectForPipAtIndex: i];
		CGContextTranslateCTM(ctx, pipRect.origin.x, pipRect.origin.y);
		
		CGContextSetLineWidth( ctx, pipThickness_ );
		
		CGContextAddPath(ctx, _pipPath);
		CGPathDrawingMode mode = kCGPathStroke;
		if ( i == page_ )
		{
			[self.fillColor set];
			mode = kCGPathFillStroke;
		}
		else
		{
			[self.emptyColor set];
		}
		
		CGContextDrawPath(ctx, mode);
		
		// reset the transformation, ready for the next one
		CGContextTranslateCTM(ctx, -pipRect.origin.x, -pipRect.origin.y);
	}
}

@end

@implementation CLPageIndicator (CLPipPath)

- (void) updatePipPath
{
	CGMutablePathRef path = CGPathCreateMutable();
	CGFloat diameter = pipRadius_ * 2.0;
	CGFloat inset = pipThickness_ * 0.5;
	CGPathAddEllipseInRect(path, nil, CGRectInset(CGRectMake(0.0, 0.0, diameter, diameter), inset, inset));
	
	CGPathRelease(_pipPath);
	_pipPath = CGPathCreateCopy(path);
	CGPathRelease(path);
}

@end

