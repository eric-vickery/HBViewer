//
//  HBDeviceTypes.m
//  HBTest
//
//  Created by Eric Vickery on 12/26/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import "HBDeviceTypes.h"

@implementation HBDeviceTypes
NSArray *TYPE_STRINGS = nil;

+ (NSString *) getDeviceNameFromType:(NSUInteger)type
{
	if (TYPE_STRINGS == nil)
		{
		TYPE_STRINGS = @[@"Empty", @"UV Index Meter", @"Moisture Meter", @"Moisture Meter Datalogger", @"1-Wire Sniffer", @"4 Channel Hub", @"Barometer", @"Humidity", @"Pyranometer", @"", @"", @"", @"", @"", @"", @"", @"Master Hub", @"Wireless Master"];
		}
	
	if (type <= TYPE_STRINGS.count)
		{
		return TYPE_STRINGS[type];
		}
	else
		{
		return @"Unknown";
		}
}

@end
