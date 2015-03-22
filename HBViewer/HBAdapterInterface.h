//
//  HBAdapterInterface.h
//  HBViewer
//
//  Created by Eric Vickery on 10/8/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBAdapterInterfaceDelegate.h"
#import "HBVersion.h"

@interface HBAdapterInterface : NSObject
@property (nonatomic, strong) NSMutableArray *devices;

- (id)initWithObserver:(id <HBAdapterInterfaceDelegate>)observer;
- (id)initWithHost:(NSString *)pHost;
- (void) searchForAdapter;
- (BOOL) connectToHost:(NSString *)pHost;
- (void) disconnect;
- (BOOL) isConnected;

- (NSNumber *) lastHeard:(NSString *) deviceID;

- (BOOL) beginExclusive;
- (void) endExclusive;
- (id <HBAdapterInterfaceDelegate>) getObserver;
- (void) addObserver:(id <HBAdapterInterfaceDelegate>)observer;
- (void) removeObserver:(id <HBAdapterInterfaceDelegate>)observer;
- (void) findAllDevices;
- (void) syncPort;
- (BOOL) adapterDetected;
- (HBVersion *) getVersion;
- (NSString *) getName;
- (void) reboot;
- (BOOL) selectDevice:(NSString *)address;
- (void) writeByte:(uint8_t) byteValue;
//- (NSNumber *) readByte;
//- (NSString *) readBlockWithLength:(NSUInteger) length;
- (NSString *) writeBlock:(NSString *)buffer;

- (NSString *) byteToHexString:(uint8_t) pByte;
- (NSString *) byteArrayToHexString:(NSMutableData *) array WithOffset:(NSUInteger)offset AndLength:(NSUInteger)length;
- (NSString *) hexStringToAsciiString:(NSString *)hexString;

#define RESET_NOPRESENCE	0x00
#define RESET_PRESENCE		0x01
#define RESET_ALARM			0x02
#define RESET_SHORT			0x03

@end
