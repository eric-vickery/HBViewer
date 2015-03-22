//
//  WirelessInfoViewController.m
//  HBViewer
//
//  Created by Eric Vickery on 10/15/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import "WirelessInfoViewController.h"

@interface WirelessInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *wirelessInfoLabel;

@end

@implementation WirelessInfoViewController

@synthesize wirelessInfo = _wirelessInfo;

-(void) setWirelessInfo:(NSString *)wirelessInfo
{
	if (![_wirelessInfo isEqualToString:wirelessInfo])
		{
		_wirelessInfo = wirelessInfo;
		self.wirelessInfoLabel.text = _wirelessInfo;
		}
}

-(void) viewDidLoad
{
	self.wirelessInfoLabel.text = _wirelessInfo;
}

@end
