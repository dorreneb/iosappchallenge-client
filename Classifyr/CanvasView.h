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

@property (strong, nonatomic) NSMutableDictionary *components;

- (void)createConnectionWithStart:(UMLComponentView *)startComponent withEnd:(UMLComponentView *)endComponent;
- (UMLConnection *)addConnectionWithId:(NSString *)id withStart:(NSString *)startId withEnd:(NSString *)endId;

- (void)createComponent:(UMLComponentView *)component;
- (void)addComponentWithId:(NSString *)id withComponent:(UMLComponentView *)component;
- (void)moveComponent:(UMLComponentView *)component withPoint:(CGPoint)point;
- (void)deleteConnection:(UMLConnection *)connection;

- (UMLConnection *)connectionSelected:(CGPoint)touchLocation;

- (void)recalculateConnections;
- (void) clearBoard;

@end
