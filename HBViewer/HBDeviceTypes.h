//
//  HBDeviceTypes.h
//  HBTest
//
//  Created by Eric Vickery on 12/26/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBDeviceTypes : NSObject
#define TYPE_NULL							0x00
#define TYPE_UVI							0x01
#define TYPE_MOISTURE_METER					0x02
#define TYPE_MOISTURE_METER_DATALOGGER		0x03
#define TYPE_SNIFFER						0x04
#define TYPE_HUB							0x05
#define TYPE_BAROMETER						0x06
#define TYPE_HUMIDITY						0x07
#define TYPE_PYRANOMETER					0x08

#define TYPE_ADAPTER_MASTER_HUB				0x10
#define TYPE_ADAPTER_WIRELESS_MASTER		0x11

+ (NSString *) getDeviceNameFromType:(NSUInteger)type;
@end
