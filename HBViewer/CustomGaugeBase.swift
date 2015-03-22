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
	
	@IBInspectable var unitOfMeasureColor: UIColor = UIColor.blackColor()
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
	
	func setGaugeValue(value: Float, animated: Bool) -> Void
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
			NSTimer.scheduledTimerWithTimeInterval(0.075, target: self, selector: "gaugeStepTick:", userInfo: nil, repeats: true)
			}
		}
	
	func gaugeStepTick(timer:NSTimer!)
		{
		gaugeValue += gaugeStepValue
		
		if (tickCounter < 10)
			{
			tickCounter++
			}
		else
			{
			timer.invalidate()
			}
		}
	
	func drawRect (context: CGContextRef, rect: CGRect, fillColor: UIColor) -> Void
		{
		CGContextSaveGState(context)
		
		CGContextSetLineWidth(context, 0.01)
		CGContextSetFillColorWithColor(context, fillColor.CGColor)
		CGContextSetStrokeColorWithColor(context, fillColor.CGColor)
		
		CGContextFillRect(context, rect)
		
		CGContextRestoreGState(context)
		}
	
	func drawArc (context: CGContextRef, centerPoint: CGPoint, radius: CGFloat, lineColor: UIColor, lineWidth: CGFloat, startingAngleInDegrees: Float, endingAngleInDegrees: Float) -> Void
		{
		CGContextSaveGState(context)
		
		CGContextSetLineWidth(context, lineWidth)
		CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
		
		let startAngle: CGFloat = CGFloat(GLKMathDegreesToRadians(90.0 + startingAngleInDegrees))
		let endAngle: CGFloat = CGFloat(GLKMathDegreesToRadians(90.0 + endingAngleInDegrees))
		CGContextAddArc(context, centerPoint.x, centerPoint.y, radius - (lineWidth / 2), startAngle, endAngle, 0)
		CGContextStrokePath(context)
		
		CGContextRestoreGState(context)
		}
	
	func drawTickMark (context: CGContextRef, centerPoint: CGPoint, radius: CGFloat, lineColor: UIColor, lineWidth: CGFloat, lineLength: CGFloat, angleInDegrees: Float) -> Void
		{
		CGContextSaveGState(context)
		
		CGContextSetAllowsAntialiasing(context, true)
		CGContextSetLineWidth(context, lineWidth)
		CGContextSetLineCap(context, kCGLineCapRound)
		CGContextSetStrokeColorWithColor(context, lineColor.CGColor)

		var a = radius * CGFloat(sin(GLKMathDegreesToRadians(angleInDegrees)))
		var b = radius * CGFloat(cos(GLKMathDegreesToRadians(angleInDegrees)))
		var x = centerPoint.x + CGFloat(b)
		var y = centerPoint.y + CGFloat(a)
		CGContextMoveToPoint(context, x, y)

		a = (radius - lineLength) * CGFloat(sin(GLKMathDegreesToRadians(angleInDegrees)))
		b = (radius - lineLength) * CGFloat(cos(GLKMathDegreesToRadians(angleInDegrees)))
		x = centerPoint.x + CGFloat(b)
		y = centerPoint.y + CGFloat(a)
		CGContextAddLineToPoint(context, x, y)

		CGContextStrokePath(context)
		
		CGContextRestoreGState(context)
		}
}
