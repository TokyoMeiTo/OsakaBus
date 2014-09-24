//
//  OWINAsyncXMLParser.m
//  OWIN
//
//  Created by ohs on 12/05/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OWINAsyncXMLParser.h"

@implementation OWINAsyncXMLParser
@synthesize serverMsg=_serverMsg;

- (void)dealloc
{
    [_serverMsg release];
    [super dealloc];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //清空数据
    if ([self.objParsed isKindOfClass:[NSArray class]]) {
        [self.objParsed removeAllObjects];
    }
    
    self.objParsed =nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"server"])
    {
        //flag为0时去除消息前的S,B
        if ([[attributeDict objectForKey:@"flag"] isEqualToString:@"0"]) {
            if ([attributeDict objectForKey:@"msg"] && [[attributeDict objectForKey:@"msg"] length] > 1) {
                self.objParsed=[[attributeDict objectForKey:@"msg"] substringFromIndex:1];
            }
        }else if ([[attributeDict objectForKey:@"flag"] isEqualToString:@"2"]) {
//            if ([attributeDict objectForKey:@"msg"] && [[attributeDict objectForKey:@"msg"] length] > 1) {
//                self.objParsed=[[attributeDict objectForKey:@"msg"] substringFromIndex:1];
//            }            
            //TODO: 可能会有特殊内容message的情况
            NSError *err = [NSError errorWithDomain:@"SocketDomain" code: OWINAsyncXMLParserSsrIsFalseError userInfo:nil];
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFailed:error:)]) {
                [_delegate performSelector:@selector(parseDidFailed:error:) withObject:self withObject:err];
            }
        }else  {
            self.objParsed=[attributeDict objectForKey:@"msg"];
        }
        
        //去除所有F开头的消息
        if ([self.objParsed hasPrefix:@"F"]) {
            self.objParsed = [self.objParsed substringFromIndex:1];
        }
    }
    if([elementName isEqualToString:@"response"])
    {
        NSString *ssr = [attributeDict objectForKey:@"ssr"];
        if ([ssr isEqualToString:@"true"])
        {
            //不做任何操作
        }else if ([ssr isEqualToString:@"false"]) 
        {
            NSError *err = [NSError errorWithDomain:@"SocketDomain" code: OWINAsyncXMLParserSsrIsFalseError userInfo:nil];
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFailed:error:)]) {
                [_delegate performSelector:@selector(parseDidFailed:error:) withObject:self withObject:err];
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    if([elementName isEqualToString:@"server"])
//    {
//        //请求到消息
//        if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidGotMessage:)]) {
//            [_delegate performSelector:@selector(parseDidGotMessage:) withObject:self];
//        }
//    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //获得了消息
    if ([self.objParsed isKindOfClass:[NSString class]]) {
        //请求到消息
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidGotMessage:)]) {
            [_delegate performSelector:@selector(parseDidGotMessage:) withObject:self];
        }
    }
    //数据对象不存在，调用转换错误
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFinished:)]) {
        [_delegate parseDidFinished:self];
    }
}

@end
