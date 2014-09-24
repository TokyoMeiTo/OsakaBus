//
//  OAPAsyncJSONParser.h
//  TokyoMetro
//
//  Created by limc on 2014/09/03.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "OAPAsyncParser.h"

@protocol OAPAsyncJSONParserDelegate <OAPAsyncParserDelegate>

@optional

-(NSUInteger) useParseOption:(id)parser;

@end

@interface OAPAsyncJSONParser : OAPAsyncParser

//解析选项
-(NSUInteger) parseOption;
//解析字典对象
-(void) convertDictionary:(NSDictionary *)dict;
//解析数组对象
-(void) convertArray:(NSArray *)arr;
//解析字符串对象
-(void) convertString:(NSString *)str;

@end