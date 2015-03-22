//
//  MoistureMeterDevice.swift
//  HBTest
//
//  Created by Eric Vickery on 10/7/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

import Foundation

@objc public class MoistureMeterDevice: HBBaseDevice
{
	var CHANNEL_1 = 0x01;
	var CHANNEL_2 = 0x02;
	var CHANNEL_3 = 0x04;
	var CHANNEL_4 = 0x08;
	
	var GET_SENSOR_DATA = 0x21;
	var GET_RAW_SENSOR_DATA = 0x31;
	var GET_LEAF_WETNESS_CHANNELS = 0x22;
//	var SET_LEAF_WETNESS_CHANNELS = GET_LEAF_WETNESS_CHANNELS | BaseOneWireDevice.WRITE_FLAG;
	var GET_LEAF_WETNESS_MAX = 0x23;
//	var SET_LEAF_WETNESS_MAX = GET_LEAF_WETNESS_MAX | BaseOneWireDevice.WRITE_FLAG;
	var GET_LEAF_WETNESS_MIN = 0x24;
//	var SET_LEAF_WETNESS_MIN = GET_LEAF_WETNESS_MIN | BaseOneWireDevice.WRITE_FLAG;
	
	public func getSensorData() -> [Int]
		{
		var sensorDataList: [Int] = [Int](count: 4, repeatedValue: 0)
		
		if (!self.demoMode)
			{
			if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
				{
				// select the device
				if (self.adapterInterface.selectDevice(self.address))
					{
					var byteArray: NSString = NSString(format: "%XFFFFFFFF", GET_SENSOR_DATA)
					
					// Send the data to the device
					let results = self.adapterInterface.writeBlock(byteArray)
					
					var temp: UInt32 = 0
					var sensorByte: NSString
					var pScanner: NSScanner
					
					for index in 0..<4
						{
						sensorByte = (results as NSString).substringWithRange(NSMakeRange(index * 2, 2))
						pScanner = NSScanner(string: sensorByte)
						pScanner.scanHexInt(&temp)
						sensorDataList[index] = Int(temp)
						}
					}
				
				self.adapterInterface.endExclusive()
				}
			}
		else
			{
			sensorDataList[0] = Int(arc4random_uniform(199));
			sensorDataList[1] = Int(arc4random_uniform(199));
			sensorDataList[2] = Int(arc4random_uniform(199));
			sensorDataList[3] = Int(arc4random_uniform(199));
			}
		
		return sensorDataList
		}
	
//	public func getRawSensorData() -> [Int]
//	{
//	byte[] tempBlock = new byte[20];
//	ArrayList<Integer> sensorDataList = new ArrayList<Integer>();
//	
//	try
//	{
//	AdapterManager.getInstance().getAdapter().beginExclusive(true);
//	
//	// select the device
//	if (AdapterManager.getInstance().getAdapter().select(getAddressAsString()))
//	{
//	General.bytefill(tempBlock, (byte) 0xFF);
//	
//	tempBlock[0] = GET_RAW_SENSOR_DATA;
//	
//	// Send the data to the device
//	AdapterManager.getInstance().getAdapter().dataBlock(tempBlock, 0, 9);
//	
//	sensorDataList.add((tempBlock[2] << 8) & 0xFFFF | tempBlock[1] & 0xFF);
//	sensorDataList.add((tempBlock[4] << 8) & 0xFFFF | tempBlock[3] & 0xFF);
//	sensorDataList.add((tempBlock[6] << 8) & 0xFFFF | tempBlock[5] & 0xFF);
//	sensorDataList.add((tempBlock[8] << 8) & 0xFFFF | tempBlock[7] & 0xFF);
//	
//	AdapterManager.getInstance().getAdapter().endExclusive();
//	
//	return sensorDataList;
//	}
//	}
//	catch (OneWireIOException pExp)
//	{
//	pExp.printStackTrace();
//	}
//	catch (OneWireException pExp)
//	{
//	pExp.printStackTrace();
//	}
//	
//	return null;
//	}
	
	public func setLeafWetnessChannels(leafWetnessFlags: Int) -> Void
		{
//		try
//		{
//		AdapterManager.getInstance().getAdapter().beginExclusive(true);
//		
//		// select the device
//		if (AdapterManager.getInstance().getAdapter().select(getAddressAsString()))
//		{
//		AdapterManager.getInstance().getAdapter().putByte((byte) SET_LEAF_WETNESS_CHANNELS);
//		
//		AdapterManager.getInstance().getAdapter().putByte(pLeafWetnessFlags);
//		}
//		AdapterManager.getInstance().getAdapter().endExclusive();
//		}
//		catch (OneWireIOException pExp)
//		{
//		pExp.printStackTrace();
//		}
//		catch (OneWireException pExp)
//		{
//		pExp.printStackTrace();
//		}
		}
	
	public func getLeafWetnessChannels() -> Int
		{
		var leafWetnessFlags: UInt32 = 0
		
		if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
		{
			// select the device
			if (self.adapterInterface.selectDevice(self.address))
			{
				var byteArray: NSString = NSString(format: "%XFF", GET_LEAF_WETNESS_CHANNELS)
				
				// Send the data to the device
				let results = self.adapterInterface.writeBlock(byteArray)
				
				let lowByte = (results as NSString).substringWithRange(NSMakeRange(0, 2))
				var temp: UInt32 = 0;
				var pScanner = NSScanner(string: lowByte)
				pScanner.scanHexInt(&temp)
				leafWetnessFlags = temp
			}
			
			self.adapterInterface.endExclusive()
		}
		
		return Int(leafWetnessFlags)
		}
	
	public func setLeafWetnessMax(leafWetnessMax: Int) -> Void
		{
//		byte[] tempBlock = new byte[5];
//		try
//		{
//		AdapterManager.getInstance().getAdapter().beginExclusive(true);
//		
//		// select the device
//		if (AdapterManager.getInstance().getAdapter().select(getAddressAsString()))
//		{
//		General.bytefill(tempBlock, (byte) 0xFF);
//		
//		tempBlock[0] = (byte) SET_LEAF_WETNESS_MAX;
//		tempBlock[1] = (byte) (pLeafWetnessMax & 0xFF);
//		tempBlock[2] = (byte) ((pLeafWetnessMax >> 8) & 0xFF);
//		
//		// Send the data to the device
//		AdapterManager.getInstance().getAdapter().dataBlock(tempBlock, 0, 3);
//		}
//		AdapterManager.getInstance().getAdapter().endExclusive();
//		}
//		catch (OneWireIOException pExp)
//		{
//		pExp.printStackTrace();
//		}
//		catch (OneWireException pExp)
//		{
//		pExp.printStackTrace();
//		}
		}
	
	public func getLeafWetnessMax() -> Int
	{
	var leafWetnessMax: UInt32 = 0
	
	if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
	{
		// select the device
		if (self.adapterInterface.selectDevice(self.address))
		{
			var byteArray: NSString = NSString(format: "%XFFFF", GET_LEAF_WETNESS_MAX)
			
			// Send the data to the device
			let results = self.adapterInterface.writeBlock(byteArray)
			
			let lowByte = (results as NSString).substringWithRange(NSMakeRange(0, 2))
			let highByte = (results as NSString).substringWithRange(NSMakeRange(2, 2))
			var temp: UInt32 = 0;
			var pScanner = NSScanner(string: lowByte)
			pScanner.scanHexInt(&temp)
			leafWetnessMax = temp
			pScanner = NSScanner(string: highByte)
			pScanner.scanHexInt(&temp)
			leafWetnessMax |= (temp << 8)
		}
		
		self.adapterInterface.endExclusive()
	}
	
	return Int(leafWetnessMax)
	}
	
	public func setLeafWetnessMin(leafWetnessMin: Int) -> Void
		{
//		byte[] tempBlock = new byte[5];
//		try
//		{
//		AdapterManager.getInstance().getAdapter().beginExclusive(true);
//		
//		// select the device
//		if (AdapterManager.getInstance().getAdapter().select(getAddressAsString()))
//		{
//		General.bytefill(tempBlock, (byte) 0xFF);
//		
//		tempBlock[0] = (byte) SET_LEAF_WETNESS_MIN;
//		tempBlock[1] = (byte) (pLeafWetnessMin & 0xFF);
//		tempBlock[2] = (byte) ((pLeafWetnessMin >> 8) & 0xFF);
//		
//		// Send the data to the device
//		AdapterManager.getInstance().getAdapter().dataBlock(tempBlock, 0, 3);
//		}
//		AdapterManager.getInstance().getAdapter().endExclusive();
//		}
//		catch (OneWireIOException pExp)
//		{
//		pExp.printStackTrace();
//		}
//		catch (OneWireException pExp)
//		{
//		pExp.printStackTrace();
//		}
		}
	
	public func getLeafWetnessMin() -> Int
	{
		var leafWetnessMin: UInt32 = 0
		
		if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
		{
			// select the device
			if (self.adapterInterface.selectDevice(self.address))
			{
				var byteArray: NSString = NSString(format: "%XFFFF", GET_LEAF_WETNESS_MIN)
				
				// Send the data to the device
				let results = self.adapterInterface.writeBlock(byteArray)
				
				let lowByte = (results as NSString).substringWithRange(NSMakeRange(0, 2))
				let highByte = (results as NSString).substringWithRange(NSMakeRange(2, 2))
				var temp: UInt32 = 0;
				var pScanner = NSScanner(string: lowByte)
				pScanner.scanHexInt(&temp)
				leafWetnessMin = temp
				pScanner = NSScanner(string: highByte)
				pScanner.scanHexInt(&temp)
				leafWetnessMin |= (temp << 8)
			}
			
			self.adapterInterface.endExclusive()
		}
		
		return Int(leafWetnessMin)
	}
	
	public func getName() -> String
	{
		return "Moisture Meter"
	}
	
	public func getDescription() -> String
	{
		return "Measures Watermark Sensors and Leaf Wetness Sensors"
	}
	
	public func hasUpdatableFirmware() -> Bool
	{
		return true;
	}
	
	public func hasConfigurationOptions() -> Bool
	{
		return true;
	}
}
