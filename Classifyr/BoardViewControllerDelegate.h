//
//  BoardViewControllerDelegate.h
//  Classifyr
//
//  Created by Sean Congden on 14/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BoardViewController;

@protocol BoardViewControllerDelegate <NSObject>

- (void)boardViewController:(BoardViewController *)vc connectModeToggled:(BOOL)mode;

- (void)boardViewController:(BoardViewController *)vc canvasDidScrollWithOffset:(CGPoint)offset;

@end
