//
//  HBBaseDevice.h
//  HBTest
//
//  Created by Eric Vickery on 12/22/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBAdapterInterface.h"

#define POLLING_CONSTANT			0
#define POLLING_EVERY_SECOND		1
#define POLLING_EVERY_10_SECONDS	2
#define POLLING_EVERY_MINUTE		3
#define POLLING_EVERY_10_MINUTES	4
#define POLLING_EVERY_HOUR			5
#define POLLING_EVERY_DAY			6
#define POLLING_EVERY_2_HOURS		8
#define POLLING_EVERY_30_SECONDS	9

#define SLEEP_MODE_FLAG		0x40
#define WIRELESS_FLAG		0x80


@interface HBBaseDevice : NSObject
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) HBVersion *version;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *config;
@property (nonatomic, strong) NSNumber *pollingFreq;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, weak) HBAdapterInterface *adapterInterface;
@property BOOL demoMode;

- (id) initWithHBInterface:(HBAdapterInterface *)adapterInterface AndAddress:(NSString *)address;

- (BOOL) canConnectWirelessly;
- (BOOL) isConnectedWirelessly;
- (NSString *) pollingFreqAsString;
- (NSNumber *) lastHeard;
//- (HBVersion *) getVersion;

@end
