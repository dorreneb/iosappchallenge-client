//
//  UMLConnection.m
//  Classifyr
//
//  Created by Sean Congden on 13/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <math.h>

#import "UMLConnection.h"

@implementation UMLConnection

- (id)init
{
    self = [super init];
    if (self) {
        self.path = [[UIBezierPath alloc] init];
        
        self.startArrow = [self makeArrow];
    }
    return self;
}

- (UIBezierPath *)makeArrow
{
    UIBezierPath *arrow = [[UIBezierPath alloc] init];
    [arrow moveToPoint:CGPointMake(0.0f, 0.0f)];
    [arrow addLineToPoint:CGPointMake(6.0f, 12.0f)];
    [arrow addLineToPoint:CGPointMake(-6.0f, 12.0f)];
    [arrow closePath];
    
    return arrow;
}

- (void)calculatePath
{
    [self.path removeAllPoints];
    
    // Calculate the start and end of the path
    CGPoint startPoint = [self intersectionOfRect:self.endComponent.frame andLineWithStart:self.startComponent.center withEnd:self.endComponent.center];
    CGPoint endPoint = [self intersectionOfRect:self.startComponent.frame andLineWithStart:self.endComponent.center withEnd:self.startComponent.center];
    
    // Set up the path
    [self.path moveToPoint:startPoint];
    [self.path addLineToPoint:endPoint];
    [self.path closePath];
    
    self.path.lineWidth = 3;
    
    // Move and rotate arrows
    if (self.startArrow != nil) {
        float theta = atan((endPoint.x - startPoint.x)/ (endPoint.y - startPoint.y));
        if (startPoint.y > endPoint.y) {
            theta += M_PI;
        }
        
        self.startArrow = [self makeArrow];
        [self.startArrow applyTransform: CGAffineTransformRotate(CGAffineTransformMakeTranslation(startPoint.x, startPoint.y), -theta)];
    }
    
    // Move and rotate arrows
    if (self.endArrow != nil) {
        float theta = atan((endPoint.x - startPoint.x)/ (endPoint.y - startPoint.y));
        if (startPoint.y < endPoint.y) {
            theta += M_PI;
        }
        
        self.endArrow = [self makeArrow];
        [self.endArrow applyTransform: CGAffineTransformRotate(CGAffineTransformMakeTranslation(endPoint.x, endPoint.y), -theta)];
    }
}

- (CGPoint)intersectionOfRect:(CGRect)bounds andLineWithStart:(CGPoint)startPoint withEnd:(CGPoint)endPoint
{
    float slope = (endPoint.y - startPoint.y) / (endPoint.x - startPoint.x);
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
