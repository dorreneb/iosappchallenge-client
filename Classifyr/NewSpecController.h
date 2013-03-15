//
//  NewSpecController.h
//  Classifyr
//
//  Created by Dorrene Brown on 3/13/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewSpecController : UIViewController

-(IBAction) generateSpec:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *specNameField;
- (IBAction)closeKeyboardOnTouch:(id)sender;

@end
