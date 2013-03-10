//
//  ViewController.m
//  Classifyr
//
//  Created by Sean Congden on 8/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "ViewController.h"
#import <SRWebSocket.h>

@interface ViewController () <SRWebSocketDelegate, UITextViewDelegate>
@end

@implementation ViewController {
    SRWebSocket *_webSocket;
    NSMutableArray *_messages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinButtonPressed:(id)sender
{
    NSLog(@"Initializing Server");
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://jotspec.student.rit.edu:8080/graph"]]];
    _webSocket.delegate = self;
    NSLog(@"Opening Connection...");
    [_webSocket open];
    NSLog(@"Return from open");
    //[self performSegueWithIdentifier:@"canvasSegue" sender:nil];
}



#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    self.title = @"Connected!";
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@"%@", error);
    
    self.title = @"Connection Failed! (see logs)";
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.title = @"Connection Closed! (see logs)";
    _webSocket = nil;
}

@end
