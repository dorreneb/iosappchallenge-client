//
//  CanvasViewController.h
//  Classifyr
//
//  Created by Sean Congden on 9/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

#import "BoardViewControllerDelegate.h"


@interface BoardViewController : UIViewController <UIScrollViewDelegate>

@property (readonly) CMMotionManager *motionManager;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *helpLabel;

@property (weak, nonatomic) UIView *canvasView;

@property (nonatomic) BOOL connectMode;
@property (nonatomic) BOOL moveMode;
@property (weak, nonatomic) id<BoardViewControllerDelegate> delegate;


- (IBAction)backButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;
- (IBAction)connectButtonPressed:(id)sender;
- (IBAction)revisionsButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *revisionsButtonPressed;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;

- (void)startTiltScrolling;
- (void)stopTiltScrolling;

@end
