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

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)deleteConnectionPressed:(id)sender;

@end
