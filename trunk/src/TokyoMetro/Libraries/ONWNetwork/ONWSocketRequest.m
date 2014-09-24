//
//  ONWSocketRequst.m
//  ONTSNetwork
//
//  Created by ohs on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ONWSocketRequest.h"

@implementation ONWSocketRequestProvider
@synthesize host = _host;
@synthesize port = _port;
@synthesize protocolType = _protocolType;
@synthesize socket = _socket;

static ONWSocketRequestProvider *socketProvider = nil;

//获取单例
+(ONWSocketRequestProvider *)getInstance
{
    @synchronized(self) 
    {
        if (socketProvider == nil) 
        {
            socketProvider = [[self alloc] init];
        }
    }
    return socketProvider;
}

- (void)dealloc
{
    [_host release];
    
    //以下方法待测试
    if (self.socket && [self.socket isConnected]) {
        [self.socket disconnect];
    }
    //清理delegate
    self.socket.delegate = nil;
    
    [_socket release];
    
    [super dealloc];
}

- (void)connect:(id)delegate
{
    @synchronized(self.socket) 
    {
        @try
        {
            if (nil == self.socket) {
                self.socket = [[AsyncSocket alloc]initWithDelegate:delegate];
            }
//            else {
//                if ([_socket isConnected]) {
//                    [_socket disconnect];
//                }
//            }
            self.host = @"210.255.211.19";
            self.port = 80;
            [self.socket connectToHost:self.host onPort:self.port withTimeout:-1 error:nil];
        }
        @catch (NSException *ex) {
            NSLog(@"NSException:%@",ex);
        }
        @finally {
            
        }
    }
}

//断开连接
- (void)disconnect
{
    @synchronized(self.socket) 
    {
        @try
        {
            //判断是否是连接状态
            if (self.socket && [self.socket isConnected]) {
                [self.socket disconnect];
            }
            
            self.socket.delegate = nil;
        }
        @catch (NSException *ex) {
            NSLog(@"NSException:%@",ex);
        }
        @finally {
            
        }
    }
}

- (AsyncSocket *)getSockWithDelegate:(id)delegate
{
    //判断是否需要连接
    if (nil == self.socket || ![self.socket isConnected]) {
        [self connect:delegate];
    }
    
    return self.socket;
}

@end

@implementation ONWSocketRequest

//@synthesize host = _host;
//@synthesize port = _port;
@synthesize param = _param;
//@synthesize protocolType = _protocolType;
@synthesize buffer = _buffer;

//static ONWSocketRequest *instance = nil;
//
////获取单例
//+(ONWSocketRequest *)getInstance
//{
//    @synchronized(self) 
//    {
//        if (instance == nil) 
//        {
//            instance = [[self alloc] init];
//        }
//    }
//    return instance;
//    
//    return [[[self alloc]init]autorelease];
//}

- (void)dealloc
{
//    [_host release];
    
    [[ONWSocketRequestProvider getInstance]disconnect];
    
    [_param release];
    
//    //以下方法待测试
//    if ([_socket isConnected]) {
//        [_socket disconnect];
//    }
//    
//    [_socket release];
    [_buffer release];
    
    [super dealloc];
}

//- (void) connect
//{
//    _socket = [[AsyncSocket alloc]initWithDelegate:self];
//    self.host = @"210.255.211.19";
//    self.port = 80;
//    [_socket connectToHost:self.host onPort:self.port withTimeout:-1 error:nil];
//}

- (void) send:(int) tag
{
    //判断是否需要连接
//    if (nil == _socket || NO ==  _socket.isConnected) {
//        [self connect];
//    }
    
//    if (self.host && self.host.length) {
//        if(self.param == NULL)
//        {
//            self.param = @"";
//        }
//        
//        if (self.protocolType == 0) {
//            self.protocolType = ONWSocketRequestProtocolTypeTCP;
//        }
//        
        //设置标签
        self.tag = tag;
        
        //获取socket
        AsyncSocket *sock = [[ONWSocketRequestProvider getInstance]getSockWithDelegate:self];
        //设置delegate
        sock.delegate = self;
        //延迟3秒内发送完毕
        [sock writeData:[self.param dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3 tag:tag];
//    }
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    NSLog(@"%@",newSocket);
}

- (BOOL)onSocketWillConnect:(AsyncSocket *)sock
{
    return YES;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    [sock readDataWithTimeout:-1 tag:self.tag];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSError *error = err;
    NSLog(@"Error: %@",error);
    //请求结束
    //请求失败，检查parse失败,如果失败，则调用失败的委托方法
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(requestDidFailed:error:)]) 
    {
        [_delegate performSelector:@selector(requestDidFailed:error:) withObject:self withObject:error];
    }
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    if ([sock canSafelySetDelegate]) {
        sock.delegate = nil;
    }
    sock = nil;
}

- (void)onSocketDidSecure:(AsyncSocket *)sock{
    NSLog(@"Error");
    //请求结束
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(requestDidFailed:)])
    {
        [_delegate requestDidFailed:self];
    }
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //继续读取数据
    [sock readDataWithTimeout:-1 tag:self.tag];
    //将Data转换为字符串
    NSString* utf8String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    //判断是否是报文头部
    if ([utf8String hasPrefix:@"<response"]||[utf8String hasPrefix:@"<preview"]||[utf8String hasPrefix:@"<stream"])
    {
        //判断buffer是否为NULL，用于创建对象
        if (self.buffer == nil)
        {
            self.buffer = [[[NSMutableData alloc]initWithData:data]autorelease];
        }else {
            [self.buffer setLength:0];
            [self.buffer appendData:data];
        }
        
    }else {
        [self.buffer appendData:data];
    }
    
    //判断是否是报文尾部，使用'>\x0'区分，通信协议内容
    if([utf8String hasSuffix:@"\x0"]) {
        //复制一份数据用于处理并返回
        self.resultData = [[self.buffer copy]autorelease];
        //清除XML中末尾的无效字符'\x0'
        NSString* contentString = [[[[NSString alloc] initWithData:self.resultData encoding:NSUTF8StringEncoding]autorelease] stringByReplacingOccurrencesOfString:@"\x0" withString:@""];
        
//        //去除\r\n
//        contentString =  [[contentString 
//                            stringByReplacingOccurrencesOfString:@"\x0A" withString:@""]
//                           stringByReplacingOccurrencesOfString:@"\x0D" withString:@""];
        
        NSLog(@"Hava received datas is :%@",contentString);
        
        //设置ResultString
        self.resultString = contentString;
        
        //请求结束
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(requestDidFinished:)])
        {
            [_delegate requestDidFinished:self];
        }
    }
}

- (void)cancelActiveRequest
{
    //关闭socket连接
    [[ONWSocketRequestProvider getInstance] disconnect];
}
@end
