//
//  MstT02StationTable.h
//  TokyoMetro
//
//  Created by caowj on 14-9-12.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"


#define MSTT02_STATION               @"MSTT02_STATION"
#define MSTT02_STAT_ID               @"STAT_ID"
#define MSTT02_STAT_GROUP_ID         @"STAT_GROUP_ID"
#define MSTT02_LINE_ID               @"LINE_ID"
#define MSTT02_STAT_SEQ              @"STAT_SEQ"
#define MSTT02_STAT_METRO_ID         @"STAT_METRO_ID"
#define MSTT02_STAT_METRO_ID_FULL    @"STAT_METRO_ID_FULL"
#define MSTT02_STAT_NAME             @"STAT_NAME"
#define MSTT02_STAT_NAME_KANA        @"STAT_NAME_KANA"
#define MSTT02_STAT_NAME_ROME        @"STAT_NAME_ROME"
#define MSTT02_STAT_NAME_EXIT1       @"STAT_NAME_EXTI1"
#define MSTT02_STAT_NAME_EXIT2       @"STAT_NAME_EXTI2"
#define MSTT02_STAT_NAME_EXIT3       @"STAT_NAME_EXTI3"
#define MSTT02_STAT_NAME_EXIT4       @"STAT_NAME_EXTI4"
#define MSTT02_STAT_NAME_EXIT5       @"STAT_NAME_EXTI5"
#define MSTT02_STAT_NAME_EXIT6       @"STAT_NAME_EXTI6"
#define MSTT02_STAT_LON              @"STAT_LON"
#define MSTT02_STAT_LAT              @"STAT_LAT"
#define MSTT02_STAT_PREF             @"STAT_PREF"
#define MSTT02_STAT_ADDR             @"STAT_ADDR"
#define MSTT02_STAT_DESP             @"STAT_DESP"

@interface MstT02StationTable : ODBDataTable{
}

@property(copy, nonatomic) NSString* statId;
@property(copy, nonatomic) NSString* statGroupId;
@property(copy, nonatomic) NSString* lineId;
@property(copy, nonatomic) NSString* statSeq;
@property(copy, nonatomic) NSString* statNameMetroId;
@property(copy, nonatomic) NSString* statNameMetroIdFull;
@property(copy, nonatomic) NSString* statNameExit1;
@property(copy, nonatomic) NSString* statNameExit2;
@property(copy, nonatomic) NSString* statNameExit3;
@property(copy, nonatomic) NSString* statNameExit4;
@property(copy, nonatomic) NSString* statNameExit5;
@property(copy, nonatomic) NSString* statNameExit6;
@property(copy, nonatomic) NSString* statName;
@property(copy, nonatomic) NSString* statNameKana;
@property(copy, nonatomic) NSString* statNameRome;
@property(copy, nonatomic) NSString* statLon;
@property(copy, nonatomic) NSString* statLat;
@property(copy, nonatomic) NSString* statPref;
@property(copy, nonatomic) NSString* statAddr;
@property(copy, nonatomic) NSString* statDesp;


@end