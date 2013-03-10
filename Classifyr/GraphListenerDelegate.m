//
//  GraphListenerDelegate.m
//  Classifyr
//
//  Created by Dorrene Brown on 3/10/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "GraphListenerDelegate.h"

@interface GraphListenerDelegate() <SRWebSocketDelegate>
@end

@implementation GraphListenerDelegate {
    
}

#pragma mark - GraphListenerMethods
SRWebSocket *_webSocket;
static dispatch_once_t graphGuarantee;
static GraphListenerDelegate* instance;

+ (GraphListenerDelegate *)mainGraphListenerDelegate
{
    dispatch_once(&graphGuarantee, ^{
        instance = [[GraphListenerDelegate alloc] init];
    });
    
    return instance;
}

-(void)sendMessage:(NSString *)message {
    NSLog(@"Hello from sendmessage");
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
}

- (void)webSocket:(SRWebSocket *)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"Graph Listener WebSocket closed");
    socket = nil;
}



@end

