//
//  ONWHttpRequst.h
//  ONTSNetwork
//
//  Created by ohs on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONWRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

typedef enum{
    ONWHttpRequestMethodGET = 1,
    ONWHttpRequestMethodPOST
    
}ONWHttpRequestMethod;

@interface ONWHttpRequest : ONWRequest<ASIHTTPRequestDelegate>{
    NSString *_url;
    NSDictionary *_paramDict;
    NSData *_paramData;
    NSString *_paramString;
    
    ONWHttpRequestMethod _method;
    
    ASIHTTPRequest *_getRequest;
    ASIFormDataRequest *_postRequest;
}

//发送HTTP请求的URL
@property(copy,nonatomic) NSString *url;

//HTTP请求的发送方法 POST/GET
@property(assign,nonatomic) ONWHttpRequestMethod method;

//请求参数字典
@property(retain,nonatomic) NSDictionary *paramDict;

//请求参数NSData
@property(retain,nonatomic) NSData *paramData;

//请求参数NSString
@property(retain,nonatomic) NSString *paramString;

@property(retain,nonatomic) ASIHTTPRequest *getRequest;
@property(retain,nonatomic) ASIFormDataRequest *postRequest;


//发送get请求，使用对象内的url作为参数
- (void) get;

//发送get请求，使用自定义get的URL
- (void) getByUrl:(NSString *)url;

//发送post请求
//如果参数param为空，则调用get请求
- (void) post;

//发送post请求,使用自定义post的URL
- (void) postByUrl:(NSString *)url;

//发送post请求,使用自定义post的URL,请求param参数
- (void) postByUrl:(NSString *)url param:(NSDictionary *)param;

//发送post请求,使用自定义post的URL,请求data参数
- (void) postData:(NSString *)url data:(NSData *)data;

//发送post请求,使用自定义post的URL,请求string参数
- (void) postString:(NSString *)url string:(NSString *)string;

//取消有效请求
- (void) cancelActiveRequest;

@end
