//
//  CanvasView.h
//  Classifyr
//
//  Created by Sean Congden on 9/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMLComponent.h"

@interface CanvasView : UIView

//@property(strong, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;

- (void) addUMLComponent: (UMLComponent *)component;

@end
