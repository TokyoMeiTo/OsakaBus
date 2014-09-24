//
//  OAPAsyncParserDelegate.h
//  ONTSNetwork
//
//  Created by ohs on 12/04/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OAPAsyncParserDelegate <NSObject>

@optional
//数据转换即将开始
- (void) parseWillStart:(id) parser;

//数据转换完成
- (void) parseDidFinished:(id) parser;

//数据转换失败
- (void) parseDidFailed:(id) parser error:(id)err;

//数据转换失败
- (void) parseDidFailed:(id) parser;

@end
