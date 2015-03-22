//
//  NEOColorPickerViewController.m
//
//  Created by Karthik Abram on 10/10/12.
//  Copyright (c) 2012 Neovera Inc.
//
//  Modified by Tony Nguyen Pham (softgaroo.com) Jan 2013

/*
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */


#import "NEOColorPickerHSLViewController.h"
#import "UIColor+NEOColor.h"
#import "NEOColorPickerGradientView.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorPreviewView.h"

#define CP_RESOURCE_CHECKERED_IMAGE		@"colorPicker.bundle/color-picker-checkered"
#define CP_RESOURCE_HUE_CIRCLE			@"colorPicker.bundle/color-picker-hue"
#define CP_RESOURCE_HUE_CROSSHAIR		@"colorPicker.bundle/color-picker-crosshair"

@interface NEOColorPickerHSLViewController() <NEOColorPickerGradientViewDelegate>
    @property CGFloat hue;
	@property CGFloat saturation;
	@property CGFloat luminosity;
	@property CGFloat alpha;
    @property ColorPreviewView* colorPreviewView;
@end

@implementation NEOColorPickerHSLViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    if (self.selectedColor == nil)
		{
        self.selectedColor = [UIColor redColor];
		}
    
    self.hueImageView.image = [UIImage imageNamed:CP_RESOURCE_HUE_CIRCLE];
    self.hueImageView.layer.zPosition = 10;
    self.labelPreview.layer.zPosition = 11;

	[self.selectedColorView setBackgroundColor: self.selectedColor];

    self.hueCrosshair.image = [UIImage imageNamed:CP_RESOURCE_HUE_CROSSHAIR];
    self.hueCrosshair.layer.zPosition = 15;
	
    self.gradientViewSaturation.delegate = self;
    self.gradientViewLuminosity.delegate = self;
    self.gradientViewAlpha.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:CP_RESOURCE_CHECKERED_IMAGE]];
    self.gradientViewAlpha.delegate = self;

    [[self.selectedColor neoToHSL] getHue:&_hue saturation:&_saturation brightness:&_luminosity alpha:&_alpha];
    if (self.disallowOpacitySelection)
		{
        self.alpha = 1.0;
        self.gradientViewAlpha.hidden = YES;
        self.buttonAlphaMax.hidden = YES;
        self.buttonAlphaMin.hidden = YES;
        self.labelTransparency.hidden = YES;
		}
    
    [self valuesChanged];
    
    // Position hue cross-hair.
    [self positionHue];
    
    self.hueImageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(huePanOrTap:)];
    [self.hueImageView addGestureRecognizer:panRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(huePanOrTap:)];
    [self.hueImageView addGestureRecognizer:tapRecognizer];
    
    [self setupButton:self.buttonSatMax withBundleImageIdx:BUNDLE_IMAGE_MAX];
    [self setupButton:self.buttonSatMin withBundleImageIdx:BUNDLE_IMAGE_MIN];

    [self setupButton:self.buttonLumMax withBundleImageIdx:BUNDLE_IMAGE_MAX];
    [self setupButton:self.buttonLumMin withBundleImageIdx:BUNDLE_IMAGE_MIN];

    [self setupButton:self.buttonAlphaMax withBundleImageIdx:BUNDLE_IMAGE_MAX];
    [self setupButton:self.buttonAlphaMin withBundleImageIdx:BUNDLE_IMAGE_MIN];

    [self adjustPanelPositionWithOrientation:[self isLandscape]];
}

- (void) viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self positionHue];
}

-(void) adjustPanelPositionWithOrientation:(BOOL)landscapeMode
{
}

- (void) positionHue
{
	CGFloat angle = 2 * M_PI * self.hue - M_PI;
	CGFloat radius = (self.hueImageView.bounds.size.width / 2) * 0.8;
	CGFloat centerX = self.hueImageView.frame.origin.x + (self.hueImageView.bounds.size.width / 2);
	CGFloat centerY = self.hueImageView.frame.origin.y + (self.hueImageView.bounds.size.height / 2);
	CGFloat crosshairMidX = self.hueCrosshair.bounds.size.width / 2;
	CGFloat crosshairMidY = self.hueCrosshair.bounds.size.height / 2;
	
	CGFloat cx = radius * cos(angle);
	CGFloat cy = radius * sin(angle);
	
    CGRect frame = self.hueCrosshair.frame;
    frame.origin.x = (centerX + cx) - crosshairMidX;
    frame.origin.y = (centerY + cy) - crosshairMidY;
    self.hueCrosshair.frame = frame;
	NSLog(@"Hue is %f and is positioned at x:%f y:%f", self.hue, frame.origin.x, frame.origin.y);
}

- (void) valuesChanged
{
    [self positionHue];
    
    self.gradientViewSaturation.color1 = [UIColor colorWithHue:_hue saturation:0 brightness:1.0 alpha:1.0];
    self.gradientViewSaturation.color2 = [UIColor colorWithHue:_hue saturation:1.0 brightness:1.0 alpha:1.0];
    self.gradientViewSaturation.value = _saturation;
    [self.gradientViewSaturation reloadGradient];
    [self.gradientViewSaturation setNeedsDisplay];
    
    self.gradientViewLuminosity.color1 = [UIColor colorWithHue:_hue saturation:_saturation brightness:0.0 alpha:1.0];
    self.gradientViewLuminosity.color2 = [UIColor colorWithHue:_hue saturation:_saturation brightness:1.0 alpha:1.0];
    self.gradientViewLuminosity.value = _luminosity;
    [self.gradientViewLuminosity reloadGradient];
    [self.gradientViewLuminosity setNeedsDisplay];
    
    self.gradientViewAlpha.color1 = [UIColor colorWithHue:_hue saturation:_saturation brightness:_luminosity alpha:0.0];
    self.gradientViewAlpha.color2 = [UIColor colorWithHue:_hue saturation:_saturation brightness:_luminosity alpha:1.0];
    self.gradientViewAlpha.value = _alpha;
    [self.gradientViewAlpha reloadGradient];
    [self.gradientViewAlpha setNeedsDisplay];
    
    self.selectedColor = [UIColor colorWithHue:_hue saturation:_saturation brightness:_luminosity alpha:_alpha];
	[self.selectedColorView setBackgroundColor: self.selectedColor];
	
    self.labelPreview.textColor = [[self.selectedColor neoComplementary] neoColorWithAlpha:1.0];
}

//- (void)viewDidUnload
//{
////    colorPreviewView = nil;
//    [self setNavigationBar:nil];
//    [self setHueCrosshair:nil];
//    [self setGradientViewSaturation:nil];
//    [self setGradientViewLuminosity:nil];
//    [self setGradientViewAlpha:nil];
//    [self setButtonSatMin:nil];
//    [self setButtonSatMax:nil];
//    [self setButtonLumMax:nil];
//    [self setButtonAlphaMax:nil];
//    [self setButtonAlphaMin:nil];
//    [self setButtonAlphaMin:nil];
//    [self setButtonLumMin:nil];
//    [self setLabelTransparency:nil];
//    [self setLabelPreview:nil];
//    [self setHueLabel:nil];
//    [super viewDidUnload];
//}

- (void) huePanOrTap:(UIGestureRecognizer *)recognizer
{
	CGPoint point = [recognizer locationInView:self.hueImageView];
	CGFloat dx = point.x - self.hueImageView.bounds.size.width / 2;
	CGFloat dy = point.y - self.hueImageView.bounds.size.height / 2;
	CGFloat angle = atan2f(dy, dx);
	
    switch (recognizer.state)
		{
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
            if (dy != 0)
				{
                angle += M_PI;
                self.hue = angle / (2 * M_PI);
				}
			else if (dx > 0)
				{
                self.hue = 0.5;
				}
            [self valuesChanged];
            break;

        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            break;

        default:
            // Canceled or error state.
            break;
		}
}

- (void)colorPickerGradientView:(NEOColorPickerGradientView *)view valueChanged:(CGFloat)value
{
    if (view == self.gradientViewSaturation)
		{
        self.saturation = value;
		}
	else if (view == self.gradientViewLuminosity)
		{
        self.luminosity = value;
		}
	else
		{
        self.alpha = value;
		}
    [self valuesChanged];
}

- (IBAction)buttonPressMaxMin:(id)sender
{
    if (sender == self.buttonSatMax)
		{
        self.saturation = 1.0;
		}
	else if (sender == self.buttonSatMin)
		{
        self.saturation = 0.0;
		}
	else if (sender == self.buttonLumMax)
		{
        self.luminosity = 1.0;
		}
	else if (sender == self.buttonLumMin)
		{
        self.luminosity = 0.0;
		}
	else if (sender == self.buttonAlphaMax)
		{
        self.alpha = 1.0;
		}
	else if (sender == self.buttonAlphaMin)
		{
        self.alpha = 0.0;
		}
    [self valuesChanged];
}

@end