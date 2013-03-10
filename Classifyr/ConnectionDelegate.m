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
    
    NSLog(@"Initializing auth connection");
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:connectAddress]]];
    _webSocket.delegate = self;
    NSLog(@"Checking connection...");
    [_webSocket open];
    
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
    
    //parse json message
    NSError *jsonParsingError = nil;
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    NSString *sessionid;
    
    //graph listener delegate
    GraphListenerDelegate *graphListener;
    
    //parse message and if valid start the graph listener
    if (!jsonArray) {
        NSLog(@"Session auth error parsing JSON: %@", jsonParsingError);
    } else {
        [self closeConnection];
        sessionid = [jsonArray objectForKey:@"session-id"];
        
        if (sessionid != nil) {
            graphListener = [GraphListenerDelegate mainGraphListenerDelegate];
            [graphListener openConnection:sessionid];
        }
        
    } 
}

- (void)webSocket:(SRWebSocket *)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"Session auth WebSocket closed");
    socket = nil;
}



@end
