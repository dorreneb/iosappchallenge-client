//
//  ConnectionDelegate.m
//  Classifyr
//
//  Created by Dorrene Brown on 3/9/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "ConnectionDelegate.h"
#import <SRWebSocket.h>
#import "GraphListenerDelegate.h"

@interface ConnectionDelegate() <SRWebSocketDelegate>
@end

@implementation ConnectionDelegate {

}

#pragma mark - public accessors

SRWebSocket *_webSocket;
NSArray *allSessions;
NSString *specID;

-(void) startSessionConnection {
    NSString *connectAddress = @"ws://jotspec.student.rit.edu:8080/sessions";
    
    NSLog(@"Initializing auth connection");
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:connectAddress]]];
    _webSocket.delegate = self;
    NSLog(@"Checking connection...");
    [_webSocket open];

}

-(NSArray*) startConnection {
    [self startSessionConnection];
    CFRunLoopRun();
    return allSessions;
}

-(void) closeConnection {
    NSLog(@"Stopping auth connection...");
    [_webSocket close];
}

-(NSString*) startNewGraph:name {
    [self startSessionConnection];
    CFRunLoopRun();
    NSString *x = [NSString stringWithFormat:@"{\"type\": \"create\", \"spec-name\": \"%@\"}", name];
    [_webSocket send:x];
    CFRunLoopRun();
    NSLog(@"end of start new graph");
    return specID;
    
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
    
    // get type of message
    NSString *messageType = [json objectForKey:@"type"];
    
    if ([messageType isEqualToString:@"session-listing"]) {
        //get list of specs
        allSessions = [json objectForKey:@"sessions"];
    } else if ([messageType isEqualToString:@"new-spec"]) {
        specID = [json objectForKey:@"session-id"];
    }
    NSLog(@"%@", specID);
    CFRunLoopStop(CFRunLoopGetMain());
}

- (void)webSocket:(SRWebSocket *)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"Session auth WebSocket closed");
    socket = nil;
}



@end
