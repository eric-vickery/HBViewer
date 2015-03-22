//
//  SimpleFlatStraightGaugeView.swift
//  DrawingTest
//
//  Created by Eric Vickery on 10/7/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

import UIKit

@IBDesignable class SimpleFlatStraightGaugeView: CustomGaugeBase
{
	@IBInspectable var gaugeEmptyColor: UIColor = UIColor(red:0.0, green:1.0, blue:0.0, alpha:1.0)
		{
		didSet
		{
			setupView()
		}
	}
	
	@IBInspectable var gaugeFilledColor: UIColor = UIColor(red:1.0, green:0.0, blue:0.0, alpha:1.0)
		{
		didSet
		{
			setupView()
		}
	}
	
	@IBInspectable var gaugeInset: CGFloat = 5.0
		{
		didSet
		{
			setupView()
		}
	}
	
	@IBInspectable var gaugeBarWidth: CGFloat = CGFloat(30.0)
		{
		didSet
		{
			gaugeBarPercent = gaugeBarWidth / 100.0
			setupView()
		}
	}
	
	var gaugeBarPercent: CGFloat = 0.30
	
	@IBInspectable var vertical: Bool = false
		{
		didSet
		{
			setupView()
		}
	}
	
	override func drawRect(rect: CGRect)
	{
		let context:CGContextRef = UIGraphicsGetCurrentContext()
	
		CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
		
		if (self.bounds.height > self.bounds.width)
			{
			vertical = true
			}
		else
			{
			vertical = false
			}
		
		var gaugeRect: CGRect
		var gaugeLength: CGFloat
		
		if (vertical)
		{
			gaugeRect = CGRect(x: gaugeInset, y: gaugeInset, width: self.bounds.width * gaugeBarPercent, height: self.bounds.height - (gaugeInset * 2))
			gaugeLength = gaugeRect.height
		}
		else
		{
			gaugeRect = CGRect(x: gaugeInset, y: gaugeInset, width: self.bounds.width - (gaugeInset * 2), height: self.bounds.height * gaugeBarPercent)
			gaugeLength = gaugeRect.width
		}
		
		let totalValueRange = gaugeMaxValue - gaugeMinValue
		let scaleLengthPerScaleValue = Float(gaugeLength) / totalValueRange
//		let scaleValueEndLength = gaugeStartAngle + (gaugeRelativeValue * scaleLengthPerScaleValue)

		var gaugeFilledRect: CGRect
		var gaugeUnfilledRect: CGRect
		if (vertical)
		{
			gaugeUnfilledRect = CGRect(x: gaugeRect.origin.x, y: gaugeRect.origin.y, width: gaugeRect.width, height: gaugeRect.height - CGFloat(gaugeRelativeValue * scaleLengthPerScaleValue))
			gaugeFilledRect = CGRect(x: gaugeRect.origin.x, y: gaugeRect.origin.y + gaugeUnfilledRect.height, width: gaugeRect.width, height: gaugeRect.height - gaugeUnfilledRect.height)
		}
		else
		{
			gaugeFilledRect = CGRect(x: gaugeRect.origin.x, y: gaugeRect.origin.y, width: CGFloat(gaugeRelativeValue * scaleLengthPerScaleValue), height: gaugeRect.height)
			gaugeUnfilledRect = CGRect(x: gaugeRect.origin.x + gaugeFilledRect.width, y: gaugeRect.origin.y, width: gaugeRect.width - gaugeFilledRect.width, height: gaugeRect.height)
		}
		
		// Draw the value stripe of the dial
		drawRect(context, rect: gaugeFilledRect, fillColor: gaugeFilledColor)
		
		// Draw the empty stripe of the gauge
		drawRect(context, rect: gaugeUnfilledRect, fillColor: gaugeEmptyColor)
		
		// Now put on the text
		let textRect = drawValueText (context, gaugeRect: gaugeRect)
		
		if (showScaleText)
			{
			drawUnitOfMeasureText(context, valueTextRect: textRect)
			drawScaleText (context, gaugeRect: gaugeRect)
			}
	}
	
	private func drawUnitOfMeasureText (context:CGContextRef, valueTextRect: CGRect) -> Void
	{
		let stringAttrs: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName : unitOfMeasureFont, NSForegroundColorAttributeName : unitOfMeasureColor])
		let attribString: NSAttributedString = NSAttributedString(string: unitOfMeasure, attributes: stringAttrs);
		
		let attribStringSize = attribString.size()
		
		var startingPoint = CGPoint(x: valueTextRect.origin.x + (valueTextRect.width / 2) - (attribStringSize.width / 2), y: valueTextRect.origin.y + valueTextRect.height)
		
		// See if any part of the text is out of bounds
		// Only needed for horizontial layout
		if (!vertical && (startingPoint.y + attribStringSize.height > self.bounds.height))
			{
			startingPoint = CGPoint(x: valueTextRect.origin.x + valueTextRect.width + 10, y: valueTextRect.origin.y + ((valueTextRect.height / 2) - attribStringSize.height / 2))
			}
		
		attribString.drawAtPoint(startingPoint);
	}
	
	private func drawScaleText (context:CGContextRef, gaugeRect: CGRect) -> Void
		{
		let stringAttrs: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName : scaleFont, NSForegroundColorAttributeName : unitOfMeasureColor])
		var attribString: NSAttributedString = NSAttributedString(string: String(format: "%.0f", gaugeMinValue), attributes: stringAttrs);
		
		var attribStringSize = attribString.size()
		
		var startingPoint: CGPoint
		
		if (vertical)
			{
			startingPoint = CGPoint(x: gaugeRect.origin.x + gaugeRect.width + gaugeInset, y: gaugeRect.origin.y + gaugeRect.height - attribStringSize.height)
			}
		else
			{
			startingPoint = CGPoint(x: gaugeRect.origin.x, y: gaugeRect.origin.y + gaugeRect.height)
			}
		
		attribString.drawAtPoint(startingPoint);
		
		attribString = NSAttributedString(string: String(format: "%.0f", gaugeMaxValue), attributes: stringAttrs);
		
		attribStringSize = attribString.size()
		
		if (vertical)
			{
			startingPoint = CGPoint(x: gaugeRect.origin.x + gaugeRect.width + gaugeInset, y: gaugeRect.origin.y)
			}
		else
			{
			startingPoint = CGPoint(x: gaugeRect.origin.x + gaugeRect.width - attribStringSize.width, y: gaugeRect.origin.y + gaugeRect.height)
			}
		
		attribString.drawAtPoint(startingPoint);
		}
	
	private func drawValueText (context:CGContextRef, gaugeRect: CGRect) -> CGRect
		{
		var resizedFontReturn: (resizedFont: UIFont, fontFitsNow: Bool)
		var stringAttrs: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName : gaugeValueFont, NSForegroundColorAttributeName : gaugeFilledColor])
		var attribString: NSAttributedString = NSAttributedString(string: String(format: "%.2f", gaugeValue), attributes: stringAttrs)
		
		var attribStringSize = attribString.size()
		
		var startingPoint: CGPoint
		
		if (vertical)
			{
			startingPoint = CGPoint(x: gaugeRect.origin.x + gaugeRect.width + gaugeInset, y: gaugeRect.origin.y + (gaugeRect.height / 2) - attribStringSize.height)
			resizedFontReturn = sizeFontToFitInWidth(gaugeValueFont, largestNumber: gaugeMaxValue, rectToFitIn: self.bounds, startingPoint: startingPoint)
			}
		else
			{
			startingPoint = CGPoint(x: gaugeRect.origin.x + (gaugeRect.width / 2) - (attribStringSize.width / 2), y: gaugeRect.origin.y + gaugeRect.height)
			resizedFontReturn = sizeFontToFitInHeight(gaugeValueFont, largestNumber: gaugeMaxValue, rectToFitIn: self.bounds, startingPoint: startingPoint)
			}
			
		stringAttrs = NSDictionary(dictionary: [NSFontAttributeName : resizedFontReturn.resizedFont, NSForegroundColorAttributeName : gaugeFilledColor])
		attribString = NSAttributedString(string: String(format: "%.2f", gaugeValue), attributes: stringAttrs)
		attribStringSize = attribString.size()
		attribString.drawAtPoint(startingPoint)
		
		return CGRect(origin: startingPoint, size: attribStringSize)
		}
	
	func sizeFontToFitInHeight(font: UIFont, largestNumber: Float, rectToFitIn: CGRect, startingPoint: CGPoint) -> (resizedFont: UIFont, fontFitsNow: Bool)
	{
		var resizedFont: UIFont = font
		var stringAttrs: NSDictionary
		var attribString: NSAttributedString
		var attribStringSize: CGSize
		
		let startingSize:Int = Int(font.pointSize)
		
		for var index = startingSize; index > 10; index--
			{
			resizedFont = font.fontWithSize(CGFloat(index))
			stringAttrs = NSDictionary(dictionary: [NSFontAttributeName : resizedFont, NSForegroundColorAttributeName : gaugeFilledColor])
			attribString = NSAttributedString(string: String(format: "%.2f", largestNumber), attributes: stringAttrs)
			attribStringSize = attribString.size()
			
			if ((startingPoint.y + attribStringSize.height) < rectToFitIn.height)
				{
				return (resizedFont, true)
				}
			}
		
		return (resizedFont, false)
	}
	
	func sizeFontToFitInWidth(font: UIFont, largestNumber: Float, rectToFitIn: CGRect, startingPoint: CGPoint) -> (resizedFont: UIFont, fontFitsNow: Bool)
	{
		var resizedFont: UIFont = font
		var stringAttrs: NSDictionary
		var attribString: NSAttributedString
		var attribStringSize: CGSize
		
		let startingSize:Int = Int(font.pointSize)
		
		for var index = startingSize; index > 10; index--
			{
			resizedFont = font.fontWithSize(CGFloat(index))
			stringAttrs = NSDictionary(dictionary: [NSFontAttributeName : resizedFont, NSForegroundColorAttributeName : gaugeFilledColor])
			attribString = NSAttributedString(string: String(format: "%.2f", largestNumber), attributes: stringAttrs)
			attribStringSize = attribString.size()
			
			if ((startingPoint.x + attribStringSize.width) < rectToFitIn.width)
				{
				return (resizedFont, true)
				}
			}
		
		return (resizedFont, false)
	}
}
