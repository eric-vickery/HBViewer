//
//  CommonDeviceDetailsViewController.h
//  HBTest
//
//  Created by Eric Vickery on 12/27/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBBaseDevice.h"

@interface CommonDeviceDetailsViewController : UIViewController <UIPopoverPresentationControllerDelegate>
@property (nonatomic, weak) HBBaseDevice *device;
@end
