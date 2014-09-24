//
//  OWINFilterSocketRequest.h
//  OWIN
//
//  Created by ohs on 12/08/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ONWSocketRequest.h"

@interface OWINFilterSocketRequest : ONWSocketRequest
{
    NSString *_cust;
    NSString *_cmp;
    NSString *_sss;
}

@property(copy,nonatomic)NSString *cust;
@property(copy,nonatomic)NSString *cmp;
@property(copy,nonatomic)NSString *sss;

@end
