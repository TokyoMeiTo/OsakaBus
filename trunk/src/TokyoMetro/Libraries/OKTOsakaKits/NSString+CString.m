//
//  NSString+CString.m
//  TokyoMetro
//
//  Created by limc on 2014/09/02.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "NSString+CString.h"

@implementation NSString (CString)
//查找和替换
-(NSString *) replaceAll:(NSString *)search target:(NSString *)target
{
    NSString *str = [self stringByReplacingOccurrencesOfString:search withString:target];
    return str;
}

//对应位置插入
-(NSString *) insertAt:(NSString *)str post:(NSUInteger)post
{
    NSString *str1 = [self substringToIndex:post];
    NSString *str2 = [self substringFromIndex:post];
    return [[str1 stringByAppendingString:str]stringByAppendingString:str2];
}

-(NSUInteger) indexOf:(NSString *)str
{
    if (str == nil) {
        return NSNotFound;
    }
    
    if ([str isEqualToString:@""]) {
        return NSNotFound;
    }
    
    return [self rangeOfString:str].location;
}

//尾部位置追加
-(NSString *) append:(NSString *)str
{
    return [self stringByAppendingString:str];
}

//头部位置插入
-(NSString *) concate:(NSString *)str
{
    return [str stringByAppendingString:self];
}

//对应字符分割
-(NSArray *) split:(NSString *)split
{
    return [self componentsSeparatedByString:split];
}

//去除多余的空白字符
-(NSString *) trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//去除多余的特定字符
-(NSString *) trim:(NSString *)trim
{
    NSString *str = self;
    str = [str trimLeft:trim];
    str = [str trimRight:trim];
    return str;
}

//去除左边多余的空白字符
-(NSString *) trimLeft
{
    return [self trimLeft:@" "];
}

//去除左边多余的特定字符
-(NSString *) trimLeft:(NSString *)trim
{
    NSString *str = self;
    while ([str hasPrefix:trim]) {
        str = [str substringFromIndex:[trim length]];
    }
    return str;
}

//去除右边多余的空白字符
-(NSString *) trimRight
{
    return [self trimRight:@" "];
}

//去除右边多余的特定字符
-(NSString *) trimRight:(NSString *)trim
{
    NSString *str = self;
    while ([str hasSuffix:trim])
    {
        str = [str substringToIndex:([str length] - [trim length])];
    }
    return str;
}

//取得字符串的左边特定字符数
-(NSString *) left:(NSUInteger)num
{
    //TODO:判断Index
    return [self substringToIndex:num];
}

//取得字符串的右边特定字符数
-(NSString *) right:(NSUInteger)num
{
    //TODO:判断Index
    return [self substringFromIndex:([self length] - num)];
}

//取得字符串的右边特定字符数
-(NSString *) left:(NSUInteger) left right:(NSUInteger) right
{
    return [[self left:left]right:right];
}

-(NSString *) right:(NSUInteger) right left:(NSUInteger) left
{
    return [[self right:right]left:left];
}
@end
