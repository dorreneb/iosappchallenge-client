//
//  ConnectionDelegate.m
//  Classifyr
//
//  Created by Dorrene Brown on 3/9/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "ServerConnection.h"
#import "GraphListener.h"

@implementation ServerConnection

#pragma mark - public accessors

SRWebSocket *_webSocket;
NSArray *allSessions;

-(NSArray*) startConnection {
    NSString *connectAddress = @"ws://jotspec.student.rit.edu:8080/sessions";
    
    NSLog(@"Initializing auth connection");
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:connectAddress]]];
    _webSocket.delegate = self;
    NSLog(@"Checking connection...");
    [_webSocket open];
    CFRunLoopRun();
    return allSessions;
}

-(void) closeConnection {
    NSLog(@"Stopping auth connection...");
    [_webSocket close];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Session auth websocket connected");
}

- (void)webSocket:(SRWebSocket *)socket didFailWithError:(NSError *)error;
{
    NSLog(@"Session auth error: %@", error);
    socket = nil;
}

- (void)webSocket:(SRWebSocket *)socket didReceiveMessage:(id)message;
{
    NSLog(@"Session auth received \"%@\"", message);
    
    // convert the message to json
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    //get message type
    allSessions = [json objectForKey:@"sessions"];
    
    CFRunLoopStop(CFRunLoopGetMain());
}

- (void)webSocket:(SRWebSocket *)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"Session auth WebSocket closed");
    socket = nil;
}



@end
