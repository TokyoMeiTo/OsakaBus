//
//  OAPAsyncParser.h
//  ONTSNetwork
//
//  Created by ohs on 12/04/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAPAsyncParserDelegate.h"

@interface OAPAsyncParser : NSObject {
    //需要被转换的对象
    id _objToBeParse;
    //转换后的对象
    id _objParsed;
    //转换委托
    id<OAPAsyncParserDelegate> _delegate;
    //用于标记parser
    int _tag;
}

@property (retain, nonatomic) id objToBeParse;
@property (retain, nonatomic) id objParsed;
@property (assign, nonatomic) id<OAPAsyncParserDelegate> delegate;
@property (assign, nonatomic) int tag;

//以下方法使用异步方式实现
- (void) asyncParse;
- (void) asyncParse:(id)obj;

//以下为两个共通同步方法，可以直接 被外部调用，亦可以再异步线程中使用
- (id) parseString:(NSString *) string;
- (id) parseData:(NSData *) data;

@end
