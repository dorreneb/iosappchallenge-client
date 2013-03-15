//
//  GraphListenerDelegate.m
//  Classifyr
//
//  Created by Dorrene Brown on 3/10/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "GraphListener.h"

typedef enum {
    RED = 0,
    BLUE,
    Green
} MessageTypes;

@implementation GraphListener

#pragma mark - GraphListenerMethods

SRWebSocket *graphSocket;
static dispatch_once_t graphGuarantee;
static GraphListener* instance;

+ (GraphListener *)mainGraphListener
{
    dispatch_once(&graphGuarantee, ^{
        instance = [[GraphListener alloc] init];
    });
    
    return instance;
}

-(void)openConnection:(NSString *)graphId {
    NSString *connectAddress = [NSString stringWithFormat:@"%@/%@", @"ws://jotspec.student.rit.edu:8080/graph", graphId];
    NSLog(@"graph connect url: %@", connectAddress);
    graphSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:connectAddress]]];
    graphSocket.delegate = self;
    [graphSocket open];
}

-(void)closeConnection {
    [graphSocket close];
}

-(void)sendMessage:(NSString *)message {
    NSString *message2 = [NSString stringWithFormat:@"%@", message];
    NSLog(@"Hello from sendmessage: %@", message2);
    [graphSocket send:message2];

}

#pragma mark - GraphListenerSRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Graph Listener Websocket Connected");
}

- (void)webSocket:(SRWebSocket *)socket didFailWithError:(NSError *)error;
{
    NSLog(@"Graph Listener Error: %@", error);
    socket = nil;
}

- (void)webSocket:(SRWebSocket *)socket didReceiveMessage:(id)message;
{
    NSLog(@"Graph Listener Received: \"%@\"", message);
    
    // convert the message to json
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    //get message type
    NSString* messageType = [json objectForKey:@"type"];
    
    //act based on the message type
    if ([messageType isEqualToString:@"init"]) {
        NSLog(@"Initialize board");
        if ([_delegate respondsToSelector:@selector(graphListener:initializeBoardWithJson:)]) {
            [_delegate graphListener:self initializeBoardWithJson:[json objectForKey:@"body"]];
        }
    } else if ([messageType isEqualToString:@"create-box"]) {
        NSLog(@"Create square");
        if ([_delegate respondsToSelector:@selector(graphListener:addComponentWithJson:)]) {
            [_delegate graphListener:self addComponentWithJson:[json objectForKey:@"body"]];
        }
    } else if ([messageType isEqualToString:@"create-connection"]) {
        NSLog(@"Create connection");
        if ([_delegate respondsToSelector:@selector(graphListener:addConnectionWithJson:)]) {
            [_delegate graphListener:self addConnectionWithJson:[json objectForKey:@"body"]];
        }
    } else if ([messageType isEqualToString:@"rename-box"]) {
        if ([_delegate respondsToSelector:@selector(graphListener:addConnectionWithJson:)]) {
            [_delegate graphListener:self updateClass:[json objectForKey:@"body"]];
        }
    } else if ([messageType isEqualToString:@"delete-box"]) {
        if ([_delegate respondsToSelector:@selector(graphListener:deleteClass:)]) {
            [_delegate graphListener:self deleteClass:[json objectForKey:@"id"]];
        }
    } else if ([messageType isEqualToString:@"move-box"]) {
        if ([_delegate respondsToSelector:@selector(graphListener:componentMoved:)]) {
            [_delegate graphListener:self componentMoved:[json objectForKey:@"body"]];
        }
    } else if (([messageType isEqualToString:@"delete-connection"])) {
        if ([_delegate respondsToSelector:@selector(graphListener:deleteConnection:)]) {
            [_delegate graphListener:self deleteConnection:[json objectForKey:@"id"]];
        }
    }
    
}

- (void)webSocket:(SRWebSocket *)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"Graph Listener WebSocket closed");
    socket = nil;
}

-(void)editClass:(NSString*)newName classId:(id)classId
{
    NSString *jsonString = [NSString stringWithFormat:@"{\"type\": \"rename-box\", \"body\": {\"id\": \"%@\", \"name\": \"%@\"}};", classId, newName];
    NSLog(@"about to send %@", jsonString);
    [graphSocket send:jsonString];
}

-(void)deleteClass:(id)classId
{
    NSString *jsonScreen = [NSString stringWithFormat:@"{\"type\":\"delete-box\",\"id\":\"%@\"}", classId];
    [graphSocket send:jsonScreen];
    //make json
    NSLog(@"from listener %@", classId);
}

@end

