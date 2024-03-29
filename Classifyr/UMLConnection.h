//
//  UMLConnection.h
//  Classifyr
//
//  Created by Sean Congden on 13/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMLComponentView.h"

@interface UMLConnection : NSObject

@property (strong, nonatomic) NSString *id;

@property (weak, nonatomic) UMLComponentView *startComponent;
@property (weak, nonatomic) UMLComponentView *endComponent;

@property (nonatomic) BOOL startArrowEnabled;
@property (nonatomic) BOOL endArrowEnabled;

@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) UIBezierPath *startArrowPath;
@property (strong, nonatomic) UIBezierPath *endArrowPath;

- (void)calculatePath;

@end
