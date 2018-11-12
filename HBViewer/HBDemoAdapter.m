//
//  HBDemoAdapter.m
//  HBViewer
//
//  Created by Eric Vickery on 10/8/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import "HBDemoAdapter.h"
#import "HBDeviceTypes.h"
#import "HBViewer-Swift.h"

@implementation HBDemoAdapter

- (id)initWithObserver:(id <HBAdapterInterfaceDelegate>)observer
{
	if ((self = [super init]))
		{
		[self addObserver:observer];
		}
	
	return self;
}

- (id)initWithHost:(NSString *)pHost
{
	if ((self = [super init]))
		{
		[self connectToHost:pHost];
		}
	
	return self;
}

- (void) searchForAdapter
{
	[self connectToHost:@""];
}

- (BOOL) connectToHost:(NSString *)pHost
{
	dispatch_async(dispatch_get_main_queue(),^{
		if ([self getObserver] != nil)
			{
			[[self getObserver] adapterConnected:self];
			}
	});

	return YES;
}

- (BOOL) isConnected
{
	return YES;
}

- (void) disconnect
{
}

- (BOOL) beginExclusive
{
	return YES;
}

- (void) endExclusive
{
}

#pragma mark Interface Methods

- (void) findAllDevices
{
	//	NSLog(@"Finding Devices");
	[self.devices removeAllObjects];
	[self initializeFoundDevices];
}

- (void) syncPort
{
	//	NSLog(@"Syncing Port");
}

- (BOOL) portReady
{
	return YES;
}

- (BOOL) adapterDetected
{
	return YES;
}

- (HBVersion *) getVersion
{
	HBVersion *version = [[HBVersion alloc] initWithHighVersion:@1 LowVersion:@0];
	
	return version;
}

- (NSString *) getAdapterName
{
	return @"Hobby Boards Demo Adapter";
}

- (NSString *) getName
{
	return [self getAdapterName];
}

- (BOOL) selectDevice:(NSString *)address
{
	return YES;
}

- (int) sendReset
{
	return RESET_PRESENCE;
}

- (NSNumber *) lastHeard:(NSString *) deviceID
{
	return @0;
}

- (NSString *) writeBlock:(NSString *)buffer
{
	return [buffer substringWithRange:NSMakeRange(4, buffer.length-6)];
}

#pragma mark Utility Functions

- (void) waitForOperationToComplete
{
}

- (void) completeOperation
{
}

#pragma mark Low Level Functions

- (void)initializeFoundDevices
	{
	HBBaseDevice *device;
	
	device = [[BarometerDevice alloc] initWithHBInterface: self address: @"Demo"];
	device.type = TYPE_BAROMETER;
	[self.devices addObject:device];

	device = [[HumidityDevice alloc] initWithHBInterface: self address: @"Demo"];
	device.type = TYPE_HUMIDITY;
	[self.devices addObject:device];

	device = [[MoistureMeterDevice alloc] initWithHBInterface: self address: @"Demo"];
	device.type = TYPE_MOISTURE_METER;
	[self.devices addObject:device];

	dispatch_async(dispatch_get_main_queue(),
		^{
		if ([self getObserver] != nil)
			{
			[[self getObserver] newDevicesDidAppear];
			}
		});
	}

@end
