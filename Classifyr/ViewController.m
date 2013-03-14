//
//  ViewController.m
//  Classifyr
//
//  Created by Sean Congden on 8/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "ViewController.h"
#import "ServerConnection.h"
#import "SelectSessionController.h"
#import "GraphListener.h"

@interface ViewController () <UITextViewDelegate>
@end

@implementation ViewController {
    __strong ServerConnection *_web;
    NSMutableArray *_messages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.navigationController.navigationBarHidden = YES;
    
    _web = [[ServerConnection alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getExistingSpecs:(id)sender {
    NSArray *sessions = [_web startConnection];
    NSLog(@"From view controller: %@", sessions);
    [_web closeConnection];
    
    //pull out session names into an array
    [self performSegueWithIdentifier:@"selectSession" sender:sessions];
}

- (IBAction)createNewSpec:(id)sender {
    [self performSegueWithIdentifier:@"newSpecParams" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"selectSession"]) {
        NSLog(@"about to segue to table view");
        
        SelectSessionController *dest = (SelectSessionController *)[segue destinationViewController];
        dest.data = (NSArray*)sender;
        
        NSLog(@"%@", dest.data);
    }
}

@end
