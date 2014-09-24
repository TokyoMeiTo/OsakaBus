//
//  OWINHttpRequest.h
//  OWIN
//
//  Created by ohs on 12/05/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ONWHttpRequest.h"
#import "ONTSConst.h"

#define OWIN_HTTP_REQUEST_URL_TEST @"okasan-t.netrd.jp"
#define OWIN_HTTP_REQUEST_URL_HONBAN @"okasan.netrd.jp"

@interface OWINHttpRequest : ONWHttpRequest
{
    //HTTP GET
    NSString *_sessionID;
    NSString *_companyCode;
    NSString *_customerCode;
    NSString *_channelType;
    NSString *_accountKind;
    NSString *_businessType;
    NSString *_screenNo;
    
    //HTTP POST
    NSString *_cust;
    NSString *_cmp;
    NSString *_sss;
}

@property(copy,nonatomic) NSString *sessionID;
@property(copy,nonatomic) NSString *companyCode;
@property(copy,nonatomic) NSString *customerCode;
@property(copy,nonatomic) NSString *channelType;
@property(copy,nonatomic) NSString *accountKind;
@property(copy,nonatomic) NSString *businessType;
@property(copy,nonatomic) NSString *screenNo;

@property(copy,nonatomic) NSString *cust;
@property(copy,nonatomic) NSString *cmp;
@property(copy,nonatomic) NSString *sss;

@end
