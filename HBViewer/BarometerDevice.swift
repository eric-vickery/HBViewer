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
	let GET_ALTITUDE_IN_METERS = 0x26;
	let GET_TEMPERATURE_IN_C = 0x40;
	let GET_TEMPERATURE_IN_F = 0x41;
	
	@objc public func getPressureIninHg() -> Float
	{
		var pressure: UInt32 = 0

		if (!self.demoMode)
		{
			pressure = getUIntForCommand(command: String(format: "%XFFFF", GET_PRESSURE_IN_INHG))
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
			pressure = getUIntForCommand(command: String(format: "%XFFFF", GET_PRESSURE_IN_KPA))
		}
		else
		{
			// Get a random number between 9400 and 10800 to simulate pressure
			pressure = arc4random_uniform(1300) + 9400;
		}
	
		return Float(pressure) / 100.0;
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
			temperature = Int32(arc4random_uniform(700)) - 200
		}
		
		return Float(temperature) / 10.0;
	}
	
	public func getPressureAltitudeInFeet() -> Int
	{
		return 0;
		}
	
	public func getPressureAltitudeInMeters() -> Int
	{
		return 0
	}
	
	public func getCalibrationAltitudeInFeet() -> Int
	{
		return 0
	}
	
	public func setCalibrationAltitudeInFeet(altitude: Int) -> Void
	{
	}
	
	public func getCalibrationAltitudeInMeters() -> Int
	{
		return 0
	}
	
	public func setCalibrationAltitudeInMeters(altitude: Int) -> Void
	{
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
