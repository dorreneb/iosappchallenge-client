//
//  CanvasViewController.h
//  Classifyr
//
//  Created by Sean Congden on 14/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BoardViewControllerDelegate.h"
#import "EditComponentViewControllerDelegate.h"
#import "GraphListenerDelegate.h"
#import "UMLComponentDelegate.h"

@class CanvasView;
@class UMLAddView;


@interface CanvasViewController : UIViewController<BoardViewControllerDelegate, EditComponentViewControllerDelegate, GraphListenerDelegate, UMLComponentDelegate>

@property (weak, nonatomic) BoardViewController *boardViewController;
@property (strong, nonatomic) IBOutlet CanvasView *canvasView;
@property (strong, nonatomic) UMLAddView *addComponentView;
@property (weak, nonatomic) UMLComponentView *selectedComponent;


- (IBAction)cavnasTapped:(UITapGestureRecognizer *)recognizer;
- (IBAction)newClassTapped:(UIButton *)button;

- (void)boardViewController:(BoardViewController *)vc connectModeToggled:(BOOL)mode;

- (void)editViewController:(EditComponentViewController *)vc addComponentWithName:(NSString *)name;
- (void)editViewController:(EditComponentViewController *)vc updateComponent:(UMLComponentView *)componentToEdit withName:(NSString *)name;

- (void)graphListener:(id)gl initializeBoardWithJson:(id)json;
- (void)graphListener:(GraphListener *)gl addComponentWithJson:(id)json;
- (void)graphListener:(GraphListener *)gl addConnectionWithJson:(id)json;

- (void)umlComponent:(UMLComponentView *)component selected:(UITapGestureRecognizer *)recognizer;


@end
