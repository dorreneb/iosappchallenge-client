//
//  CanvasViewController.m
//  Classifyr
//
//  Created by Sean Congden on 14/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "BoardViewController.h"
#import "CanvasView.h"
#import "EditComponentViewController.h"
#import "EditConnectionViewController.h"
#import "GraphListener.h"
#import "UMLConnection.h"

#import "CanvasViewController.h"


@implementation CanvasViewController


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
    
    [[GraphListener mainGraphListener] setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editUMLSegue"]) {
        //set delegate
        ((EditComponentViewController *)(segue.destinationViewController)).delegate = self;
        //set component to edit - if null it will create
        //new box -- if not null it will update component
        //this assumes that creating a new box sends a nil
        //and that editing takes a component
        ((EditComponentViewController *)(segue.destinationViewController)).componentToEdit = sender;
    } else if ([segue.identifier isEqualToString:@"editConnectionSegue"]) {
        ((EditConnectionViewController *)(segue.destinationViewController)).connectionToEdit = sender;
        ((EditConnectionViewController *)(segue.destinationViewController)).delegate = self;
    }
}

- (IBAction)cavnasTapped:(UITapGestureRecognizer *)recognizer;
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.addComponentView.hidden == NO) {
            self.addComponentView.hidden = YES;
        } else {
            CGPoint location = [recognizer locationInView:self.canvasView];
            UMLConnection *connectionTapped = [self.canvasView connectionSelected:location];
        
            if (connectionTapped != nil) {
                [self performSegueWithIdentifier:@"editConnectionSegue" sender:connectionTapped];
            } else {
                self.addComponentView.center = location;
                self.addComponentView.hidden = NO;
            }
        }
    }
}

- (IBAction)newClassTapped:(UIButton *)button
{
    [self performSegueWithIdentifier:@"editUMLSegue" sender:nil];
}

- (void)boardViewController:(BoardViewController *)vc connectModeToggled:(BOOL)mode
{
    vc.helpLabel.hidden = !mode;
    
    if (mode == NO) {
        if (self.selectedComponent != nil) {
            self.selectedComponent.selected = NO;
            self.selectedComponent = nil;
        }
        
        [self.canvasView setNeedsDisplay];
    }
}

- (void)editViewController:(id)editViewController addComponentWithName:(NSString *)name
{
    self.addComponentView.hidden = YES;
    UMLComponentView *uml = [UMLComponentView viewFromNib];
    uml.center = self.addComponentView.center;
    uml.name = name;
    
    [editViewController dismissViewControllerAnimated:true completion:nil];
    
    [self.canvasView createComponent:uml];
}

- (void)editViewController:(EditComponentViewController *)vc deleteClass:(id)classId {
    GraphListener *listener = [GraphListener mainGraphListener];
    [listener deleteClass:classId];
    //transition back to canvas
    [vc dismissViewControllerAnimated:true completion:nil];
    
}

- (void)editViewController:(EditComponentViewController *)vc updateComponent:(UMLComponentView *)componentToEdit withName:(NSString *)name
{
    //talk to server
    //NSString *edit = "";
    NSLog(@"%@", componentToEdit.id);
    [[GraphListener mainGraphListener] editClass:name classId:componentToEdit.id];
    
    //remove old outdated box and place new one
    UMLComponentView *uml = [UMLComponentView viewFromNib];
    uml.center = componentToEdit.center;
    uml.name = name;
    uml.delegate = self;
    [componentToEdit removeFromSuperview];
    [self.canvasView addSubview:uml];
    
    //transition back to canvas
    [vc dismissViewControllerAnimated:true completion:nil];
}

- (void)editViewController:(EditConnectionViewController *)vc deleteConnection:(UMLConnection *)connection
{
    [self.canvasView deleteConnection:connection];
}

- (void)graphListener:(id)gl initializeBoardWithJson:(id)json
{
    NSArray *components = (NSArray *)json;
    if (!components) {
        NSLog(@"Error parsing JSON");
    } else {
        for(NSDictionary *item in components) {
            NSString *type = [item objectForKey:@"type"];
            
            if ([type isEqual:@"box"]) {
                UMLComponentView *uml = [UMLComponentView viewFromNib];
                uml.center = self.addComponentView.center;
                uml.name = [item objectForKey:@"name"];
                NSString *id = [item objectForKey:@"id"];
                uml.id = id;
                uml.delegate = self;
                
                NSDictionary *location = [item objectForKey:@"location"];
                NSNumber *x = [location objectForKey:@"x"];
                NSNumber *y = [location objectForKey:@"y"];
                uml.center = CGPointMake([x floatValue], [y floatValue]);
                
                [self.canvasView addComponentWithId:id withComponent:uml];
            } else if ([type isEqual:@"connection"]) {
                NSString *connectionId = [item objectForKey:@"id"];
                NSString *startId = [item objectForKey:@"from"];
                NSString *endId = [item objectForKey:@"to"];
                
                [self.canvasView addConnectionWithId:connectionId withStart:startId withEnd:endId];
            }
        }
        
        [self.canvasView setNeedsDisplay];
    }
}

- (void)graphListener:(GraphListener *)gl addComponentWithJson:(id)json
{
    NSDictionary *item = (NSDictionary *)json;
    
    UMLComponentView *uml = [UMLComponentView viewFromNib];
    uml.center = self.addComponentView.center;
    uml.name = [item objectForKey:@"name"];
    
    NSString *id = [item objectForKey:@"id"];
    uml.id = id;
    uml.delegate = self;
    
    NSDictionary *location = [item objectForKey:@"location"];
    NSNumber *x = [location objectForKey:@"x"];
    NSNumber *y = [location objectForKey:@"y"];
    uml.center = CGPointMake([x floatValue], [y floatValue]);
    
    [self.canvasView addComponentWithId:id withComponent:uml];
}

- (void)graphListener:(GraphListener *)gl addConnectionWithJson:(id)json
{
    NSDictionary *item = (NSDictionary *)json;
    
    NSString *connectionId = [item objectForKey:@"id"];
    NSString *startId = [item objectForKey:@"from"];
    NSString *endId = [item objectForKey:@"to"];
    
    
    [self.canvasView addConnectionWithId:connectionId withStart:startId withEnd:endId];
    
    [self.canvasView setNeedsDisplay];
}

- (void)graphListener:(GraphListener *)gl updateClass:(id)json
{
    NSDictionary *item = (NSDictionary *)json;
    
    NSString *classId = [item objectForKey:@"id"];
    NSString *name = [item objectForKey:@"name"];
    
    UMLComponentView *box = [self.canvasView.components objectForKey:classId];
    
    //edit
    box.name = name;
    box.id = classId;
    
    [self.canvasView addComponentWithId:classId withComponent:box];
    
    [self.canvasView setNeedsDisplay];
}

- (void)graphListener:(GraphListener *)gl deleteConnection:(NSString *)id
{
    [self.canvasView.connections removeObjectForKey:id];
    [self.canvasView setNeedsDisplay];
}

- (void)umlComponent:(UMLComponentView *)component selected:(UITapGestureRecognizer *)recognizer
{
    if (self.boardViewController.connectMode == YES) {
        if (self.selectedComponent == nil) {
            component.selected = YES;
            self.selectedComponent = component;
        } else {
            // Two classes selected, create the connection
            [self.canvasView createConnectionWithStart:self.selectedComponent withEnd:component];
            
            component.selected = NO;
            self.boardViewController.connectMode = NO;
        }
        
        [self.canvasView setNeedsDisplay];
    } else { //just clicked on a box, time to edit!
        [self performSegueWithIdentifier:@"editUMLSegue" sender:component];
        
    }
}

- (void)graphListener:(GraphListener *)gl componentMoved:(id)json
{
    NSLog(@"boop");
    UMLComponentView *componentToMove = [self.canvasView.components objectForKey:[json objectForKey:@"id"]];
    
    NSDictionary *location = [json objectForKey:@"location"];
    NSNumber *x = [location objectForKey:@"x"];
    NSNumber *y = [location objectForKey:@"y"];
    
    componentToMove.center = CGPointMake([x floatValue], [y floatValue]);
    
    [self.canvasView recalculateConnections];
}

- (void)graphListener:(GraphListener *)gl deleteClass :(id)json
{
    UMLComponentView *boxToDelete = [self.canvasView.components objectForKey:json];
    [boxToDelete removeFromSuperview];
    [self.canvasView setNeedsDisplay];
    
    //transition back to canvas
    //[UIViewController dismissViewControllerAnimated:true completion:nil];
}
    
- (void)umlComponent:(UMLComponentView *)component moveStarted:(UIGestureRecognizer *)recognizer
{
    // Create a copy of the component just for moving
    self.componentToMove = [UMLComponentView viewFromNib];
    self.componentToMove.center = component.center;
    self.componentToMove.name = component.name;
    self.componentToMove.selected = YES;
    [self.canvasView addSubview:self.componentToMove];
    
    // Mark the ghost (real) component view as disabled
    component.backgroundColor = [UIColor lightGrayColor];
    [component setNeedsDisplay];
    
    // Enable tilt scrolling
    [self.boardViewController startTiltScrolling];
}

- (void)umlComponent:(UMLComponentView *)component moveEnded:(UIGestureRecognizer *)recognizer
{
    [self.boardViewController stopTiltScrolling];
    
    // Re-enable the disabled component
    component.backgroundColor = [UIColor whiteColor];
    [component setNeedsDisplay];
    
    // Send the move to the server
    [self.canvasView moveComponent:component withPoint:self.componentToMove.center];
    
    // Remove the temporary component
    [self.componentToMove removeFromSuperview];
    self.componentToMove = nil;
}

- (BOOL)boardViewController:(BoardViewController *)vc canvasDidScrollWithOffset:(CGPoint)offset
{
    if (self.componentToMove != nil) {
        CGRect frame = self.componentToMove.frame;
        frame.origin.x += offset.x;
        frame.origin.y += offset.y;
        
        CGRect bounds = CGRectMake(0.0f, 0.0f, self.boardViewController.scrollView.contentSize.width, self.boardViewController.scrollView.contentSize.height);
        
        BOOL doScroll = CGRectContainsRect(bounds, frame);
        if (doScroll) {
            self.componentToMove.frame = frame;
        }
        
        return doScroll;
    }
    
    return NO;
}

@end
