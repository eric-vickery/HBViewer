//
//  HBAdapterInterfaceDelegate.h
//  HBViewer
//
//  Created by Eric Vickery on 12/22/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import <Foundation/Foundation.h>

// Forward declaration
@class HBAdapterInterface;

@protocol HBAdapterInterfaceDelegate <NSObject>
- (void) couldNotFindAnAdapter;
- (void) couldNotLoadAdapter;
- (void) adapterConnected:(HBAdapterInterface *)adapter;
- (void) newDevicesDidAppear;
- (void) adapterDisconnected:(NSError *)error;
@end
