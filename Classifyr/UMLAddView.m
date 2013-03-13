//
//  UMLAddView.m
//  Classifyr
//
//  Created by Sean Congden on 12/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UMLAddView.h"

@implementation UMLAddView

+ (UMLAddView *)viewFromNib
{
    UMLAddView *view = nil;
    
    // I assume, that there is only one root view in interface file
    NSArray *loadedObjects = [[NSBundle mainBundle] loadNibNamed:@"UMLAddView" owner:nil options:nil];
    view = [loadedObjects lastObject];
    
    return view;
}

- (void)awakeFromNib
{
    // Set up component style
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
}

@end
