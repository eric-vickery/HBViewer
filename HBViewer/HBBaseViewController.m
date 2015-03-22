//
//  HBBaseViewController.m
//  HBTest
//
//  Created by Eric Vickery on 12/27/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import "HBBaseViewController.h"
#import "CommonDeviceDetailsViewController.h"

@interface HBBaseViewController ()
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HBBaseViewController

- (void) setDevice:(HBBaseDevice *)device
{
	_device = device;
	self.title = device.name;
}

-(void) setGaugeEmptyColor:(UIColor *)gaugeEmptyColor
{
	_gaugeEmptyColor = gaugeEmptyColor;
	[self gaugeEmptyColorChanged];
}

-(void) setGaugeFilledColor:(UIColor *)gaugeFilledColor
{
	_gaugeFilledColor = gaugeFilledColor;
	[self gaugeFilledColorChanged];
}

-(void) gaugeEmptyColorChanged
{
}

-(void) gaugeFilledColorChanged
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
									 target:self
								   selector:@selector(onTick:)
								   userInfo:nil
									repeats:YES];
//	NSLog(@"Loading Widget and starting timer %@", self.timer);
}

- (void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
//	NSLog(@"Widget Disappearing and killing timer %@", self.timer);
	[self.timer invalidate];
	self.timer = nil;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Common Details"])
		{
		if ([segue.destinationViewController isKindOfClass:[CommonDeviceDetailsViewController class]])
			{
			CommonDeviceDetailsViewController *commonDetailsVC = segue.destinationViewController;
			commonDetailsVC.device = self.device;
			}
		}
}

-(void)onTick:(NSTimer *)timer
{
	[self sampleDevice];
}

-(void) sampleDevice
{
}

@end
