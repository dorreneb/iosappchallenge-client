//
//  AppDelegate.h
//  Classifyr
//
//  Created by Sean Congden on 8/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CMMotionManager *motionManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly) CMMotionManager *motionManager;

@end
