//
//  CommonDeviceDetailsViewController.m
//  HBTest
//
//  Created by Eric Vickery on 12/27/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import "CommonDeviceDetailsViewController.h"
#import "WirelessInfoViewController.h"
#import "HBDeviceTypes.h"
#import "HBVersion.h"
#import "HBViewer-Swift.h"

@interface CommonDeviceDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *lastHeardButton;
@property (weak, nonatomic) IBOutlet UIImageView *wirelessImageView;

@end

@implementation CommonDeviceDetailsViewController

- (void) setDevice:(HBBaseDevice *)device
{
	_device = device;
	self.nameLabel.text = device.name;
	self.addressLabel.text = device.address;
	self.versionLabel.text = [device.version description];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.nameLabel.text = self.device.name;
	self.addressLabel.text = self.device.address;
	self.versionLabel.text = [self.device.version description];

	if ([self.device canConnectWirelessly])
		{
		[self.wirelessImageView setImage:[UIImage imageNamed:@"Wireless Capable"]];
		}

	// Hide the last heard button if the device is not connected wirelessly
	if (![self.device isConnectedWirelessly])
		{
		self.lastHeardButton.hidden = YES;
		}
	else
		{
		[self.wirelessImageView setImage:[UIImage imageNamed:@"Wireless Connected"]];
		}
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Wireless Info Popover"])
		{
		WirelessInfoViewController *viewController = (WirelessInfoViewController *)segue.destinationViewController;
		NSNumber *lastHeard = [NSNumber numberWithInt:[self.device lastHeard]];
		NSString *lastHeardFormatString;
		if ([lastHeard intValue] == 1)
			{
			lastHeardFormatString = @"%@ second";
			}
		else
			{
			lastHeardFormatString = @"%@ seconds";
			}
		
		NSString *lastHeardString = [NSString stringWithFormat:lastHeardFormatString, lastHeard];
		viewController.wirelessInfo = [NSString stringWithFormat: @"%@\r\nLast heard from %@ ago", [self.device pollingFreqAsString], lastHeardString];
		viewController.preferredContentSize = CGSizeMake(300, 75);
		viewController.popoverPresentationController.delegate = self;
		}
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
	return UIModalPresentationNone;
}

@end
