//
//  ONWRequestDelegate.h
//  ONTSNetwork
//
//  Created by ohs on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ONWRequestDelegate <NSObject>

@optional

//服务端请求是否被发送
- (BOOL) shouldRequestBeSend:(id) request;
//服务端请求即将被发送
- (void) requestWillSend:(id) request;
//服务端请求已发送，客户端等待接受服务端传入数据
- (void) requestDidSent:(id) request;
//服务端请求被响应，已成功接受数据
- (void) requestDidResponsed:(id) request;
//服务端请求结束
- (void) requestDidFinished:(id) request;
//请求发生错误，或失败
- (void) requestDidFailed:(id) request;
//请求发生错误，或失败
- (void) requestDidFailed:(id) request error:(id)error;

@end
