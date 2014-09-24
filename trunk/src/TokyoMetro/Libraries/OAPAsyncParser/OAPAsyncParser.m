//
//  OAPAsyncParser.m
//  ONTSNetwork
//
//  Created by ohs on 12/04/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OAPAsyncParser.h"

@interface OAPAsyncParser(private)

- (void) backgroudDataParseOver;
- (void) backgroudDataParse;

@end


@implementation OAPAsyncParser

@synthesize delegate = _delegate;
@synthesize objToBeParse = _objToBeParse;
@synthesize objParsed = _objParsed;
@synthesize tag = _tag;

- (void) dealloc
{
    [_objToBeParse release];
    [_objParsed release];
    
    [super dealloc];
}

- (id)initWithDelegate:(id<OAPAsyncParserDelegate>)delegate
{
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void) asyncParse
{
    //准备开始数据转换
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseWillStart:)]) {
        [_delegate parseWillStart:self];
    }
    
    //判断是否符合Parse要求
    if(_objToBeParse)
    {
        //在后台启动parse
        [NSThread detachNewThreadSelector:@selector(backgroudDataParse) toTarget:self withObject:nil];
    }
    else
    {
        //数据对象不存在，调用转换错误
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFailed:)]) {
            [_delegate parseDidFailed:self];
        }
    }
}

- (void) asyncParse:(id)obj
{
    //设置被parse的对象
    _objToBeParse = obj;
    [self asyncParse];
}

- (void) backgroudDataParseOver
{
    NSLog(@"Data Parse Over");
    
    //准备开始数据转换
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFinished:)]) {
        [_delegate parseDidFinished:self];
    }
}

- (void)backgroudDataParse
{
    NSLog(@"Start Data Parse");
    
    if ([self.objToBeParse isKindOfClass:[NSString class]]) {
       self.objParsed = [self parseString:self.objToBeParse];
    }else if([self.objToBeParse isKindOfClass:[NSData class]]){
       self.objParsed = [self parseData:self.objToBeParse];
    }
    
    //返回主线程
    [self performSelectorOnMainThread:@selector(backgroudDataParseOver) withObject:nil waitUntilDone:NO];
}

- (id) parseString:(NSString *) string
{
    return string;
}

- (id) parseData:(NSData *) data
{
    return data;
}

@end
