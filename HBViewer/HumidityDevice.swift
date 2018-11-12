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
	var GET_TEMPERATURE_IN_C = 0x40;
	var GET_TEMPERATURE_IN_F = 0x41;
	
	@objc public func getHumidity() -> Float
	{
		var humidity: UInt32 = 0
		
		if (!self.demoMode)
		{
			humidity = getUIntForCommand(command: String(format: "%XFFFF", GET_TRUE_HUMIDITY))
		}
		else
		{
			// Get a random number between 0 and 10000 to simulate humidity
			humidity = arc4random_uniform(10000);
		}
		return Float(humidity) / 100.0;
	}
	
	@objc public func getSensorHumidity() -> Float
	{
		var humidity: UInt32 = 0
		
		humidity = getUIntForCommand(command: String(format: "%XFFFF", GET_SENSOR_HUMIDITY))
		
		return Float(humidity) / 100.0;
	}
	
	public func getRawHumidity() -> Float
	{
		var humidity: UInt32 = 0
		
		humidity = getUIntForCommand(command: String(format: "%XFFFF", GET_RAW_HUMIDITY))
		
		return Float(humidity) / 100.0;
	}
	
	public func getHumidityOffset() -> Int
	{
		var humidityOffset: UInt32 = 0

		humidityOffset = getUIntForCommand(command: String(format: "%XFFFF", GET_RAW_HUMIDITY))
		
		return Int(humidityOffset)
	}
	
	public func setHumidityOffset(offset: Int) -> Void
	{
	}
	
	@objc public func getTemperatureInFahrenheit() -> Float
	{
		var temperature: Int32 = 0
		
		if (!self.demoMode)
		{
			temperature = getIntForCommand(command: String(format: "%XFFFF", GET_TEMPERATURE_IN_F))
		}
		else
		{
			// Get a random number between -100 and 1300 to simulate temperature
			temperature = Int32(arc4random_uniform(1400)) - 100
		}
		
		return Float(temperature) / 10.0;
	}
	
	public func getTemperatureInCelsius() -> Float
	{
		var temperature: Int32 = 0
		
		if (!self.demoMode)
		{
			temperature = getIntForCommand(command: String(format: "%XFFFF", GET_TEMPERATURE_IN_C))
		}
		else
		{
			// Get a random number between -200 and 540 to simulate temperature
			temperature = Int32(arc4random_uniform(700)) - 200;
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
