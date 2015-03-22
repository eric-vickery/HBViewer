//
//  ViewController.m
//  HBTest
//
//  Created by Eric Vickery on 12/17/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import "ViewController.h"
//#import "HBAdapterViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *IPAddressEdit;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//	HBAdapterViewController *vc = (HBAdapterViewController *)[segue destinationViewController];
//	vc.hostName = self.IPAddressEdit.text;
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
	if ([identifier isEqualToString:@"Connect"])
		{
		if ([self.IPAddressEdit.text length] != 0)
			{
			return YES;
			}
		else
			{
			return NO;
			}
		}
	return YES;
}

@end
