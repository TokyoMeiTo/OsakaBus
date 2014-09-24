//
//  MstT03LineStationTable.h
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/12.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define MSTT03_LINE_STATION               @"MSTT03_LINE_STATION"
#define MSTT03_STAT_ID                    @"STAT_ID"
#define MSTT03_LINE_ID                    @"LINE_ID"
#define MSTT03_STAT_SEQ                   @"STAT_SEQ"


@interface MstT03LineStationTable : ODBDataTable{
}
@property (copy,nonatomic) NSString* statId;
@property (copy,nonatomic) NSString* lineId;
@property (copy,nonatomic) NSString* statSeq;

@end