//
//  EditComponentViewControllerDelegate.h
//  Classifyr
//
//  Created by Sean Congden on 12/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMLComponentView.h"

@class EditComponentViewController;

@protocol EditComponentViewControllerDelegate <NSObject>

- (void)editViewController:(EditComponentViewController *)vc updateWithUML:(NSString *)name;

- (void)editViewController:(EditComponentViewController *)vc returnToEditCanvas:(NSString *)name:(UMLComponentView*)componentToEdit;


@end
