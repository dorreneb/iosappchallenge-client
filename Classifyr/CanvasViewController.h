//
//  CanvasViewController.h
//  Classifyr
//
//  Created by Sean Congden on 9/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UMLComponentView.h"

@interface CanvasViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *canvasView;
@property (strong, nonatomic) IBOutlet UIView *addComponentView;

- (IBAction)cavnasTapped:(UITapGestureRecognizer *)recognizer;
- (IBAction)newClassTapped:(UIButton *)button;

@end
