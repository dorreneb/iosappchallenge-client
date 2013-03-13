//
//  CanvasViewController.m
//  Classifyr
//
//  Created by Sean Congden on 9/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import "CanvasViewController.h"
#import "GraphListener.h"
#import "EditComponentViewController.h"

@implementation CanvasViewController

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
    
    [[GraphListener mainGraphListener] setDelegate:self];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    // Set up the canvas view
    self.canvasView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1600.0f, 800.0f)];
    self.canvasView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grid.jpg"]];
    
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
{
    ((EditComponentViewController *)(segue.destinationViewController)).delegate = self;
}

- (IBAction)cavnasTapped:(UITapGestureRecognizer *)recognizer;
{
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

- (void)editViewController:(id)editViewController updateWithUML:(NSString *)name
{
    self.addComponentView.hidden = YES;
    UMLComponentView *uml = [UMLComponentView viewFromNib];
    uml.center = self.addComponentView.center;
    uml.classNameLabel.text = name;
    [self.canvasView addSubview:uml];
    
    [editViewController dismissViewControllerAnimated:true completion:nil];
    
    NSString *x = [NSString stringWithFormat:@"{\"type\": \"create\", \"body\": {\"type\": \"box\", \"name\": \"%@\", \"location\": {\"x\": \"%f\", \"y\": \"%f\"}}}", name, uml.center.x, uml.center.y];
     
    //send message to the server
    GraphListener *del = [GraphListener mainGraphListener];
    [del sendMessage:x];
}

-(void)graphListener:(id)gl initializeBoardWithJson:(id)json
{
    NSArray *components = (NSArray *)json;
    if (!components) {
        NSLog(@"Error parsing JSON");
    } else {
        for(NSDictionary *item in components) {
            UMLComponentView *uml = [UMLComponentView viewFromNib];
            uml.center = self.addComponentView.center;
            uml.classNameLabel.text = [item objectForKey:@"name"];
            
            NSDictionary *location = [item objectForKey:@"location"];
            NSNumber *x = [location objectForKey:@"x"];
            NSNumber *y = [location objectForKey:@"y"];
            uml.center = CGPointMake([x floatValue], [y floatValue]);
            
            [self.canvasView addSubview:uml];
        }
    }
}

@end
