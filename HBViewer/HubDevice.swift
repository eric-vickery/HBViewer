//
//  HubDevice.swift
//  HBViewer
//
//  Created by Eric Vickery on 10/20/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

import Foundation

public class HubDevice: HBBaseDevice
{
	let CHANNEL_1 = 0x01;
	let CHANNEL_2 = 0x02;
	let CHANNEL_3 = 0x04;
	let CHANNEL_4 = 0x08;
	let CHANNEL_ON_FLAG = 0x10;
	let ALL_CHANNELS = 0x0F;
	let SINGLE_CHANNEL_FLAG = 0x02;
	
	let SET_CHANNELS = 0x21;
	let GET_ACTIVE_CHANNELS = 0x22;
	let GET_SHORTED_CHANNELS = 0x23;


	public func setChannels(on: Bool, channels: UInt32) -> Void
	{
//		var channelFlags: UInt32 = channels
//
//		if (!self.demoMode)
//		{
//
//			if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
//			{
//				if (on)
//				{
//					channelFlags |= UInt32(CHANNEL_ON_FLAG);
//				}
//
//				// select the device
//				if (self.adapterInterface.selectDevice(self.address))
//				{
//					var byteArray: NSString = NSString(format: "%X%X", SET_CHANNELS, channelFlags)
//
//					// Send the data to the device
//					let results = self.adapterInterface.writeBlock(byteArray)
//
////					self.adapterInterface.writeByte(UInt8(SET_CHANNELS))
////					self.adapterInterface.writeByte(UInt8(channels))
//				}
//
//				self.adapterInterface.endExclusive()
//			}
//		}
//		else
//		{
//			// TODO Put some demo code here
//		}
	}
	
	public func getActiveChannels() -> UInt32
	{
		let activeChannels: UInt32 = 0
		
//		if (!self.demoMode)
//		{
//			if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
//			{
//				// select the device
//				if (self.adapterInterface.selectDevice(self.address))
//				{
//					var byteArray: NSString = NSString(format: "%XFF", GET_ACTIVE_CHANNELS)
//					
//					// Send the data to the device
//					let results = self.adapterInterface.writeBlock(byteArray)
//					
//					let lowByte = (results as NSString).substringWithRange(NSMakeRange(0, 2))
//					let highByte = (results as NSString).substringWithRange(NSMakeRange(2, 2))
//					var temp: UInt32 = 0;
//					var pScanner = NSScanner(string: lowByte)
//					pScanner.scanHexInt(&temp)
//					activeChannels = temp
//					pScanner = NSScanner(string: highByte)
//					pScanner.scanHexInt(&temp)
//					activeChannels |= (temp << 8)
//				}
//				
//				self.adapterInterface.endExclusive()
//			}
//		}
//		else
//		{
//			// TODO Put some demo code here
//		}
	
		return activeChannels;
	}

	public func getName() -> String
	{
		return "4 Channel Hub";
	}
	
	public func getDescription() -> String
	{
		return "Supports 4 independent 1-Wire branches";
	}
	
	public func hasUpdatableFirmware() -> Bool
	{
		return true;
	}
	
	public func hasConfigurationOptions() -> Bool
	{
		return false;
	}

}
