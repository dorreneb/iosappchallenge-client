//
//  EditComponentViewController.m
//  Classifyr
//
//  Created by Sean Congden on 12/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "EditComponentViewController.h"

@interface EditComponentViewController ()

@end

@implementation EditComponentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender
{
    //if add
    if (_componentToEdit == nil) {
        if ([_delegate respondsToSelector:@selector(editViewController:addComponentWithName:)]) {
            [_delegate editViewController:self addComponentWithName:self.classNameTextField.text];
        }
    } else { //if edit
        if ([_delegate respondsToSelector:@selector(editViewController:updateComponent:withName:)]) {
            [_delegate editViewController:self updateComponent:self.componentToEdit withName:self.classNameTextField.text];
        }
    }
}
@end
