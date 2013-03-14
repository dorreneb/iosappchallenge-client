//
//  CanvasViewController.m
//  Classifyr
//
//  Created by Sean Congden on 9/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "BoardViewController.h"
#import "GraphListener.h"
#import "EditComponentViewController.h"
#import "UMLConnection.h"

@implementation BoardViewController

@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.connectMode = NO;
    
    [[GraphListener mainGraphListener] setDelegate:self];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    // Set up the canvas view
    self.canvasView = [[CanvasView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1600.0f, 800.0f)];
    
    // Add the add component view / button
    self.addComponentView = [UMLAddView viewFromNib];
    [self.addComponentView.addClassButton addTarget:self action:@selector(newClassTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.addComponentView.hidden = YES;
    [self.canvasView addSubview:self.addComponentView];
    
    // Set up the scroll view
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.scrollEnabled = YES;
    [self.scrollView addGestureRecognizer:self.tapGestureRecognizer];
    
    [self.scrollView setContentSize:self.canvasView.bounds.size];
    [self.scrollView addSubview:self.canvasView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.canvasView;
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

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)settingsButtonPressed:(id)sender
{
}

- (IBAction)connectButtonPressed:(id)sender
{
    if (self.connectMode == NO) {
        self.helpLabel.text = @"Select components to connect";
        self.helpLabel.hidden = NO;
        self.connectMode = YES;
    } else {
        [self leaveConnectMode];
    }
}

- (IBAction)cavnasTapped:(UITapGestureRecognizer *)recognizer;
{
    NSLog(@"hello from canvas tapped");
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.addComponentView.isHidden == YES) {
            CGPoint location = [recognizer locationInView:self.canvasView];
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
    if (self.connectMode == YES) {
        if (self.selectedComponent == nil) {
            component.selected = YES;
            self.selectedComponent = component;
        } else {
            // Two classes selected, create the connection
            [self.canvasView createConnectionWithStart:self.selectedComponent withEnd:component];
            
            component.selected = NO;
            [self leaveConnectMode];
        }
        
        [self.canvasView setNeedsDisplay];
    } else { //just clicked on a box, time to edit!
        [self performSegueWithIdentifier:@"editUMLSegue" sender:component];
        
    }
}

- (void)leaveConnectMode
{
    self.helpLabel.hidden = YES;
    self.connectMode = NO;
    
    if (self.selectedComponent != nil) {
        self.selectedComponent.selected = NO;
        self.selectedComponent = nil;
    }
}

@end
