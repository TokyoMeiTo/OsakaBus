//
//  MstT04LandMarkTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "MstT04LandMarkTable.h"

@implementation MstT04LandMarkTable

@synthesize lmakId;
@synthesize lmakName;
@synthesize lmakNameKana;
@synthesize lmakNameRome;
@synthesize lmakNameExt1;
@synthesize lmakNameExt2;
@synthesize lmakNameExt3;
@synthesize lmakNameExt4;
@synthesize lmakNameExt5;
@synthesize lmakNameExt6;
@synthesize lmakType;
@synthesize lmakSubType;
@synthesize statId;
@synthesize statExitId;
@synthesize statExitTime;
@synthesize lmakPref;
@synthesize lmakWard;
@synthesize lmakRank;
@synthesize lmakMiciRank;
@synthesize lmakAvalTime;
@synthesize lmakAddr;
@synthesize lmakDesp;
@synthesize olimpicFlag;
@synthesize exitFlag1;
@synthesize exitFlag2;
@synthesize exitFlag3;
@synthesize exitFlag4;
@synthesize imagId1;
@synthesize imagId2;
@synthesize imagId3;
@synthesize imagId4;
@synthesize imagId5;
@synthesize lmakLon;
@synthesize lmakLat;
@synthesize readFlag;
@synthesize readTime;
@synthesize favoFlag;
@synthesize favoTime;
@synthesize lmakPricMin;
@synthesize lmakPricMax;

-(id)init{
    self = [super init];
    if (self) {
        self.tableName = MSTT04_LANDMARK;
        self.columns = [NSArray arrayWithObjects:
                        MSTT04_LANDMARK_LMAK_ID,
                        MSTT04_LANDMARK_LMAK_NAME,
                        MSTT04_LANDMARK_LMAK_NAME_KANA,
                        MSTT04_LANDMARK_LMAK_NAME_ROME,
                        MSTT04_LANDMARK_LMAK_NAME_EXT1,
                        MSTT04_LANDMARK_LMAK_NAME_EXT2,
                        MSTT04_LANDMARK_LMAK_NAME_EXT3,
                        MSTT04_LANDMARK_LMAK_NAME_EXT4,
                        MSTT04_LANDMARK_LMAK_NAME_EXT5,
                        MSTT04_LANDMARK_LMAK_NAME_EXT6,
                        MSTT04_LANDMARK_LMAK_TYPE,
                        MSTT04_LANDMARK_LMAK_SUB_TYPE,
                        MSTT04_LANDMARK_STAT_ID,
                        MSTT04_LANDMARK_STAT_EXIT_ID,
                        MSTT04_LANDMARK_STAT_EXIT_TIME,
                        MSTT04_LANDMARK_PREF,
                        MSTT04_LANDMARK_WARD,
                        MSTT04_LANDMARK_RANK,
                        MSTT04_LANDMARK_MICI_RANK,
                        MSTT04_LANDMARK_LMAK_AVAL_TIME,
                        MSTT04_LANDMARK_LMAK_TICL_PRIC,
                        MSTT04_LANDMARK_LMAK_PRIC_MIN,
                        MSTT04_LANDMARK_LMAK_PRIC_MAX,
                        MSTT04_LANDMARK_LMAK_ADDR,
                        MSTT04_LANDMARK_LMAK_DESP,
                        MSTT04_LANDMARK_OLIMPIC_FLAG,
                        MSTT04_LANDMARK_EXIT_FLAG1,
                        MSTT04_LANDMARK_EXIT_FLAG2,
                        MSTT04_LANDMARK_EXIT_FLAG3,
                        MSTT04_LANDMARK_EXIT_FLAG4,
                        MSTT04_LANDMARK_IMAG_ID1,
                        MSTT04_LANDMARK_IMAG_ID2,
                        MSTT04_LANDMARK_IMAG_ID3,
                        MSTT04_LANDMARK_IMAG_ID4,
                        MSTT04_LANDMARK_IMAG_ID5,
                        MSTT04_LANDMARK_LMAK_LON,
                        MSTT04_LANDMARK_LMAK_LAT,
                        MSTT04_LANDMARK_READ_FLAG,
                        MSTT04_LANDMARK_READ_TIME,
                        MSTT04_LANDMARK_FAVO_FLAG,
                        MSTT04_LANDMARK_FAVO_TIME, nil];
        self.dataTypes = [NSArray arrayWithObjects:
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT, nil];
        self.primaryKeys = [NSArray arrayWithObjects:MSTT04_LANDMARK_LMAK_ID, nil];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqualToString:MSTT04_LANDMARK_LMAK_ID]) {
        self.lmakId = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME]){
        self.lmakName = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_KANA]){
        self.lmakNameKana = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_ROME]){
        self.lmakNameRome = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_EXT1]){
        self.lmakNameExt1 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_EXT2]){
        self.lmakNameExt2 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_EXT3]){
        self.lmakNameExt3 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_EXT4]){
        self.lmakNameExt4 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_EXT5]){
        self.lmakNameExt5 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_EXT6]){
        self.lmakNameExt6 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_TYPE]){
        self.lmakType = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_SUB_TYPE]){
        self.lmakSubType = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_STAT_ID]){
        self.statId = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_STAT_EXIT_ID]){
        self.statExitId = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_STAT_EXIT_TIME]){
        self.statExitTime = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_PREF]){
        self.lmakPref = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_WARD]){
        self.lmakWard = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_RANK]){
        self.lmakRank = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_MICI_RANK]){
        self.lmakMiciRank = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_AVAL_TIME]){
        self.lmakAvalTime = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_TICL_PRIC]){
        self.lmakTictPric = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_PRIC_MIN]){
        self.lmakPricMin = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_PRIC_MAX]){
        self.lmakPricMax = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_ADDR]){
        self.lmakAddr = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_DESP]){
        self.lmakDesp = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_OLIMPIC_FLAG]){
        self.olimpicFlag = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_EXIT_FLAG1]){
        self.exitFlag1 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_EXIT_FLAG2]){
        self.exitFlag2 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_EXIT_FLAG3]){
        self.exitFlag3 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_EXIT_FLAG4]){
        self.exitFlag4 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_IMAG_ID1]){
        self.imagId1 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_IMAG_ID2]){
        self.imagId2 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_IMAG_ID3]){
        self.imagId3 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_IMAG_ID4]){
        self.imagId4 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_IMAG_ID5]){
        self.imagId5 = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_LON]){
        self.lmakLon = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_LAT]){
        self.lmakLat = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_READ_FLAG]){
        self.readFlag = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_READ_TIME]){
        self.readTime = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_FAVO_FLAG]){
        self.favoFlag = value;
    }else if ([item isEqualToString:MSTT04_LANDMARK_FAVO_TIME]){
        self.favoTime = value;
    }else{
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqualToString:MSTT04_LANDMARK_LMAK_ID]) {
        return self.lmakId;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME]){
        return self.lmakName;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_KANA]){
        return self.lmakNameKana;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_ROME]){
        return self.lmakNameRome;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_EXT1]){
        return self.lmakNameExt1;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_EXT2]){
        return self.lmakNameExt2;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_EXT3]){
        return self.lmakNameExt3;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_EXT4]){
        return self.lmakNameExt4;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_EXT5]){
        return self.lmakNameExt5;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_NAME_EXT6]){
        return self.lmakNameExt6;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_TYPE]){
        return self.lmakType;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_SUB_TYPE]){
        return self.lmakSubType;
    }else if ([item isEqualToString:MSTT04_LANDMARK_STAT_ID]){
        return self.statId;
    }else if ([item isEqualToString:MSTT04_LANDMARK_STAT_EXIT_ID]){
        return self.statExitId;
    }else if ([item isEqualToString:MSTT04_LANDMARK_STAT_EXIT_TIME]){
	return self.statExitTime;
    }else if ([item isEqualToString:MSTT04_LANDMARK_PREF]){
        return self.lmakPref;
    }else if ([item isEqualToString:MSTT04_LANDMARK_WARD]){
        return self.lmakWard;
    }else if ([item isEqualToString:MSTT04_LANDMARK_RANK]){
        return self.lmakRank;
    }else if ([item isEqualToString:MSTT04_LANDMARK_MICI_RANK]){
        return self.lmakMiciRank;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_AVAL_TIME]){
        return self.lmakAvalTime;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_TICL_PRIC]){
        return self.lmakTictPric;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_PRIC_MIN]){
	return self.lmakPricMin;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_PRIC_MAX]){
	return self.lmakPricMax;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_ADDR]){
        return self.lmakAddr;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_DESP]){
        return self.lmakDesp;
    }else if ([item isEqualToString:MSTT04_LANDMARK_OLIMPIC_FLAG]){
        return self.olimpicFlag;
    }else if ([item isEqualToString:MSTT04_LANDMARK_EXIT_FLAG1]){
        return self.exitFlag1;
    }else if ([item isEqualToString:MSTT04_LANDMARK_EXIT_FLAG2]){
        return self.exitFlag2;
    }else if ([item isEqualToString:MSTT04_LANDMARK_EXIT_FLAG3]){
        return self.exitFlag3;
    }else if ([item isEqualToString:MSTT04_LANDMARK_EXIT_FLAG4]){
        return self.exitFlag4;
    }else if ([item isEqualToString:MSTT04_LANDMARK_IMAG_ID1]){
        return self.imagId1;
    }else if ([item isEqualToString:MSTT04_LANDMARK_IMAG_ID2]){
        return self.imagId2;
    }else if ([item isEqualToString:MSTT04_LANDMARK_IMAG_ID3]){
        return self.imagId3;
    }else if ([item isEqualToString:MSTT04_LANDMARK_IMAG_ID4]){
        return self.imagId4;
    }else if ([item isEqualToString:MSTT04_LANDMARK_IMAG_ID5]){
        return self.imagId5;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_LON]){
        return self.lmakLon;
    }else if ([item isEqualToString:MSTT04_LANDMARK_LMAK_LAT]){
        return self.lmakLat;
    }else if ([item isEqualToString:MSTT04_LANDMARK_READ_FLAG]){
        return self.readFlag;
    }else if ([item isEqualToString:MSTT04_LANDMARK_READ_TIME]){
        return self.readTime;
    }else if ([item isEqualToString:MSTT04_LANDMARK_FAVO_FLAG]){
        return favoFlag;
    }else if ([item isEqualToString:MSTT04_LANDMARK_FAVO_TIME]){
        return favoTime;
    }else{
        return [super item:item];
    }
}
@end