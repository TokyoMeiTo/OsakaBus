//
//  LinT04RouteTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/23.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define LINT04_ROUTE                        @"LINT04_ROUTE"
#define LINT04_ROUTE_RUTE_ID                @"RUTE_ID"
#define LINT04_ROUTE_START_STAT_ID          @"START_STAT_ID"
#define LINT04_ROUTE_START_STAT_NAME        @"START_STAT_NAME"
#define LINT04_ROUTE_TERM_STAT_ID           @"TERM_STAT_ID"
#define LINT04_ROUTE_TERM_STAT_NAME         @"TERM_STAT_NAME"
@interface LinT04RouteTable : ODBDataTable{
}

@property(copy,nonatomic)NSString* ruteId;
@property(copy,nonatomic)NSString* startStatId;
@property(copy,nonatomic)NSString* startStatName;
@property(copy,nonatomic)NSString* termStatId;
@property(copy,nonatomic)NSString* termStatName;

@end