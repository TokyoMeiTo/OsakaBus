//
//  ONWHttpRequst.m
//  ONTSNetwork
//
//  Created by ohs on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ONWHttpRequest.h"

//@interface NSString (NSStringURLArgumentsAdditions) 
////URL编码
//- (NSString*)stringByEscapingForURLArgument;
//@end 
//@implementation NSString (NSStringURLArgumentsAdditions)  
//
//- (NSString*)stringByEscapingForURLArgument {   
//    CFStringRef escaped =   
//    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  
//                                            (CFStringRef)self,  
//                                            NULL,  
//                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",  
//                                            kCFStringEncodingUTF8);  
//    return [NSString stringWithString:((NSString *)escaped)];  
//}  
//@end

@implementation ONWHttpRequest

@synthesize url = _url;
@synthesize method = _method;
@synthesize paramDict = _paramDict;
@synthesize paramData = _paramData;
@synthesize paramString = _paramString;
@synthesize getRequest = _getRequest;
@synthesize postRequest = _postRequest;

- (void)dealloc
{
    //判断是否需要释放
    if (self.getRequest) {
        [self.getRequest clearDelegatesAndCancel];
    }
    
    //判断是否需要释放
    if (self.postRequest) {
        [self.postRequest clearDelegatesAndCancel];
    }
    
    //
    [_url release];
    [_paramDict release];
    [_paramData release];
    [_paramString release];
    
    [_getRequest release];
    [_postRequest release];

    [super dealloc];
}

- (void) get
{
    //请求方式
    self.method = ONWHttpRequestMethodGET;
    
    //请求将要发送
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(requestWillSend:)]) {
		[_delegate requestWillSend:self];
	}
    
    //是否应该发送请求
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(shouldRequestBeSend:)]) {
		if (![_delegate shouldRequestBeSend:self]) {
            return;
        }
	}
    
    //判断URL是否为空
    if(self.url && ![self.url isEqualToString:@""])
    {
        //使用%号方式区分URL的特殊字符
        self.url = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //去除base64编码后的‘+’'/'
        //TODO:URLEncode对应
        self.url = [self.url stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//      self.url = [self.url stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        
        //创建URL
        NSURL *url = [NSURL URLWithString:self.url];
        self.getRequest = [ASIHTTPRequest requestWithURL:url];
        
        //设置delegate
        self.getRequest.delegate = self;
        
        NSLog(@"Starting Http Request");
        [self.getRequest startAsynchronous];
        
        //请求已发送
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(requestDidSent:)]) {
            [_delegate requestDidSent:self];
        }
    }
}

- (void) getByUrl:(NSString *)url
{
    //设置url
    self.url = url;
    [self get];
}

- (void) post
{   
    //请求方式
    self.method = ONWHttpRequestMethodPOST;
    
    //请求将要发送
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(requestWillSend:)]) {
		[_delegate requestWillSend:self];
	}
    
    //是否应该发送请求
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(shouldRequestBeSend:)]) {
		if (![_delegate shouldRequestBeSend:self]) {
            return;
        }
	}
    
    //所有参数都是空则调用get
    if (self.paramString == nil && self.paramData == nil && self.paramDict == nil) {
        [self get];
    }else {
        //参数为空时，调用GET
        if(self.paramDict || [self.paramDict count])
        {
            [self get];
        }
    }
    
    //判断URL是否为空
    if(self.url && ![self.url isEqualToString:@""])
    {
        //创建URL
        NSURL *url = [NSURL URLWithString:self.url];
        NSLog(@"ONWHttpRequest url:%@",url);
        self.postRequest = [ASIFormDataRequest requestWithURL:url];
        [self.postRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"]; 
        //设置请求方法
        [self.postRequest setRequestMethod:@"POST"];
        //设置UTF8编码
        [self.postRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
        //判断键值对
        if (self.paramDict && [self.paramDict count] > 0) {
            //设置请求键值对
            for(NSString *key in [self.paramDict allKeys])
            {
                [self.postRequest setPostValue:[self.paramDict objectForKey:key] forKey:key];
            }
        }
        
        //添加String
        if(self.paramString)
        {
            [self.postRequest appendPostData:[self.paramString dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        //添加data
        if (self.paramData) {
            [self.postRequest appendPostData:self.paramData];
        }
        
        //设置delegate
        self.postRequest.delegate = self;
        
        NSLog(@"Starting Http Request");
        [self.postRequest startAsynchronous];
        
        //请求已发送
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(requestDidSent:)]) {
            [_delegate requestDidSent:self];
        }
    }
}

- (void) postByUrl:(NSString *)url
{
    //设置url
    self.url = url;
    [self post];
}

//发送post请求,使用自定义post的URL,请求param参数
- (void) postByUrl:(NSString *)url param:(NSDictionary *)param
{
    //设置字典
    self.paramDict = param;
    //设置url
    self.url = url;
    [self post];
}

- (void) postData:(NSString *)url data:(NSData *)data
{
    //设置字典
    self.paramData = data;
    //设置url
    self.url = url;
    [self post];
}

- (void) postString:(NSString *)url string:(NSString *)string
{
    //设置字典
    self.paramString = string;
    //设置url
    self.url = url;
    [self post];
}

-(void) request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{    
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //请求结束
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(requestDidResponsed:)]) 
    {
        [_delegate requestDidResponsed:self];
    }
    
    NSString *responseString = [request responseString];
    NSLog(@"Recived String, Length=%d",responseString.length);
    
    if(responseString != NULL && responseString.length > 0)
    {
        //TODO: 清理换行符，代码重构时需要移动位置
        //去除\r\n
        responseString =  [[responseString 
                            stringByReplacingOccurrencesOfString:@"\r" withString:@""]
                           stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        self.resultString = responseString;
    }
    else
    {
        //请求结束
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(requestDidFailed:)])
        {
            [_delegate requestDidFailed:self];
        }
    }
    
    NSData *responseData = [request responseData];
    NSLog(@"Recived Data, Length=%d",responseData.length);
    
    if(responseData != NULL && responseData.length > 0){
        self.resultData = responseData;
    }else
    {
        //请求结束
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(requestDidFailed:)])
        {
            [_delegate requestDidFailed:self];
        }
    }
    
    //请求结束
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(requestDidFinished:)])
    {
        [_delegate requestDidFinished:self];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Recived Error: %@",error);
    
    //请求失败，检查parse失败,如果失败，则调用失败的委托方法
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(requestDidFailed:error:)]) 
    {
        [_delegate performSelector:@selector(requestDidFailed:error:) withObject:self withObject:error];
    }
}

- (void)cancelActiveRequest
{
    if (self.getRequest) {
        [self.getRequest clearDelegatesAndCancel];
        self.getRequest = nil;
    }
    if (self.postRequest) {
        [self.postRequest clearDelegatesAndCancel];
        self.getRequest = nil;
    }
}
@end
