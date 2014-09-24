//
//  OWINSocketRequest.h
//  OWIN
//
//  Created by ohs on 12/07/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#import "ONWSocketRequest.h"
#import "OWINHttpRequest.h"
#import "ONTSConst.h"

//本番サーバー選択
#ifdef __OKASAN_HONBAN__
    #define OWIN_SOCKET_REQUEST_URL @"https://okasan-i.netrd.jp/"
#else
    #ifdef __OKASAN_DEVELOP__
        #define OWIN_SOCKET_REQUEST_URL @"http://192.168.188.181:1443/"
    #else
        #define OWIN_SOCKET_REQUEST_URL @"https://okasan-it.netrd.jp/"
    #endif
#endif

typedef enum
{
    OWINSocketRequestTypeRequest=1,
    OWINSocketRequestTypePreview,
    OWINSocketRequestTypeFilters,
}OWINSocketRequestType;

typedef enum 
{
    OWINSocketRequestTagHeartBeat = 1
}OWINSocketRequestTag;

@interface OWINSocketRequest : OWINHttpRequest
{
//    NSString *_cust;
//    NSString *_cmp;
//    NSString *_sss;
    
    NSString *_param;
    
    OWINSocketRequestType _requestType;
}

//@property(copy,nonatomic)NSString *cust;
//@property(copy,nonatomic)NSString *cmp;
//@property(copy,nonatomic)NSString *sss;

@property(copy,nonatomic)NSString *param;

@property(assign,nonatomic)OWINSocketRequestType requestType;

//向服务端发送数据
- (void) send:(int) tag;
@end
