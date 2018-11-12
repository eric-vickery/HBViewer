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
	
	@objc public func getSensorData() -> [Int]
	{
		var sensorDataList: [Int] = [Int](repeating: 0, count: 4)
		
		if (!self.demoMode)
		{
			if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
			{
				// select the device
				if (self.adapterInterface.selectDevice(self.address))
				{
					let byteArray = String(format: "%XFFFFFFFF", GET_SENSOR_DATA)
					
					// Send the data to the device
					let results = self.adapterInterface.writeBlock(byteArray)
					
					var temp: UInt32 = 0
					var sensorByte: String
					var pScanner: Scanner
					
					for index in 0..<4
					{
						if let results = results
						{
							let startingIndex = results.index(results.startIndex, offsetBy: index * 2)
							let endingIndex = results.index(startingIndex, offsetBy: 2)
							sensorByte = String(results[startingIndex..<endingIndex])
							pScanner = Scanner(string: sensorByte)
							pScanner.scanHexInt32(&temp)
							sensorDataList[index] = Int(temp)
						}
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
	
	public func setLeafWetnessChannels(leafWetnessFlags: Int) -> Void
	{
	}
	
	public func getLeafWetnessChannels() -> Int
	{
		var leafWetnessFlags: UInt32 = 0
		
		leafWetnessFlags = getUIntForCommand(command: String(format: "%XFF", GET_LEAF_WETNESS_CHANNELS))
		
		return Int(leafWetnessFlags)
	}
	
	public func setLeafWetnessMax(leafWetnessMax: Int) -> Void
	{
	}
	
	public func getLeafWetnessMax() -> Int
	{
		var leafWetnessMax: UInt32 = 0
		
		leafWetnessMax = getUIntForCommand(command: String(format: "%XFFFF", GET_LEAF_WETNESS_MAX))
		
		return Int(leafWetnessMax)
	}
	
	public func setLeafWetnessMin(leafWetnessMin: Int) -> Void
	{
	}
	
	public func getLeafWetnessMin() -> Int
	{
		var leafWetnessMin: UInt32 = 0

		leafWetnessMin = getUIntForCommand(command: String(format: "%XFFFF", GET_LEAF_WETNESS_MIN))
		
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
