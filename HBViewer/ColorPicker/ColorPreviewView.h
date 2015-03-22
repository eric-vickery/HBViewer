//
//  ColorPreviewView.h
//  CompositePhoto
//
//  Created by Nguyen Pham on 20/01/13.
//  Copyright (c) 2013 Nguyen Pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPreviewView : UIView

@property BOOL shadow;

-(id) initWithFrame:(CGRect)frame color:(UIColor*)color shadow:(BOOL)shadow;
-(void) setDisplayColor:(UIColor*)color;
-(UIColor*) getDisplayColor;

@end
