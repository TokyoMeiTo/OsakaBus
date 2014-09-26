//
//  LinT06RouteDetailTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define LINT05_ROUTE_DETAIL                     @"LINT06_ROUTE_DETAIL"
#define LINT05_ROUTE_DETAIL_RUTE_ID             @"RUTE_ID"
#define LINT05_ROUTE_DETAIL_RUTE_ID_GROUP_ID    @"RUTE_ID_GROUP_ID"
#define LINT05_ROUTE_DETAIL_EXCH_STAT_ID        @"EXCH_STAT_ID"
#define LINT05_ROUTE_DETAIL_EXCH_LINE_ID        @"EXCH_LINE_ID"
#define LINT05_ROUTE_DETAIL_EXCH_DEST_ID        @"EXCH_DEST_ID"
#define LINT05_ROUTE_DETAIL_EXCH_TYPE           @"EXCH_TYPE"
#define LINT05_ROUTE_DETAIL_EXCH_SEQ            @"EXCH_SEQ"
#define LINT05_ROUTE_DETAIL_MOVE_TIME           @"MOVE_TIME"
#define LINT05_ROUTE_DETAIL_WAIT_TIME           @"WAIT_TIME"

@interface LinT05RouteDetailTable : ODBDataTable{
    
}

@property(copy,nonatomic) NSString* ruteId;
@property(copy,nonatomic) NSString* ruteIdGroupId;
@property(copy,nonatomic) NSString* exchStatId;
@property(copy,nonatomic) NSString* exchLineId;
@property(copy,nonatomic) NSString* exchDestId;
@property(copy,nonatomic) NSString* exchType;
@property(copy,nonatomic) NSNumber* exchSeq;
@property(copy,nonatomic) NSNumber* moveTime;
@property(copy,nonatomic) NSNumber* waitTime;

@end