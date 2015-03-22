//
//  HBViewerSplitViewController.h
//  HBViewer
//
//  Created by Eric Vickery on 10/15/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBAdapterInterfaceDelegate.h"

@interface HBViewerSplitViewController : UISplitViewController <UISplitViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIBarButtonItem *splitViewButton;
@property UIPopoverController * splitPopover;

@end
