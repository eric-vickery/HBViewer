//
//  HBBaseViewController.h
//  HBTest
//
//  Created by Eric Vickery on 12/27/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBViewer-Swift.h"

#define GAUGE_EMPTY_COLOR_KEY	@"Gauge Empty Color"
#define GAUGE_FILLED_COLOR_KEY	@"Gauge Filled Color"

@interface HBBaseViewController : UIViewController
@property (nonatomic, strong) HBBaseDevice *device;
@property (nonatomic, strong) UIColor *gaugeEmptyColor;
@property (nonatomic, strong) UIColor *gaugeFilledColor;

-(void) sampleDevice;
-(void) gaugeEmptyColorChanged;
-(void) gaugeFilledColorChanged;
@end
