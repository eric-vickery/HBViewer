//
//  HBBaseDevice.m
//  HBTest
//
//  Created by Eric Vickery on 12/22/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import "HBBaseDevice.h"
#import "HBDeviceTypes.h"
#import "HBAdapterInterface.h"
#import "HBVersion.h"

#define WRITE_FLAG					0x80

#define GET_VERSION					0x11
#define GET_TYPE					0x12
#define GET_POLLING_FREQ			0x14
#define SET_POLLING_FREQ			GET_POLLING_FREQ | WRITE_FLAG
#define GET_AVAILABLE_POLLING_FREQS	0x15
#define GET_LOCATION				0x16
#define SET_LOCATION				GET_LOCATION | WRITE_FLAG
#define GET_CONFIG					0x61
#define SET_CONFIG					GET_CONFIG | WRITE_FLAG
#define GET_LAST_CODE				0x62

#define PREP_FOR_FIRMWARE			0x65 | WRITE_FLAG
#define UPDATE_FIRMWARE_LINE		0x66 | WRITE_FLAG

#define RESET_DEVICE				0x71 | WRITE_FLAG
#define FACTORY_RESET				0x77 | WRITE_FLAG

@interface HBBaseDevice ()
@end

@implementation HBBaseDevice

- (id) initWithHBInterface:(HBAdapterInterface *)adapterInterface AndAddress:(NSString *)address
{
	if ((self = [super init]))
		{
		self.adapterInterface = adapterInterface;
		self.address = address;
		
		if ([self.address isEqualToString: @"Demo"])
			{
			self.demoMode = YES;
			}
		else
			{
			self.demoMode = NO;
			}
		}
	
	return self;
}

- (NSString *) name
{
	if (_name == nil)
		{
		_name = [HBDeviceTypes getDeviceNameFromType:[self.type unsignedIntegerValue]];
		}
	
	return _name;
}

- (NSString *) location
{
	if (_location == nil)
		{
//		NSLog(@"Get Device Location");
		
		if (!self.demoMode)
			{
			if ([self.adapterInterface beginExclusive] && self.address.length != 0)
				{
				// select the device
				if ([self.adapterInterface selectDevice:self.address])
					{
					NSString *byteArray = [NSString stringWithFormat:@"%XFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", GET_LOCATION];
					
					// Send the data to the device
					NSString *hexStringResults = [self.adapterInterface writeBlock:byteArray];
					NSString *results = [self.adapterInterface hexStringToAsciiString:hexStringResults];
	//				NSLog(@"Device Location returned %@", results);
					_location = results;
					}
				
				[self.adapterInterface endExclusive];
				}
			}
		else
			{
			_location = @"";
			}
		}
	return _location;
}

- (NSNumber *) type
{
	if (_type == nil)
		{
//		NSLog(@"Get Device Type");
		if ([self.adapterInterface beginExclusive] && self.address.length != 0)
			{
			// select the device
			if ([self.adapterInterface selectDevice:self.address])
				{
				NSString *byteArray = [NSString stringWithFormat:@"%XFF", GET_TYPE];
				
				// Send the data to the device
				NSString *results = [self.adapterInterface writeBlock:byteArray];
				
				NSScanner* pScanner = [NSScanner scannerWithString: results];
				
				unsigned int temp;
				[pScanner scanHexInt:&temp];
				_type = [NSNumber numberWithInt:temp];
//				NSLog(@"Device Type is %@", _type);
				}
			
			[self.adapterInterface endExclusive];
			}
		else
			{
			_type = 0;
			}
		}
	
	return _type;
}

- (HBVersion *) version
{
	if (_version == nil)
		{
//		NSLog(@"Get Device Version");
		
		if (!self.demoMode)
			{
			if ([self.adapterInterface beginExclusive] && self.address.length != 0)
				{
				// select the device
				if ([self.adapterInterface selectDevice:self.address])
					{
					NSString *byteArray = [NSString stringWithFormat:@"%XFFFF", GET_VERSION];
					
					// Send the data to the device
					NSString *results = [self.adapterInterface writeBlock:byteArray];
	//				NSLog(@"Device Version returned %@", results);
					NSString *lowVersion = [results substringWithRange:NSMakeRange(0, 2)];
					NSString *highVersion = [results substringWithRange:NSMakeRange(2, 2)];
					unsigned int temp;
					NSScanner* pScanner = [NSScanner scannerWithString: lowVersion];
					[pScanner scanHexInt:&temp];
					NSNumber *low = [NSNumber numberWithInt:temp];
					pScanner = [NSScanner scannerWithString: highVersion];
					[pScanner scanHexInt:&temp];
					NSNumber *high = [NSNumber numberWithInt:temp];
					
					_version = [[HBVersion alloc] initWithHighVersion:high LowVersion:low];
					}
				
				[self.adapterInterface endExclusive];
				}
			}
		else
			{
			_version = [[HBVersion alloc] initWithHighVersion:@1 LowVersion:@0];
			}
		}
	
	return _version;
}

- (NSNumber *) config
{
	if (_config == nil)
		{
		_config = 0;
		
		if (!self.demoMode)
			{
//				NSLog(@"Get Device Config");
			if ([self.adapterInterface beginExclusive] && self.address.length != 0)
				{
				// select the device
				if ([self.adapterInterface selectDevice:self.address])
					{
					NSString *byteArray = [NSString stringWithFormat:@"%XFF", GET_CONFIG];
					
					// Send the data to the device
					NSString *results = [self.adapterInterface writeBlock:byteArray];
					
					NSScanner* pScanner = [NSScanner scannerWithString: results];
					
					unsigned int temp;
					[pScanner scanHexInt:&temp];
					_config = [NSNumber numberWithInt:temp];
					//				NSLog(@"Device Type is %@", _type);
					}
				
				[self.adapterInterface endExclusive];
				}
			}
		}
	
	return _config;
}

- (NSNumber *) pollingFreq
{
	if (_pollingFreq == nil)
		{
		_pollingFreq = 0;

		if (!self.demoMode)
			{
//				NSLog(@"Get Device Config");
			if ([self.adapterInterface beginExclusive] && self.address.length != 0)
				{
				// select the device
				if ([self.adapterInterface selectDevice:self.address])
					{
					NSString *byteArray = [NSString stringWithFormat:@"%XFF", GET_POLLING_FREQ];
					
					// Send the data to the device
					NSString *results = [self.adapterInterface writeBlock:byteArray];
					
					NSScanner* pScanner = [NSScanner scannerWithString: results];
					
					unsigned int temp;
					[pScanner scanHexInt:&temp];
					_pollingFreq = [NSNumber numberWithInt:temp];
					//				NSLog(@"Device Type is %@", _type);
					}
				
				[self.adapterInterface endExclusive];
				}
			}
		}
	
	return _pollingFreq;
}

- (NSString *) pollingFreqAsString
{
	NSString *retValue = @"";
	
	switch ([self.pollingFreq intValue])
		{
		case POLLING_CONSTANT:
			retValue = @"Sends data constantly";
			break;

		case POLLING_EVERY_SECOND:
			retValue = @"Sends data every second";
			break;
			
		case POLLING_EVERY_10_SECONDS:
			retValue = @"Sends data every 10 seconds";
			break;
			
		case POLLING_EVERY_30_SECONDS:
			retValue = @"Sends data every 30 seconds";
			break;
			
		case POLLING_EVERY_MINUTE:
			retValue = @"Sends data every minute";
			break;
			
		case POLLING_EVERY_10_MINUTES:
			retValue = @"Sends data every 10 minutes";
			break;
			
		case POLLING_EVERY_HOUR:
			retValue = @"Sends data every hour";
			break;
			
		case POLLING_EVERY_2_HOURS:
			retValue = @"Sends data every 2 hours";
			break;
			
		case POLLING_EVERY_DAY:
			retValue = @"Sends data every day";
			break;
			
		default:
			break;
		}
	return retValue;
}

- (NSNumber *) lastHeard
{
	NSNumber *retValue = @-1;
	
	if (!self.demoMode)
		{
		if ([self.adapterInterface beginExclusive] && self.address.length != 0)
			{
			retValue = [self.adapterInterface lastHeard:self.address];
			}
		}
	else
		{
		retValue = @0;
		}
	
	return retValue;
}

- (BOOL) canConnectWirelessly
{
	return [self.config intValue] & SLEEP_MODE_FLAG;
}

- (BOOL) isConnectedWirelessly
{
	return [self.config intValue] & WIRELESS_FLAG;
}

@end
