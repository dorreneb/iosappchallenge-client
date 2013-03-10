//
//  GraphListenerDelegate.h
//  Classifyr
//
//  Created by Dorrene Brown on 3/10/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>

@interface GraphListenerDelegate : NSObject

-(void)sendMessage:(NSString*)message;

+ (GraphListenerDelegate *)mainGraphListenerDelegate;

@end


