//
//  ContainingViewController.m
//  HBViewer
//
//  Created by Eric Vickery on 10/15/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import "ContainingViewController.h"
#import "HBViewerSplitViewController.h"

@interface ContainingViewController ()
@property (nonatomic, strong) UISplitViewController *splitViewController;

@end

@implementation ContainingViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"SplitView"])
		{
		if ([segue.destinationViewController isKindOfClass:[HBViewerSplitViewController class]])
			{
			self.splitViewController = segue.destinationViewController;
//			HBViewerSplitViewController *splitViewController = segue.destinationViewController;
			// TODO Setup whatever needs to be done here
			}
		}
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	if (size.width > size.height)
		{
		[self setOverrideTraitCollection:[UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular] forChildViewController: self.splitViewController];
		}
	else
		{
		[self setOverrideTraitCollection:nil forChildViewController:self.splitViewController];
		}
		
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
