//
//  EditConnectionViewController.m
//  Classifyr
//
//  Created by Sean Congden on 15/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "EditConnectionViewController.h"

@implementation EditConnectionViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteConnectionPressed:(id)sender
{
    
}

@end
