//
//  UMLComponentView.m
//  Classifyr
//
//  Created by Sean Congden on 11/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UMLComponentView.h"

@implementation UMLComponentView

+ (UMLComponentView *)viewFromNib
{
    UMLComponentView *view = nil;
    
    NSArray *loadedObjects = [[NSBundle mainBundle] loadNibNamed:@"UMLComponentView" owner:nil options:nil];
    view = [loadedObjects lastObject];
    
    return view;
}

- (void)awakeFromNib
{
    // Set up component style
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2.0f;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(componentTapped:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapRecognizer];
}


- (void)componentTapped:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"hopefully touched box");
    
    if ([_delegate respondsToSelector:@selector(umlComponent:selected:)]) {
        [_delegate umlComponent:self selected:recognizer];
        
        
    } 
}

- (void)setSelected:(BOOL)value
{
    _selected = value;
    if (value == YES) {
        self.layer.borderColor = [UIColor blueColor].CGColor;
    } else {
        self.layer.borderColor = [UIColor blackColor].CGColor;
    }
}

- (void)setName:(NSString *)value
{
    _name = value;
    self.classNameLabel.text = value;
}

@end
