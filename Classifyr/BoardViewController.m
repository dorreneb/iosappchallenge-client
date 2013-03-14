//
//  CanvasViewController.m
//  Classifyr
//
//  Created by Sean Congden on 9/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "BoardViewController.h"
#import "CanvasView.h"
#import "CanvasViewController.h"
#import "GraphListener.h"
#import "EditComponentViewController.h"
#import "UMLConnection.h"

@implementation BoardViewController

@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.connectMode = NO;
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    if (self.storyboard) {
        // Add the canvas view controller as a child view controller
        CanvasViewController *canvasViewController = (CanvasViewController *)([self.storyboard instantiateViewControllerWithIdentifier:@"canvasViewController"]);
        [self addChildViewController:canvasViewController];
        self.canvasView = canvasViewController.view;
        [canvasViewController setBoardViewController:self];
        self.delegate = canvasViewController;
        
        // Set the size of the canvas
        CGRect frame = CGRectMake(0.0f, 0.0f, 1024.0f, 740.0f);
        [self.scrollView setContentSize:frame.size];
        self.canvasView.frame = frame;
        
        // Set up the scroll view
        self.scrollView.minimumZoomScale = 0.5;
        self.scrollView.maximumZoomScale = 6.0;
        self.scrollView.clipsToBounds = YES;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.delegate = self;
        
        // Display the canvas
        [self.scrollView addSubview:self.canvasView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.canvasView;
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
    [self setConnectMode:!_connectMode];
}

- (void)setConnectMode:(BOOL)value
{
    _connectMode = value;
    if ([_delegate respondsToSelector:@selector(boardViewController:connectModeToggled:)]) {
        [_delegate boardViewController:self connectModeToggled:value];
    }
}

@end
