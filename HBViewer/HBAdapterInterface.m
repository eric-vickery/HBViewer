//
//  HBAdapterInterface.m
//  HBViewer
//
//  Created by Eric Vickery on 10/8/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import "HBAdapterInterface.h"
#import "HBVersion.h"
#import "HBDeviceTypes.h"
#import "HBViewer-Swift.h"

@interface HBAdapterInterface ()

@property (nonatomic, weak) id <HBAdapterInterfaceDelegate> observer;

@end


@implementation HBAdapterInterface

- (NSArray *) devices
{
	if (_devices == nil)
		{
		_devices = [[NSMutableArray alloc] init];
		}
	return _devices;
}

- (id)initWithObserver:(id <HBAdapterInterfaceDelegate>)observer
{
	return nil;
}

- (id)initWithHost:(NSString *)pHost
{
	return nil;
}

- (void) searchForAdapter
{
}

- (BOOL) connectToHost:(NSString *)pHost
{
	return NO;
}

- (void) disconnect
{
}

- (BOOL) isConnected
{
	return NO;
}

- (NSNumber *) lastHeard:(NSString *) deviceID
{
	return @-1;
}

- (BOOL) beginExclusive
{
	return NO;
}

- (void) endExclusive
{
	
}

- (id <HBAdapterInterfaceDelegate>) getObserver
{
	return self.observer;
}

- (void) addObserver:(id<HBAdapterInterfaceDelegate>)observer
{
	self.observer = observer;
}

- (void) removeObserver:(id<HBAdapterInterfaceDelegate>)observer
{
	if (observer == self.observer)
		{
		self.observer = nil;
		}
}

- (void) findAllDevices
{
	
}

- (void) syncPort
{
	
}

- (BOOL) adapterDetected
{
	return NO;
}

- (HBVersion *) getVersion
{
	return nil;
}

- (NSString *) getName
{
	return nil;
}

- (void) reboot
{
	
}

- (BOOL) selectDevice:(NSString *)address
{
	return NO;
}

//- (void) writeByte:(uint8_t) byteValue;
//- (NSNumber *) readByte;
//- (NSString *) readBlockWithLength:(NSUInteger) length;
- (NSString *) writeBlock:(NSString *)buffer
{
	return nil;
}

- (void) writeByte:(uint8_t) byteValue
{
}

- (NSString *) byteToHexString:(uint8_t) pByte
{
	char charArray[3];
	int nibble;
	
	nibble = (pByte >> 4) & 0x0F;
	nibble += ((nibble > 9) ? 'A' - 10 : '0');
	charArray[0] = (char) nibble;
	nibble = pByte & 0x0F;
	nibble += ((nibble > 9) ? 'A' - 10 : '0');
	charArray[1] = (char) nibble;
	charArray[2] = 0;
	
	return [NSString stringWithCString:(const char *)charArray encoding:NSUTF8StringEncoding];
}

- (NSString *) byteArrayToHexString:(NSMutableData *) array WithOffset:(NSUInteger)offset AndLength:(NSUInteger)length
{
	const uint8_t *byteArray = [array bytes];
	char charArray[100];
	int index = 0;
	int nibble;
	
	for (int counter = (int)offset; counter < ((int)offset + (int)length); counter++)
		{
		nibble = (byteArray[counter] >> 4) & 0x0F;
		nibble += ((nibble > 9) ? 'A' - 10 : '0');
		charArray[index++] = (char) nibble;
		nibble = byteArray[counter] & 0x0F;
		nibble += ((nibble > 9) ? 'A' - 10 : '0');
		charArray[index++] = (char) nibble;
		}
	charArray[index] = 0;
	
	return [NSString stringWithCString:(const char *)charArray encoding:NSUTF8StringEncoding];
}

- (NSString *) hexStringToAsciiString:(NSString *)hexString
{
	unsigned long len = hexString.length;
	char characters[len/2+1];
	int charIndex = 0;
	NSString *nullString = @"00";
	NSString *ffString = @"FF";
	
	for(int index = 0; index < len; index+=2)
		{
		NSString *byte = [hexString substringWithRange:NSMakeRange(index, 2)];
		// See if we got a null character or an 0xFF. If so then just break out of the loop
		if ([byte isEqualToString:nullString] || [byte isEqualToString:ffString])
			{
			break;
			}
		characters[charIndex++] = (char) (int)strtol([byte cStringUsingEncoding:NSUTF8StringEncoding], NULL, 16);
		}
	characters[charIndex] = '\0';
	return [NSString stringWithCString:characters encoding:NSUTF8StringEncoding];
}

@end
