//
//  NEOColorPickerBaseViewController.h
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


enum BundleImageIdx
{
    BUNDLE_IMAGE_HUE,
    BUNDLE_IMAGE_FAVORITE_ADD,
    BUNDLE_IMAGE_FAVORITE_PICKER,
    BUNDLE_IMAGE_GRID,
    BUNDLE_IMAGE_CLEANER,
    BUNDLE_IMAGE_MAX,
    BUNDLE_IMAGE_MIN
};

#define SELECTED_COLOR_BOX_FRAME    CGRectMake(130, 6, 100, 40)


@class NEOColorPickerBaseViewController;

@protocol NEOColorPickerViewControllerDelegate <NSObject>

@required
- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didSelectColor:(UIColor *)color;
@optional
- (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller;

@end


//#define NEOColorPicker4InchDisplay()  ([UIScreen mainScreen].bounds.size.height == 568)


@interface NEOColorPickerFavoritesManager : NSObject

@property (readonly, nonatomic, strong) NSOrderedSet *favoriteColors;

+ (NEOColorPickerFavoritesManager *) instance;

- (void) addFavorite:(UIColor *)color;
-(void) clearAllFavoriteColors;


@end


@interface NEOColorPickerBaseViewController : UIViewController

@property (nonatomic, weak) id <NEOColorPickerViewControllerDelegate> delegate;

// Title to give the modal view.
@property (nonatomic, strong) NSString *dialogTitle;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) BOOL disallowOpacitySelection;

@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;

-(void)setupShadow:(CALayer *)layer;

-(void)saveButtonPressed;
-(void)adjustPanelPositionWithOrientation:(BOOL)landscapeMode;
-(BOOL)isLandscape;
-(int)getScreenWidth;
-(void)setupButton:(UIButton*)button withBundleImageIdx:(int)bundleImageIdx;

@end
