//
//  StaT01StationExitTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/26.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define STAT01_STATION_EXIT             @"STAT01_STATION_EXIT"
#define STAT01_STAT_EXIT_ID             @"STAT_EXIT_ID"
#define STAT01_LINE_ID                  @"LINE_ID"
#define STAT01_STAT_ID                  @"STAT_ID"
#define STAT01_STAT_EXIT_NUM            @"STAT_EXIT_NUM"
#define STAT01_STAT_EXIT_NAME           @"STAT_EXIT_NAME"
#define STAT01_STAT_EXIT_TYPE           @"STAT_EXIT_TYPE"
#define STAT01_STAT_EXIT_LON            @"STAT_EXIT_LON"
#define STAT01_STAT_EXIT_LAT            @"STAT_EXIT_LAT"
#define STAT01_STAT_EXIT_FLOOR          @"STAT_EXIT_FLOOR"

@interface StaT01StationExitTable : ODBDataTable{
    
}
@property(copy,nonatomic) NSString* statExitId;
@property(copy,nonatomic) NSString* lineId;
@property(copy,nonatomic) NSString* statId;
@property(copy,nonatomic) NSString* statExitNum;
@property(copy,nonatomic) NSString* statExitName;
@property(copy,nonatomic) NSNumber* statExitType;
@property(copy,nonatomic) NSNumber* statExitLon;
@property(copy,nonatomic) NSNumber* statExitLat;
@property(copy,nonatomic) NSNumber* statExitFloor;
@end