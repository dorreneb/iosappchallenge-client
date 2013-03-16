//
//  EditConnectionViewController.m
//  Classifyr
//
//  Created by Sean Congden on 15/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "EditConnectionViewController.h"
#import "UMLConnection.h"

@implementation EditConnectionViewController

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
    
    [self toggleArrowButtonText:self.connectionToEdit.startArrowEnabled withButton: self.startArrowButton];
    [self toggleArrowButtonText:self.connectionToEdit.endArrowEnabled withButton: self.endArrowButton];
    
    self.startClassLabel.text = self.connectionToEdit.startComponent.name;
    self.endClassLabel.text = self.connectionToEdit.endComponent.name;
    
    self.arrowsChanged = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleArrowButtonText: (BOOL)state withButton:(UIButton *)button
{
    NSString *text = (state) ? @"Remove arrow" : @"Add arrow";
    [button setTitle:text forState:UIControlStateNormal];
}

- (IBAction)showStartArrowPressed:(id)sender
{
    self.arrowsChanged = YES;
    self.connectionToEdit.startArrowEnabled = !self.connectionToEdit.startArrowEnabled;
    
    [self toggleArrowButtonText:self.connectionToEdit.startArrowEnabled withButton:(UIButton *)sender];
    
    [self.connectionToEdit calculatePath];
}

- (IBAction)showEndArrowPressed:(id)sender
{
    self.arrowsChanged = YES;
    self.connectionToEdit.endArrowEnabled = !self.connectionToEdit.endArrowEnabled;
    
    [self toggleArrowButtonText:self.connectionToEdit.endArrowEnabled withButton:(UIButton *)sender];
    
    [self.connectionToEdit calculatePath];
}

- (IBAction)backButtonPressed:(id)sender
{
    if (self.arrowsChanged == YES) {
        if (self.connectionToEdit != nil && [_delegate respondsToSelector:@selector(arrowsChangedForEditViewController:withConnection:)]) {
            [_delegate arrowsChangedForEditViewController:self withConnection:self.connectionToEdit];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteConnectionPressed:(id)sender
{
    if (self.connectionToEdit != nil && [_delegate respondsToSelector:@selector(editViewController:deleteConnection:)]) {
        [_delegate editViewController:self deleteConnection:self.connectionToEdit];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
