#import "HBEthernetAdapter.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "HBVersion.h"
#import "HBBaseDevice.h"
#import "HBDeviceTypes.h"
#import "HBViewer-swift.h"

#define ENABLE_BACKGROUNDING  0

//#define HOST @"192.168.211.184"
#define PORT 8760

@interface HBEthernetAdapter ()
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong) dispatch_queue_t socketQueue;
@property (nonatomic) BOOL doneReading;
@property (nonatomic, strong) NSTimer *udpTimer;
@property long state;
@property BOOL operationActive;
@property NSCondition *operationCondition;
// Init the timeout to 500 milliseconds
@property NSTimeInterval socketTimeout;
@property NSMutableArray *devicesAddresses;
@property GCDAsyncUdpSocket *udpSocket;

@end

@implementation HBEthernetAdapter

#define CRLF	@"\r\n"

#define SKIP						0
#define VERIFY_READY				1
#define SYNC_PORT					2
#define FINDING_DEVICES				3
#define CHECKING_ADAPTER_DETECTED	4
#define GETTING_ADAPTER_VERSION		5
#define REBOOTING_ADAPTER			6
#define SELECTING_DEVICE			7
#define SENDING_1WIRE_RESET			8
#define WRITING_BYTE				9
#define READING_BLOCK				10
#define WRITING_BLOCK				11
#define LAST_HEARD					12
#define GETTING_ADAPTER_NAME		13

- (id)initWithObserver:(id <HBAdapterInterfaceDelegate>)observer
{
	if ((self = [super init]))
		{
		[self addObserver:observer];
		self.socketTimeout = 0.500;
		}
	
	return self;
}

- (id)initWithHost:(NSString *)pHost
{
	if ((self = [super init]))
		{
		[self connectToHost:pHost];
		self.socketTimeout = 0.500;
		}
	
	return self;
}

- (void) searchForAdapter
{
	self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	
	NSError *error = nil;
	
	if ((![self.udpSocket bindToPort:29299 error:&error]) || (![self.udpSocket beginReceiving:&error]))
		{
		dispatch_async(dispatch_get_main_queue(),^{
			if ([self getObserver] != nil)
				{
				[[self getObserver] couldNotFindAnAdapter];
				}
		});
		return;
		}
	
	[self.udpSocket enableBroadcast:YES error:&error];
	[self.udpSocket joinMulticastGroup:@"255.255.255.255" error:&error];

	NSData *data = [@"Discovery: Who is out there?\r\n" dataUsingEncoding:NSUTF8StringEncoding];
	[self.udpSocket sendData:data toHost:@"255.255.255.255" port:29299 withTimeout:self.socketTimeout tag:0];

	self.udpTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
												  target:self
												selector:@selector(udpTimeout:)
												userInfo:nil
												 repeats:NO];
}

-(void)udpTimeout:(NSTimer *)timer
{
	// If the UDP timer timed out then close the socket and notifiy the observer
	[self.udpSocket close];
	self.udpSocket = nil;
	
	dispatch_async(dispatch_get_main_queue(),^{
		if ([self getObserver] != nil)
			{
			[[self getObserver] couldNotFindAnAdapter];
			}
	});
	[timer invalidate];
}

- (BOOL) connectToHost:(NSString *)pHost
{
	self.operationCondition = [[NSCondition alloc] init];
	self.operationActive = NO;
	
	self.mCurrentChannel = @"A";
	
	self.socketQueue = dispatch_queue_create("com.hobbyboards.HBViewer.SocketQueue", NULL);
	
	self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
	
	NSString *host = pHost;
	uint16_t port = PORT;
	
	NSError *error = nil;
	if (![self.asyncSocket connectToHost:host onPort:port error:&error])
		{
		dispatch_async(dispatch_get_main_queue(),^{
			if ([self getObserver] != nil)
				{
				[[self getObserver] couldNotLoadAdapter];
				}
		});
		NSLog(@"Could not connect to Master");
		return NO;
		}
	
	[self syncPort];

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
	return [self.asyncSocket isConnected];
}

- (void) disconnect
{
	NSLog(@"Disconnecting!!!!!!!!!!");
	[self.asyncSocket disconnect];
}

- (BOOL) beginExclusive
{
	return YES;
}

- (void) endExclusive
{
	
}

- (BOOL) isReturnValueValid: (NSString *) dataString
{
	if (dataString.length > 0 && [dataString characterAtIndex:0] == '+')
		{
		return YES;
		}
	else
		{
		return NO;
		}
}

#pragma mark Interface Methods

- (void) findAllDevices
{
//	NSLog(@"Finding Devices");
	[self waitForOperationToComplete];
	if (self.devicesAddresses != nil)
		{
		self.devicesAddresses = nil;
		}
	[self.devices removeAllObjects];
	self.devicesAddresses = [[NSMutableArray alloc] init];
	[self writeDataToSocket:@"FA\r\n" withTimeout:-1 tag:FINDING_DEVICES verifyReady:YES];
}

- (void) syncPort
{
	[self waitForOperationToComplete];
//	NSLog(@"Syncing Port");
	[self writeDataToSocket:@"s\r\n" withTimeout:-1 tag:SYNC_PORT verifyReady:NO];
}

- (BOOL) portReady
{
	BOOL portReady = [self.asyncSocket isConnected];
	
	if (!portReady)
		{
		[self completeOperation];
		}
	
	return portReady;
}

- (BOOL) adapterDetected
{
	NSString *response = nil;
	
	if ([self portReady ])
		{
		[self writeDataToSocket:@"s\r\n" withTimeout:-1 tag:CHECKING_ADAPTER_DETECTED verifyReady:YES];
		response = [self readFromSocketUntilData:CRLF withTimeout:self.socketTimeout withTag:CHECKING_ADAPTER_DETECTED];
//		if (response != nil && [response characterAtIndex:0] == '+')
//			{
//			return YES;
//			}
		}
	return [self isReturnValueValid:response];
}

- (NSString *) getAdapterVersion
{
	NSString *buffer = @"Not Found";
	
	[self waitForOperationToComplete];
//	NSLog(@"Getting Version");
	if ([self portReady])
		{
		[self writeDataToSocket:@"V\r\n" withTimeout:-1 tag:GETTING_ADAPTER_VERSION verifyReady:YES];
		NSString *response = [self readFromSocketUntilData:CRLF withTimeout:self.socketTimeout withTag:GETTING_ADAPTER_VERSION];
		
		if ([self isReturnValueValid:response])
			{
			return [response substringFromIndex:2];
			}
		}
	return buffer;
}

- (HBVersion *) getVersion
{
	HBVersion *version = [[HBVersion alloc] initWithString:[self getAdapterVersion]];
	
	return version;
}

- (NSString *) getAdapterName
{
	NSString *buffer = @"Not Found";
	
	[self waitForOperationToComplete];
//	NSLog(@"Getting Adapter Name");
	if ([self portReady])
		{
		[self writeDataToSocket:@"I\r\n" withTimeout:-1 tag:GETTING_ADAPTER_VERSION verifyReady:YES];
		NSString *response = [self readFromSocketUntilData:CRLF withTimeout:self.socketTimeout withTag:GETTING_ADAPTER_NAME];
		// Read the second and third line just to get them off the stream
		[self readFromSocketUntilData:CRLF withTimeout:self.socketTimeout withTag:GETTING_ADAPTER_NAME];
		[self readFromSocketUntilData:CRLF withTimeout:self.socketTimeout withTag:GETTING_ADAPTER_NAME];
		
		if ([self isReturnValueValid:response])
			{
			return [response substringFromIndex:8];
			}
		}
	return buffer;
}

- (NSString *) getName
{
	return [self getAdapterName];
}

- (void) reboot
{
	if ([self portReady])
		{
		[self writeDataToSocket:@"p\r\n" withTimeout:-1 tag:REBOOTING_ADAPTER verifyReady:YES];
		}
	else
		{
		NSLog(@"Not connected to the master");
		}
}

- (BOOL) selectDevice:(NSString *)address
{
	[self waitForOperationToComplete];
//	NSLog(@"Selecting %@", address);
	
	// send 1-Wire Reset
	int result = [self sendReset];
	
	if ([self portReady])
		{
		NSString *buffer = [[NSString alloc] initWithFormat:@"A%@%@\r\n", self.mCurrentChannel, address];
//		NSLog(@"Sending command %@", buffer);
		[self writeDataToSocket:buffer withTimeout:-1 tag:SELECTING_DEVICE verifyReady:YES];
		// Check for an error
		buffer = [self readFromSocketUntilData:CRLF withTimeout:self.socketTimeout withTag:SELECTING_DEVICE];
		if ([self isReturnValueValid:buffer])
			{
			// success if any device present on 1-Wire Network
			return ((result == RESET_PRESENCE) || (result == RESET_ALARM));
			}
		else
			{
			NSLog(@"Wrong Charater Received");
			}
		}
	else
		{
		NSLog(@"Not connected to the master");
		}
	return NO;
}

- (int) sendReset
{
	int code = RESET_NOPRESENCE;
	
	if ([self portReady])
		{
//		NSLog(@"Sending Reset");
		NSString *buffer = [[NSString alloc] initWithFormat:@"r%@\r\n", self.mCurrentChannel];
		[self writeDataToSocket:buffer withTimeout:-1 tag:SENDING_1WIRE_RESET verifyReady:YES];
		// Check for an error
		buffer = [self readFromSocketUntilData:CRLF withTimeout:self.socketTimeout withTag:SENDING_1WIRE_RESET];
		if ([self isReturnValueValid:buffer])
			{
			switch ([buffer characterAtIndex:2])
				{
				case 'N':
					code = RESET_NOPRESENCE;
					break;
					
				case 'P':
					code = RESET_PRESENCE;
					break;
					
				case 'A':
					code = RESET_ALARM;
					break;
					
				case 'S':
					code = RESET_SHORT;
					break;
				}
			}
		else
			{
			NSLog(@"Wrong Charater Received");
			}
		}
	else
		{
		NSLog(@"Not connected to the master");
		}
	return code;
}

- (NSNumber *) lastHeard:(NSString *) deviceID
{
	NSNumber *retValue = @-1;
	
	if ([self portReady])
		{
		NSString *buffer = [[NSString alloc] initWithFormat:@"L%@\r\n", deviceID];
		[self writeDataToSocket:buffer withTimeout:-1 tag:LAST_HEARD verifyReady:YES];
		// Check for an error
		buffer = [self readFromSocketUntilData:CRLF withTimeout:self.socketTimeout withTag:LAST_HEARD];
		if ([self isReturnValueValid:buffer])
			{
			if ([buffer characterAtIndex:2] != 'D')
				{
				NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
				
				retValue = [formatter numberFromString:[buffer substringWithRange:NSMakeRange(2, buffer.length-4)]];
				}
			}
		else
			{
			NSLog(@"Wrong Charater Received");
			}
		}
	else
		{
		NSLog(@"Not connected to the master");
		}
	
	return retValue;
}

- (void) writeByte:(uint8_t) byteValue
{
	if ([self portReady])
		{
		NSString *buffer = [[NSString alloc] initWithFormat:@"W%@%@\r\n", self.mCurrentChannel, [self byteToHexString:byteValue]];
		[self writeDataToSocket:buffer withTimeout:self.socketTimeout tag:WRITING_BYTE verifyReady:YES];
		}
	else
		{
		NSLog(@"Not connected to the master");
		}
}

//- (NSNumber *) readByte
//{
////	const uint8_t *byteArray = [[self readBlockWithLength:1] bytes];
////	return [NSNumber numberWithUnsignedChar:byteArray[0]];
//	return [NSNumber numberWithInt:[[self readBlockWithLength:1] intValue]];
//}
//
//- (NSString *) readBlockWithLength:(NSUInteger) length
//{
//	NSString *stringBuffer;
//	
//	if ([self portReady])
//		{
//		stringBuffer = [[NSString alloc] initWithFormat:@"R%@%lu\r\n", self.mCurrentChannel, (unsigned long)length];
//		[self writeDataToSocket:stringBuffer withTimeout:-1 tag:READING_BLOCK verifyReady:NO];
//		// Check for the return
//		stringBuffer = [self readFromSocketUntilData:CRLF withTimeout:-1 withTag:READING_BLOCK];
//		if ([stringBuffer characterAtIndex:0] != '+')
//			{
//			NSLog(@"Wrong Charater Received");
//			}
//		}
//	else
//		{
//		NSLog(@"Not connected to the master");
//		}
//	
//	// Remove the + at the beginning and \r\n at the end
//	return [stringBuffer substringWithRange:NSMakeRange(2, stringBuffer.length-4)];
//}

- (NSString *) writeBlock:(NSString *)buffer
{
	NSString *stringBuffer;
	
	if ([self portReady])
		{
		stringBuffer = [[NSString alloc] initWithFormat:@"W%@%@\r\n", self.mCurrentChannel, buffer];
//		NSLog(@"Write and Read with command %@", stringBuffer);
		[self writeDataToSocket:stringBuffer withTimeout:-1 tag:WRITING_BLOCK verifyReady:YES];
		// Check for an error
		stringBuffer = [self readFromSocketUntilData:CRLF withTimeout:self.socketTimeout withTag:WRITING_BLOCK];
//		NSLog(@"Write and Read response %@", stringBuffer);
		if (![self isReturnValueValid:stringBuffer])
			{
			NSLog(@"Wrong Charater Received");
			}
		}
	else
		{
		NSLog(@"Not connected to the master");
		}
	
	return [stringBuffer substringWithRange:NSMakeRange(4, stringBuffer.length-6)];
}

#pragma mark Utility Functions

- (void) waitForOperationToComplete
{
	[self.operationCondition lock];
	
	while (self.operationActive)
		{
		[self.operationCondition wait];
		}
	[self.operationCondition unlock];
	
	self.operationActive = YES;
}

- (void) completeOperation
{
	[self.operationCondition lock];
	self.operationActive = NO;
	[self.operationCondition signal];
	[self.operationCondition unlock];
}

#pragma mark Low Level Functions

- (void) writeDataToSocket:(NSString *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag verifyReady:(BOOL)verify
{
//	NSLog(@"Writing %@", data);
	dispatch_async(self.socketQueue, ^{
				   [self.asyncSocket writeData:[data dataUsingEncoding:NSUTF8StringEncoding] withTimeout:timeout tag:tag];
				   if (verify)
					   {
//					   NSLog(@"Verifying Port ready");
					   [self.asyncSocket readDataToLength:1 withTimeout:-1 tag:VERIFY_READY];
					   }
				   });
}

- (NSString *) readFromSocketUntilData:(NSString *)data withTimeout:(NSTimeInterval)timeout withTag:(long)tag
{
	NSMutableData *dataBuffer = [[NSMutableData alloc] initWithCapacity:100];
	self.doneReading = NO;
	
	dispatch_async(self.socketQueue, ^{
		[self.asyncSocket readDataToData:[data dataUsingEncoding:NSUTF8StringEncoding] withTimeout:timeout buffer:dataBuffer bufferOffset:0 tag:tag];
		});
	
	// Wait until we are done reading. If this gets stuck for some reason it will never return because there is no timeout
	while (!self.doneReading);
	
	// Now return the results converted into a string
	return [[NSString alloc] initWithData:dataBuffer encoding:NSUTF8StringEncoding];
}

- (NSString *) readFromSocketToLength:(NSUInteger)length withTimeout:(NSTimeInterval)timeout withTag:(long)tag
{
	NSMutableData *dataBuffer = [[NSMutableData alloc] initWithCapacity:length];
	self.doneReading = NO;
	
	dispatch_async(self.socketQueue, ^{
		[self.asyncSocket readDataToLength:length withTimeout:timeout buffer:dataBuffer bufferOffset:0 tag:tag];
	});
	
	// Wait until we are done reading. If this gets stuck for some reason it will never return because there is no timeout
	while (!self.doneReading);

	// Now return the results converted into a string
	return [[NSString alloc] initWithData:dataBuffer encoding:NSUTF8StringEncoding];
}

#pragma mark TCP Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{

#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
	{
	// Backgrounding doesn't seem to be supported on the simulator yet
	[sock performBlock:^{
		if ([sock enableBackgroundingOnSocket])
//			DDLogInfo(@"Enabled backgrounding on socket");
		else
//			DDLogWarn(@"Enabling backgrounding failed!");
	}];
	}
#endif
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	if (tag == SYNC_PORT)
		{
//		NSLog(@"Wrote data for Sync Port");
		[self.asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:SYNC_PORT];
		}
	else if (tag == FINDING_DEVICES)
		{
//		NSLog(@"Wrote data for Finding Devices");
		[self.asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:tag];
		}
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

//	NSLog(@"%@", response);
	
	switch (tag)
	{
		case SKIP:
			NSLog(@"SKIP");
			return;
		
		case VERIFY_READY:
			if ([response characterAtIndex:0] != '?')
				{
				NSLog(@"Wrong response to sync command");
				}
//			NSLog(@"VERIFY_READY");
			return;
		
		case SYNC_PORT:
			if ([response characterAtIndex:0] != '+')
				{
				NSLog(@"Wrong response to sync command");
				}
//			NSLog(@"SYNC_PORT");
			[self completeOperation];
			break;
		
		case FINDING_DEVICES:
			if ([response characterAtIndex:2] != 'N')
				{
//				NSLog(@"Finding More Devices");
				NSString *deviceAddress = [response substringWithRange:NSMakeRange(2, 16)];
//				NSLog(@"Found Device %@", deviceAddress);
				[self.devicesAddresses addObject:deviceAddress];
				
				[self writeDataToSocket:@"N\r\n" withTimeout:-1 tag:FINDING_DEVICES verifyReady:YES];
				}
			else
				{
//				NSLog(@"Found All The Devices");
				[self completeOperation];
				dispatch_async(dispatch_get_main_queue(),^{
						[self initializeFoundDevices];
						if ([self getObserver] != nil)
							{
							[[self getObserver] newDevicesDidAppear];
							}
						});
				}
			break;
		
		default:
			break;
	}
	
	if (tag > FINDING_DEVICES)
		{
//		NSLog(@"Completing Read");
		self.doneReading = YES;
		[self completeOperation];
		}
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
	{
//	NSLog(@"Socket did Disconnect with error %@", err);
	self.doneReading = YES;
	[self completeOperation];
	dispatch_async(dispatch_get_main_queue(),^{
		if ([self getObserver] != nil)
			{
			[[self getObserver] adapterDisconnected:err];
			}
	});
	}

- (void)initializeFoundDevices
{
	HBBaseDevice *device = nil;
	
	for (NSString *deviceAddress in self.devicesAddresses)
		{
//		NSLog(@"Processing device %@", deviceAddress);
		HBBaseDevice *tempDevice = [[HBBaseDevice alloc] initWithHBInterface: self AndAddress: deviceAddress];
		NSNumber *type = tempDevice.type;
		switch ([type intValue])
			{
			case TYPE_BAROMETER:
				device = [[BarometerDevice alloc] initWithHBInterface: self AndAddress: deviceAddress];
				break;
				
			case TYPE_HUMIDITY:
				device = [[HumidityDevice alloc] initWithHBInterface: self AndAddress: deviceAddress];
				break;
				
			case TYPE_MOISTURE_METER:
				device = [[MoistureMeterDevice alloc] initWithHBInterface: self AndAddress: deviceAddress];
				break;
				
			default:
//				device = [[HBBaseDevice alloc] initWithHBInterface: self AndAddress: deviceAddress];
				break;
			}
		
		// Add the device if we loaded one
		if (device != nil)
			{
			[self.devices addObject:device];
			device = nil;
			}
		}
}

#pragma mark UDP Socket Delegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
	  fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (msg && ![msg containsString:@"Discovery"])
		{
		// For now we just find the first Master we hear from on the network.
		// It is not very likely that there will be more than 1 Master on the network at one time but in v2.0 I will add support for multiple Master found
		[self.udpTimer invalidate];
		self.udpTimer = nil;
		[self.udpSocket close];
		self.udpSocket = nil;

		NSString *host = nil;
		uint16_t port = 0;
		[GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
		
		[self connectToHost:host];
		}
}

@end
