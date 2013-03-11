//
//  CanvasViewController.m
//  Classifyr
//
//  Created by Sean Congden on 9/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "CanvasViewController.h"

@implementation CanvasViewController

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
    
    // Set up the canvas view
    self.canvasView = [[CanvasView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1600.0f, 800.0f)];
    self.canvasView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    // Set up the scroll view
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale=0.5;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.scrollEnabled = YES;
    
    [self.scrollView addSubview:self.canvasView];
    [self.scrollView setContentSize:CGSizeMake(1600.0f, 800.0f)];
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

- (IBAction)cavnasTapped:(UITapGestureRecognizer *)recognizer;
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [recognizer locationInView:self.canvasView];
    
        // Create an UML component at the tapped location
        UMLComponent *uml = [[UMLComponent alloc] initWithLocation:location];
        [self.canvasView addUMLComponent:uml];
    }
}

@end
