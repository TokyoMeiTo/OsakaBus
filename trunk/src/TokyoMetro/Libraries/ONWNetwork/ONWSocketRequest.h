//
//  ONWSocketRequst.h
//  ONTSNetwork
//
//  Created by ohs on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONWRequest.h"
#import "ONWRequestDelegate.h"
#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"

typedef enum{
    ONWSocketRequestProtocolTypeTCP = 1,
    ONWSocketRequestProtocolTypeUDP
    
}ONWSocketRequestProtocolType;

@interface ONWSocketRequestProvider : NSObject{
    NSString *_host;
    unsigned int _port;
    ONWSocketRequestProtocolType _protocolType;
    
    AsyncSocket *_socket;
}

@property(copy,nonatomic) NSString *host;
@property(assign,nonatomic) unsigned int port;
@property(assign,nonatomic) ONWSocketRequestProtocolType protocolType;
@property(retain,nonatomic) AsyncSocket *socket;

//连接
- (void)connect:(id)delegate;
//断开连接
- (void)disconnect;
//获取sock对象使用delegate
- (AsyncSocket *)getSockWithDelegate:(id)delegate;

//获取单例
+(ONWSocketRequestProvider *)getInstance;

@end

@interface ONWSocketRequest : ONWRequest<AsyncSocketDelegate,AsyncUdpSocketDelegate> {
//    NSString *_host;
//    unsigned int _port;
//    ONWSocketRequestProtocolType _protocolType;
    
    NSString *_param;
    
//    AsyncSocket *_socket;
//    AsyncUdpSocket *_udpSocket;
    
    NSMutableData *_buffer;
}

//@property(copy,nonatomic) NSString *host;
@property(copy,nonatomic) NSString *param;
//@property(assign,nonatomic) unsigned int port;
//@property(assign,nonatomic) ONWSocketRequestProtocolType protocolType;

@property(retain,nonatomic) NSMutableData *buffer;

//向服务端发送数据
- (void) send:(int) tag;

////获取单例
//+(ONWSocketRequest *)getInstance;

//取消有效请求
- (void) cancelActiveRequest;

@end

