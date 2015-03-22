//
//  HBVersion.h
//  HBTest
//
//  Created by Eric Vickery on 12/22/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBVersion : NSObject
@property (nonatomic, strong) NSNumber *lowVersion;
@property (nonatomic, strong) NSNumber *highVersion;

- (id) initWithHighVersion:(NSNumber *)highVersion LowVersion:(NSNumber *)lowVersion;
- (id) initWithString:(NSString *)versionString;
@end
