//
//  MstT01LineTable.m
//  TokyoMetro
//
//  Created by limc on 2014/09/12.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "MstT01LineTable.h"

@implementation MstT01LineTable
@synthesize lineId;
@synthesize lineMetroId;
@synthesize lineMetroIdFull;
@synthesize lineName;
@synthesize lineNameKana;
@synthesize lineNameRome;
@synthesize lineNameExit1;
@synthesize lineNameExit2;
@synthesize lineNameExit3;
@synthesize lineNameExit4;
@synthesize lineNameExit5;
@synthesize lineNameExit6;
@synthesize lineLon;
@synthesize lineLat;
@synthesize linePref;
@synthesize lineComp;

-(id)init{
    
    self = [super init];
    if (self) {
        self.tableName = MSTT01_LINE;
        self.columns = [NSArray arrayWithObjects:
                        MSTT01_LINE_ID,
                        MSTT01_LINE_NAME,
                        MSTT01_LINE_METRO_ID,
                        MSTT01_LINE_METRO_ID_FULL,
                        MSTT01_LINE_NAME_KANA,
                        MSTT01_LINE_NAME_ROME,
                        MSTT01_LINE_NAME_EXIT1,
                        MSTT01_LINE_NAME_EXIT2,
                        MSTT01_LINE_NAME_EXIT3,
                        MSTT01_LINE_NAME_EXIT4,
                        MSTT01_LINE_NAME_EXIT5,
                        MSTT01_LINE_NAME_EXIT6,
                        MSTT01_LINE_LON,
                        MSTT01_LINE_LAT,
                        MSTT01_LINE_PREF,
                        MSTT01_LINE_COMP, nil];
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
                          ODB_DATATYPE_REAL,
                          ODB_DATATYPE_REAL,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,nil];
        self.primaryKeys = [NSArray arrayWithObjects:MSTT01_LINE_ID, nil];
        
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if([item isEqual:MSTT01_LINE_ID]){
        self.lineId = value;
    }else if([item isEqual:MSTT01_LINE_NAME]){
        self.lineName = value;
    }else if([item isEqual:MSTT01_LINE_METRO_ID]){
        self.lineMetroId = value;
    }else if([item isEqual:MSTT01_LINE_METRO_ID_FULL]){
        self.lineMetroIdFull = value;
    }else if([item isEqual:MSTT01_LINE_NAME_KANA]){
        self.lineNameKana = value;
    }else if([item isEqual:MSTT01_LINE_NAME_ROME]){
        self.lineNameRome = value;
    }else if([item isEqual:MSTT01_LINE_NAME_EXIT1]){
        self.lineNameExit1 = value;
    }else if([item isEqual:MSTT01_LINE_NAME_EXIT2]){
        self.lineNameExit1 = value;
    }else if([item isEqual:MSTT01_LINE_NAME_EXIT3]){
        self.lineNameExit1 = value;
    }else if([item isEqual:MSTT01_LINE_NAME_EXIT4]){
        self.lineNameExit1 = value;
    }else if([item isEqual:MSTT01_LINE_NAME_EXIT5]){
        self.lineNameExit1 = value;
    }else if([item isEqual:MSTT01_LINE_NAME_EXIT6]){
        self.lineNameExit1 = value;
    }else if([item isEqual:MSTT01_LINE_LON]){
        self.lineLon = value;
    }else if([item isEqual:MSTT01_LINE_LAT]){
        self.lineLat = value;
    }else if([item isEqual:MSTT01_LINE_PREF]){
        self.linePref = value;
    }else if([item isEqual:MSTT01_LINE_COMP]){
        self.lineComp = value;
    }else{
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if([item isEqual:MSTT01_LINE_ID]){
        return self.lineId;
    }else if([item isEqual:MSTT01_LINE_NAME]){
        return self.lineName;
    }else if([item isEqual:MSTT01_LINE_METRO_ID]){
        return self.lineMetroId;
    }else if([item isEqual:MSTT01_LINE_METRO_ID_FULL]){
        return self.lineMetroIdFull;
    }else if([item isEqual:MSTT01_LINE_NAME_KANA]){
        return self.lineNameKana;
    }else if([item isEqual:MSTT01_LINE_NAME_ROME]){
        return self.lineNameRome;
    }else if([item isEqual:MSTT01_LINE_NAME_EXIT1]){
        return self.lineNameExit1;
    }else if([item isEqual:MSTT01_LINE_NAME_EXIT2]){
        return self.lineNameExit2;
    }else if([item isEqual:MSTT01_LINE_NAME_EXIT3]){
        return self.lineNameExit3;
    }else if([item isEqual:MSTT01_LINE_NAME_EXIT4]){
        return self.lineNameExit4;
    }else if([item isEqual:MSTT01_LINE_NAME_EXIT5]){
        return self.lineNameExit5;
    }else if([item isEqual:MSTT01_LINE_NAME_EXIT6]){
        return self.lineNameExit6;
    }else if([item isEqual:MSTT01_LINE_LON]){
        return self.lineLon;
    }else if([item isEqual:MSTT01_LINE_LAT]){
        return self.lineLat;
    }else if([item isEqual:MSTT01_LINE_PREF]){
        return self.linePref;
    }else if([item isEqual:MSTT01_LINE_COMP]){
        return self.lineComp;
    }else{
        return [super item:item];
    }
}

@end