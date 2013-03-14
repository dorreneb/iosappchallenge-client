//
//  UMLConnection.m
//  Classifyr
//
//  Created by Sean Congden on 13/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "UMLConnection.h"

@implementation UMLConnection

- (id)init
{
    self = [super init];
    if (self) {
        self.path = [[UIBezierPath alloc] init];
    }
    return self;
}

- (void)calculatePath
{
    [self.path removeAllPoints];
    
    [self.path moveToPoint:self.startComponent.center];
    [self.path addLineToPoint:self.endComponent.center];
    [self.path closePath];
    
    self.path.lineWidth = 3;
}

@end
