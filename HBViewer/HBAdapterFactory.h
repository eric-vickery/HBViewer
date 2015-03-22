//
//  HBAdapterFactory.h
//  HBViewer
//
//  Created by Eric Vickery on 10/8/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBAdapterInterface.h"
#import "HBAdapterInterfaceDelegate.h"

#define HOST_NAME			@"Hostname"
#define ADAPTER_TYPE_KEY	@"Adapter Type"
#define DEMO_ADAPTER		0
#define ETHERNET_ADAPTER	1

@interface HBAdapterFactory : NSObject

+ (void) loadAdapterWithObserver:(id <HBAdapterInterfaceDelegate>) observer;
//+ (HBAdapterInterface *) findAdapter;

@end
