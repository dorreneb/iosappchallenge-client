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
#import "EditConnectionViewControllerDelegate.h"
#import "GraphListenerDelegate.h"
#import "UMLComponentDelegate.h"

@class CanvasView;
@class UMLAddView;


@interface CanvasViewController : UIViewController<BoardViewControllerDelegate, EditComponentViewControllerDelegate, EditConnectionViewControllerDelegate, GraphListenerDelegate, UMLComponentDelegate>

@property (weak, nonatomic) BoardViewController *boardViewController;
@property (strong, nonatomic) IBOutlet CanvasView *canvasView;
@property (strong, nonatomic) IBOutlet UIView *addComponentView;
@property (weak, nonatomic) UMLComponentView *selectedComponent;
@property (weak, nonatomic) UMLComponentView *componentToMove;


- (IBAction)cavnasTapped:(UITapGestureRecognizer *)recognizer;
- (IBAction)newClassTapped:(UIButton *)button;

- (void)resetBoard:(id)specId;


- (void)boardViewController:(BoardViewController *)vc connectModeToggled:(BOOL)mode;
- (BOOL)boardViewController:(BoardViewController *)vc canvasDidScrollWithOffset:(CGPoint)offset;

- (void)editViewController:(EditComponentViewController *)vc addComponentWithName:(NSString *)name;
- (void)editViewController:(EditComponentViewController *)vc updateComponent:(UMLComponentView *)componentToEdit withName:(NSString *)name;

- (void)editViewController:(EditConnectionViewController *)vc deleteConnection:(UMLConnection *)connection;
- (void)arrowsChangedForEditViewController:(EditConnectionViewController *)vc;

- (void)graphListener:(id)gl initializeBoardWithJson:(id)json;
- (void)graphListener:(GraphListener *)gl addComponentWithJson:(id)json;
- (void)graphListener:(GraphListener *)gl addConnectionWithJson:(id)json;
- (void)graphListener:(GraphListener *)gl componentMoved:(id)json;
- (void)graphListener:(GraphListener *)gl deleteClass:(id)json;
- (void)graphListener:(GraphListener *)gl deleteConnection:(NSString *)id;
- (void)graphListener:(GraphListener *)gl updateConnection:(id)json;

- (void)umlComponent:(UMLComponentView *)component selected:(UIGestureRecognizer *)recognizer;

- (void)umlComponent:(UMLComponentView *)component moveStarted:(UIGestureRecognizer *)recognizer;
- (void)umlComponent:(UMLComponentView *)component moveEnded:(UIGestureRecognizer *)recognizer;

@end
