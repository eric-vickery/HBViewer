//
//  NEOColorPickerFavoritesViewController.m
//
//  Created by Karthik Abram on 10/24/12.
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

#import "NEOColorPickerFavoritesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorPreviewView.h"

#define COLOR_LAYER_GAP 6

@interface NEOColorPickerFavoritesViewController () <UIScrollViewDelegate>
@property NSMutableArray* colorArray;
@property int colorPerPage;

@end

@implementation NEOColorPickerFavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
		{
        // Custom initialization
		}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setupButton:self.clearAllButton withBundleImageIdx:BUNDLE_IMAGE_CLEANER];

    self.colorPerPage = 32;
    self.colorArray = [NSMutableArray array];
    NSOrderedSet *colors = [NEOColorPickerFavoritesManager instance].favoriteColors;
    int count = (int)[colors count];
    for (int i = 0; i < count; i++)
		{
        ColorPreviewView* preview = [[ColorPreviewView alloc] initWithFrame:CGRectZero
                                                                      color:[colors objectAtIndex:i]
                                                                     shadow:YES];
        [self.scrollView addSubview:preview];
        [self.colorArray addObject:preview];
		}

    self.scrollView.delegate = self;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorGridTapped:)];
    [self.scrollView addGestureRecognizer:recognizer];
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

//- (void)viewDidUnload
//{
//    [self setScrollView:nil];
//    [self setPageControl:nil];
//    [self setClearAllButton:nil];
//    [super viewDidUnload];
//}

- (void) colorGridTapped:(UITapGestureRecognizer *)recognizer
{
	CGPoint point = [recognizer locationInView:self.scrollView];
	UIView *colorView = [self.scrollView hitTest:point withEvent:nil];
	
	self.selectedColor = colorView.backgroundColor;
	[self updateSelectedColor];
}

- (void) updateSelectedColor
{
	[self.selectedColorPreviewView setBackgroundColor: self.selectedColor];
}

- (IBAction)pageValueChange:(id)sender
{
    int screenWidth = [self getScreenWidth];
    [self.scrollView scrollRectToVisible:CGRectMake(self.pageControl.currentPage * screenWidth, 0,
                                                    self.scrollView.bounds.size.width,
                                                    self.scrollView.bounds.size.height)
								animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int screenWidth = [self getScreenWidth];
    self.pageControl.currentPage = scrollView.contentOffset.x / screenWidth;
}

//-(void)saveButtonPressed;
//{
//    [super saveButtonPressed];
//    [self.navigationController popViewControllerAnimated:YES];
//}

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
    int i = 0;
    
    for(ColorPreviewView* colorView in self.colorArray)
		{
		int page = i / self.colorPerPage;
		int x = i % self.colorPerPage;
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
		colorView.frame = CGRectMake((page * screenWidth) + (column * (colorRect.width + COLOR_LAYER_GAP)), row * (colorRect.height + COLOR_LAYER_GAP), colorRect.width, colorRect.height);
        i++;
		}
    
    int count = (int)[self.colorArray count];
    int pages = (count - 1) / self.colorPerPage + 1;
    self.pageControl.numberOfPages = pages;
    self.scrollView.contentSize = CGSizeMake(pages * screenWidth, self.scrollView.bounds.size.height);
}

- (IBAction)toucheDownClearButton:(id)sender
{
    if ([self.colorArray count]>0)
		{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete all favorite colors"
                                                        message:@"Are you sure to delete all the favorites?"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Cancel", nil];
        [alert show];
		}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) //OK buttons
		{
        for(ColorPreviewView* colorView in self.colorArray)
			{
            [colorView removeFromSuperview];
			}
        [self.colorArray removeAllObjects];

        [[NEOColorPickerFavoritesManager instance] clearAllFavoriteColors];

        [self adjustPanelPositionWithOrientation:[self isLandscape]];
		}
}

@end
