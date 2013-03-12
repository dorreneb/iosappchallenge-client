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
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    // Set up the scroll view
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale=0.5;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.scrollEnabled = YES;
    
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
        if (self.addComponentView.isHidden == YES) {
            CGPoint location = [recognizer locationInView:self.canvasView];
            self.addComponentView.center = location;
            self.addComponentView.hidden = NO;
        } else {
            self.addComponentView.hidden = YES;
        }
    }
}

- (IBAction)newClassTapped:(UIButton *)button
{
    self.addComponentView.hidden = YES;
    UMLComponentView *uml = [UMLComponentView viewFromNib];
    uml.center = self.addComponentView.center;
    [self.canvasView addSubview:uml];
}

@end
