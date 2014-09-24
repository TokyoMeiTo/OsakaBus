//
//  OAPAsyncJSONParser.m
//  TokyoMetro
//
//  Created by limc on 2014/09/03.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//


#import "OAPAsyncJSONParser.h"

@implementation OAPAsyncJSONParser

- (void) asyncParse
{
    //准备开始数据转换
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseWillStart:)]) {
        [_delegate parseWillStart:self];
    }
    
    //判断是否符合Parse要求
    if(_objToBeParse)
    {
        NSError *error;
        id json = [NSJSONSerialization JSONObjectWithData:_objToBeParse
                                            options:[self parseOption] error:&error];
        if (json == nil) {
            NSLog(@"json parse failed!");
            //数据对象不存在，调用转换错误
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFailed:)]) {
                [_delegate parseDidFailed:self];
            }
            return;
        }
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            NSLog(@"json is parsed to Dictionary");
            [self convertDictionary:json];
            
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFinished:)]) {
                [_delegate parseDidFinished:self];
            }
            
        }else if ([json isKindOfClass:[NSArray class]]) {
            NSLog(@"json is parsed to Array");
            [self convertArray:json];
            
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFinished:)]) {
                [_delegate parseDidFinished:self];
            }
            
        }else if ([json isKindOfClass:[NSString class]]) {
            NSLog(@"json is parsed to String");
            [self convertString:json];
            
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFinished:)]) {
                [_delegate parseDidFinished:self];
            }
            
        }else{
            NSLog(@"json parse failed!");
            //数据对象不存在，调用转换错误
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(parseDidFailed:)]) {
                [_delegate parseDidFailed:self];
            }
            return;
        }
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

-(NSUInteger) parseOption{
    return kNilOptions;
}

-(void) convertDictionary:(NSDictionary *)dict
{
    self.objParsed = dict;
}

-(void) convertArray:(NSArray *)arr
{
    self.objParsed = arr;
}

-(void) convertString:(NSString *)str
{
    self.objParsed = str;

}

@end
