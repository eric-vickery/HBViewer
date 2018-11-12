//
//  HBViewerSplitViewController.m
//  HBViewer
//
//  Created by Eric Vickery on 10/15/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import "HBViewerSplitViewController.h"
#import "DeviceTableViewController.h"
#import "HBBaseViewController.h"
#import "ConfigViewController.h"
#import "HBAdapterInterface.h"
#import "HBAdapterFactory.h"
#import "HBVersion.h"
#import "HBDeviceTypes.h"

@interface HBViewerSplitViewController ()

@end

@implementation HBViewerSplitViewController

- (void) awakeFromNib
{
	[super awakeFromNib];
	
	self.delegate = self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//set the master nav delegates
//	UITableViewController * masterView = (id)[self.viewControllers[0] topViewController];
//	masterView.splitViewController = self;
//	masterView.tableView.delegate = self;
//	masterView.tableView.dataSource = self;
 
	//set a couple of settings
//	masterView.clearsSelectionOnViewWillAppear = NO;
//	masterView.preferredContentSize = CGSizeMake(320.0, 600.0);
	
//	self.refreshControl = [[UIRefreshControl alloc] init];
//	[self.refreshControl addTarget:self action:@selector(refreshDeviceList) forControlEvents:UIControlEventValueChanged];
//	masterView.refreshControl = self.refreshControl;
	//	self.refreshControl.tintColor = [UIColor colorWithRed:(254/255.0) green:(153/255.0) blue:(0/255.0) alpha:1];
}

- (void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	// Reload the table data to make it get rid of the disclosure indicator if we rotated. If it is a UITableViewController
	if ([self.viewControllers[0] isKindOfClass:[UINavigationController class]] &&
	[((UINavigationController *)self.viewControllers[0]).viewControllers[0] isKindOfClass:[UITableViewController class]])
		{
		UITableViewController *masterView = (UITableViewController *)((UINavigationController *)self.viewControllers[0]).viewControllers[0];
		[masterView.tableView reloadData];
		}
}

- (void)splitViewController:(UISplitViewController*)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem
	   forPopoverController:(UIPopoverController *)popoverController
{
	DeviceTableViewController * masterView = (id)[self.viewControllers[0] topViewController];
	if (masterView.adapterName.length > 0)
		{
		barButtonItem.title = masterView.adapterName;
		}
	else
		{
		barButtonItem.title = @"Back";
		}
	[[[self.viewControllers[1] topViewController] navigationItem] setLeftBarButtonItem:barButtonItem animated:YES];
	self.splitViewButton = barButtonItem;
	self.splitPopover = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	[[[self.viewControllers[1] topViewController] navigationItem] setLeftBarButtonItem:nil animated:YES];
	self.splitViewButton = nil;
	self.splitPopover = nil;
}

- (BOOL) splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
	if (([secondaryViewController isKindOfClass:[UINavigationController class]]
		&& [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[HBBaseViewController class]]
		&& ([(HBBaseViewController *)[(UINavigationController *)secondaryViewController topViewController] device] != nil)) ||
		([secondaryViewController isKindOfClass:[HBBaseViewController class]]
		 && ([(HBBaseViewController *)secondaryViewController device] != nil)))
		{
		return NO;
		}
	else
		{
		// Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
		return YES;
		}
}

@end
