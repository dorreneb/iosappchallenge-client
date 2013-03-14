//
//  EditComponentViewController.h
//  Classifyr
//
//  Created by Sean Congden on 12/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditComponentViewControllerDelegate.h"
#import "UMLComponentView.h"

@interface EditComponentViewController : UIViewController

@property(weak, nonatomic) id<EditComponentViewControllerDelegate> delegate;

@property(weak, nonatomic) id componentToEdit;

@property (strong, nonatomic) IBOutlet UITextField *classNameTextField;

- (IBAction)backButtonPressed:(id)sender;

@end
