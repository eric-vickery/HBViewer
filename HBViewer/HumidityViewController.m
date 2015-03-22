//
//  HumidityViewController.m
//  HBTest
//
//  Created by Eric Vickery on 12/27/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import "HumidityViewController.h"
#import "HBViewer-swift.h"

@interface HumidityViewController ()
@property (nonatomic, strong) HumidityDevice *humidityDevice;

@property (weak, nonatomic) IBOutlet SimpleFlatRoundGaugeView *humidityGauge;
@property (weak, nonatomic) IBOutlet SimpleFlatStraightGaugeView *temperatureGauge;

@end

@implementation HumidityViewController

- (void) setDevice:(HBBaseDevice *)device
{
	[super setDevice:device];
	
	if ([device isKindOfClass:[HumidityDevice class]])
		{
		self.humidityDevice = (HumidityDevice *)device;
		}
}

-(void) gaugeEmptyColorChanged
{
	[self.humidityGauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.temperatureGauge setGaugeEmptyColor: self.gaugeEmptyColor];
}

-(void) gaugeFilledColorChanged
{
	[self.humidityGauge setGaugeFilledColor: self.gaugeFilledColor];
	[self.temperatureGauge setGaugeFilledColor: self.gaugeFilledColor];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self.humidityGauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.humidityGauge setGaugeFilledColor: self.gaugeFilledColor];
	[self.temperatureGauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.temperatureGauge setGaugeFilledColor: self.gaugeFilledColor];
	
	[self sampleDevice];
}

- (void) sampleDevice
{
	[self.humidityGauge setGaugeValue:[self.humidityDevice getHumidity] animated:YES];
	[self.temperatureGauge setGaugeValue:[self.humidityDevice getTemperatureInFahrenheit] animated:YES];
}

@end
