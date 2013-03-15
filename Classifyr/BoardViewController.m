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
        self.scrollView.minimumZoomScale = 0.5;
        self.scrollView.maximumZoomScale = 6.0;
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
        //NSLog(@"motion data:  roll:  %f  pitch:  %f  yaw:  %f", motionData.attitude.roll, motionData.attitude.pitch, motionData.attitude.yaw);
        
        BOOL changed = NO;
        CGPoint offset = CGPointZero;
        
        if (fabs(motionData.attitude.roll) > 0.05) {
            changed = YES;
            offset.x += (motionData.attitude.roll * 10.0f);
        }
        
        if (fabs(motionData.attitude.pitch - 0.22) > 0.05) {
            changed = YES;
            offset.y += ((motionData.attitude.pitch - 0.22) * 10.0f);
        }
        
        if (changed == YES) {
            CGPoint scrollLocation = self.scrollView.contentOffset;
            scrollLocation.x += offset.x;
            scrollLocation.y += offset.y;
            
            [self.scrollView setContentOffset:(scrollLocation) animated:NO];
            
            if ([_delegate respondsToSelector:@selector(boardViewController:canvasDidScrollWithOffset:)]) {
                [_delegate boardViewController:self canvasDidScrollWithOffset:offset];
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

@end
