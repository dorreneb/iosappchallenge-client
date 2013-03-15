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
#import "GraphListener.h"

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
{   //set delegate
    ((EditComponentViewController *)(segue.destinationViewController)).delegate = self;
    //set component to edit - if null it will create
    //new box -- if not null it will update component
    //this assumes that creating a new box sends a nil
    //and that editing takes a component
    ((EditComponentViewController *)(segue.destinationViewController)).componentToEdit = sender;
}

- (IBAction)cavnasTapped:(UITapGestureRecognizer *)recognizer;
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.addComponentView.isHidden == YES) {
            CGPoint location = [recognizer locationInView:self.canvasView];
            //self.addComponentView.frame = CGRectMake(0.0f, 0.0f, 140.0f, 60.0f);
            self.addComponentView.center = location;
            self.addComponentView.hidden = NO;
        } else {
            self.addComponentView.hidden = YES;
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
    uml.delegate = self;
    [self.canvasView addSubview:uml];
    
    [editViewController dismissViewControllerAnimated:true completion:nil];
    
    [self.canvasView createComponent:uml];
}

- (void)editViewController:(EditComponentViewController *)vc updateComponent:(UMLComponentView *)componentToEdit withName:(NSString *)name
{
    //talk to server
    
    
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

- (void)boardViewController:(BoardViewController *)vc canvasDidScrollWithOffset:(CGPoint)offset
{
    if (self.selectedComponent != nil) {
        CGPoint location = self.selectedComponent.center;
        location.x += offset.x;
        location.y += offset.y;
        self.selectedComponent.center = location;
        //[self.canvasView setNeedsDisplay];
    }
}


@end
