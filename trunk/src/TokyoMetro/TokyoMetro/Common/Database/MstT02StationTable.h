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
#define MSTT02_STAT_NAME_EXT1        @"STAT_NAME_EXT1"
#define MSTT02_STAT_NAME_EXT2        @"STAT_NAME_EXT2"
#define MSTT02_STAT_NAME_EXT3        @"STAT_NAME_EXT3"
#define MSTT02_STAT_NAME_EXT4        @"STAT_NAME_EXT4"
#define MSTT02_STAT_NAME_EXT5        @"STAT_NAME_EXT5"
#define MSTT02_STAT_NAME_EXT6        @"STAT_NAME_EXT6"
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
@property(copy, nonatomic) NSString* statNameExt1;
@property(copy, nonatomic) NSString* statNameExt2;
@property(copy, nonatomic) NSString* statNameExt3;
@property(copy, nonatomic) NSString* statNameExt4;
@property(copy, nonatomic) NSString* statNameExt5;
@property(copy, nonatomic) NSString* statNameExt6;
@property(copy, nonatomic) NSString* statName;
@property(copy, nonatomic) NSString* statNameKana;
@property(copy, nonatomic) NSString* statNameRome;
@property(copy, nonatomic) NSString* statLon;
@property(copy, nonatomic) NSString* statLat;
@property(copy, nonatomic) NSString* statPref;
@property(copy, nonatomic) NSString* statAddr;
@property(copy, nonatomic) NSString* statDesp;


@end