//
//  UMLComponentView.h
//  Classifyr
//
//  Created by Sean Congden on 11/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMLComponentView : UIView

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) IBOutlet UILabel *classNameLabel;

+ (UMLComponentView *)viewFromNib;

- (void)awakeFromNib;

@end
