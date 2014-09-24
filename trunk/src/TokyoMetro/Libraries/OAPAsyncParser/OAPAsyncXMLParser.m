//
//  OAPAsyncXMLParser.m
//  OkasanNetworkTest
//
//  Created by ohs on 12/05/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OAPAsyncXMLParser.h"

@implementation OAPAsyncXMLParser
@synthesize xmlParser = _xmlParser;

- (void) dealloc
{
    [_xmlParser release];
    [super dealloc];
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
        
        NSXMLParser *parser = [[[[NSXMLParser alloc]init]initWithData:_objToBeParse]autorelease];
        parser.delegate = self;
        [parser parse];
        
        self.xmlParser = parser;
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

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //数据对象不存在，调用转换错误
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFinished:)]) {
        [_delegate parseDidFinished:self];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@",parseError);
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFailed:error:)]) {
        [_delegate parseDidFailed:self error:parseError];
    }
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    NSLog(@"%@",validationError);
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFailed:error:)]) {
        [_delegate parseDidFailed:self error:validationError];
    }
}

@end
