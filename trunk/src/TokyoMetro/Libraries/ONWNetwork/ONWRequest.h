//
//  ONWRequest.h
//  ONTSNetwork
//
//  Created by ohs on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONWRequestDelegate.h"

@interface ONWRequest : NSObject {
    NSData *_resultData;
    NSString *_resultString;
    
    NSString *_resultCount;
    NSString *_msgCode;
    NSString *_msgContent;
    
    id<ONWRequestDelegate> _delegate;
    
    NSUInteger _tag;
}

@property(retain,nonatomic) NSData *resultData;
@property(copy,nonatomic) NSString *resultString;
@property(copy,nonatomic) NSString *resultCount;
@property(copy,nonatomic) NSString *msgCode;
@property(copy,nonatomic) NSString *msgContent;

@property(assign,nonatomic) NSUInteger tag;

@property (assign, nonatomic) id<ONWRequestDelegate> delegate;

- (id)initWithDelegate:(id<ONWRequestDelegate>)delegate;

@end

