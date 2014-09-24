//
//  OWINHttpRequest.m
//  OWIN
//
//  Created by ohs on 12/05/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OWINHttpRequest.h"

@implementation OWINHttpRequest
@synthesize sessionID = _sessionID;
@synthesize companyCode = _companyCode;
@synthesize customerCode = _customerCode;
@synthesize channelType = _channelType;
@synthesize accountKind = _accountKind;
@synthesize businessType = _businessType;
@synthesize screenNo = _screenNo;

@synthesize cust = _cust;
@synthesize cmp = _cmp;
@synthesize sss = _sss;

- (void) dealloc
{
    [_sessionID release];
    [_companyCode release];
    [_customerCode release];
    [_channelType release];
    [_accountKind release];
    [_businessType release];
    [_screenNo release];
    
    [_cust release];
    [_cmp release];
    [_sss release];
    
    [super dealloc];
}

- (id) init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) getByUrl:(NSString *)url
{
    
//本番する時、本番URL作成
//okasan-t.netrd.jp -> okasan.netrd.jp
#ifdef __OKASAN_HONBAN__
    NSString *newurl = [url stringByReplacingOccurrencesOfString:OWIN_HTTP_REQUEST_URL_TEST withString:OWIN_HTTP_REQUEST_URL_HONBAN];
    NSLog(@"URL:%@",newurl);
#else
    #ifdef __OKASAN_DEVELOP__
        NSString *newurl = [url stringByReplacingOccurrencesOfString:@"https://okasan-t.netrd.jp" withString:@"http://192.168.188.51:1443"];
        NSLog(@"*******URL:%@",newurl);
    #else
        NSString *newurl = url;
    #endif
#endif
    
    [super getByUrl:newurl];
}

@end
