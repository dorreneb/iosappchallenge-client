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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.jpg"]];
        self.connections = [[NSMutableDictionary alloc] init];
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
    
    UMLConnection *connection = [self addConnectionWithId:id withStart:startComponent withEnd:endComponent];
    
    // Send the new connection to the server
    NSString *message = [NSString stringWithFormat:@"{\"type\": \"create-connection\", \"body\": {\"from\": \"%@\", \"to\": \"%@\"}}", connection.startComponent.id, connection.endComponent.id];
    
    GraphListener *server = [GraphListener mainGraphListener];
    [server sendMessage:message];
}

- (UMLConnection *)addConnectionWithId:(NSString *)id withStart:(id)startComponent withEnd:(id)endComponent
{
    UMLConnection *connection = [[UMLConnection alloc] init];
    connection.startComponent = startComponent;
    connection.endComponent = endComponent;
    connection.id = id;
    [connection calculatePath];
    
    [self.connections setObject:connection forKey:connection.id];
    return connection;
}

@end
