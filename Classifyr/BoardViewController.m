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
    self.moveMode = NO;
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
        self.scrollView.minimumZoomScale = 0.3;
        self.scrollView.maximumZoomScale = 1.0;
        self.scrollView.clipsToBounds = YES;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.delegate = self;
        
        // Set up tilt scrolling
        
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
    
    // Close the server connection
    GraphListener *del = [GraphListener mainGraphListener];
    [del closeConnection];
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

- (CMMotionManager *)motionManager
{
    CMMotionManager *motionManager = nil;
    
    id appDelegate = [UIApplication sharedApplication].delegate;
    if ([appDelegate respondsToSelector:@selector(motionManager)]) {
        motionManager = [appDelegate motionManager];
    }
    
    return motionManager;
}

- (void)startTiltScrolling
{
    self.moveMode = YES;
    self.scrollView.scrollEnabled = NO;
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler: ^(CMDeviceMotion *motionData, NSError *error) {
        //NSLog(@"motion data:  x:  %f  y:  %f  z:  %f", motionData.gravity.x, motionData.gravity.y, motionData.gravity.z);
        
        BOOL changed = NO;
        CGPoint offset = CGPointZero;
        
        if (fabs(motionData.gravity.x) > 0.05) {
            changed = YES;
            offset.x += (motionData.gravity.x * 7.0f);
        }
        
        if (fabs(motionData.gravity.y + 0.15) > 0.05) {
            changed = YES;
            offset.y -= ((motionData.gravity.y + 0.15) * 7.0f);
        }
        
        if (changed == YES) {
            if ([_delegate respondsToSelector:@selector(boardViewController:canvasDidScrollWithOffset:)]) {
                BOOL doScroll = [_delegate boardViewController:self canvasDidScrollWithOffset:offset];
                if (doScroll) {
                    CGPoint location = self.scrollView.contentOffset;
                    location.x += offset.x;
                    location.y += offset.y;
                    
                    [self.scrollView setContentOffset:(location) animated:NO];
                }

            }
        }
    }];
}

- (void)stopTiltScrolling
{
    self.moveMode = NO;
    self.scrollView.scrollEnabled = YES;
    
    [self.motionManager stopDeviceMotionUpdates];
}

- (IBAction)revisionsButtonPressed:(id)sender
{
    NSLog(@"revisions");
    //showRevisions
    [_delegate boardViewController:self showRevisions:@""];
}

@end
