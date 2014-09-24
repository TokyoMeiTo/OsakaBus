//
//  NSObject+NSString_Decimal.m
//  TokyoMetro
//
//  Created by limc on 2014/09/02.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "NSString+Decimal.h"
#import "NSString+CString.h"

@implementation NSString(Decimal)

- (NSString *) decimal;
{
    //定义格式化串
    NSNumberFormatter *decimalformatter = [[NSNumberFormatter alloc]init];
    decimalformatter.numberStyle = NSNumberFormatterDecimalStyle;
    [decimalformatter setMaximumFractionDigits:9];
    return [decimalformatter stringFromNumber:[NSNumber numberWithDouble:[[self numberic] doubleValue]]];
}


- (NSString *) zero
{
    return [self zeroIs:@"-"];
}

- (NSString *) zeroIsBlank
{
    return [self zeroIs:@""];
}

- (NSString *) zeroIsNil
{
    return [self zeroIs:nil];
}

- (NSString *) zeroIsSpace
{
    return [self zeroIs:@" "];
}

- (NSString *) zeroIs
{
    return [self zeroIs:@"-"];
}

- (NSString *) zeroIs:(NSString *)replace
{
    //如果当期值不是0
    if ([[self numberic] doubleValue] == 0)
    {
        return replace;
    }else {
        return self;
    }
}

- (NSString *) numberic;
{
    //字符串还原
    NSString *str = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (str.length  > 1 && [str floatValue] == 0.0 &&[[str substringToIndex:1]isEqualToString:@"-"]) {
        str = [str substringFromIndex:1];
    }
    //    str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    return str;
    
    
}
- (NSString *) decimal:(int)deci
{
    NSMutableString *ms = [[NSMutableString alloc]init];
    [ms appendString:@"###,###,###,##0"];
    if(deci != 0){
        [ms appendString:@"."];
    }
    for (int i = 0; i < deci; i++) {
        [ms appendString:@"0"];
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundDown];
    [numberFormatter setPositiveFormat:ms];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[[self numberic] doubleValue]]];
}

//- (NSString *) decimalCutTo:(int)deci {
//    self = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
//    NSString *str = [self decimal];
//    NSRange range = [str rangeOfString:@"."];
//
//    if (range.location == NSNotFound)
//    {
//        if (deci > 0) str = [str stringByAppendingString:@"."];
//        for (int i = 0; i < deci; i++) {
//            str = [str stringByAppendingString:@"0"];
//        }
//    }else {
//        int len = [str length];
//        if (len - range.location - 1 < deci) {
//            for (int i = 0; i < deci - (len - range.location - 1); i++) {
//                str = [str stringByAppendingString:@"0"];
//            }
//        }
//        else if (len - range.location - 1 > deci) {
//            if (deci == 0) {
//                str = [str substringToIndex:range.location];
//            }else {
//                str = [str substringToIndex:range.location + deci + 1];
//            }
//        }
//    }
//    return str;
//}

- (NSInteger) numberOfDecimal
{
    if (self && ![self isEqualToString:@""]) {
        if ([self indexOf:@"."]!= NSNotFound
            &&[self indexOf:@"."] < self.length -1) {
            return [[self substringFromIndex:[self indexOf:@"."] + 1] length];
        }
    }
    return 0;
}

- (NSString *)currency:(NSString *)code
{
    if ([code isEqualToString:@"HKD"]) {
        return [self decimal:3];
    }else if([code isEqualToString:@"USD"])
    {
        return [self decimal:2];
    }else if ([code isEqualToString:@"JPY"]) {
        return [self decimal:0];
    }else {
        return self;
    }
}

- (NSString *) decimalWithSign
{
    NSString *str = [self decimal];
    
    if ([[str numberic] doubleValue] > 0) {
        return [NSString stringWithFormat:@"+%@",str];
    }else {
        return str;
    }
}

- (NSString *) decimalWithSign:(NSUInteger)deci
{
    NSString *str = [self decimal:deci];
    if ([[str numberic] doubleValue] > 0) {
        return [NSString stringWithFormat:@"+%@",str];
    }else {
        return str;
    }
}

- (UIColor *) colorForSign
{
    if ([[self numberic] doubleValue] > 0)
    {
        return [UIColor redColor];
    }else if ([[self numberic] doubleValue] == 0)
    {
        return [UIColor blackColor];
    }else if ([[self numberic] doubleValue] < 0)
    {
        return [UIColor blueColor];
    }else {
        return nil;
    }
}

- (UIColor *) colorForCompare:(NSString *)value
{
    if ([[self numberic] doubleValue] > [[value numberic]doubleValue])
    {
        return [UIColor redColor];
    }else if ([[self numberic] doubleValue] == [[value numberic]doubleValue])
    {
        return [UIColor blackColor];
    }else if ([[self numberic] doubleValue] < [[value numberic]doubleValue])
    {
        return [UIColor blueColor];
    }else {
        return nil;
    }
}

- (UIColor *) colorForCompareDouble:(double)value
{
    if ([[self numberic] doubleValue] > value)
    {
        return [UIColor redColor];
    }else if ([[self numberic] doubleValue] == value)
    {
        return [UIColor blackColor];
    }else if ([[self numberic] doubleValue] < value)
    {
        return [UIColor blueColor];
    }else {
        return nil;
    }
}

- (BOOL) doubleValueIsEqualTo:(NSString *)value
{
    NSString *this = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *compareTo = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    if (fabs([this doubleValue] - [compareTo doubleValue]) >= 0.01) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL) unitCheck:(NSString *)unit
{
    NSDecimalNumber *divisor = [[NSDecimalNumber alloc]initWithString:unit];
    NSDecimalNumber *num = [[NSDecimalNumber alloc]initWithString:self];
    
    NSRoundingMode roundingMode = (([num doubleValue] < 0) ^ ([num doubleValue] < 0)) ? NSRoundUp : NSRoundDown;
    NSDecimalNumberHandler *rounding = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode
                                                                                              scale:0
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    
    NSDecimalNumber *quotient = [num decimalNumberByDividingBy:divisor withBehavior:rounding];
    NSDecimalNumber *subtract = [quotient decimalNumberByMultiplyingBy:divisor];
    
    NSComparisonResult result = [subtract compare:num];
    if (result == NSOrderedSame) {
        return YES;
    }
    
    return NO;
}

- (double) unitPart:(NSString *)unit
{
    NSDecimalNumber *divisor = [[NSDecimalNumber alloc]initWithString:unit];
    NSDecimalNumber *num = [[NSDecimalNumber alloc]initWithString:self];
    
    NSRoundingMode roundingMode = (([num doubleValue] < 0) ^ ([num doubleValue] < 0)) ? NSRoundUp : NSRoundDown;
    NSDecimalNumberHandler *rounding = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode
                                                                                              scale:0
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    
    NSDecimalNumber *quotient = [num decimalNumberByDividingBy:divisor withBehavior:rounding];
    NSDecimalNumber *subtract = [quotient decimalNumberByMultiplyingBy:divisor];
    
    return [subtract doubleValue];
}

@end