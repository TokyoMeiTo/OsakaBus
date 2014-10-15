//
//  MstT04LandMarkTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define MSTT04_LANDMARK                     @"MSTT04_LANDMARK"
#define MSTT04_LANDMARK_LMAK_ID             @"LMAK_ID"
#define MSTT04_LANDMARK_LMAK_NAME           @"LMAK_NAME"
#define MSTT04_LANDMARK_LMAK_NAME_KANA      @"LMAK_NAME_KANA"
#define MSTT04_LANDMARK_LMAK_NAME_ROME      @"LMAK_NAME_ROME"
#define MSTT04_LANDMARK_LMAK_NAME_EXT1      @"LMAK_NAME_EXT1"
#define MSTT04_LANDMARK_LMAK_NAME_EXT2      @"LMAK_NAME_EXT2"
#define MSTT04_LANDMARK_LMAK_NAME_EXT3      @"LMAK_NAME_EXT3"
#define MSTT04_LANDMARK_LMAK_NAME_EXT4      @"LMAK_NAME_EXT4"
#define MSTT04_LANDMARK_LMAK_NAME_EXT5      @"LMAK_NAME_EXT5"
#define MSTT04_LANDMARK_LMAK_NAME_EXT6      @"LMAK_NAME_EXT6"
#define MSTT04_LANDMARK_LMAK_TYPE           @"LMAK_TYPE"
#define MSTT04_LANDMARK_LMAK_SUB_TYPE       @"LMAK_SUB_TYPE"
#define MSTT04_LANDMARK_LINE_ID             @"LINE_ID"
#define MSTT04_LANDMARK_STAT_ID             @"STAT_ID"
#define MSTT04_LANDMARK_STAT_EXIT_ID        @"STAT_EXIT_ID"
#define MSTT04_LANDMARK_PREF                @"LMAK_PREF"
#define MSTT04_LANDMARK_WARD                @"LMAK_WARD"
#define MSTT04_LANDMARK_RANK                @"LMAK_RANK"
#define MSTT04_LANDMARK_MICI_RANK           @"LMAK_MICI_RANK"
#define MSTT04_LANDMARK_LMAK_AVAL_TIME      @"LMAK_AVAL_TIME"
#define MSTT04_LANDMARK_LMAK_TICL_PRIC      @"LMAK_TICT_PRIC"
#define MSTT04_LANDMARK_LMAK_ADDR           @"LMAK_ADDR"
#define MSTT04_LANDMARK_LMAK_DESP           @"LMAK_DESP"
#define MSTT04_LANDMARK_OLIMPIC_FLAG        @"OLIMPIC_FLAG"
#define MSTT04_LANDMARK_EXIT_FLAG1          @"EXIT_FLAG1"
#define MSTT04_LANDMARK_EXIT_FLAG2          @"EXIT_FLAG2"
#define MSTT04_LANDMARK_EXIT_FLAG3          @"EXIT_FLAG3"
#define MSTT04_LANDMARK_EXIT_FLAG4          @"EXIT_FLAG4"
#define MSTT04_LANDMARK_IMAG_ID1            @"IMAG_ID1"
#define MSTT04_LANDMARK_IMAG_ID2            @"IMAG_ID2"
#define MSTT04_LANDMARK_IMAG_ID3            @"IMAG_ID3"
#define MSTT04_LANDMARK_IMAG_ID4            @"IMAG_ID4"
#define MSTT04_LANDMARK_IMAG_ID5            @"IMAG_ID5"
#define MSTT04_LANDMARK_LMAK_LON            @"LMAK_LON"
#define MSTT04_LANDMARK_LMAK_LAT            @"LMAK_LAT"
#define MSTT04_LANDMARK_READ_FLAG           @"READ_FLAG"
#define MSTT04_LANDMARK_READ_TIME           @"READ_TIME"
#define MSTT04_LANDMARK_FAVO_FLAG           @"FAVO_FLAG"
#define MSTT04_LANDMARK_FAVO_TIME           @"FAVO_TIME"

@interface MstT04LandMarkTable : ODBDataTable{
    
}

@property(copy,nonatomic) NSString* lmakId;
@property(copy,nonatomic) NSString* lmakName;
@property(copy,nonatomic) NSString* lmakNameKana;
@property(copy,nonatomic) NSString* lmakNameRome;
@property(copy,nonatomic) NSString* lmakNameExt1;
@property(copy,nonatomic) NSString* lmakNameExt2;
@property(copy,nonatomic) NSString* lmakNameExt3;
@property(copy,nonatomic) NSString* lmakNameExt4;
@property(copy,nonatomic) NSString* lmakNameExt5;
@property(copy,nonatomic) NSString* lmakNameExt6;
@property(copy,nonatomic) NSString* lmakType;
@property(copy,nonatomic) NSString* lmakSubType;
@property(copy,nonatomic) NSString* lineId;
@property(copy,nonatomic) NSString* statId;
@property(copy,nonatomic) NSString* statExitId;
@property(copy,nonatomic) NSString* lmakPref;
@property(copy,nonatomic) NSString* lmakWard;
@property(copy,nonatomic) NSString* lmakRank;
@property(copy,nonatomic) NSString* lmakMiciRank;
@property(copy,nonatomic) NSString* lmakAvalTime;
@property(copy,nonatomic) NSString* lmakTictPric;
@property(copy,nonatomic) NSString* lmakAddr;
@property(copy,nonatomic) NSString* lmakDesp;
@property(copy,nonatomic) NSString* olimpicFlag;
@property(copy,nonatomic) NSString* exitFlag1;
@property(copy,nonatomic) NSString* exitFlag2;
@property(copy,nonatomic) NSString* exitFlag3;
@property(copy,nonatomic) NSString* exitFlag4;
@property(copy,nonatomic) NSString* imagId1;
@property(copy,nonatomic) NSString* imagId2;
@property(copy,nonatomic) NSString* imagId3;
@property(copy,nonatomic) NSString* imagId4;
@property(copy,nonatomic) NSString* imagId5;
@property(copy,nonatomic) NSString* lmakLon;
@property(copy,nonatomic) NSString* lmakLat;
@property(copy,nonatomic) NSString* readFlag;
@property(copy,nonatomic) NSString* readTime;
@property(copy,nonatomic) NSString* favoFlag;
@property(copy,nonatomic) NSString* favoTime;

@end