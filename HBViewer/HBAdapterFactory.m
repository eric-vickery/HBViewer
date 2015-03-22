//
//  HBAdapterFactory.m
//  HBViewer
//
//  Created by Eric Vickery on 10/8/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import "HBAdapterFactory.h"
#import "HBAdapterInterface.h"
#import "HBEthernetAdapter.h"
#import "HBDemoAdapter.h"

@implementation HBAdapterFactory

+ (void) loadAdapterWithObserver:(id <HBAdapterInterfaceDelegate>) observer
{
	HBAdapterInterface *adapter = nil;
	
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSNumber *adapterType = [[NSUserDefaults standardUserDefaults] objectForKey:ADAPTER_TYPE_KEY];
	
	// Return a demo adapter if the demo flag is set, otherwise search for an ethernet adapter
	switch ([adapterType intValue])
	{
		case DEMO_ADAPTER:
		adapter = [[HBDemoAdapter alloc] initWithObserver:observer];
		break;
		
		case ETHERNET_ADAPTER:
		adapter = [[HBEthernetAdapter alloc] initWithObserver:observer];
		break;
		
		default:
		break;
	}
	[adapter searchForAdapter];
}

//+ (HBAdapterInterface *) findAdapter
//{
//	NSString *hostAddress = nil;
//	HBAdapterInterface *adapter = nil;
//	
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	
//	NSNumber *adapterType = [defaults objectForKey:ADAPTER_TYPE];
//	
//	// Return a demo adapter if the demo flag is set, otherwise search for an ethernet adapter
//	switch ([adapterType intValue])
//		{
//		case DEMO_ADAPTER:
//			adapter = [[HBDemoAdapter alloc] initWithHost:@""];
//			break;
//			
//		case ETHERNET_ADAPTER:
//			hostAddress = [self searchForEthernetAdapter];
//			adapter = [[HBEthernetAdapter alloc] initWithHost:hostAddress];
//			break;
//			
//		default:
//			break;
//		}
//
//	return adapter;
//}

@end
