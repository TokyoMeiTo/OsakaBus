//
//  OWINSocketRequest.m
//  OWIN
//
//  Created by ohs on 12/07/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OWINSocketRequest.h"

@implementation OWINSocketRequest
//@synthesize cust = _cust;
//@synthesize cmp = _cmp;
//@synthesize sss = _sss;
@synthesize requestType = _requestType;
@synthesize param =_param;

- (void)dealloc
{
//    [_cust release];
//    [_cmp release];
//    [_sss release];
    
    [_param release];
    
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

- (void)send:(int) tag{
    //设置参数
    self.paramString = self.param;
//    self.url = @"https://okasan-it.netrd.jp/";
//本番時
//  okasan-t.netrd.jp -> okasan.netrd.jp
    self.url = OWIN_SOCKET_REQUEST_URL;
    
    //发送请求,这里的标签注意
    [self post];
}

@end
