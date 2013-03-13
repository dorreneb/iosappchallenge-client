//
//  ViewController.m
//  Classifyr
//
//  Created by Sean Congden on 8/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "ViewController.h"
#import "ConnectionDelegate.h"
#import "SelectSessionController.h"

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
    [self performSegueWithIdentifier:@"canvasSegue" sender:sender];
}

- (IBAction)getExistingSpecs:(id)sender {
    NSArray *sessions = [_web startConnection];
    NSLog(@"From view controller: %@", sessions);
    [_web closeConnection];
    
    //pull out session names into an array
    [self performSegueWithIdentifier:@"selectSession" sender:sessions];
}

- (IBAction)createNewSpec:(id)sender {
    ConnectionDelegate *newSpec = [[ConnectionDelegate alloc] init];
    [newSpec startNewGraph];
    
    [self performSegueWithIdentifier:@"canvasSegue" sender:nil];
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
