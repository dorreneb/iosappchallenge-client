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
        
        if (connection.startArrowEnabled == YES)
            [connection.startArrowPath fill];
        if (connection.endArrowEnabled == YES)
            [connection.endArrowPath fill];
    }
}

- (void)createConnectionWithStart:(UMLComponentView *)startComponent withEnd:(UMLComponentView *)endComponent
{
    // Send the new connection to the server
    NSString *message = [NSString stringWithFormat:@"{\"type\": \"create-connection\", \"body\": {\"from\": \"%@\", \"to\": \"%@\"}}", startComponent.id, endComponent.id];
    
    GraphListener *server = [GraphListener mainGraphListener];
    [server sendMessage:message];
}

- (UMLConnection *)addConnectionWithId:(NSString *)id withStart:(NSString *)startId withEnd:(NSString *)endId withStartArrow:(BOOL)startArrow withEndArrow:(BOOL)endArrow
{
    UMLConnection *connection = [[UMLConnection alloc] init];
    connection.id = id;
    connection.startComponent = [_components objectForKey:startId];
    connection.endComponent = [_components objectForKey:endId];
    connection.startArrowEnabled = startArrow;
    connection.endArrowEnabled = endArrow;
    
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

- (void)deleteConnection:(UMLConnection *)connection
{
    NSString *x = [NSString stringWithFormat:@"{\"type\": \"delete-connection\", \"id\": \"%@\"}", connection.id];
    
    //send message to the server
    GraphListener *del = [GraphListener mainGraphListener];
    [del sendMessage:x];
    del = nil;
}

- (UMLConnection *)connectionSelected:(CGPoint)touchLocation
{
    CGContextRef cgContext = CGBitmapContextCreate(nil, (int)self.frame.size.width, (int)self.bounds.size.height, 8, 4 * (int)self.frame.size.width, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);
    
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

- (void)recalculateConnections
{
    for (UMLConnection *connection in self.connections.allValues) {
        [connection calculatePath];
    }
    
    [self setNeedsDisplay];
}

- (void)updateConnectionWithId:(NSString *)id startArrow:(BOOL)startArrow endArrow:(BOOL)endArrow
{
    UMLConnection *connection = [self.connections objectForKey:id];
    connection.startArrowEnabled = startArrow;
    connection.endArrowEnabled = endArrow;
    
    [connection calculatePath];
    [self setNeedsDisplay];
}

-(void)clearBoard {
    NSLog(@"Should clear board now");
    
    [self.connections removeAllObjects];
    for (UMLComponentView* comp in self.components.allValues)
    {
        [comp removeFromSuperview];
        
    }
    [self.components removeAllObjects];
    [self setNeedsDisplay];
}

@end
