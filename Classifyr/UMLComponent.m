//
//  UMLComponent.m
//  Classifyr
//
//  Created by Sean Congden on 9/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "UMLComponent.h"

@implementation UMLComponent

- (id)initWithLocation:(CGPoint)location
{
    CGRect frame = CGRectMake(location.x, location.y, 70.0f, 50.0f);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

@end
