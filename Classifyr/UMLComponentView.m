//
//  UMLComponentView.m
//  Classifyr
//
//  Created by Sean Congden on 11/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UMLComponentView.h"

@implementation UMLComponentView

+ (UMLComponentView *)viewFromNib
{
    UMLComponentView *view = nil;
    
    // I assume, that there is only one root view in interface file
    NSArray *loadedObjects = [[NSBundle mainBundle] loadNibNamed:@"UMLComponentView" owner:nil options:nil];
    view = [loadedObjects lastObject];
    
    return view;
}

- (void)awakeFromNib
{
    // Set up component style
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2.0f;
}

@end
