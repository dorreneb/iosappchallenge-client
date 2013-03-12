//
//  UMLPlaceholderView.h
//  Classifyr
//
//  Created by Sean Congden on 11/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UMLComponentView.h"

@interface UMLPlaceholderView : UIView

@property(weak, nonatomic) UMLComponentView *componentView;

+ (UMLPlaceholderView *)viewFromNib;

- (void)awakeFromNib;

@end
