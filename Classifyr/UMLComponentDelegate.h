//
//  UMLComponentDelegate.h
//  Classifyr
//
//  Created by Sean Congden on 13/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMLComponentView;

@protocol UMLComponentDelegate <NSObject>

- (void)umlComponent:(UMLComponentView *)component selected:(UITapGestureRecognizer *)recognizer;

@end
