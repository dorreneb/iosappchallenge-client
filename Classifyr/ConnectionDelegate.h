//
//  ConnectionDelegate.h
//  Classifyr
//
//  Created by Dorrene Brown on 3/9/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>

@interface ConnectionDelegate : NSObject {
}

-(void) startServer;
-(void) closeConnection;

+ (ConnectionDelegate *)mainConnectionDelegate;

@end
