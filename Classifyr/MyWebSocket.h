//
//  MyWebSocket.h
//  Classifyr
//
//  Created by Dorrene Brown on 3/9/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebSocket.h>

@interface MyWebSocket : NSObject <WebSocketDelegate>
{
@private
    WebSocket* _ws;
}

@property (nonatomic, readonly) WebSocket* ws;

- (void) startMyWebSocket;


@end
