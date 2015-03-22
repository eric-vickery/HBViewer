//
//  BarometerDevice.swift
//  HBTest
//
//  Created by Eric Vickery on 10/6/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

import Foundation

@objc public class BarometerDevice : HBBaseDevice
{
	let GET_PRESSURE_IN_INHG = 0x21;
	let GET_PRESSURE_IN_KPA = 0x22;
	let GET_PRESSURE_ALT_IN_FEET = 0x23;
	let GET_PRESSURE_ALT_IN_METERS = 0x24;
	let GET_ALTITUDE_IN_FEET = 0x25;
//	let SET_ALTITUDE_IN_FEET = GET_ALTITUDE_IN_FEET | WRITE_FLAG;
	let GET_ALTITUDE_IN_METERS = 0x26;
//	let SET_ALTITUDE_IN_METERS = GET_ALTITUDE_IN_METERS | WRITE_FLAG;
	let GET_TEMPERATURE_IN_C = 0x40;
	let GET_TEMPERATURE_IN_F = 0x41;
	
	public func getPressureIninHg() -> Float
		{
		var pressure: UInt32 = 0

		if (!self.demoMode)
			{
			if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
				{
				// select the device
				if (self.adapterInterface.selectDevice(self.address))
					{
					var byteArray: NSString = NSString(format: "%XFFFF", GET_PRESSURE_IN_INHG)
					
					// Send the data to the device
					let results = self.adapterInterface.writeBlock(byteArray)

					let lowByte = (results as NSString).substringWithRange(NSMakeRange(0, 2))
					let highByte = (results as NSString).substringWithRange(NSMakeRange(2, 2))
					var temp: UInt32 = 0;
					var pScanner = NSScanner(string: lowByte)
					pScanner.scanHexInt(&temp)
					pressure = temp
					pScanner = NSScanner(string: highByte)
					pScanner.scanHexInt(&temp)
					pressure |= (temp << 8)
					}
				
				self.adapterInterface.endExclusive()
				}
			}
		else
			{
			// Get a random number between 2800 and 3200 to simulate pressure
			pressure = arc4random_uniform(400) + 2800;
			}
			
		return Float(pressure) / 100.0;
		}
	
	public func getPressureInkPa() -> Float
		{
		var pressure: UInt32 = 0
		
		if (!self.demoMode)
			{
			if (self.adapterInterface.beginExclusive() && !self.address.isEmpty)
				{
				// select the device
				if (self.adapterInterface.selectDevice(self.address))
					{
					var byteArray: NSString = NSString(format: "%XFFFF", GET_PRESSURE_IN_KPA)
					
					// Send the data to the device
					let results = self.adapterInterface.writeBlock(byteArray)
					
					let lowByte = (results as NSString).substringWithRange(NSMakeRange(0, 2))
					let highByte = (results as NSString).substringWithRange(NSMakeRange(2, 2))
					var temp: UInt32 = 0;
					var pScanner = NSScanner(string: lowByte)
					pScanner.scanHexInt(&temp)
					pressure = temp
					pScanner = NSScanner(string: highByte)
					pScanner.scanHexInt(&temp)
					pressure |= (temp << 8)
					}
				
				self.adapterInterface.endExclusive()
				}
			}
		else
			{
			// Get a random number between 9400 and 10800 to simulate pressure
			pressure = arc4random_uniform(1300) + 9400;
			}
	
		return Float(pressure) / 100.0;
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
	
	public func getPressureAltitudeInFeet() -> Int
		{
//		byte[] tempBlock = new byte[10];
//		int pressureAlt = -1;
//		
//		AdapterManager.getInstance().getAdapter().beginExclusive(true);
//		
//		// Send an extra reset to wake up the datalogger
//		AdapterManager.getInstance().getAdapter().reset();
//		// select the device
//		if (AdapterManager.getInstance().getAdapter().select(getAddressAsString()))
//		{
//			General.bytefill(tempBlock, (byte) 0xFF);
//			
//			tempBlock[0] = (byte)GET_PRESSURE_ALT_IN_FEET;
//			
//			// Send the data to the device
//			AdapterManager.getInstance().getAdapter().dataBlock(tempBlock, 0, 3);
//			
//			pressureAlt = tempBlock[1] & 0xFF;
//			pressureAlt |= (tempBlock[2] << 8) & 0xFFFF;
//		}
//		
//		AdapterManager.getInstance().getAdapter().endExclusive();
//		
//		return pressureAlt;
		return 0;
		}
	
	public func getPressureAltitudeInMeters() -> Int
		{
//		byte[] tempBlock = new byte[10];
//		int pressureAlt = -1;
//		
//		AdapterManager.getInstance().getAdapter().beginExclusive(true);
//		
//		// Send an extra reset to wake up the datalogger
//		AdapterManager.getInstance().getAdapter().reset();
//		// select the device
//		if (AdapterManager.getInstance().getAdapter().select(getAddressAsString()))
//		{
//			General.bytefill(tempBlock, (byte) 0xFF);
//			
//			tempBlock[0] = (byte)GET_PRESSURE_ALT_IN_METERS;
//			
//			// Send the data to the device
//			AdapterManager.getInstance().getAdapter().dataBlock(tempBlock, 0, 3);
//			
//			pressureAlt = tempBlock[1] & 0xFF;
//			pressureAlt |= (tempBlock[2] << 8) & 0xFFFF;
//		}
//		
//		AdapterManager.getInstance().getAdapter().endExclusive();
//		
//		return pressureAlt;
		return 0
		}
	
	public func getCalibrationAltitudeInFeet() -> Int
		{
//		byte[] tempBlock = new byte[10];
//		int alt = -1;
//		
//		AdapterManager.getInstance().getAdapter().beginExclusive(true);
//		
//		// Send an extra reset to wake up the datalogger
//		AdapterManager.getInstance().getAdapter().reset();
//		// select the device
//		if (AdapterManager.getInstance().getAdapter().select(getAddressAsString()))
//		{
//			General.bytefill(tempBlock, (byte) 0xFF);
//			
//			tempBlock[0] = (byte)GET_ALTITUDE_IN_FEET;
//			
//			// Send the data to the device
//			AdapterManager.getInstance().getAdapter().dataBlock(tempBlock, 0, 3);
//			
//			alt = tempBlock[1] & 0xFF;
//			alt |= (tempBlock[2] << 8) & 0xFFFF;
//		}
//		
//		AdapterManager.getInstance().getAdapter().endExclusive();
//		
//		return alt;
		return 0
		}
	
	public func setCalibrationAltitudeInFeet(altitude: Int) -> Void
		{
//		byte[] tempBlock = new byte[10];
//		
//		AdapterManager.getInstance().getAdapter().beginExclusive(true);
//		
//		// Send an extra reset to wake up the datalogger
//		AdapterManager.getInstance().getAdapter().reset();
//		// select the device
//		if (AdapterManager.getInstance().getAdapter().select(getAddressAsString()))
//		{
//			General.bytefill(tempBlock, (byte) 0xFF);
//			
//			tempBlock[0] = (byte) SET_ALTITUDE_IN_FEET;
//			tempBlock[1] = (byte) (pAltitude & 0xFF);
//			tempBlock[2] = (byte) ((pAltitude >> 8) & 0xFF);
//			
//			// Send the data to the device
//			AdapterManager.getInstance().getAdapter().dataBlock(tempBlock, 0, 3);
//		}
//		
//		AdapterManager.getInstance().getAdapter().endExclusive();
		}
	
	public func getCalibrationAltitudeInMeters() -> Int
		{
//		byte[] tempBlock = new byte[10];
//		int alt = -1;
//		
//		AdapterManager.getInstance().getAdapter().beginExclusive(true);
//		
//		// Send an extra reset to wake up the datalogger
//		AdapterManager.getInstance().getAdapter().reset();
//		// select the device
//		if (AdapterManager.getInstance().getAdapter().select(getAddressAsString()))
//		{
//			General.bytefill(tempBlock, (byte) 0xFF);
//			
//			tempBlock[0] = (byte)GET_ALTITUDE_IN_METERS;
//			
//			// Send the data to the device
//			AdapterManager.getInstance().getAdapter().dataBlock(tempBlock, 0, 3);
//			
//			alt = tempBlock[1] & 0xFF;
//			alt |= (tempBlock[2] << 8) & 0xFFFF;
//		}
//		
//		AdapterManager.getInstance().getAdapter().endExclusive();
//		
//		return alt;
		return 0
		}
	
	public func setCalibrationAltitudeInMeters(altitude: Int) -> Void
		{
//		byte[] tempBlock = new byte[10];
//		
//		AdapterManager.getInstance().getAdapter().beginExclusive(true);
//		
//		// Send an extra reset to wake up the datalogger
//		AdapterManager.getInstance().getAdapter().reset();
//		// select the device
//		if (AdapterManager.getInstance().getAdapter().select(getAddressAsString()))
//		{
//			General.bytefill(tempBlock, (byte) 0xFF);
//			
//			tempBlock[0] = (byte) SET_ALTITUDE_IN_METERS;
//			tempBlock[1] = (byte) (pAltitude & 0xFF);
//			tempBlock[2] = (byte) ((pAltitude >> 8) & 0xFF);
//			
//			// Send the data to the device
//			AdapterManager.getInstance().getAdapter().dataBlock(tempBlock, 0, 3);
//		}
//		
//		AdapterManager.getInstance().getAdapter().endExclusive();
		}
	
	public func getName() -> String
		{
		return "Barometer";
		}
	
	public func getDescription() -> String
		{
		return "Measures Barometeric Pressure";
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