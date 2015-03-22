//
//  MoistureMeterViewController.m
//  HBTest
//
//  Created by Eric Vickery on 12/27/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import "MoistureMeterViewController.h"
#import "HBViewer-swift.h"

@interface MoistureMeterViewController ()
@property (nonatomic, strong) MoistureMeterDevice *moistureMeterDevice;

@property (weak, nonatomic) IBOutlet SimpleFlatStraightGaugeView *channel1Gauge;
@property (weak, nonatomic) IBOutlet SimpleFlatStraightGaugeView *channel2Gauge;
@property (weak, nonatomic) IBOutlet SimpleFlatStraightGaugeView *channel3Gauge;
@property (weak, nonatomic) IBOutlet SimpleFlatStraightGaugeView *channel4Gauge;
@end

@implementation MoistureMeterViewController

- (void) setDevice:(HBBaseDevice *)device
{
	[super setDevice:device];
	
	if ([device isKindOfClass:[MoistureMeterDevice class]])
		{
		self.moistureMeterDevice = (MoistureMeterDevice *)device;
		}
}

-(void) gaugeEmptyColorChanged
{
	[self.channel1Gauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.channel2Gauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.channel3Gauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.channel4Gauge setGaugeEmptyColor: self.gaugeEmptyColor];
}

-(void) gaugeFilledColorChanged
{
	[self.channel1Gauge setGaugeFilledColor: self.gaugeFilledColor];
	[self.channel2Gauge setGaugeFilledColor: self.gaugeFilledColor];
	[self.channel3Gauge setGaugeFilledColor: self.gaugeFilledColor];
	[self.channel4Gauge setGaugeFilledColor: self.gaugeFilledColor];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self.channel1Gauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.channel1Gauge setGaugeFilledColor: self.gaugeFilledColor];
	[self.channel2Gauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.channel2Gauge setGaugeFilledColor: self.gaugeFilledColor];
	[self.channel3Gauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.channel3Gauge setGaugeFilledColor: self.gaugeFilledColor];
	[self.channel4Gauge setGaugeEmptyColor: self.gaugeEmptyColor];
	[self.channel4Gauge setGaugeFilledColor: self.gaugeFilledColor];

	[self sampleDevice];
}

- (void) sampleDevice
{
	NSArray *sensorReadings = [[NSArray alloc] initWithArray:[self.moistureMeterDevice getSensorData]];
	[self.channel1Gauge setGaugeValue:[[sensorReadings objectAtIndex: 0] floatValue] animated:YES];
	[self.channel2Gauge setGaugeValue:[[sensorReadings objectAtIndex: 1] floatValue] animated:YES];
	[self.channel3Gauge setGaugeValue:[[sensorReadings objectAtIndex: 2] floatValue] animated:YES];
	[self.channel4Gauge setGaugeValue:[[sensorReadings objectAtIndex: 3] floatValue] animated:YES];
}

@end
