//
//  OAPAsyncCsvParser.m
//  ONTSNetwork
//
//  Created by ohs on 12/04/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OAPAsyncCsvParser.h"

#define OAP_ASYNC_CSV_PARSER_DATA_SPLITER @","
#define OAP_ASYNC_CSV_PARSER_LINE_SPLITER @";"

@interface OAPAsyncCsvParser(private)

- (NSArray *) parseCsvMultiLines:(NSString *) source;
- (NSArray *) parseCsvSingleLine:(NSString *) source;

@end

@implementation OAPAsyncCsvParser

@synthesize dataSpliter = _dataSpliter;
@synthesize lineSpliter = _lineSpliter;

- (void) dealloc
{
    [_dataSpliter release];
    [_lineSpliter release];
    
    [super dealloc];
}

- (id) init
{
    self = [super init];
    if(self)
    {
        _dataSpliter = OAP_ASYNC_CSV_PARSER_DATA_SPLITER;
        _lineSpliter = OAP_ASYNC_CSV_PARSER_LINE_SPLITER;
    }
    return self;
}

- (id) parseData:(NSData *) data
{
    //将数据转换为字符串
    NSString *str= [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    
    //使用字符串进行转换
    return [self parseString:str];
}

- (id) parseString:(NSString *) string
{
    NSArray *result;

    //开始调用
    result = [self parseCsvMultiLines:string];
    
    return result;
}

- (NSArray *) parseCsvMultiLines:(NSString *) source
{
    NSArray *result = nil;
    if(source)
    {
        //首先按照分号分割
        NSArray *rows = [source componentsSeparatedByString:_lineSpliter];
        NSMutableArray *arr = [[[NSMutableArray alloc]init]autorelease];
        
        //这里去除第一行报文行
        for (int i = 1 ;i <[rows count] ;i++)
        {
            NSString *str = [rows objectAtIndex:i];
            if(str && str.length)
            {
                NSArray *data = [self parseCsvSingleLine:str];
                
                //判断是否为空
                if (data && [data count] > 0) {
                    [arr addObject:data];
                }
            }
        }
        
        result = [[[NSArray alloc] initWithArray:arr]autorelease];
    }
    //返回
    return result; 
}

- (NSArray *) parseCsvSingleLine:(NSString *) source
{
    NSArray *result = nil;
    if(source && [source length])
    {
        //分割并返回
        result = [source componentsSeparatedByString:_dataSpliter];
    }
    //返回
    return result;  
}


@end
