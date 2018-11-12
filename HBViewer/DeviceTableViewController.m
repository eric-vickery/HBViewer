//
//  DeviceTableViewController.m
//  HBViewer
//
//  Created by Eric Vickery on 10/27/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import "DeviceTableViewController.h"
#import "HBViewerSplitViewController.h"
#import "HBBaseViewController.h"
#import "ConfigViewController.h"
#import "HBAdapterInterface.h"
#import "HBAdapterFactory.h"
#import "HBVersion.h"
#import "HBDeviceTypes.h"

@interface DeviceTableViewController ()
@property (nonatomic, strong) HBAdapterInterface *adapterInterface;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, weak) HBViewerSplitViewController *splitView;
@property (nonatomic, strong) UIColor *gaugeEmptyColor;
@property (nonatomic, strong) UIColor *gaugeFilledColor;

@end

@implementation DeviceTableViewController

@dynamic refreshControl;

- (void) clearOutDetailPane
{
	// TODO Fix this to not show the "Device Not Found" page in portrait mode
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
	UIViewController *deviceView = [mainStoryboard instantiateViewControllerWithIdentifier:@"BlankDetail"];
	[self showDetailViewController: deviceView sender: self];
	//	if (!self.collapsed)
	//		{
	//		UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
	//		UIViewController *deviceView = [mainStoryboard instantiateViewControllerWithIdentifier:@"BlankDetail"];
	//		[self showDetailViewController: deviceView sender: self];
	//		NSLog(@"The view is NOT collapsed");
	//		}
	//	else
	//		{
	//		UINavigationController *masterView = (UINavigationController *)self.viewControllers[0];
	//		[masterView popToRootViewControllerAnimated:NO];
	//		NSLog(@"The view is collapsed");
	//		}
	//
	//	if (self.viewControllers.count == 1)
	//		{
	//		NSLog(@"Only Master available");
	//		}
	//	else
	//		{
	//		NSLog(@"Master and Detail available");
	//		}
	// Determine what mode the UISplitViewController is in and perform the approprate actions to clear the detail pane.
	//	UINavigationController *detailView = (id)self.viewControllers[1];
}

- (void) loadAdapter
{
	if (self.adapterInterface != nil)
		{
		[self.adapterInterface removeObserver:self];
		[self.adapterInterface disconnect];
		self.adapterInterface = nil;
		// Make the table refresh its data to clear out the table
		[self clearOutDetailPane];
		self.title = @"";
		[self.tableView reloadData];
		}
	
	[HBAdapterFactory loadAdapterWithObserver:self];
}

- (void) showAlertWithTitle: (NSString*) title message:(NSString*) message
{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title
																			  message: message
																	   preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
	[alertController addAction: defaultAction];
	
	[self presentViewController:alertController animated:YES completion:nil];
	
}

- (void) couldNotFindAnAdapter
{
	[self showAlertWithTitle:@"Error" message:@"Could not find a Master on the network. Make sure the Master is powered on."];
}

- (void) couldNotLoadAdapter
{
	[self showAlertWithTitle:@"Error" message:@"There was a problem connecting to the Master."];
}

- (void) adapterDisconnected:(NSError *)error
{
	// If error is nil then it was a normal disconnect so don't do anything. Otherwise the adapter disconnected because of some problem
	// so clear out the tableview and nil out the adapter.
	if (error != nil)
		{
		[self.adapterInterface removeObserver:self];
		self.adapterInterface = nil;
		// Make the table refresh its data to clear out the table
		[self clearOutDetailPane];
		self.title = @"";
		[self.tableView reloadData];
		
		[self showAlertWithTitle:@"Error" message:@"The Master disconnected unexpectedly."];
		}
}

- (void) adapterConnected:(HBAdapterInterface *)adapter
{
	self.adapterInterface = adapter;
	self.adapterVersion = [self.adapterInterface getVersion];
	self.adapterName = [self.adapterInterface getName];
	self.title = self.adapterName;
	self.splitView.splitViewButton.title = self.adapterName;
	[self.adapterInterface findAllDevices];
}

- (void) newDevicesDidAppear
{
	[self.tableView reloadData];
	[self.refreshControl endRefreshing];
}

- (void) refreshDeviceList
{
	[self.adapterInterface findAllDevices];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	self.gaugeEmptyColor = [UIColor colorWithHexString:[defaults objectForKey:GAUGE_EMPTY_COLOR_KEY]];
	self.gaugeFilledColor = [UIColor colorWithHexString:[defaults objectForKey:GAUGE_FILLED_COLOR_KEY]];
	
	[self loadAdapter];
	
	self.splitView = (HBViewerSplitViewController *)self.splitViewController;
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(refreshDeviceList) forControlEvents:UIControlEventValueChanged];
	self.refreshControl = self.refreshControl;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.adapterInterface.devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Device";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
		{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
	
	// Configure the cell...
	[self configureCell: cell atIndexPath: indexPath];
	
	return cell;
}

- (void)configureCell: (UITableViewCell *)cell atIndexPath: (NSIndexPath *)indexPath
{
	HBBaseDevice *device = [self.adapterInterface.devices objectAtIndex:[indexPath row]];
	[cell.textLabel setText: device.name];
	NSString *location = device.location;
	if (location.length)
		{
		[cell.detailTextLabel setText: location];
		}
	else
		{
		if (device.type < 255)
			{
			[cell.detailTextLabel setText: [NSString stringWithFormat:@"%@ v%@", device.address, [device.version description]]];
			}
		else
			{
			[cell.detailTextLabel setText: device.address];
			}
		}
	
	switch (device.type)
	{
		case TYPE_BAROMETER:
		[cell.imageView setImage: [UIImage imageNamed:@"Barometer"]];
		break;
		
		case TYPE_HUMIDITY:
		[cell.imageView setImage: [UIImage imageNamed:@"Humidity"]];
		break;
		
		case TYPE_MOISTURE_METER:
		[cell.imageView setImage: [UIImage imageNamed:@"Moisture Meter"]];
		break;
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Only show a disclosure indicator if we are collapsed
	if (self.splitView.collapsed)
		{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	else
		{
		cell.accessoryType = UITableViewCellAccessoryNone;
		}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
	HBBaseViewController *widgetView;
	
	HBBaseDevice *device = [self.adapterInterface.devices objectAtIndex:[indexPath row]];
	
	switch (device.type)
	{
		case TYPE_BAROMETER:
		widgetView = [mainStoryboard instantiateViewControllerWithIdentifier:@"BarometerView"];
		break;
		
		case TYPE_HUMIDITY:
		widgetView = [mainStoryboard instantiateViewControllerWithIdentifier:@"HumidityView"];
		break;
		
		case TYPE_MOISTURE_METER:
		widgetView = [mainStoryboard instantiateViewControllerWithIdentifier:@"MoistureMeterView"];
		break;
	}
	[widgetView setDevice: device];
	[widgetView setGaugeEmptyColor: self.gaugeEmptyColor];
	[widgetView setGaugeFilledColor: self.gaugeFilledColor];
	
	[self.splitView.splitPopover dismissPopoverAnimated:YES];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:widgetView];
	
	if (self.splitView.displayMode == UISplitViewControllerDisplayModePrimaryHidden)
		{
		[[widgetView navigationItem] setLeftBarButtonItem:self.splitView.splitViewButton animated:YES];
		}
	else
		{
		[[widgetView navigationItem] setLeftBarButtonItem:nil animated:YES];
		}
	[self showDetailViewController: navController sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Settings"])
		{
//		ConfigViewController *configController = (ConfigViewController *)segue.destinationViewController;
		}
	else
		{
//		HBBaseViewController *viewController = (HBBaseViewController *)segue.destinationViewController;
//		viewController.device = sender;
		}
}

- (IBAction)donePressedInConfigViewController:(UIStoryboardSegue *)segue;
{
	if ([segue.sourceViewController isKindOfClass:[ConfigViewController class]])
		{
		[self dismissViewControllerAnimated:YES completion:nil];
		
		BOOL somethingChanged = NO;
		ConfigViewController *viewController = (ConfigViewController *)segue.sourceViewController;
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		if (viewController.adapterType != viewController.previousAdapterType)
			{
			[defaults setObject: viewController.adapterType forKey:ADAPTER_TYPE_KEY];
			[self loadAdapter];
			somethingChanged = YES;
			}
		if (![[viewController.emptyColor hexStringValue] isEqualToString: [viewController.previousEmptyColor hexStringValue]])
			{
			[defaults setObject: [viewController.emptyColor hexStringValue] forKey:GAUGE_EMPTY_COLOR_KEY];
			self.gaugeEmptyColor = viewController.emptyColor;
			somethingChanged = YES;
			}
		if (![[viewController.filledColor hexStringValue] isEqualToString: [viewController.previousFilledColor hexStringValue]])
			{
			[defaults setObject: [viewController.filledColor hexStringValue] forKey:GAUGE_FILLED_COLOR_KEY];
			self.gaugeFilledColor = viewController.filledColor;
			somethingChanged = YES;
			}
		
		if (somethingChanged)
			{
			[defaults synchronize];
			}
		}
}

@end
