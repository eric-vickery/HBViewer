//
//  HBBaseDevice.swift
//  HBViewer
//
//  Created by Eric Vickery on 10/2/18.
//  Copyright © 2018 Eric Vickery. All rights reserved.
//

import Foundation

@objc public class HBBaseDevice: NSObject
{
	static let WRITE_FLAG = 0x80
	
	static let GET_VERSION = 0x11
	static let GET_TYPE = 0x12
	static let GET_POLLING_FREQ = 0x14
	static let SET_POLLING_FREQ = GET_POLLING_FREQ | WRITE_FLAG
	static let GET_AVAILABLE_POLLING_FREQS = 0x15
	static let GET_LOCATION = 0x16
	static let SET_LOCATION = GET_LOCATION | WRITE_FLAG
	static let GET_CONFIG = 0x61
	static let SET_CONFIG = GET_CONFIG | WRITE_FLAG
	static let GET_LAST_CODE = 0x62
	
	static let PREP_FOR_FIRMWARE = 0x65 | WRITE_FLAG
	static let UPDATE_FIRMWARE_LINE = 0x66 | WRITE_FLAG
	
	static let RESET_DEVICE = 0x71 | WRITE_FLAG
	static let FACTORY_RESET = 0x77 | WRITE_FLAG

	static let POLLING_CONSTANT = 0
	static let POLLING_EVERY_SECOND = 1
	static let POLLING_EVERY_10_SECONDS = 2
	static let POLLING_EVERY_MINUTE = 3
	static let POLLING_EVERY_10_MINUTES = 4
	static let POLLING_EVERY_HOUR = 5
	static let POLLING_EVERY_DAY = 6
	static let POLLING_EVERY_2_HOURS = 8
	static let POLLING_EVERY_30_SECONDS = 9

	static let SLEEP_MODE_FLAG = 0x40
	static let WIRELESS_FLAG = 0x80

	@objc var address = ""
	private var _version: HBVersion?
	@objc var version: HBVersion
	{
		get
		{
			if (_version == nil)
			{
				if !self.demoMode
				{
					if self.adapterInterface.beginExclusive() && !self.address.isEmpty
					{
						// select the device
						if self.adapterInterface.selectDevice(self.address)
						{
							let byteArray = String(format:"%XFFFF", HBBaseDevice.GET_VERSION)
							
							// Send the data to the device
							if let results = self.adapterInterface.writeBlock(byteArray)
							{
								let startingIndex = results.startIndex
								let middleIindex = results.index(startingIndex, offsetBy: 2)
								let lowVersion = results[startingIndex..<middleIindex]
								let highIndex = results.index(middleIindex, offsetBy: 2)
								let highVersion = results[middleIindex..<highIndex]
								var temp: UInt32 = 0
								var pScanner = Scanner(string: String(lowVersion))
								pScanner.scanHexInt32(&temp)
								let low = Int32(bitPattern: temp)
								pScanner = Scanner(string: String(highVersion))
								pScanner.scanHexInt32(&temp)
								let high = Int32(bitPattern: temp)
								
								_version = HBVersion(highVersion: NSNumber(value: high), lowVersion: NSNumber(value: low))
							}
						}
						self.adapterInterface.endExclusive()
					}
				}
			}
			return _version == nil ? HBVersion(highVersion: 1, lowVersion: 0) : _version!
		}
	}
	@objc var type: UInt
	@objc var config: Int
	@objc var pollingFreq: Int
	@objc var name: String
	{
		get
		{
			return HBDeviceTypes.getDeviceName(fromType: self.type)
		}
	}
	private var _location = ""
	@objc var location: String
	{
		get
		{
			if _location.isEmpty
			{
				if !self.demoMode
				{
					if self.adapterInterface.beginExclusive() && !self.address.isEmpty
					{
						if self.adapterInterface.selectDevice(self.address)
						{
							let byteArray = String(format:"%XFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", HBBaseDevice.GET_LOCATION)
							
							// Send the data to the device
							let hexStringResults = self.adapterInterface.writeBlock(byteArray)
							let results = self.adapterInterface.hexString(toAsciiString: hexStringResults)
							if let results = results
							{
								_location = results
							}
						}
						self.adapterInterface.endExclusive()
					}
				}
				else
				{
					_location = ""
				}
			}
			return _location
		}
	}
	@objc var adapterInterface: HBAdapterInterface
	@objc var demoMode: Bool

	@objc init(withHBInterface adapterInterface: HBAdapterInterface, address: String)
	{
		self.address = address
		self.adapterInterface = adapterInterface
		self.pollingFreq = HBBaseDevice.POLLING_CONSTANT
		
		if self.address == "Demo"
		{
			self.demoMode = true
		}
		else
		{
			self.demoMode = false
		}
		
		self.type = UInt(TYPE_NULL)
		self.config = 0
	}

	func getUIntForCommand(command: String) -> UInt32
	{
		return UInt32(getIntForCommand(command: command))
	}
	
	func getIntForCommand(command: String) -> Int32
	{
		var value: Int32 = 0
		
		if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
		{
			// select the device
			if (self.adapterInterface.selectDevice(self.address))
			{
				// Send the data to the device
				let results = self.adapterInterface.writeBlock(command)
				
				if let startingIndex = results?.startIndex, let results = results
				{
					let middleIndex = results.index(startingIndex, offsetBy: 2)
					let lowByte = results[..<middleIndex]
					let lastIndex = results.index(middleIndex, offsetBy: 2)
					let highByte = results[middleIndex..<lastIndex]
					var temp: UInt32 = 0
					var pScanner = Scanner(string: String(lowByte))
					pScanner.scanHexInt32(&temp)
					value = Int32(temp)
					pScanner = Scanner(string: String(highByte))
					pScanner.scanHexInt32(&temp)
					value |= Int32(temp << 8)
				}
			}
			
			self.adapterInterface.endExclusive()
		}
		return value
	}
	

//	- (NSNumber *) type
//	{
//	if (_type == nil)
//	{
//	//		NSLog("Get Device Type")
//	if ([self.adapterInterface beginExclusive] && self.address.length != 0)
//	{
//	// select the device
//	if ([self.adapterInterface selectDevice:self.address])
//	{
//	NSString *byteArray = [NSString stringWithFormat:"%XFF", GET_TYPE]
//
//	// Send the data to the device
//	NSString *results = [self.adapterInterface writeBlock:byteArray]
//
//	NSScanner* pScanner = [NSScanner scannerWithString: results]
//
//	unsigned int temp
//	[pScanner scanHexInt:&temp]
//	_type = [NSNumber numberWithInt:temp]
//	//				NSLog("Device Type is %", _type)
//	}
//
//	[self.adapterInterface endExclusive]
//	}
//	else
//	{
//	_type = 0
//	}
//	}
//
//	return _type
//	}
	
//	- (NSNumber *) config
//	{
//	if (_config == nil)
//	{
//	_config = 0
//
//	if (!self.demoMode)
//	{
//	//				NSLog("Get Device Config")
//	if ([self.adapterInterface beginExclusive] && self.address.length != 0)
//	{
//	// select the device
//	if ([self.adapterInterface selectDevice:self.address])
//	{
//	NSString *byteArray = [NSString stringWithFormat:"%XFF", GET_CONFIG]
//
//	// Send the data to the device
//	NSString *results = [self.adapterInterface writeBlock:byteArray]
//
//	NSScanner* pScanner = [NSScanner scannerWithString: results]
//
//	unsigned int temp
//	[pScanner scanHexInt:&temp]
//	_config = [NSNumber numberWithInt:temp]
//	//				NSLog("Device Type is %", _type)
//	}
//
//	[self.adapterInterface endExclusive]
//	}
//	}
//	}
//
//	return _config
//	}
	
//	- (NSNumber *) pollingFreq
//	{
//	if (_pollingFreq == nil)
//	{
//	_pollingFreq = 0
//
//	if (!self.demoMode)
//	{
//	//				NSLog("Get Device Config")
//	if ([self.adapterInterface beginExclusive] && self.address.length != 0)
//	{
//	// select the device
//	if ([self.adapterInterface selectDevice:self.address])
//	{
//	NSString *byteArray = [NSString stringWithFormat:"%XFF", GET_POLLING_FREQ]
//
//	// Send the data to the device
//	NSString *results = [self.adapterInterface writeBlock:byteArray]
//
//	NSScanner* pScanner = [NSScanner scannerWithString: results]
//
//	unsigned int temp
//	[pScanner scanHexInt:&temp]
//	_pollingFreq = [NSNumber numberWithInt:temp]
//	//				NSLog("Device Type is %", _type)
//	}
//
//	[self.adapterInterface endExclusive]
//	}
//	}
//	}
//
//	return _pollingFreq
//	}
	
	@objc func pollingFreqAsString() -> String
	{
		var retValue = ""
		
		switch self.pollingFreq
		{
			case HBBaseDevice.POLLING_CONSTANT:
				retValue = "Sends data constantly"
				break
			
			case HBBaseDevice.POLLING_EVERY_SECOND:
				retValue = "Sends data every second"
				break
			
			case HBBaseDevice.POLLING_EVERY_10_SECONDS:
				retValue = "Sends data every 10 seconds"
				break
			
			case HBBaseDevice.POLLING_EVERY_30_SECONDS:
				retValue = "Sends data every 30 seconds"
				break
			
			case HBBaseDevice.POLLING_EVERY_MINUTE:
				retValue = "Sends data every minute"
				break
			
			case HBBaseDevice.POLLING_EVERY_10_MINUTES:
				retValue = "Sends data every 10 minutes"
				break
			
			case HBBaseDevice.POLLING_EVERY_HOUR:
				retValue = "Sends data every hour"
				break
			
			case HBBaseDevice.POLLING_EVERY_2_HOURS:
				retValue = "Sends data every 2 hours"
				break
			
			case HBBaseDevice.POLLING_EVERY_DAY:
				retValue = "Sends data every day"
				break
			
			default:
				break
		}
		return retValue
	}
	
	@objc func lastHeard() -> Int32
	{
		var retValue: Int32 = -1
		
		if (!self.demoMode)
		{
			if self.adapterInterface.beginExclusive() && !self.address.isEmpty
			{
				retValue = Int32(truncating: self.adapterInterface.lastHeard(self.address))
			}
		}
		else
		{
			retValue = 0
		}
		
		return retValue
	}
	
	@objc func canConnectWirelessly() -> Bool
	{
	return (self.config & HBBaseDevice.SLEEP_MODE_FLAG) > 0 ? true : false
	}
	
	@objc func isConnectedWirelessly() -> Bool
	{
	return (self.config & HBBaseDevice.WIRELESS_FLAG) > 0 ? true : false
	}

}
