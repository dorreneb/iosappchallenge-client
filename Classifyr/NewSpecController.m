//
//  NewSpecController.m
//  Classifyr
//
//  Created by Dorrene Brown on 3/13/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "NewSpecController.h"
#import "ServerConnection.h"
#import "GraphListener.h"

@interface NewSpecController ()

@end

@implementation NewSpecController

@synthesize specNameField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)generateSpec:(id)sender {
    ServerConnection *newSpec = [[ServerConnection alloc] init];
    NSString *newId = [newSpec startNewGraph:[specNameField text]];
    
    GraphListener *del = [GraphListener mainGraphListener];
    [del openConnection:newId];
    
    [self performSegueWithIdentifier:@"loadNewSpec" sender:nil];
}

@end
