//
//  EditConnectionViewController.h
//  Classifyr
//
//  Created by Sean Congden on 15/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditConnectionViewControllerDelegate.h"

@interface EditConnectionViewController : UIViewController

@property(weak, nonatomic) id<EditConnectionViewControllerDelegate> delegate;

@property(weak, nonatomic) UMLConnection *connectionToEdit;

@property (strong, nonatomic) IBOutlet UILabel *startClassLabel;
@property (strong, nonatomic) IBOutlet UILabel *endClassLabel;

@property (weak, nonatomic) IBOutlet UIButton *startArrowButton;
@property (weak, nonatomic) IBOutlet UIButton *endArrowButton;

- (IBAction)showStartArrowPressed:(id)sender;
- (IBAction)showEndArrowPressed:(id)sender;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)deleteConnectionPressed:(id)sender;

- (void) toggleArrowButtonText: (BOOL)state withButton:(UIButton *)button;

@end
