//
//  MstT02StationTable.m
//  TokyoMetro
//
//  Created by caowj on 14-9-12.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "MstT02StationTable.h"


@implementation MstT02StationTable
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
@synthesize statNameExit1;
@synthesize statNameExit2;
@synthesize statNameExit3;
@synthesize statNameExit4;
@synthesize statNameExit5;
@synthesize statNameExit6;
@synthesize statNameMetroId;
@synthesize statNameMetroIdFull;

-(id)init{
    
    self = [super init];
    if (self) {
        self.tableName = MSTT02_STATION;
        self.columns = [NSArray arrayWithObjects:
                        MSTT02_STAT_ID,
                        MSTT02_STAT_GROUP_ID,
                        MSTT02_LINE_ID,
                        MSTT02_STAT_SEQ,
                        MSTT02_STAT_NAME,
                        MSTT02_STAT_METRO_ID,
                        MSTT02_STAT_METRO_ID_FULL,
                        MSTT02_STAT_NAME_KANA,
                        MSTT02_STAT_NAME_ROME,
                        MSTT02_STAT_NAME_EXIT1,
                        MSTT02_STAT_NAME_EXIT2,
                        MSTT02_STAT_NAME_EXIT3,
                        MSTT02_STAT_NAME_EXIT4,
                        MSTT02_STAT_NAME_EXIT5,
                        MSTT02_STAT_NAME_EXIT6,
                        MSTT02_STAT_LON,
                        MSTT02_STAT_LAT,
                        MSTT02_STAT_PREF,
                        MSTT02_STAT_ADDR,
                        MSTT02_STAT_DESP, nil];
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
        self.primaryKeys = [NSArray arrayWithObjects:MSTT02_STAT_ID, nil];
        
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if([item isEqual:MSTT02_STAT_ID]){
        self.statId = value;
    }else if([item isEqual:MSTT02_STAT_GROUP_ID]){
        self.statGroupId = value;
    }else if([item isEqual:MSTT02_STAT_METRO_ID]){
        self.statNameMetroId = value;
    }else if([item isEqual:MSTT02_STAT_METRO_ID_FULL]){
        self.statNameMetroIdFull = value;
    }else if([item isEqual:MSTT02_STAT_NAME_EXIT1]){
        self.statNameExit1 = value;
    }else if([item isEqual:MSTT02_STAT_NAME_EXIT2]){
        self.statNameExit2 = value;
    }else if([item isEqual:MSTT02_STAT_NAME_EXIT3]){
        self.statNameExit3 = value;
    }else if([item isEqual:MSTT02_STAT_NAME_EXIT4]){
        self.statNameExit4 = value;
    }else if([item isEqual:MSTT02_STAT_NAME_EXIT5]){
        self.statNameExit5 = value;
    }else if([item isEqual:MSTT02_STAT_NAME_EXIT6]){
        self.statNameExit6 = value;
    }else if([item isEqual:MSTT02_STAT_NAME]){
        self.statName = value;
    }else if([item isEqual:MSTT02_STAT_NAME_KANA]){
        self.statNameKana = value;
    }else if([item isEqual:MSTT02_STAT_NAME_ROME]){
        self.statNameRome = value;
    }else if([item isEqual:MSTT02_STAT_LON]){
        self.statLon = value;
    }else if([item isEqual:MSTT02_STAT_LAT]){
        self.statLat = value;
    }else if([item isEqual:MSTT02_STAT_PREF]){
        self.statPref = value;
    }else if([item isEqual:MSTT02_STAT_ADDR]){
        self.statAddr = value;
    }else if([item isEqual:MSTT02_STAT_DESP]){
        self.statDesp = value;
    }else if([item isEqual:MSTT02_LINE_ID]){
        self.lineId = value;
    }else if([item isEqual:MSTT02_STAT_SEQ]){
        self.statSeq = value;
    }else{
        [super item:item value:value];
    }
}


-(id)item:(NSString *)item{
    if([item isEqual:MSTT02_STAT_ID]){
        return self.statId;
    }else if([item isEqual:MSTT02_STAT_GROUP_ID]){
        return self.statGroupId;
    }else if([item isEqual:MSTT02_STAT_NAME]){
        return self.statName;
    }else if([item isEqual:MSTT02_STAT_NAME_KANA]){
        return self.statNameKana;
    }else if([item isEqual:MSTT02_STAT_NAME_ROME]){
        return self.statNameRome;
    }else if([item isEqual:MSTT02_STAT_LON]){
        return self.statLon;
    }else if([item isEqual:MSTT02_STAT_LAT]){
        return self.statLat;
    }else if([item isEqual:MSTT02_STAT_PREF]){
        return self.statPref;
    }else if([item isEqual:MSTT02_STAT_ADDR]){
        return self.statAddr;
    }else if([item isEqual:MSTT02_STAT_METRO_ID]){
        return self.statNameMetroId;
    }else if([item isEqual:MSTT02_STAT_METRO_ID_FULL]){
        return self.statNameMetroIdFull;
    }else if([item isEqual:MSTT02_STAT_NAME_EXIT1]){
        return self.statNameExit1;
    }else if([item isEqual:MSTT02_STAT_NAME_EXIT2]){
        return self.statNameExit2;
    }else if([item isEqual:MSTT02_STAT_NAME_EXIT3]){
        return self.statNameExit3;
    }else if([item isEqual:MSTT02_STAT_NAME_EXIT4]){
        return self.statNameExit4;
    }else if([item isEqual:MSTT02_STAT_NAME_EXIT5]){
        return self.statNameExit5;
    }else if([item isEqual:MSTT02_STAT_NAME_EXIT6]){
        return self.statNameExit6;
    }else if([item isEqual:MSTT02_STAT_DESP]){
        return self.statDesp;
    }else if ([item isEqual:MSTT02_STAT_SEQ]){
        return self.statSeq;
    }else if ([item isEqual:MSTT02_LINE_ID]){
        return self.lineId;
    }else{
        return [super item:item];
    }
}


@end