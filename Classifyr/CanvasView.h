//
//  CanvasView.h
//  Classifyr
//
//  Created by Sean Congden on 13/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMLComponentView;
@class UMLConnection;

@interface CanvasView : UIView

@property (strong, nonatomic) NSMutableDictionary *connections;
@property (strong, nonatomic) NSNumber *nextLocalId;

- (void)createConnectionWithStart:(UMLComponentView *)startComponent withEnd:(UMLComponentView *)endComponent;

- (UMLConnection *)addConnectionWithId:(NSString *)id withStart:(UMLComponentView *)startComponent withEnd:(UMLComponentView *)endComponent;

@end
