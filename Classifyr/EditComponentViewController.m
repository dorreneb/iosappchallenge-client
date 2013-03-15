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

- (void)viewWillAppear:(BOOL)animated
{
    //new view - grey out delete button
    if (_componentToEdit == nil) {
        [_deleteButton setAlpha:0.46f];
        [_deleteButton setBackgroundColor:[UIColor grayColor]];
        [_deleteButton setEnabled:NO];
        
    } else { //new - enable delete button, put name in box
        UIColor *myColor = [UIColor colorWithRed:(217.0 / 255.0) green:(133.0 / 255.0) blue:(87.0 / 255.0) alpha: 1];
        _deleteButton.backgroundColor = myColor;
        [_deleteButton setEnabled:YES];
        _classNameTextField.text = [_componentToEdit name];
    }
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

- (IBAction)closeKeyboardOnTouch:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)deleteClass:(id)sender {
}
@end
