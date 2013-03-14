//
//  CanvasViewController.m
//  Classifyr
//
//  Created by Sean Congden on 9/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "BoardViewController.h"
#import "GraphListener.h"
#import "EditComponentViewController.h"
#import "UMLConnection.h"

@implementation BoardViewController

@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.connectMode = NO;
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    // Set up the scroll view
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.scrollEnabled = YES;
    
    [self performSegueWithIdentifier:@"canvasViewEmbed" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"canvasViewEmbed"]) {
        self.canvasViewController = segue.destinationViewController;
        self.viewToScroll = self.canvasViewController.view;
        self.scrollView.contentSize = self.viewToScroll.bounds.size;
        [self.scrollView addSubview:self.viewToScroll];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.viewToScroll;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)settingsButtonPressed:(id)sender
{
}

- (IBAction)connectButtonPressed:(id)sender
{
    if (self.connectMode == NO) {
        self.helpLabel.text = @"Select components to connect";
        self.helpLabel.hidden = NO;
        self.connectMode = YES;
    } else {
        self.connectMode = NO;
    }
}

- (void)setConnectMode:(BOOL)value
{
    _connectMode = value;
    self.helpLabel.hidden = !value;
}

@end
