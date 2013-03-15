//
//  CanvasView.m
//  Classifyr
//
//  Created by Sean Congden on 13/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "CanvasView.h"
#import "UMLConnection.h"
#import "GraphListener.h"

@implementation CanvasView

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.jpg"]];
        self.connections = [[NSMutableDictionary alloc] init];
        self.components = [[NSMutableDictionary alloc] init];
        self.nextLocalId = @1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] setStroke];
    
    // Draw all the bezier paths
    for (UMLConnection *connection in [self.connections allValues]) {
        [connection.path stroke];
    }
}

- (void)createConnectionWithStart:(UMLComponentView *)startComponent withEnd:(UMLComponentView *)endComponent
{
    NSString *id = [self.nextLocalId stringValue];
    self.nextLocalId = @([self.nextLocalId intValue] + 1);
    
    UMLConnection *connection = [self addConnectionWithId:id withStart:startComponent.id withEnd:endComponent.id];
    
    // Send the new connection to the server
    NSString *message = [NSString stringWithFormat:@"{\"type\": \"create-connection\", \"body\": {\"from\": \"%@\", \"to\": \"%@\"}}", connection.startComponent.id, connection.endComponent.id];
    
    GraphListener *server = [GraphListener mainGraphListener];
    [server sendMessage:message];
}

- (UMLConnection *)addConnectionWithId:(NSString *)id withStart:(NSString *)startId withEnd:(NSString *)endId
{
    UMLConnection *connection = [[UMLConnection alloc] init];
    connection.id = id;
    connection.startComponent = [_components objectForKey:startId];
    connection.endComponent = [_components objectForKey:endId];
    
    // Calculate and save the connection
    [connection calculatePath];
    [_connections setObject:connection forKey:connection.id];
    
    return connection;
}

- (void)createComponent:(UMLComponentView *)component
{
    NSString *x = [NSString stringWithFormat:@"{\"type\": \"create\", \"body\": {\"type\": \"box\", \"name\": \"%@\", \"location\": {\"x\": \"%f\", \"y\": \"%f\"}}}", component.name, component.center.x, component.center.y];
    
    //send message to the server
    GraphListener *del = [GraphListener mainGraphListener];
    [del sendMessage:x];
    del = nil;
}

- (void)addComponentWithId:(NSString *)id withComponent:(UMLComponentView *)component
{
    [self.components setObject:component forKey:id];
    [self addSubview:component];
}

- (void)moveComponent:(UMLComponentView *)component withPoint:(CGPoint)point
{
    NSString *x = [NSString stringWithFormat:@"{\"type\": \"move-box\", \"body\": {\"id\": \"%@\", \"location\": {\"x\": \"%f\", \"y\": \"%f\"}}}", component.id, point.x, point.y];
    
    //send message to the server
    GraphListener *del = [GraphListener mainGraphListener];
    [del sendMessage:x];
    del = nil;
}

- (UMLConnection *)connectionSelected:(CGPoint)touchLocation
{
    CGContextRef cgContext = CGBitmapContextCreate(nil, self.frame.size.width, self.frame.size.height, 8, 4 * self.frame.size.width, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);
    
    // Check each connection on the canvas
    for (UMLConnection *connection in [self.connections allValues]) {
        // Create a path thicker than the actual path for touch detection
        CGPathRef path = CGPathCreateCopyByStrokingPath(connection.path.CGPath, NULL, 50.0f, kCGLineCapButt, kCGLineJoinBevel, 0.0f);
        
        // Save the current graphics context so it can be restored and add the path
        CGContextSaveGState(cgContext);
        CGContextAddPath(cgContext, path);
        
        BOOL isHit = CGContextPathContainsPoint(cgContext, touchLocation, kCGPathFill);
        
        // Restore the graphics context
        CGContextRestoreGState(cgContext);
        
        if (isHit) {
            return connection;
        }
    }
    
    return nil;
}

@end
