//
//  NSString+Datetime.m
//  TokyoMetro
//
//  Created by limc on 2014/09/02.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "NSString+Datetime.h"

@implementation NSString (Datetime)

- (NSString *) dateWithFormat:(NSString *)source target:(NSString *)target
{
    NSDateFormatter *sourceDateFormatter = [[NSDateFormatter alloc]init];
    [sourceDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    sourceDateFormatter.dateFormat = source;
    NSDateFormatter *targetDateFormatter = [[NSDateFormatter alloc]init];
    [targetDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    targetDateFormatter.dateFormat = target;
    NSString *str = [targetDateFormatter stringFromDate:[sourceDateFormatter dateFromString:self]];
    
    if (str == nil) {
        return @"";
    }else {
        return str;
    }
}

- (NSString *)plainDate
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"/" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"年" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"月" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"日" withString:@""];
    return str;
}

- (NSString *) yyyyMMddHHmmss
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:@"yyyyMMddHHmmss"];
}

- (NSString *) yyyyMMddHHmm
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:@"yyyyMMddHHmm"];
}

- (NSString *) yyyyMMdd
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:@"yyyyMMdd"];
}

- (NSString *) yyMMdd
{
    return [[self plainDate] dateWithFormat:@"yyyyMMdd" target:@"yyMMdd"];
}

- (NSString *) MMdd
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:@"MMdd"];
}

- (NSString *) HHmmss
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:@"HHmmss"];
}

- (NSString *) HHmm
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:@"HHmm"];
}

- (NSString *) yyyyMMddHHmm:(NSString *)split
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmm" target:[NSString stringWithFormat:@"yyyy%@MM%@dd HH:mm",split,split]];
}

- (NSString *) yyyyMMddHHmmss:(NSString *)split
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:[NSString stringWithFormat:@"yyyy%@MM%@dd HH:mm:ss",split,split]];
}

- (NSString *) yyyyMMdd:(NSString *)split
{
    return [[self plainDate] dateWithFormat:@"yyyyMMdd" target:[NSString stringWithFormat:@"yyyy%@MM%@dd",split,split]];
}

- (NSString *) yyMMdd:(NSString *)split
{
    return [[self plainDate] dateWithFormat:@"yyyyMMdd" target:[NSString stringWithFormat:@"yy%@MM%@dd",split,split]];
}

- (NSString *) MMdd:(NSString *)split
{
    return [[self plainDate] dateWithFormat:@"MMdd" target:[NSString stringWithFormat:@"MM%@dd",split]];
}

@end
