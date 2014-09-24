//
//  ONWRequest.m
//  ONTSNetwork
//
//  Created by ohs on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ONWRequest.h"

@implementation ONWRequest

@synthesize resultData = _resultData;
@synthesize resultString = _resultString;
@synthesize resultCount = _resultCount;
@synthesize msgCode = _msgCode;
@synthesize msgContent = _msgContent;
@synthesize tag = _tag;

@synthesize delegate = _delegate;

- (void)dealloc
{
    [_resultData release];
    [_resultString release];
    [_resultCount release];
    [_msgCode release];
    [_msgContent release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.tag = 0;
    }
    return self;
}

- (id)initWithDelegate:(id<ONWRequestDelegate>)delegate
{
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

@end
