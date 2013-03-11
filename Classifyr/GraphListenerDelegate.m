//
//  GraphListenerDelegate.m
//  Classifyr
//
//  Created by Dorrene Brown on 3/10/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "GraphListenerDelegate.h"

typedef enum{
    RED = 0,
    BLUE,
    Green
} MessageTypes;

@interface GraphListenerDelegate() <SRWebSocketDelegate>
@end

@implementation GraphListenerDelegate {
    
}

#pragma mark - GraphListenerMethods
SRWebSocket *graphSocket;
static dispatch_once_t graphGuarantee;
static GraphListenerDelegate* instance;

+ (GraphListenerDelegate *)mainGraphListenerDelegate
{
    dispatch_once(&graphGuarantee, ^{
        instance = [[GraphListenerDelegate alloc] init];
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
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    //get message type
    NSString* latestLoans = [json objectForKey:@"type"];
    
    //act based on the message type
    if ([latestLoans isEqualToString:@"init"]) {
        NSLog(@"Initialize board");
    } else if ([latestLoans isEqualToString:@"create"]) {
        NSLog(@"Create square");
    }
    
}

- (void)webSocket:(SRWebSocket *)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"Graph Listener WebSocket closed");
    socket = nil;
}





@end

