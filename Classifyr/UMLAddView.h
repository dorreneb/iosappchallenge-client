//
//  UMLAddView.h
//  Classifyr
//
//  Created by Sean Congden on 12/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMLAddView : UIView

@property (strong, nonatomic) IBOutlet UIButton *addClassButton;

+ (UMLAddView *)viewFromNib;

- (void)awakeFromNib;

@end
