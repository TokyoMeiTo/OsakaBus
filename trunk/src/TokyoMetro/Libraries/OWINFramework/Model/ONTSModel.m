//
//  ONTSModel.m
//  ONTS
//
//  Created by ohs on 12/04/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ONTSModel.h"

#define  ONTS_MODEL_AUTO_REQUEST_MASK 100000

@interface ONTSModel(Private)

-(void) doMaskRequest:(ONWRequest *) request;
-(void) undoMaskRequest:(ONWRequest *) request;

@end

@implementation ONTSModel
@synthesize delegate = _delegate;

- (void)dealloc
{    
    [super dealloc];
}

-(id) initWithDelegate:(id<ONTSModelDelegate>)delegate
{
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (BOOL)shouldRequestBeSend:(ONWRequest *) request
{
    //如果是被mask的请求
    if (request.tag > ONTS_MODEL_AUTO_REQUEST_MASK) {
        //当前请求是否为独占
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(shouldReuqestCancelOthers:)]) {
            //判断是否为独占请求
            if ([_delegate performSelector:@selector(shouldReuqestCancelOthers:) withObject:request]) {
                return  NO;
            }
        }
    }
    return YES;
}

- (void)requestWillSend:(ONWRequest *) request
{
    //当前请求是否为独占
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(shouldReuqestCancelOthers:)]) {
        //判断是否为独占请求
        if ([_delegate performSelector:@selector(shouldReuqestCancelOthers:) withObject:request]) {
            //对请求不做任何处理，不设置mask
        }else {
            //mask请求
            [self doMaskRequest:request];
        }
    }else {
        //mask请求
        [self doMaskRequest:request];
    }
}

- (void) requestDidFinished:(ONWRequest *) request
{
    NSLog(@"string:%@",request.resultString);
    
    NSString *str = [request.resultString stringByReplacingOccurrencesOfString:@"	" withString:@"   "];
    str = [str stringByReplacingOccurrencesOfString:@"&#x1B;" withString:@""];

    request.resultString = str;
    
    
    //如果是被mask的请求
    if (request.tag > ONTS_MODEL_AUTO_REQUEST_MASK) {
        //当前请求是否为独占
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(shouldReuqestCancelOthers:)]) {
            //判断是否为独占请求
            if ([_delegate performSelector:@selector(shouldReuqestCancelOthers:) withObject:request]) {
                return;
            }
        }
        [self undoMaskRequest:request];
    }
    
    Class parserClassRef = [self parserClassForRequest:request tag:request.tag];
    if (parserClassRef !=NULL) {
        if ([request isKindOfClass:[OWINHttpRequest class]])
        {
            //初期化一个Parser
            OAPAsyncParser *parser = [[[parserClassRef alloc] initWithDelegate:self]autorelease];
            //设置Parser的tag
            parser.tag = request.tag;
            if ([(OWINHttpRequest *)request method] == ONWHttpRequestMethodGET) {
                //将代码转换为ShiftJIS编码
                parser.objToBeParse = [request.resultString dataUsingEncoding:NSUTF8StringEncoding];
            }else {
                //增加XML头部
                NSString *strToParse = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\" ?>%@",request.resultString];
                //去掉\x0
                strToParse = [strToParse stringByReplacingOccurrencesOfString:@"\x0" withString:@""];
                //使用UTF-8编码进行转换
                parser.objToBeParse = [strToParse dataUsingEncoding:NSUTF8StringEncoding];
            }
            //开始异步Parse
            [parser asyncParse];
        }
        else if ([request isKindOfClass:[OWINFilterSocketRequest class]])
        {
            //初期化一个Parser
            OAPAsyncParser *parser = [[[parserClassRef alloc] initWithDelegate:self]autorelease];
            //设置Parser的tag
            parser.tag = request.tag;
            //增加XML头部
            NSString *strToParse = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\" ?>%@",request.resultString];
            //使用UTF-8编码进行转换
            parser.objToBeParse = [strToParse dataUsingEncoding:NSUTF8StringEncoding];
            //开始转换
            [parser asyncParse];
        }
        else
        {
            //TODO: :提示开发者Request为空或非法
            NSLog(@"Request is not a valid Object");
        }
    }
    else 
    {
        //判断是列表的情况
        NSArray *classes = [self parserClassesForRequest:request tag:request.tag];
        if(classes != NULL)
        {
            for (Class classRef in classes) 
            {
                if (classRef !=NULL) {
                    if ([request isKindOfClass:[OWINHttpRequest class]])
                    {
                        //初期化一个Parser
                        OAPAsyncParser *parser = [[[classRef alloc] initWithDelegate:self]autorelease];
                        //设置Parser的tag
                        parser.tag = request.tag;
                        
                        if ([(OWINHttpRequest *)request method] == ONWHttpRequestMethodGET) {
                            //将代码转换为ShiftJIS编码
                            parser.objToBeParse = [request.resultString dataUsingEncoding:NSUTF8StringEncoding];
                        }else {
                            //增加XML头部
                            NSString *strToParse = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\" ?>%@",request.resultString];
                            //去掉\x0
                            strToParse = [strToParse stringByReplacingOccurrencesOfString:@"\x0" withString:@""];
                            //使用UTF-8编码进行转换
                            parser.objToBeParse = [strToParse dataUsingEncoding:NSUTF8StringEncoding];
                        }
                        //开始异步Parse
                        [parser asyncParse];
                    }
                    else if ([request isKindOfClass:[OWINFilterSocketRequest class]])
                    {
                        //初期化一个Parser
                        OAPAsyncParser *parser = [[[classRef alloc] initWithDelegate:self]autorelease];
                        //设置Parser的tag
                        parser.tag = request.tag;
                        //增加XML头部
                        NSString *strToParse = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\" ?>%@",request.resultString];
                        //使用UTF-8编码进行转换
                        parser.objToBeParse = [strToParse dataUsingEncoding:NSUTF8StringEncoding];
                        //开始转换
                        [parser asyncParse];
                    }
                    else
                    {
                        //TODO: :提示开发者Request为空或非法
                        NSLog(@"Request is not a valid Object");
                    }
                }
                else 
                {
                    
                }
            }
        }
        else
        {
            //TODO: :提示开发者需要实现asyncParserForRequest方法
            NSLog(@"please implement asyncParserForRequest method for async parse");
        }
    }
}


- (void) requestDidFailed:(ONWRequest *) request error:(NSError *)error
{
    if ([request isKindOfClass:[OWINHttpRequest class]])
    {  
        //区分HTTP错误
        switch (error.code) {
            case ASIConnectionFailureErrorType :
            {
                //连接失败
                if (_delegate != NULL && [_delegate respondsToSelector:@selector(onConnectionFailure)]) {
                    [_delegate performSelector:@selector(onConnectionFailure)];
                }
                break;
            }
            case ASIRequestTimedOutErrorType:
            {
                //连接超时
                if (_delegate != NULL && [_delegate respondsToSelector:@selector(onRequestTimeout)]) {
                    [_delegate performSelector:@selector(onRequestTimeout)];
                }
                break;
            }
            case ASIRequestCancelledErrorType:
            {   
                //请求取消
                if (_delegate != NULL && [_delegate respondsToSelector:@selector(onRequestCanceled)]) {
                    [_delegate performSelector:@selector(onRequestCanceled)];
                }
                break;
            }
            case ASIUnableToCreateRequestErrorType:
            {   
                //请求无法创建
                //请求取消
                if (_delegate != NULL && [_delegate respondsToSelector:@selector(onUnableToCreateRequest)]) {
                    [_delegate performSelector:@selector(onUnableToCreateRequest)];
                }
                break;
            }
            default:
            {
                //Http请求发生错误时
                if (_delegate != NULL && [_delegate respondsToSelector:@selector(onHttpReuqestError:)]) {
                    [_delegate performSelector:@selector(onHttpReuqestError:) withObject:error];
                }
                break;
            }
        }
        
        //Http请求发生错误时
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(modelAsyncDidFailed:data:)]) {
            [_delegate modelAsyncDidFailed:self data:nil];
        }
    }
    else if ([request isKindOfClass:[OWINFilterSocketRequest class]])
    {        
        //区分HTTP错误
        switch (error.code) {
            case AsyncSocketCFSocketError :
            {
                //连接失败
                //请求取消
                if (_delegate != NULL && [_delegate respondsToSelector:@selector(onConnectionFailure)]) {
                    [_delegate performSelector:@selector(onConnectionFailure)];
                }
                break;
            }
            case AsyncSocketCanceledError:
            {
                //连接超时
                if (_delegate != NULL && [_delegate respondsToSelector:@selector(onRequestCanceled)]) {
                    [_delegate performSelector:@selector(onRequestCanceled)];
                }
                break;
            }
            case AsyncSocketConnectTimeoutError:
            {   
                //请求取消
                if (_delegate != NULL && [_delegate respondsToSelector:@selector(onConnectionFailure)]) {
                    [_delegate performSelector:@selector(onConnectionFailure)];
                }
                break;
            }
            case AsyncSocketReadTimeoutError:
            {   
                //请求无法创建
                //连接超时
                if (_delegate != NULL && [_delegate respondsToSelector:@selector(onRequestTimeout)]) {
                    [_delegate performSelector:@selector(onRequestTimeout)];
                }
                break;
            }
            case AsyncSocketWriteTimeoutError:
            {   
                //请求无法创建
                //连接超时
                if (_delegate != NULL && [_delegate respondsToSelector:@selector(onRequestTimeout)]) {
                    [_delegate performSelector:@selector(onRequestTimeout)];
                }
                break;
            }
            default:
            {
                //Http请求发生错误时
                if (_delegate != NULL && [_delegate respondsToSelector:@selector(onSocketReuqestError:)]) {
                    [_delegate performSelector:@selector(onSocketReuqestError:) withObject:error];
                }
                break;
            }
        }
        
        //socket请求发生错误时
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(modelAsyncDidFailed:data:)]) {
            [_delegate modelAsyncDidFailed:self data:nil];
        }
    }
    else
    {
        //TODO: :提示开发者Request为空或非法
        NSLog(@"Request is not a valid Object");
    }
}

- (void) requestDidFailed:(ONWRequest *) request
{    
    if ([request isKindOfClass:[OWINHttpRequest class]])
    {        
        //Http请求发生错误时
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(modelAsyncDidFailed:data:)]) {
            [_delegate modelAsyncDidFailed:self data:nil];
        }
    }
    else if ([request isKindOfClass:[OWINFilterSocketRequest class]])
    {
        //socket请求发生错误时
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(modelAsyncDidFailed:data:)]) {
            [_delegate modelAsyncDidFailed:self data:nil];
        }
    }
    else
    {
        //TODO: :提示开发者Request为空或非法
        NSLog(@"Request is not a valid Object");
    }
}

- (void) parseDidFinished:(OAPAsyncParser *) parser;
{
    //TODO: :先进行基础类型拦截，处理错误等信息
    Class dataClassRef = [self dataClassForParser:parser tag:parser.tag];
    if (dataClassRef != NULL) {
        if ([parser.objParsed isKindOfClass:dataClassRef])
        {
            //使用类名反射on方法名 回调 onXXXX 格式
            NSString *selectorName = [NSString stringWithFormat:@"on%@:data:",NSStringFromClass(dataClassRef)];
            //请求结束
            if (_delegate != NULL && [_delegate respondsToSelector:NSSelectorFromString(selectorName)])
            {
                [_delegate performSelector:NSSelectorFromString(selectorName) withObject:self withObject:parser.objParsed];
            }
            
        }
        else if ([parser.objParsed isKindOfClass:[NSArray class]])
        {
            //使用类名反射on方法名,处理是数组的情况，回调 onXXXXs 格式
            NSString *selectorName = [NSString stringWithFormat:@"on%@s:data:",NSStringFromClass(dataClassRef)];
            //请求结束
            if (_delegate != NULL && [_delegate respondsToSelector:NSSelectorFromString(selectorName)])
            {
                [_delegate performSelector:NSSelectorFromString(selectorName) withObject:self withObject:parser.objParsed];
            }
        }
        else
        {
            //TODO: :提示开发者必须提供的Class类型不符合要求
            NSLog(@"dataClassForParser must be implemented");
            
            //请求结束
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(modelAsyncDidFinished:data:)])
            {
                [_delegate performSelector:@selector(modelAsyncDidFinished:data:) withObject:self withObject:parser.objParsed];
            }
            
        }
    }
    else 
    {
        //判断是列表的情况
        NSArray *classes = [self dataClassesForParser:parser tag:parser.tag];
        if(classes != NULL)
        {
            for (Class classRef in classes) 
            {
                if (classRef != NULL)
                {
                    if ([parser.objParsed isKindOfClass:classRef])
                    {
                        //使用类名反射on方法名 回调 onXXXX 格式
                        NSString *selectorName = [NSString stringWithFormat:@"on%@:data:",NSStringFromClass(classRef)];
                        //请求结束
                        if (_delegate != NULL && [_delegate respondsToSelector:NSSelectorFromString(selectorName)])
                        {
                            [_delegate performSelector:NSSelectorFromString(selectorName) withObject:self withObject:parser.objParsed];
                        }
                        
                    }
                    else if ([parser.objParsed isKindOfClass:[NSArray class]])
                    {
                        //使用类名反射on方法名,处理是数组的情况，回调 onXXXXs 格式
                        NSString *selectorName = [NSString stringWithFormat:@"on%@s:data:",NSStringFromClass(classRef)];
                        //请求结束
                        if (_delegate != NULL && [_delegate respondsToSelector:NSSelectorFromString(selectorName)])
                        {
                            [_delegate performSelector:NSSelectorFromString(selectorName) withObject:self withObject:parser.objParsed];
                        }
                    }
                }
                else
                {
                    //TODO: :提示class引用为空
                    NSLog(@"class reference is null");
                    //请求结束
                    if (_delegate != NULL && [_delegate respondsToSelector:@selector(modelAsyncDidFinished:data:)])
                    {
                        [_delegate performSelector:@selector(modelAsyncDidFinished:data:) withObject:self withObject:parser.objParsed];
                    }
                }
            }
        }
        else
        {
            //TODO: :提示class引用为空
            NSLog(@"dataClassesForParser must be implemented");
            //请求结束
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(modelAsyncDidFinished:data:)])
            {
                [_delegate performSelector:@selector(modelAsyncDidFinished:data:) withObject:self withObject:parser.objParsed];
            }
        }
    }
}

- (void) parseDidGotMessage:(OAPAsyncParser *) parser
{
    
    //-------------20130130二重送信服务端修正对应------------
    //  message的内容如果是[msg=duplex]，不弹出消息
    if (parser.objParsed && [parser.objParsed isEqualToString:@"duplex"]) {
        return;
    }
    //-------------20130130二重送信服务端修正对应------------
    
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(modelAsyncDidWithMessage:message:)]) {
        //处理第一位
        [_delegate modelAsyncDidWithMessage:self message:parser.objParsed];
    }
}

- (void) parseDidFailed:(OAPAsyncParser *) parser error:(NSError *)error;
{

    //区分HTTP错误
    switch (error.code) {
        case OWINAsyncXMLParserMsgNoDataError :
        {
            //连接失败
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(onResultNoData)]) {
                [_delegate performSelector:@selector(onResultNoData)];
            }
            break;
        }
        case OWINAsyncXMLParserSsrIsFalseError :
        {
            //连接失败
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(onServerSideLogout)]) {
                [_delegate performSelector:@selector(onServerSideLogout)];
            }
            break;
        }
        default:
        {
            //Http请求发生错误时
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(onParseError:)]) {
                [_delegate performSelector:@selector(onParseError:) withObject:error];
            }
        }
    }
    
    
//    //请求结束
//    if (_delegate != NULL && [_delegate respondsToSelector:@selector(modelAsyncDidFailed:data:)]) {
//        [_delegate modelAsyncDidFailed:self data:nil];
//    }
}

- (void) parseDidFailed:(OAPAsyncParser *) parser;
{
    NSLog(@"Parse Error");
//    //Parser 错误
//    if (_delegate != NULL && [_delegate respondsToSelector:@selector(onParseError:)]) {
//        [_delegate modelAsyncDidFailed:self data:nil];
//    }
}


-(void) cancelAllActiveRequest
{
}

- (Class) parserClassForRequest:(ONWRequest *) request tag:(int)tag
{
    return nil;
}

- (Class) dataClassForParser:(OAPAsyncParser *) parser tag:(int)tag
{
    return nil;
}

- (NSArray *) parserClassesForRequest:(ONWRequest *) request tag:(int)tag
{
    return nil;
}

- (NSArray *) dataClassesForParser:(OAPAsyncParser *) parser tag:(int)tag
{
    return nil;
}

-(void) doMaskRequest:(ONWRequest *) request
{
    if (request) {
        request.tag = request.tag + ONTS_MODEL_AUTO_REQUEST_MASK;
    }
}

-(void) undoMaskRequest:(ONWRequest *) request
{
    if (request) {
        if (request.tag >= ONTS_MODEL_AUTO_REQUEST_MASK) {
            request.tag = request.tag - ONTS_MODEL_AUTO_REQUEST_MASK;
        }
    }
}
@end
