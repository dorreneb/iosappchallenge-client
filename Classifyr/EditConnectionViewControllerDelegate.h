//
//  EditConnectionViewControllerDelegate.h
//  Classifyr
//
//  Created by Sean Congden on 15/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EditConnectionViewController;
@class UMLConnection;

@protocol EditConnectionViewControllerDelegate <NSObject>

- (void)editViewController:(EditConnectionViewController *)vc deleteConnection:(UMLConnection *)connection;

@end
