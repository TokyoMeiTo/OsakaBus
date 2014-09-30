//
//  MstV01StationGroup.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/29.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "MstV01StationGroup.h"


@implementation MstV01StationGroup
@synthesize statId;
@synthesize statGroupId;
@synthesize statName;
@synthesize statNameKana;
@synthesize statNameRome;
@synthesize statLon;
@synthesize statLat;
@synthesize statPref;
@synthesize statAddr;
@synthesize statDesp;
@synthesize lineId;
@synthesize statSeq;
@synthesize statNameExt1;
@synthesize statNameExt2;
@synthesize statNameExt3;
@synthesize statNameExt4;
@synthesize statNameExt5;
@synthesize statNameExt6;
@synthesize statNameMetroId;
@synthesize statNameMetroIdFull;

-(id)init{
    
    self = [super init];
    if (self) {
        self.tableName = MSTV01_STATION_GROUP;
        self.columns = [NSArray arrayWithObjects:
                        MSTV01_STAT_ID,
                        MSTV01_STAT_GROUP_ID,
                        MSTV01_LINE_ID,
                        MSTV01_STAT_SEQ,
                        MSTV01_STAT_NAME,
                        MSTV01_STAT_METRO_ID,
                        MSTV01_STAT_METRO_ID_FULL,
                        MSTV01_STAT_NAME_KANA,
                        MSTV01_STAT_NAME_ROME,
                        MSTV01_STAT_NAME_EXT1,
                        MSTV01_STAT_NAME_EXT2,
                        MSTV01_STAT_NAME_EXT3,
                        MSTV01_STAT_NAME_EXT4,
                        MSTV01_STAT_NAME_EXT5,
                        MSTV01_STAT_NAME_EXT6,
                        MSTV01_STAT_LON,
                        MSTV01_STAT_LAT,
                        MSTV01_STAT_PREF,
                        MSTV01_STAT_ADDR,
                        MSTV01_STAT_DESP, nil];
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
                          ODB_DATATYPE_REAL,
                          ODB_DATATYPE_REAL,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,nil];
        self.primaryKeys = [NSArray arrayWithObjects:MSTV01_STAT_ID, nil];
        
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if([item isEqual:MSTV01_STAT_ID]){
        self.statId = value;
    }else if([item isEqual:MSTV01_STAT_GROUP_ID]){
        self.statGroupId = value;
    }else if([item isEqual:MSTV01_STAT_METRO_ID]){
        self.statNameMetroId = value;
    }else if([item isEqual:MSTV01_STAT_METRO_ID_FULL]){
        self.statNameMetroIdFull = value;
    }else if([item isEqual:MSTV01_STAT_NAME_EXT1]){
        self.statNameExt1 = value;
    }else if([item isEqual:MSTV01_STAT_NAME_EXT2]){
        self.statNameExt2 = value;
    }else if([item isEqual:MSTV01_STAT_NAME_EXT3]){
        self.statNameExt3 = value;
    }else if([item isEqual:MSTV01_STAT_NAME_EXT4]){
        self.statNameExt4 = value;
    }else if([item isEqual:MSTV01_STAT_NAME_EXT5]){
        self.statNameExt5 = value;
    }else if([item isEqual:MSTV01_STAT_NAME_EXT6]){
        self.statNameExt6 = value;
    }else if([item isEqual:MSTV01_STAT_NAME]){
        self.statName = value;
    }else if([item isEqual:MSTV01_STAT_NAME_KANA]){
        self.statNameKana = value;
    }else if([item isEqual:MSTV01_STAT_NAME_ROME]){
        self.statNameRome = value;
    }else if([item isEqual:MSTV01_STAT_LON]){
        self.statLon = value;
    }else if([item isEqual:MSTV01_STAT_LAT]){
        self.statLat = value;
    }else if([item isEqual:MSTV01_STAT_PREF]){
        self.statPref = value;
    }else if([item isEqual:MSTV01_STAT_ADDR]){
        self.statAddr = value;
    }else if([item isEqual:MSTV01_STAT_DESP]){
        self.statDesp = value;
    }else if([item isEqual:MSTV01_LINE_ID]){
        self.lineId = value;
    }else if([item isEqual:MSTV01_STAT_SEQ]){
        self.statSeq = value;
    }else{
        [super item:item value:value];
    }
}


-(id)item:(NSString *)item{
    if([item isEqual:MSTV01_STAT_ID]){
        return self.statId;
    }else if([item isEqual:MSTV01_STAT_GROUP_ID]){
        return self.statGroupId;
    }else if([item isEqual:MSTV01_STAT_NAME]){
        return self.statName;
    }else if([item isEqual:MSTV01_STAT_NAME_KANA]){
        return self.statNameKana;
    }else if([item isEqual:MSTV01_STAT_NAME_ROME]){
        return self.statNameRome;
    }else if([item isEqual:MSTV01_STAT_LON]){
        return self.statLon;
    }else if([item isEqual:MSTV01_STAT_LAT]){
        return self.statLat;
    }else if([item isEqual:MSTV01_STAT_PREF]){
        return self.statPref;
    }else if([item isEqual:MSTV01_STAT_ADDR]){
        return self.statAddr;
    }else if([item isEqual:MSTV01_STAT_METRO_ID]){
        return self.statNameMetroId;
    }else if([item isEqual:MSTV01_STAT_METRO_ID_FULL]){
        return self.statNameMetroIdFull;
    }else if([item isEqual:MSTV01_STAT_NAME_EXT1]){
        return self.statNameExt1;
    }else if([item isEqual:MSTV01_STAT_NAME_EXT2]){
        return self.statNameExt2;
    }else if([item isEqual:MSTV01_STAT_NAME_EXT3]){
        return self.statNameExt3;
    }else if([item isEqual:MSTV01_STAT_NAME_EXT4]){
        return self.statNameExt4;
    }else if([item isEqual:MSTV01_STAT_NAME_EXT5]){
        return self.statNameExt5;
    }else if([item isEqual:MSTV01_STAT_NAME_EXT6]){
        return self.statNameExt6;
    }else if([item isEqual:MSTV01_STAT_DESP]){
        return self.statDesp;
    }else if ([item isEqual:MSTV01_STAT_SEQ]){
        return self.statSeq;
    }else if ([item isEqual:MSTV01_LINE_ID]){
        return self.lineId;
    }else{
        return [super item:item];
    }
}


@end