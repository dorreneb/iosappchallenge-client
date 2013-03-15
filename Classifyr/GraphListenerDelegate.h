//
//  GraphListenerDelegate.h
//  Classifyr
//
//  Created by Sean Congden on 13/3/13.
//  Copyright (c) 2013 B-SQUADRON. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GraphListener;

@protocol GraphListenerDelegate <NSObject>

-(void)graphListener:(GraphListener *)gl initializeBoardWithJson:(id)json;
-(void)graphListener:(GraphListener *)gl addComponentWithJson:(id)json;
-(void)graphListener:(GraphListener *)gl addConnectionWithJson:(id)json;
-(void)graphListener:(GraphListener *)gl updateClass:(id)json;
-(void)graphListener:(GraphListener *)gl componentMoved:(id)json;
-(void)graphListener:(GraphListener *)gl deleteClass:(id)json;
-(void)graphListener:(GraphListener *)gl deleteConnection:(NSString *)id;

@end
