//
//  ConfigViewController.m
//  HBViewer
//
//  Created by Eric Vickery on 10/8/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import "ConfigViewController.h"
#import "HBAdapterFactory.h"
#import "HBBaseViewController.h"

@interface ConfigViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *demoEthernetSwitch;
@property (weak, nonatomic) IBOutlet UIButton *gaugeEmptyButton;
@property (weak, nonatomic) IBOutlet UIButton *gaugeFilledButton;

@property Boolean pickingEmptyColor;

@end

@implementation ConfigViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	self.adapterType = [defaults objectForKey:ADAPTER_TYPE_KEY];
	self.previousAdapterType = self.adapterType;
	[self.demoEthernetSwitch setSelectedSegmentIndex:[self.adapterType intValue]];
	
	self.emptyColor = [UIColor colorWithHexString:[defaults objectForKey:GAUGE_EMPTY_COLOR_KEY]];
	self.previousEmptyColor = self.emptyColor;
	[self.gaugeEmptyButton setBackgroundColor: self.emptyColor];

	self.filledColor = [UIColor colorWithHexString:[defaults objectForKey:GAUGE_FILLED_COLOR_KEY]];
	self.previousFilledColor = self.emptyColor;
	[self.gaugeFilledButton setBackgroundColor: self.filledColor];
	
	self.title = @"Settings";
}

- (IBAction)cancelButtonPressed:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)demoEthernetSwitchChanged:(id)sender
{
	self.adapterType = [NSNumber numberWithInteger: self.demoEthernetSwitch.selectedSegmentIndex];
}

- (IBAction)gaugeEmptyButtonPressed:(id)sender
{
	UIStoryboard *colorPickerStoryboard = [UIStoryboard storyboardWithName:@"ColorPicker" bundle: nil];

	NEOColorPickerViewController *controller = [colorPickerStoryboard instantiateViewControllerWithIdentifier:@"Color Picker Main View"];
	controller.delegate = self;
	controller.selectedColor = self.emptyColor;
	controller.title = @"Gauge Empty Color";
	
	self.pickingEmptyColor = YES;
	
	[self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)gaugeFilledButtonPressed:(id)sender
{
	UIStoryboard *colorPickerStoryboard = [UIStoryboard storyboardWithName:@"ColorPicker" bundle: nil];
	
	NEOColorPickerViewController *controller = [colorPickerStoryboard instantiateViewControllerWithIdentifier:@"Color Picker Main View"];
	controller.delegate = self;
	controller.selectedColor = self.filledColor;
	controller.title = @"Gauge Filled Color";
	
	self.pickingEmptyColor = NO;
	
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color
{
	if (self.pickingEmptyColor)
		{
		self.emptyColor = color;
		self.gaugeEmptyButton.backgroundColor = color;
		}
	else
		{
		self.filledColor = color;
		self.gaugeFilledButton.backgroundColor = color;
		}
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender
{
	return NO;
}
@end
