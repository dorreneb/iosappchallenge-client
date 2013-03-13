//
//  CanvasViewController.h
//  Classifyr
//
//  Created by Sean Congden on 9/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UMLComponentView.h"
#import "UMLAddView.h"

@interface CanvasViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *canvasView;
@property (strong, nonatomic) UMLAddView *addComponentView;

- (IBAction)cavnasTapped:(UITapGestureRecognizer *)recognizer;
- (IBAction)newClassTapped:(UIButton *)button;

@end
