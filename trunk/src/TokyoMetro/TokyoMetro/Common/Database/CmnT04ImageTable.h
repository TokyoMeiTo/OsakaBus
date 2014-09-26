//
//  CmnT04ImageTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/26.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define CMNT04_IMAGE        @"CMNT04_IMAGE"
#define CMNT04_IMAG_ID      @"IMAG_ID"
#define CMNT04_IMAG_PATH    @"IMAG_PATH"
#define CMNT04_IMAG_URL     @"IMAG_URL"

@interface CmnT04ImageTable : ODBDataTable{
    
}
@property(copy,nonatomic) NSString* imagId;
@property(copy,nonatomic) NSString* imagPath;
@property(copy,nonatomic) NSString* imagUrl;

@end
