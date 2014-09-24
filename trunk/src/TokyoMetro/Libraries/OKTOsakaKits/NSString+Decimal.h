//
//  NSString+Decimal.h
//  TokyoMetro
//
//  Created by limc on 2014/09/02.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString(Decimal)

//123456789.11->123,456,789.11
- (NSString *) decimal;

//0-> -
- (NSString *) zero;
//0->""
- (NSString *) zeroIsBlank;
//0->nil
- (NSString *) zeroIsNil;
//0->" "
- (NSString *) zeroIsSpace;
//0-> -
- (NSString *) zeroIs;
//0-> replace
- (NSString *) zeroIs:(NSString *)replace;

/*
 @"HKD" 返回三位小数点格式化字符
 @"USD" 返回两位小数点格式化字符
 @"JPY" 返回无小数点格式化字符
 */
- (NSString *) currency:(NSString *)code;

// deci=4 123456 ->123,456.0000 (截位)
- (NSString *) decimal:(int)deci;

// deci=4 123456 ->123,456.0000 (截位)
//- (NSString *) decimalCutTo:(int)deci;

// 123456 -> +123,456
- (NSString *) decimalWithSign;

// deci=4 123456-> +123,456.0000
- (NSString *) decimalWithSign:(NSUInteger)deci;

//正返回红色 0返回黑 负返回蓝色
- (UIColor *) colorForSign;

// self > value值返回红色 self = value值返回黑色 self < value值返回蓝色
- (UIColor *) colorForCompare:(NSString *)value;

// self > value值返回红色 self = value值返回黑色 self < value值返回蓝色
- (UIColor *) colorForCompareDouble:(double)value;

// 123,456,789 -> 123456789
- (NSString *) numberic;

// 返回小数位数
- (NSInteger) numberOfDecimal;

- (BOOL) doubleValueIsEqualTo:(NSString *)value;

//判断是否是呼值的整数倍
//unit呼值
//yes 整数倍 no 非整数倍
- (BOOL) unitCheck:(NSString *)unit;

//返回呼值整数倍部分
//unit呼值
- (double) unitPart:(NSString *)unit;

@end
