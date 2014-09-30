//
//  MstV01StationGroup.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/29.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"


#define MSTV01_STATION_GROUP         @"MSTV01_STATION_GROUP"
#define MSTV01_STAT_ID               @"STAT_ID"
#define MSTV01_STAT_GROUP_ID         @"STAT_GROUP_ID"
#define MSTV01_LINE_ID               @"LINE_ID"
#define MSTV01_STAT_SEQ              @"STAT_SEQ"
#define MSTV01_STAT_METRO_ID         @"STAT_METRO_ID"
#define MSTV01_STAT_METRO_ID_FULL    @"STAT_METRO_ID_FULL"
#define MSTV01_STAT_NAME             @"STAT_NAME"
#define MSTV01_STAT_NAME_KANA        @"STAT_NAME_KANA"
#define MSTV01_STAT_NAME_ROME        @"STAT_NAME_ROME"
#define MSTV01_STAT_NAME_EXT1        @"STAT_NAME_EXT1"
#define MSTV01_STAT_NAME_EXT2        @"STAT_NAME_EXT2"
#define MSTV01_STAT_NAME_EXT3        @"STAT_NAME_EXT3"
#define MSTV01_STAT_NAME_EXT4        @"STAT_NAME_EXT4"
#define MSTV01_STAT_NAME_EXT5        @"STAT_NAME_EXT5"
#define MSTV01_STAT_NAME_EXT6        @"STAT_NAME_EXT6"
#define MSTV01_STAT_LON              @"STAT_LON"
#define MSTV01_STAT_LAT              @"STAT_LAT"
#define MSTV01_STAT_PREF             @"STAT_PREF"
#define MSTV01_STAT_ADDR             @"STAT_ADDR"
#define MSTV01_STAT_DESP             @"STAT_DESP"

@interface MstV01StationGroup : ODBDataTable{
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