//
//  NEOColorPickerViewController.m
//
//  Created by Karthik Abram on 10/23/12.
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

#import "NEOColorPickerViewController.h"
#import "NEOColorPickerHSLViewController.h"
#import "NEOColorPickerHueGridViewController.h"
#import "NEOColorPickerFavoritesViewController.h"
#import "UIColor+NEOColor.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorPreviewView.h"

#define COLOR_LAYER_GAP 6

@interface NEOColorPickerViewController ()
@property NSMutableArray* colorPreviewArray;
@property ColorPreviewView *animatedPreviewView;

@end

@implementation NEOColorPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
		{
		}
    return self;
}

-(void)createColors
{
    self.colorPreviewArray = [NSMutableArray array];
    
	int colorCount = 24;
    for (int i = 0; i < colorCount; i++)
		{
        UIColor *color = [UIColor colorWithHue:i / (float)colorCount
                                    saturation:1.0 brightness:1.0 alpha:1.0];
        [self createColorPreviewWithColor:color];
		}
    
    colorCount = 8;
    for (int i = 0; i < colorCount; i++)
		{
        UIColor *color = [UIColor colorWithWhite:i/(float)(colorCount - 1) alpha:1.0];
        [self createColorPreviewWithColor:color];
		}
}

-(void)createColorPreviewWithColor:(UIColor*)color
{
    ColorPreviewView* colorPreviewView = [[ColorPreviewView alloc] initWithFrame:CGRectZero
                                                                           color:color
                                                                          shadow:YES];
    
    [self.simpleColorGrid addSubview:colorPreviewView];
    [self.colorPreviewArray addObject:colorPreviewView];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    if (!self.selectedColor)
		{
        self.selectedColor = [UIColor blackColor];
		}
    
    [self setupButton:self.buttonHue withBundleImageIdx:BUNDLE_IMAGE_HUE];
    [self setupButton:self.buttonAddFavorite withBundleImageIdx:BUNDLE_IMAGE_FAVORITE_ADD];
    [self setupButton:self.buttonFavorites withBundleImageIdx:BUNDLE_IMAGE_FAVORITE_PICKER];
    [self setupButton:self.buttonHueGrid withBundleImageIdx:BUNDLE_IMAGE_GRID];
    
    /*
     * Selected color box
     */
    [self createColors];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorGridTapped:)];
    [self.simpleColorGrid addGestureRecognizer:recognizer];
}

- (void) viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	// Only do the layout after autolayout has run so that the simpleColorGrid is the correct size
	if (self.simpleColorGrid.bounds.size.width <= [UIScreen mainScreen].bounds.size.width)
		{
		[self adjustPanelPositionWithOrientation:[self isLandscape]];
		}
}

-(CGSize) colorRectSize: (BOOL)landscape
{
	float width;
	float height;
	int buttonsAcross;
	int buttonsDown;
	
	if (landscape)
		{
		// If landscape then we want to be 8 wide and 4 tall with a 3 point gap between the buttons
		buttonsAcross = 8;
		buttonsDown = 4;
		}
	else
		{
		// If portrait then we want to be 4 wide and 8 tall
		buttonsAcross = 4;
		buttonsDown = 8;
		}

	width = (self.simpleColorGrid.bounds.size.width / buttonsAcross) - COLOR_LAYER_GAP;
	height = (self.simpleColorGrid.bounds.size.height / buttonsDown) - COLOR_LAYER_GAP;
	
	return CGSizeMake(width, height);
}

-(void) adjustPanelPositionWithOrientation: (BOOL)landscapeMode
{
	CGSize colorRect = [self colorRectSize:landscapeMode];
    int count = (int)[self.colorPreviewArray count];
    for (int i = 0; i < count; i++)
		{
        ColorPreviewView* colorPreviewView = [self.colorPreviewArray objectAtIndex:i];
        
        int column, row;
        if (landscapeMode)
			{
            column = i / 4;
            row = i % 4;
			}
		else
			{
            column = i % 4;
            row = i / 4;
			}
		colorPreviewView.frame = CGRectMake(column * (colorRect.width + COLOR_LAYER_GAP), row * (colorRect.height + COLOR_LAYER_GAP), colorRect.width, colorRect.height);
		}
}

//- (void)viewDidUnload
//{
//    [self setNavigationBar:nil];
//    [self setSimpleColorGrid:nil];
//    [self setButtonHue:nil];
//    [self setButtonAddFavorite:nil];
//    [self setButtonFavorites:nil];
//    [self setButtonHueGrid:nil];
//    [super viewDidUnload];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateSelectedColor];
}

- (void) updateSelectedColor
{
    [self.currentColorView setBackgroundColor: self.selectedColor];
}

- (void) colorGridTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.simpleColorGrid];
	UIView *colorView = [self.simpleColorGrid hitTest:point withEvent:nil];
	
	self.selectedColor = colorView.backgroundColor;
	[self updateSelectedColor];
}

- (IBAction)buttonPressCancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(colorPickerViewControllerDidCancel:)])
		{
        [self.delegate colorPickerViewControllerDidCancel:self];
		}
	else
		{
        [self dismissViewControllerAnimated:YES completion:nil];
		}
}

- (IBAction)buttonPressHue:(id)sender
{
	UIStoryboard *colorPickerStoryboard = [UIStoryboard storyboardWithName:@"ColorPicker" bundle: nil];
	
	NEOColorPickerHSLViewController *controller = [colorPickerStoryboard instantiateViewControllerWithIdentifier:@"HSL View"];
	controller.delegate = self;
	controller.disallowOpacitySelection = self.disallowOpacitySelection;
	controller.selectedColor = self.selectedColor;
	controller.disallowOpacitySelection = YES;
	controller.title = self.title;
	
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color
{
    if (self.disallowOpacitySelection && [color neoAlpha] != 1.0)
		{
        self.selectedColor = [color neoColorWithAlpha:1.0];
		}
	else
		{
        self.selectedColor = color;
		}
    [self updateSelectedColor];
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonPressHueGrid:(id)sender
{
	UIStoryboard *colorPickerStoryboard = [UIStoryboard storyboardWithName:@"ColorPicker" bundle: nil];
	
	NEOColorPickerHueGridViewController *controller = [colorPickerStoryboard instantiateViewControllerWithIdentifier:@"Hue Grid View"];
	controller.delegate = self;
	controller.selectedColor = self.selectedColor;
	controller.title = self.title;
	
	[self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)buttonPressAddFavorite:(id)sender
{
    [[NEOColorPickerFavoritesManager instance] addFavorite:self.selectedColor];
    
	// Make a copy of our current ColorView for the animation
	self.animatedPreviewView = [[ColorPreviewView alloc] initWithFrame:self.currentColorView.frame color: [self.currentColorView getDisplayColor] shadow:self.currentColorView.shadow];
	[self.view addSubview: self.animatedPreviewView];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                        self.animatedPreviewView.frame = self.buttonFavorites.frame;
						}
                     completion:^(BOOL finished)
					 {
                        [self.animatedPreviewView removeFromSuperview];
                        self.animatedPreviewView = nil;
                     }];
}

- (IBAction)buttonPressFavorites:(id)sender
{
	UIStoryboard *colorPickerStoryboard = [UIStoryboard storyboardWithName:@"ColorPicker" bundle: nil];
	
	NEOColorPickerHueGridViewController *controller = [colorPickerStoryboard instantiateViewControllerWithIdentifier:@"Favorites View"];
	controller.delegate = self;
	controller.selectedColor = self.selectedColor;
	controller.title = @"Favorites";
	
	[self.navigationController pushViewController:controller animated:YES];
}

@end
