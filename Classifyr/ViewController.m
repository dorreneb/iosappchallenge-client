//
//  ViewController.m
//  Classifyr
//
//  Created by Sean Congden on 8/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "ViewController.h"
#import "ConnectionDelegate.h"

@interface ViewController () <UITextViewDelegate>
@end

@implementation ViewController {
    __strong ConnectionDelegate *_web;
    NSMutableArray *_messages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _web = [[ConnectionDelegate alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinButtonPressed:(id)sender
{
    [_web startServer];
    //[self performSegueWithIdentifier:@"canvasSegue" sender:nil];
}

- (IBAction)disconnectAll:(id)sender {
    [_web stopServer];
}

@end
