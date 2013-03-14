//
//  CanvasViewController.h
//  Classifyr
//
//  Created by Sean Congden on 9/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *helpLabel;

@property (weak, nonatomic) UIViewController *canvasViewController;
@property (weak, nonatomic) UIView *viewToScroll;

@property (nonatomic) BOOL connectMode;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;
- (IBAction)connectButtonPressed:(id)sender;

@end
