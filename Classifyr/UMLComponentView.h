//
//  UMLComponentView.h
//  Classifyr
//
//  Created by Sean Congden on 11/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMLComponentDelegate.h"

@interface UMLComponentView : UIView

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;

@property (nonatomic) BOOL selected;
@property (strong, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) UIViewController *viewController;

@property (weak, nonatomic) id<UMLComponentDelegate> delegate;

+ (UMLComponentView *)viewFromNib;

- (void)awakeFromNib;

- (void)componentTapped:(UITapGestureRecognizer *)recognizer;

@end
