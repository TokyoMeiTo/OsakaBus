//
//  OWINFilterSocketRequest.m
//  OWIN
//
//  Created by ohs on 12/08/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OWINFilterSocketRequest.h"

@implementation OWINFilterSocketRequest
@synthesize cust = _cust;
@synthesize cmp = _cmp;
@synthesize sss = _sss;

- (void)dealloc
{
    [_cust release];
    [_cmp release];
    [_sss release];
    
    [super dealloc];
}

- (id) init
{
    self = [super init];
    if (self) {
//        self.cust = @"300";
//        self.cmp = @"1";
//        self.sss = @"1";
    }
    return self;
}

@end
