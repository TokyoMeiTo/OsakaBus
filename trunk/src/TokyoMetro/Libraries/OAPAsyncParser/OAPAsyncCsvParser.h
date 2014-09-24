//
//  OAPAsyncCsvParser.h
//  ONTSNetwork
//
//  Created by ohs on 12/04/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OAPAsyncParser.h"

@interface OAPAsyncCsvParser : OAPAsyncParser
{
    NSString *_lineSpliter;
    NSString *_dataSpliter;
    
    NSArray *_keys;
}

@property(copy , nonatomic)NSString *lineSpliter;
@property(copy , nonatomic)NSString *dataSpliter;


@end
