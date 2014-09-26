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
@synthesize lineNameExt1;
@synthesize lineNameExt2;
@synthesize lineNameExt3;
@synthesize lineNameExt4;
@synthesize lineNameExt5;
@synthesize lineNameExt6;
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
                        MSTT01_LINE_NAME_EXT1,
                        MSTT01_LINE_NAME_EXT2,
                        MSTT01_LINE_NAME_EXT3,
                        MSTT01_LINE_NAME_EXT4,
                        MSTT01_LINE_NAME_EXT5,
                        MSTT01_LINE_NAME_EXT6,
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
    }else if([item isEqual:MSTT01_LINE_NAME_EXT1]){
        self.lineNameExt1 = value;
    }else if([item isEqual:MSTT01_LINE_NAME_EXT2]){
        self.lineNameExt1 = value;
    }else if([item isEqual:MSTT01_LINE_NAME_EXT3]){
        self.lineNameExt1 = value;
    }else if([item isEqual:MSTT01_LINE_NAME_EXT4]){
        self.lineNameExt1 = value;
    }else if([item isEqual:MSTT01_LINE_NAME_EXT5]){
        self.lineNameExt1 = value;
    }else if([item isEqual:MSTT01_LINE_NAME_EXT6]){
        self.lineNameExt1 = value;
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
    }else if([item isEqual:MSTT01_LINE_NAME_EXT1]){
        return self.lineNameExt1;
    }else if([item isEqual:MSTT01_LINE_NAME_EXT2]){
        return self.lineNameExt2;
    }else if([item isEqual:MSTT01_LINE_NAME_EXT3]){
        return self.lineNameExt3;
    }else if([item isEqual:MSTT01_LINE_NAME_EXT4]){
        return self.lineNameExt4;
    }else if([item isEqual:MSTT01_LINE_NAME_EXT5]){
        return self.lineNameExt5;
    }else if([item isEqual:MSTT01_LINE_NAME_EXT6]){
        return self.lineNameExt6;
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