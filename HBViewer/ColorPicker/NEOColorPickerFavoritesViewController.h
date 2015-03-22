//
//  NEOColorPickerFavoritesViewController.h
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

#import "NEOColorPickerBaseViewController.h"
#import "ColorPreviewView.h"

@interface NEOColorPickerFavoritesViewController : NEOColorPickerBaseViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet ColorPreviewView *selectedColorPreviewView;

- (IBAction)pageValueChange:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *clearAllButton;
- (IBAction)toucheDownClearButton:(id)sender;

@end
