//
//  UMLComponentView.h
//  Classifyr
//
//  Created by Sean Congden on 11/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMLComponentView : UIView

+ (UMLComponentView *)viewFromNib;

- (void)awakeFromNib;

@end