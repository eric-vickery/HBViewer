//
//  HBVersion.m
//  HBTest
//
//  Created by Eric Vickery on 12/22/13.
//  Copyright (c) 2013 Eric Vickery. All rights reserved.
//

#import "HBVersion.h"

@implementation HBVersion
- (id) initWithHighVersion:(NSNumber *)highVersion LowVersion:(NSNumber *)lowVersion
{
	if ((self = [super init]))
		{
		self.highVersion = highVersion;
		self.lowVersion = lowVersion;
		}
	
	return self;
}

- (id) initWithString:(NSString *)versionString
{
	if ((self = [super init]))
		{
		// Parse the version from the string
		NSRange range = [versionString rangeOfString:@"."];
		if (range.location != NSNotFound)
			{
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			
			self.highVersion = [formatter numberFromString:[versionString substringToIndex:range.location]];
			self.lowVersion = [formatter numberFromString:[versionString substringWithRange:NSMakeRange(range.location+1, versionString.length-2 - (range.location+1))]];
			}
		else
			{
			self.highVersion = 0;
			self.lowVersion = 0;
			}
		}
	
	return self;
}

- (NSString *) description
{
	return [NSString stringWithFormat:@"%@.%@", self.highVersion, self.lowVersion];
}

@end
