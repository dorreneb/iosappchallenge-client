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
    
    CGPoint startPoint = [self intersectionOfRect:self.endComponent.frame andLineWithStart:self.startComponent.center withEnd:self.endComponent.center];
    CGPoint endPoint = [self intersectionOfRect:self.startComponent.frame andLineWithStart:self.endComponent.center withEnd:self.startComponent.center];
    
    [self.path moveToPoint:startPoint];
    [self.path addLineToPoint:endPoint];
    [self.path closePath];
    
    self.path.lineWidth = 3;
}

- (CGPoint)intersectionOfRect:(CGRect)bounds andLineWithStart:(CGPoint)startPoint withEnd:(CGPoint)endPoint
{
    float slope = (endPoint.y - startPoint.y)/(endPoint.x - startPoint.x);
    float b = endPoint.y - (endPoint.x * slope);
    
    float check1 = (slope * (bounds.size.width / 2.0f));
    if (((-bounds.size.height/2) <= check1) && (check1 <= bounds.size.height/2)) {
        if (endPoint.x > startPoint.x) {
            // left edge
            return CGPointMake(bounds.origin.x, slope * bounds.origin.x + b);
        } else {
            // right edge
            return CGPointMake(bounds.origin.x + bounds.size.width, slope * (bounds.origin.x + bounds.size.width) + b);
        }
    } else if (endPoint.y > startPoint.y) {
        // top edge
        return CGPointMake((bounds.origin.y - b) / slope, bounds.origin.y);
    } else {
        // bottom edge
        return CGPointMake(((bounds.origin.y + bounds.size.height) - b) / slope, bounds.origin.y + bounds.size.height);
    }
}

@end
