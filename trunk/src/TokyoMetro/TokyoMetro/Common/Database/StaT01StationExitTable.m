//
//  StaT01StationExitTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/26.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "StaT01StationExitTable.h"

@implementation StaT01StationExitTable

@synthesize statExitId;
@synthesize lineId;
@synthesize statId;
@synthesize statExitNum;
@synthesize statExitName;
@synthesize statExitType;
@synthesize statExitLon;
@synthesize statExitLat;
@synthesize statExitFloor;

-(id)init{
    self = [super init];
    if (self) {
        self.tableName = STAT01_STATION_EXIT;
        self.columns = [NSArray arrayWithObjects:
                        STAT01_STAT_EXIT_ID,
                        STAT01_LINE_ID,
                        STAT01_STAT_ID,
                        STAT01_STAT_EXIT_NUM,
                        STAT01_STAT_EXIT_NAME,
                        STAT01_STAT_EXIT_TYPE,
                        STAT01_STAT_EXIT_LON,
                        STAT01_STAT_EXIT_LAT,
                        STAT01_STAT_EXIT_FLOOR, nil];
        self.dataTypes = [NSArray arrayWithObjects:
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_INTEGER,
                          ODB_DATATYPE_INTEGER,
                          ODB_DATATYPE_INTEGER,
                          ODB_DATATYPE_INTEGER, nil];
        self.primaryKeys = [NSArray arrayWithObjects:STAT01_STAT_EXIT_ID, nil];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqual:STAT01_STAT_EXIT_ID]) {
        self.statExitId = value;
    }else if ([item isEqual:STAT01_LINE_ID]){
        self.lineId = value;
    }else if ([item isEqual:STAT01_STAT_ID]){
        self.statId = value;
    }else if ([item isEqual:STAT01_STAT_EXIT_NUM]){
        self.statExitNum = value;
    }else if ([item isEqual:STAT01_STAT_EXIT_NAME]){
        self.statExitName = value;
    }else if ([item isEqual:STAT01_STAT_EXIT_TYPE]){
        self.statExitType = value;
    }else if ([item isEqual:STAT01_STAT_EXIT_LON]){
        self.statExitLon = value;
    }else if ([item isEqual:STAT01_STAT_EXIT_LAT]){
        self.statExitLat = value;
    }else if ([item isEqual:STAT01_STAT_EXIT_FLOOR]){
        self.statExitFloor = value;
    }else{
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqual:STAT01_STAT_EXIT_ID]) {
        return self.statExitId;
    }else if ([item isEqual:STAT01_LINE_ID]){
        return self.lineId;
    }else if ([item isEqual:STAT01_STAT_ID]){
        return self.statId;
    }else if ([item isEqual:STAT01_STAT_EXIT_NUM]){
        return self.statExitNum;
    }else if ([item isEqual:STAT01_STAT_EXIT_NAME]){
        return self.statExitName;
    }else if ([item isEqual:STAT01_STAT_EXIT_TYPE]){
        return self.statExitType;
    }else if ([item isEqual:STAT01_STAT_EXIT_LON]){
        return self.statExitLon;
    }else if ([item isEqual:STAT01_STAT_EXIT_LAT]){
        return self.statExitLat;
    }else if ([item isEqual:STAT01_STAT_EXIT_FLOOR]){
        return self.statExitFloor;
    }else{
        return [super item:item];
    }
}
@end