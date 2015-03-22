//
//  SimpleFlatRoundGaugeView.swift
//  DrawingTest
//
//  Created by Eric Vickery on 9/29/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

import UIKit
import GLKit

@IBDesignable class SimpleFlatRoundGaugeView: CustomGaugeBase
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
	
	@IBInspectable var centerColor: UIColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
		{
		didSet
			{
			setupView()
			}
		}
	
	@IBInspectable var gaugeInset: CGFloat = 10.0
		{
		didSet
			{
			setupView()
			}
		}
	
	@IBInspectable var gaugeBarWidth: CGFloat = CGFloat(40.0)
		{
		didSet
			{
			gaugeBarPercent = gaugeBarWidth / 100.0
			setupView()
			}
		}
	
	var gaugeBarPercent: CGFloat = 0.40
	
	@IBInspectable var centerSize: CGFloat = CGFloat(2.0)
		{
		didSet
			{
			setupView()
			}
		}
	
	@IBInspectable var gaugeStartAngle: Float = 90.0
		{
		didSet
			{
			setupView()
			}
		}
	
	@IBInspectable var gaugeEndAngle: Float = 270.0
		{
		didSet
			{
			setupView()
			}
		}
	
	override func drawRect(rect: CGRect)
		{
		let context:CGContextRef = UIGraphicsGetCurrentContext()
		
		var minDimension: CGFloat
		
		if (self.bounds.height > ((self.bounds.width / 2) + ((self.bounds.width / 2) * 0.15)))
			{
			minDimension = (self.bounds.width / 2.0) - gaugeInset
			}
		else
			{
			minDimension = self.bounds.height * 0.8
			}

//		let centerPoint: CGPoint = CGPoint(x: self.bounds.width / 2.0, y: minDimension + gaugeInset)
		let centerPoint: CGPoint = CGPoint(x: self.bounds.width / 2.0, y: (self.bounds.height / 2.0) + (minDimension * 0.4))
		
		// Draw the center dot
//		drawArc (context, centerPoint: centerPoint, radius: centerSize, lineColor: centerColor, lineWidth: 3.0, startingAngleInDegrees: 0, endingAngleInDegrees: 360)
		
		// Draw the main stripe of the dial
		drawArc (context, centerPoint: centerPoint, radius: minDimension, lineColor: gaugeEmptyColor, lineWidth: minDimension * gaugeBarPercent, startingAngleInDegrees: gaugeStartAngle, endingAngleInDegrees: gaugeEndAngle)
		
		// Draw the value stripe of the dial
		let totalScaleAngle = gaugeEndAngle - gaugeStartAngle
		let totalValueRange = gaugeMaxValue - gaugeMinValue
		let scaleAnglePerScaleValue = totalScaleAngle / totalValueRange
		let scaleValueEndAngle = gaugeStartAngle + (gaugeRelativeValue * scaleAnglePerScaleValue)
		
		drawArc (context, centerPoint: centerPoint, radius: minDimension, lineColor: gaugeFilledColor, lineWidth: minDimension * gaugeBarPercent, startingAngleInDegrees: gaugeStartAngle, endingAngleInDegrees: scaleValueEndAngle)
		
		// Now put on the text
		if (showScaleText)
			{
			drawUnitOfMeasureText(context, centerPoint: centerPoint)
			drawScaleText (context, centerPoint: centerPoint, radius: minDimension, gaugeWidth: minDimension * gaugeBarPercent)
			}
		drawValueText (context, centerPoint: centerPoint)
		}
	
	private func drawUnitOfMeasureText (context:CGContextRef, centerPoint: CGPoint) -> Void
		{
//		CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
		let stringAttrs: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName : unitOfMeasureFont, NSForegroundColorAttributeName : unitOfMeasureColor])
		let attribString: NSAttributedString = NSAttributedString(string: unitOfMeasure, attributes: stringAttrs);

		let attribStringSize = attribString.size()
		
		attribString.drawAtPoint(CGPointMake(centerPoint.x - (attribStringSize.width / 2.0), centerPoint.y));
		}

	private func drawScaleText (context:CGContextRef, centerPoint: CGPoint, radius: CGFloat, gaugeWidth: CGFloat) -> Void
		{
		let stringAttrs: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName : scaleFont, NSForegroundColorAttributeName : unitOfMeasureColor])
		var attribString: NSAttributedString = NSAttributedString(string: String(format: "%.0f", gaugeMinValue), attributes: stringAttrs);
		
		var attribStringSize = attribString.size()
		var x = centerPoint.x - ((radius - (gaugeWidth / 2)) + (attribStringSize.width / 2))
		attribString.drawAtPoint(CGPointMake(x, centerPoint.y));

		attribString = NSAttributedString(string: String(format: "%.0f", gaugeMaxValue), attributes: stringAttrs);
		
		attribStringSize = attribString.size()
		x = centerPoint.x + ((radius - (gaugeWidth / 2)) - (attribStringSize.width / 2))
		attribString.drawAtPoint(CGPointMake(x, centerPoint.y));
		}

	private func drawValueText (context:CGContextRef, centerPoint: CGPoint) -> Void
		{
		let stringAttrs: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName : gaugeValueFont, NSForegroundColorAttributeName : gaugeFilledColor])
		let attribString: NSAttributedString = NSAttributedString(string: String(format: "%.2f", gaugeValue), attributes: stringAttrs);
		
		let attribStringSize = attribString.size()
		
		attribString.drawAtPoint(CGPointMake(centerPoint.x - (attribStringSize.width / 2.0), centerPoint.y - attribStringSize.height));
		}
}
