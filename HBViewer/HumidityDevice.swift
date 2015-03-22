//
//  HumidityDevice.swift
//  HBTest
//
//  Created by Eric Vickery on 10/7/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

import Foundation

@objc public class HumidityDevice: HBBaseDevice
{
	var GET_TRUE_HUMIDITY = 0x21;
	var GET_SENSOR_HUMIDITY = 0x22;
	var GET_RAW_HUMIDITY = 0x23;
	var GET_TRUE_HUMIDITY_OFFSET = 0x24;
//	var SET_TRUE_HUMIDITY_OFFSET = GET_TRUE_HUMIDITY_OFFSET | BaseOneWireDevice.WRITE_FLAG;
	var GET_TEMPERATURE_IN_C = 0x40;
	var GET_TEMPERATURE_IN_F = 0x41;
	
	public func getHumidity() -> Float
		{
		var humidity: UInt32 = 0
		
		if (!self.demoMode)
			{
			if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
				{
				// select the device
				if (self.adapterInterface.selectDevice(self.address))
					{
					var byteArray: NSString = NSString(format: "%XFFFF", GET_TRUE_HUMIDITY)
					
					// Send the data to the device
					let results = self.adapterInterface.writeBlock(byteArray)
					
					let lowByte = (results as NSString).substringWithRange(NSMakeRange(0, 2))
					let highByte = (results as NSString).substringWithRange(NSMakeRange(2, 2))
					var temp: UInt32 = 0;
					var pScanner = NSScanner(string: lowByte)
					pScanner.scanHexInt(&temp)
					humidity = temp
					pScanner = NSScanner(string: highByte)
					pScanner.scanHexInt(&temp)
					humidity |= (temp << 8)
					}
				
				self.adapterInterface.endExclusive()
				}
			}
		else
			{
			// Get a random number between 0 and 10000 to simulate humidity
			humidity = arc4random_uniform(10000);
			}
		
		
		return Float(humidity) / 100.0;
		}
	
	public func getSensorHumidity() -> Float
		{
		var humidity: UInt32 = 0
		
		if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
		{
			// select the device
			if (self.adapterInterface.selectDevice(self.address))
			{
				var byteArray: NSString = NSString(format: "%XFFFF", GET_SENSOR_HUMIDITY)
				
				// Send the data to the device
				let results = self.adapterInterface.writeBlock(byteArray)
				
				let lowByte = (results as NSString).substringWithRange(NSMakeRange(0, 2))
				let highByte = (results as NSString).substringWithRange(NSMakeRange(2, 2))
				var temp: UInt32 = 0;
				var pScanner = NSScanner(string: lowByte)
				pScanner.scanHexInt(&temp)
				humidity = temp
				pScanner = NSScanner(string: highByte)
				pScanner.scanHexInt(&temp)
				humidity |= (temp << 8)
			}
			
			self.adapterInterface.endExclusive()
		}
		
		return Float(humidity) / 100.0;
		}
	
	public func getRawHumidity() -> Float
		{
		var humidity: UInt32 = 0
		
		if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
		{
			// select the device
			if (self.adapterInterface.selectDevice(self.address))
			{
				var byteArray: NSString = NSString(format: "%XFFFF", GET_RAW_HUMIDITY)
				
				// Send the data to the device
				let results = self.adapterInterface.writeBlock(byteArray)
				
				let lowByte = (results as NSString).substringWithRange(NSMakeRange(0, 2))
				let highByte = (results as NSString).substringWithRange(NSMakeRange(2, 2))
				var temp: UInt32 = 0;
				var pScanner = NSScanner(string: lowByte)
				pScanner.scanHexInt(&temp)
				humidity = temp
				pScanner = NSScanner(string: highByte)
				pScanner.scanHexInt(&temp)
				humidity |= (temp << 8)
			}
			
			self.adapterInterface.endExclusive()
		}
		
		return Float(humidity) / 100.0;
		}
	
	public func getHumidityOffset() -> Int
		{
		var humidityOffset: UInt32 = 0
		
		if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
		{
			// select the device
			if (self.adapterInterface.selectDevice(self.address))
			{
				var byteArray: NSString = NSString(format: "%XFFFF", GET_RAW_HUMIDITY)
				
				// Send the data to the device
				let results = self.adapterInterface.writeBlock(byteArray)
				
				let lowByte = (results as NSString).substringWithRange(NSMakeRange(0, 2))
				let highByte = (results as NSString).substringWithRange(NSMakeRange(2, 2))
				var temp: UInt32 = 0;
				var pScanner = NSScanner(string: lowByte)
				pScanner.scanHexInt(&temp)
				humidityOffset = temp
				pScanner = NSScanner(string: highByte)
				pScanner.scanHexInt(&temp)
				humidityOffset |= (temp << 8)
			}
			
			self.adapterInterface.endExclusive()
		}
		
		return Int(humidityOffset)
		}
	
	public func setHumidityOffset(offset: Int) -> Void
		{
//		byte[] tempBlock = new byte[10];
//		
//		try
//		{
//		AdapterManager.getInstance().getAdapter().beginExclusive(true);
//		
//		// Send an extra reset to wake up the device
//		AdapterManager.getInstance().getAdapter().reset();
//		// select the device
//		if (AdapterManager.getInstance().getAdapter().select(getAddressAsString()))
//		{
//		General.bytefill(tempBlock, (byte) 0xFF);
//		
//		tempBlock[0] = (byte) SET_TRUE_HUMIDITY_OFFSET;
//		tempBlock[1] = (byte) (pOffset & 0xFF);
//		tempBlock[2] = (byte) ((pOffset >> 8) & 0xFF);
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
	
	public func getTemperatureInFahrenheit() -> Float
	{
		var temperature: Int = 0
		
		if (!self.demoMode)
		{
			if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
			{
				// select the device
				if (self.adapterInterface.selectDevice(self.address))
				{
					var byteArray: NSString = NSString(format: "%XFFFF", GET_TEMPERATURE_IN_F)
					
					// Send the data to the device
					let results = self.adapterInterface.writeBlock(byteArray)
					
					let lowByte = (results as NSString).substringWithRange(NSMakeRange(0, 2))
					let highByte = (results as NSString).substringWithRange(NSMakeRange(2, 2))
					var temp: UInt32 = 0;
					var pScanner = NSScanner(string: lowByte)
					pScanner.scanHexInt(&temp)
					temperature = Int(temp)
					pScanner = NSScanner(string: highByte)
					pScanner.scanHexInt(&temp)
					temperature |= Int(temp << 8)
				}
				
				self.adapterInterface.endExclusive()
			}
		}
		else
		{
			// Get a random number between -100 and 1300 to simulate temperature
			temperature = arc4random_uniform(1400) - 100
		}
		
		return Float(temperature) / 10.0;
	}
	
	public func getTemperatureInCelsius() -> Float
	{
		var temperature: Int = 0
		
		if (!self.demoMode)
		{
			if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
			{
				// select the device
				if (self.adapterInterface.selectDevice(self.address))
				{
					var byteArray: NSString = NSString(format: "%XFFFF", GET_TEMPERATURE_IN_C)
					
					// Send the data to the device
					let results = self.adapterInterface.writeBlock(byteArray)
					
					let lowByte = (results as NSString).substringWithRange(NSMakeRange(0, 2))
					let highByte = (results as NSString).substringWithRange(NSMakeRange(2, 2))
					var temp: UInt32 = 0;
					var pScanner = NSScanner(string: lowByte)
					pScanner.scanHexInt(&temp)
					temperature = Int(temp)
					pScanner = NSScanner(string: highByte)
					pScanner.scanHexInt(&temp)
					temperature |= Int(temp << 8)
				}
				
				self.adapterInterface.endExclusive()
			}
		}
		else
		{
			// Get a random number between -200 and 540 to simulate temperature
			temperature = arc4random_uniform(700) - 200;
		}
		
		return Float(temperature) / 10.0;
	}
		
	public func getName() -> String
	{
		return "Humidity"
	}
	
	public func getDescription() -> String
	{
		return "Measures Relative Humidity";
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
