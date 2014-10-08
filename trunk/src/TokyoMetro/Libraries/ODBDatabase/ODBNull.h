//
//  ODBNull.h
//  TokyoMetro
//
//  Created by limc on 2014/09/28.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODBNull : NSObject
+(ODBNull *)Value;
-(NSString *)toString;
-(BOOL) isEquals:(ODBNull *)toCompare;
-(BOOL) isEqualsToString:(NSString*)toCompare;
@end
