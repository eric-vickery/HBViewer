//
//  ConfigViewController.h
//  HBViewer
//
//  Created by Eric Vickery on 10/8/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEOColorPickerViewController.h"

@interface ConfigViewController : UITableViewController <NEOColorPickerViewControllerDelegate>
@property (nonatomic, strong) NSNumber *adapterType;
@property (nonatomic, strong) UIColor *emptyColor;
@property (nonatomic, strong) UIColor *filledColor;
@property (nonatomic, strong) NSNumber *previousAdapterType;
@property (nonatomic, strong) UIColor *previousEmptyColor;
@property (nonatomic, strong) UIColor *previousFilledColor;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)demoEthernetSwitchChanged:(id)sender;
- (IBAction)gaugeEmptyButtonPressed:(id)sender;
- (IBAction)gaugeFilledButtonPressed:(id)sender;

@end
