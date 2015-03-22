//
//  NEOColorPickerHueGridViewController.m
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

#import <QuartzCore/QuartzCore.h>
#import "NEOColorPickerHueGridViewController.h"
#import "ColorPreviewView.h"


@interface NEOColorPickerHueGridViewController () <UIScrollViewDelegate>
@property NSMutableArray* colorPreviewArray;
@property int colorCount;
@property int displayPage;

@end

#define COLOR_LAYER_GAP 6

@implementation NEOColorPickerHueGridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
		{
		}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createColors];
    
    self.colorBar.image = [UIImage imageNamed:@"colorPicker.bundle/color-bar"];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorGridTapped:)];
    [self.scrollView addGestureRecognizer:recognizer];
    
    self.colorBar.userInteractionEnabled = YES;
    UITapGestureRecognizer *barRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorBarTapped:)];
    [self.colorBar addGestureRecognizer:barRecognizer];
    
    self.displayPage = 0;
//    [self adjustPanelPositionWithOrientation:[self isLandscape]];
}

- (void) viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	// Only do the layout after autolayout has run so that the simpleColorGrid is the correct size
	if (self.scrollView.bounds.size.width <= [UIScreen mainScreen].bounds.size.width)
		{
		[self adjustPanelPositionWithOrientation:[self isLandscape]];
		}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self updateSelectedColor];
}

-(void)createColors
{
	self.colorPreviewArray = [NSMutableArray array];
	for (int i = 0 ; i < 12; i++)
		{
		CGFloat hue = i * 30 / 360.0;
		
		self.colorCount = 32;
		for (int x = 0; x < self.colorCount; x++)
			{
			int row = x / 4;
			int column = x % 4;
			
			CGFloat saturation = column * 0.25 + 0.25;
			CGFloat luminosity = 1.0 - row * 0.12;
			UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:luminosity alpha:1.0];
			[self createColorPreviewWithColor:color];
			}
		}
}

-(void)createColorPreviewWithColor:(UIColor*)color
{
	ColorPreviewView* colorPreviewView = [[ColorPreviewView alloc] initWithFrame:CGRectZero
																		   color:color
																		  shadow:YES];
	[self.scrollView addSubview:colorPreviewView];
	[self.colorPreviewArray addObject:colorPreviewView];
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
	
	width = (self.scrollView.bounds.size.width / buttonsAcross) - COLOR_LAYER_GAP;
	height = (self.scrollView.bounds.size.height / buttonsDown) - COLOR_LAYER_GAP;
	
	return CGSizeMake(width, height);
}

-(void) adjustPanelPositionWithOrientation:(BOOL)landscapeMode
{
	int screenWidth = [self getScreenWidth];
	CGSize colorRect = [self colorRectSize:landscapeMode];
	
	int count = (int)[self.colorPreviewArray count];

	self.scrollView.contentSize = CGSizeMake(screenWidth * 12, self.scrollView.bounds.size.height);

	for (int idx = 0; idx < count; idx++)
		{
		ColorPreviewView *colorPreview = [self.colorPreviewArray objectAtIndex:idx];
		int page = idx / self.colorCount;
		int x = idx % self.colorCount;
		int column;
		int row;
		
		if (landscapeMode)
			{
			column = x / 4;
			row = x % 4;
			}
		else
			{
			column = x % 4;
			row = x / 4;
			}
		colorPreview.frame = CGRectMake((page * screenWidth) + (column * (colorRect.width + COLOR_LAYER_GAP)), row * (colorRect.height + COLOR_LAYER_GAP), colorRect.width, colorRect.height);
		}
	
	[self setWorkingPage: self.displayPage];
}

- (void) updateSelectedColor
{
	[self.selectedColorPreviewView setBackgroundColor: self.selectedColor];
}

- (void) colorGridTapped:(UITapGestureRecognizer *)recognizer
{
	CGPoint point = [recognizer locationInView:self.scrollView];
	UIView *colorView = [self.scrollView hitTest:point withEvent:nil];
	
	self.selectedColor = colorView.backgroundColor;
	[self updateSelectedColor];
//    CGPoint point = [recognizer locationInView:self.scrollView];
//    int screenWidth = [self getScreenWidth];
//    int page = point.x / screenWidth;
//    int delta = (int)point.x % screenWidth;
//    
//    int width = [self colorLayerWidth];
//    int row = (int)((point.y - 8) / 48);
//    int column = (int)((delta - 8) / (width + COLOR_LAYER_GAP));
//    int index;
//    if ([self isLandscape])
//		{
//        index = colorCount * page + row + column * 4;
//		}
//	else
//		{
//        index = colorCount * page + row * 4 + column;
//		}
//    self.selectedColor = [[colorPreviewArray objectAtIndex:index] getDisplayColor];
//    [selectedColorPreviewView setDisplayColor:self.selectedColor];
}

- (void) colorBarTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.colorBar];
    int btnWidth = self.colorBar.bounds.size.width / 12;
    int page = point.x / btnWidth;
    [self setWorkingPage:page];
}

-(void)setWorkingPage:(int)page
{
    self.displayPage = page;
    int screenWidth = [self getScreenWidth];
    [self.scrollView scrollRectToVisible:CGRectMake(page*screenWidth, 0,
                                                    self.scrollView.frame.size.width,
                                                    self.scrollView.frame.size.height) animated:YES];
}

//-(void)saveButtonPressed;
//{
//    [super saveButtonPressed];
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
