//
//  ODBNull.m
//  TokyoMetro
//
//  Created by limc on 2014/09/28.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "ODBNull.h"

@implementation ODBNull

+(ODBNull *)Value
{
    return [[[ODBNull alloc]init]autorelease];
}

-(NSString *)toString
{
    return @"NULL";
}

-(BOOL) isEquals:(ODBNull *)toCompare
{
    if (toCompare) {
        return [toCompare isKindOfClass:[ODBNull class]];
    }
    return YES;
}

-(BOOL) isEqualsToString:(NSString*)toCompare
{
    if (toCompare) {
        return [toCompare isEqualToString:@"NULL"]||
        [toCompare isEqualToString:@"null"]||
        [toCompare isEqualToString:@"(null)"]||
        [toCompare isEqualToString:@"Nil"]||
        [toCompare isEqualToString:@"nul"];
    }
    return NO;
}

@end