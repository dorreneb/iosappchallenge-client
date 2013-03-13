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

@end