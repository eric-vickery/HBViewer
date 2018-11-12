//
//  BarometerViewController.m
//  HBTest
//
//  Created by Eric Vickery on 12/27/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import "BarometerViewController.h"
#import "HBViewer-Swift.h"

@interface BarometerViewController ()
@property (nonatomic, strong) BarometerDevice *baroDevice;

@property (weak, nonatomic) IBOutlet SimpleFlatRoundGaugeView *pressureGauge;
@property (weak, nonatomic) IBOutlet SimpleFlatStraightGaugeView *tempertureGauge;

@end

@implementation BarometerViewController

- (void) setDevice:(HBBaseDevice *)device
{
	[super setDevice:device];
	
	if ([device isKindOfClass:[BarometerDevice class]])
		{
		self.baroDevice = (BarometerDevice *)device;
		}
}

-(void) gaugeEmptyColorChanged
{
	[self.pressureGauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.tempertureGauge setGaugeEmptyColor: self.gaugeEmptyColor];
}

-(void) gaugeFilledColorChanged
{
	[self.pressureGauge setGaugeFilledColor: self.gaugeFilledColor];
	[self.tempertureGauge setGaugeFilledColor: self.gaugeFilledColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.pressureGauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.pressureGauge setGaugeFilledColor: self.gaugeFilledColor];
	[self.tempertureGauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.tempertureGauge setGaugeFilledColor: self.gaugeFilledColor];

	[self sampleDevice];
}

- (void) sampleDevice
{
	[self.pressureGauge setGaugeValueWithValue:[self.baroDevice getPressureIninHg] animated:YES];
	[self.tempertureGauge setGaugeValueWithValue:[self.baroDevice getTemperatureInFahrenheit] animated:YES];
}

@end
