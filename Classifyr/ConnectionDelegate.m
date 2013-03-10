//
//  ConnectionDelegate.m
//  Classifyr
//
//  Created by Dorrene Brown on 3/9/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "ConnectionDelegate.h"
#import <SRWebSocket.h>

@interface ConnectionDelegate() <SRWebSocketDelegate>
@end

@implementation ConnectionDelegate {

}

#pragma mark - public accessors

SRWebSocket *_webSocket;
static dispatch_once_t guarantee;
static ConnectionDelegate* instance;

+ (ConnectionDelegate *)mainConnectionDelegate
{
    dispatch_once(&guarantee, ^{
        instance = [[ConnectionDelegate alloc] init];
    });
    
    return instance;
}

-(void) startServer {
    NSString *connectAddress = @"ws://jotspec.student.rit.edu:8080/create-session";
    
    NSLog(@"Initializing Server");
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:connectAddress]]];
    _webSocket.delegate = self;
    NSLog(@"Checking Connection...");
    [_webSocket open];
    
}

-(void) closeConnection {
    NSLog(@"Stopping Server...");
    [_webSocket close];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
}

- (void)webSocket:(SRWebSocket *)socket didFailWithError:(NSError *)error;
{
    NSLog(@"%@", error);
    socket = nil;
}

- (void)webSocket:(SRWebSocket *)socket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
    NSLog(@"Open graph listener here");
    [self closeConnection];
}

- (void)webSocket:(SRWebSocket *)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    socket = nil;
}



@end
