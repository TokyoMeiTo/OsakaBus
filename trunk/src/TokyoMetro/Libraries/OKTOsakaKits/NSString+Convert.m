//
//  NSString+Convert.m
//  TokyoMetro
//
//  Created by limc on 2014/09/02.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "NSString+Convert.h"

@implementation NSString (Convert)

//"" -> nil
-(NSString *) blankIsNil
{
    return [self blankIs:nil];
}
//"" -> " "
-(NSString *) blankIsSpace
{
    return [self blankIs:@" "];
}
//"" -> 0
-(NSString *) blankIsZero
{
    return [self blankIs:@"0"];
}
//"" -> replace
-(NSString *) blankIs:(NSString *)replace
{
    if ([self isEqualToString:@""])
    {
        return replace;
    }else {
        return self;
    }
}


//" " -> nil
-(NSString *) spaceIsNil
{
    return [self spaceIs:nil];
}
//" " -> ""
-(NSString *) spaceIsBlank
{
    return [self spaceIs:@""];
}
//" " -> 0
-(NSString *) spaceIsZero
{
    return [self spaceIs:@"0"];
}
//" " -> replace
-(NSString *) spaceIs:(NSString *)replace
{
    if ([self isEqualToString:@" "])
    {
        return replace;
    }else {
        return self;
    }
}

@end
