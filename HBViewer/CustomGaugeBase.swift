//
//  CustomGaugeBase.swift
//  DrawingTest
//
//  Created by Eric Vickery on 9/29/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

import UIKit
import GLKit

@IBDesignable class CustomGaugeBase: UIView
{
	@IBInspectable var gaugeValue: Float = 0.0
	{
		didSet
		{
			gaugeValue = min(gaugeMaxValue, max(gaugeMinValue, gaugeValue))
			gaugeRelativeValue = gaugeValue - gaugeMinValue
			setupView()
		}
	}
	
	var gaugeRelativeValue: Float = 0.0
	
	var gaugeStepValue: Float = 0.0
	var gaugeNewValue: Float = 0.0
	var tickCounter: Int = 0;
	
	@IBInspectable var gaugeMinValue: Float = 0.0
	{
		didSet
		{
			gaugeRelativeValue = gaugeValue - gaugeMinValue
			setupView()
		}
	}
	
	@IBInspectable var gaugeMaxValue: Float = 100.0
	{
		didSet
		{
			setupView()
		}
	}

	@IBInspectable var showScaleText: Bool = true
	{
		didSet
		{
			setupView()
		}
	}
	
	@IBInspectable var scaleFont: UIFont = UIFont(name: "Helvetica", size:20)!
	{
		didSet
		{
			setupView()
		}
	}
	
	@IBInspectable var currentValueFont: UIFont = UIFont(name: "Helvetica", size:30)!
	{
		didSet
		{
			setupView()
		}
	}
	
	@IBInspectable var unitOfMeasure: String = ""
	{
		didSet
		{
			setupView()
		}
	}
	
	@IBInspectable var unitOfMeasureFont: UIFont = UIFont(name: "Helvetica", size:15)!
	{
		didSet
		{
			setupView()
		}
	}
	
	@IBInspectable var unitOfMeasureColor: UIColor = UIColor.black
	{
		didSet
		{
			setupView()
		}
	}
	
	@IBInspectable var gaugeValueFont: UIFont = UIFont(name: "Helvetica", size:30)!
	{
		didSet
		{
			setupView()
		}
	}
	
	func setupView()
	{
		self.setNeedsDisplay()
	}
	
	@objc func setGaugeValue(value: Float, animated: Bool) -> Void
	{
		if (!animated)
		{
			gaugeValue = value;
		}
		else
		{
			gaugeStepValue = (value - gaugeValue) / 10.0
			gaugeNewValue = value
			
			// Setup a timer
			tickCounter = 0
			Timer.scheduledTimer(timeInterval: 0.075, target: self, selector: #selector(CustomGaugeBase.gaugeStepTick(timer:)), userInfo: nil, repeats: true)
		}
	}
	
	@objc func gaugeStepTick(timer: Timer!)
	{
		gaugeValue += gaugeStepValue
		
		if (tickCounter < 10)
		{
			tickCounter += 1
		}
		else
		{
			timer.invalidate()
		}
	}
	
	func drawRect (context: CGContext, rect: CGRect, fillColor: UIColor)
	{
		context.saveGState()
		
		context.setLineWidth(0.01)
		context.setFillColor(fillColor.cgColor)
		context.setStrokeColor(fillColor.cgColor)
		
		context.fill(rect)
		
		context.restoreGState()
	}
	
	func drawArc (context: CGContext, centerPoint: CGPoint, radius: CGFloat, lineColor: UIColor, lineWidth: CGFloat, startingAngleInDegrees: Float, endingAngleInDegrees: Float)
	{
		context.saveGState()
		
		context.setLineWidth(lineWidth)
		context.setStrokeColor(lineColor.cgColor)
		
		let startAngle: CGFloat = CGFloat(GLKMathDegreesToRadians(90.0 + startingAngleInDegrees))
		let endAngle: CGFloat = CGFloat(GLKMathDegreesToRadians(90.0 + endingAngleInDegrees))
		context.addArc(center: centerPoint, radius: radius - (lineWidth / 2), startAngle: startAngle, endAngle: endAngle, clockwise: false)
		context.strokePath()
		
		context.restoreGState()
	}
	
	func drawTickMark (context: CGContext, centerPoint: CGPoint, radius: CGFloat, lineColor: UIColor, lineWidth: CGFloat, lineLength: CGFloat, angleInDegrees: Float)
	{
		context.saveGState()
		
		context.setAllowsAntialiasing(true)
		context.setLineWidth(lineWidth)
		context.setLineCap(.round)
		context.setStrokeColor(lineColor.cgColor)

		var a = radius * CGFloat(sin(GLKMathDegreesToRadians(angleInDegrees)))
		var b = radius * CGFloat(cos(GLKMathDegreesToRadians(angleInDegrees)))
		var newPoint = CGPoint(x: centerPoint.x + CGFloat(b), y: centerPoint.y + CGFloat(a))
		context.move(to: newPoint)

		a = (radius - lineLength) * CGFloat(sin(GLKMathDegreesToRadians(angleInDegrees)))
		b = (radius - lineLength) * CGFloat(cos(GLKMathDegreesToRadians(angleInDegrees)))
		newPoint = CGPoint(x: centerPoint.x + CGFloat(b), y: centerPoint.y + CGFloat(a))
		context.addLine(to: newPoint)

		context.strokePath()
		
		context.restoreGState()
	}
}
