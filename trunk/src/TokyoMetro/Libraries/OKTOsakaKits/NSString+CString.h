//
//  NSString+CString.h
//  TokyoMetro
//
//  Created by limc on 2014/09/02.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CString)
//查找和替换
-(NSString *) replaceAll:(NSString *)str target:(NSString *)target;
//对应位置插入
-(NSString *) insertAt:(NSString *)str post:(NSUInteger)post;
//字符串查找
-(NSUInteger) indexOf:(NSString *)str;
//尾部位置追加
-(NSString *) append:(NSString *)str;
//头部位置插入
-(NSString *) concate:(NSString *)str;
//对应字符分割
-(NSArray *) split:(NSString *)split;
//去除多余的空白字符
-(NSString *) trim;
//去除多余的特定字符
-(NSString *) trim:(NSString *)trim;
//去除左边多余的空白字符
-(NSString *) trimLeft;
//去除左边多余的特定字符
-(NSString *) trimLeft:(NSString *)trim;
//去除右边多余的空白字符
-(NSString *) trimRight;
//去除右边多余的特定字符
-(NSString *) trimRight:(NSString *)trim;

//取得字符串的左边特定字符数
-(NSString *) left:(NSUInteger)num;
//取得字符串的右边特定字符数
-(NSString *) right:(NSUInteger)num;
//取得字符串的左边右边特定字符数
-(NSString *) left:(NSUInteger) left right:(NSUInteger) right;
//取得字符串的右边左边特定字符数
-(NSString *) right:(NSUInteger) right left:(NSUInteger) left;
@end
