//
//  GraphListenerDelegate.h
//  Classifyr
//
//  Created by Dorrene Brown on 3/10/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>
#import "GraphListenerDelegate.h"

@interface GraphListener : NSObject <SRWebSocketDelegate>

@property(weak, nonatomic) id<GraphListenerDelegate> delegate;

-(void)openConnection:(NSString*)graphId;
-(void)closeConnection;
-(void)sendMessage:(NSString*)message;
-(void)editClass:(NSString*)newName classId:(id)classId;

+ (GraphListener *)mainGraphListener;

@end


