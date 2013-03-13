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
#import "EditComponentViewControllerDelegate.h"
#import "GraphListenerDelegate.h"
#import "UMLComponentDelegate.h"

@interface CanvasViewController : UIViewController <UIScrollViewDelegate, EditComponentViewControllerDelegate, GraphListenerDelegate, UMLComponentDelegate>

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *canvasView;
@property (strong, nonatomic) UMLAddView *addComponentView;
@property (strong, nonatomic) IBOutlet UILabel *helpLabel;

@property BOOL connectMode;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;
- (IBAction)connectButtonPressed:(id)sender;

- (IBAction)cavnasTapped:(UITapGestureRecognizer *)recognizer;
- (IBAction)newClassTapped:(UIButton *)button;

- (void)editViewController:(id)editViewController updateWithUML:(NSString *)name;

- (void)graphListener:(id)gl initializeBoardWithJson:(id)json;

- (void)umlComponent:(UMLComponentView *)component selected:(UITapGestureRecognizer *)recognizer;

@end
