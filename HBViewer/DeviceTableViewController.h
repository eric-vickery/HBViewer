//
//  DeviceTableViewController.h
//  HBViewer
//
//  Created by Eric Vickery on 10/27/14.
//  Copyright (c) 2014 Eric Vickery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBAdapterInterfaceDelegate.h"
#import "HBVersion.h"

@interface DeviceTableViewController : UITableViewController <HBAdapterInterfaceDelegate>
@property (nonatomic, strong) HBVersion *adapterVersion;
@property (nonatomic, strong) NSString *adapterName;

@end
