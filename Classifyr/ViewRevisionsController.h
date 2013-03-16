//
//  ViewRevisionsController.h
//  Classifyr
//
//  Created by Dorrene Brown on 3/15/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanvasViewController.h"

@interface ViewRevisionsController : UITableViewController
@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) CanvasViewController *controller;
@end

