//
//  CanvasView.m
//  Classifyr
//
//  Created by Sean Congden on 9/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "CanvasView.h"
#import "ConnectionDelegate.h"

@implementation CanvasView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) addUMLComponent:(UMLComponent *)component
{
    [self addSubview:component];
    
    //ConnectionDelegate *del = [ConnectionDelegate mainConnectionDelegate];
    //[del sendMessage:@"df"];
}

@end
