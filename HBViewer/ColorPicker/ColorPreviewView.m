//
//  ColorPreviewView.m
//  CompositePhoto
//
//  Created by Nguyen Pham on 20/01/13.
//  Copyright (c) 2013 Nguyen Pham. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ColorPreviewView.h"

#define CORNER_RADIUS       6.0

@interface ColorPreviewView()

@end

@implementation ColorPreviewView

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
		{
		self.layer.cornerRadius = CORNER_RADIUS;
		
		if (self.shadow)
			{
			[self setupShadow];
			}
		}
	return self;
}

- (id) initWithFrame:(CGRect)frame color:(UIColor*)color shadow:(BOOL)shadow
{
    self = [super initWithFrame:frame];
    if (self)
		{
        self.layer.cornerRadius = CORNER_RADIUS;
        self.backgroundColor = color;
		
        self.shadow = shadow;
        if (self.shadow)
			{
            [self setupShadow];
			}
		}
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (shadow)
		{
        [self setupShadow];
		}
}

- (void) setupShadow
{
    CGRect frame = self.frame;
    frame.origin = CGPointZero;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:CORNER_RADIUS].CGPath;
}

-(void)setDisplayColor:(UIColor*)color
{
    self.backgroundColor = color;
}

-(UIColor*) getDisplayColor;
{
    return self.backgroundColor;
}

@end
