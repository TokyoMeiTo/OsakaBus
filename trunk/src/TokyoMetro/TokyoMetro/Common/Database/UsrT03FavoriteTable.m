//
//  UsrT03FavoriteTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/26.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "UsrT03FavoriteTable.h"

@implementation UsrT03FavoriteTable

@synthesize favoType;
@synthesize favoTime;
@synthesize lineId;
@synthesize statId;
@synthesize statExitId;
@synthesize lmakId;
@synthesize ruteId;
@synthesize ext1;
@synthesize ext2;
@synthesize ext3;
@synthesize ext4;
@synthesize ext5;

-(id)init{
    self = [super init];
    
    if (self) {
        self.tableName = USRT03_FAVORITE;
        self.columns = [NSArray arrayWithObjects:
                        USRT03_FAVO_TYPE,
                        USRT03_FAVO_TIME,
                        USRT03_LINE_ID,
                        USRT03_STAT_ID,
                        USRT03_STAT_EXIT_ID,
                        USRT03_LMAK_ID,
                        USRT03_RUTE_ID,
                        USRT03_EXI1,
                        USRT03_EXI2,
                        USRT03_EXI3,
                        USRT03_EXI4,
                        USRT03_EXI5
                        , nil];
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
                          ODB_DATATYPE_TEXT
                          , nil];
        self.primaryKeys = [NSArray arrayWithObjects:USRT03_FAVO_TYPE, nil];
    }
    
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqualToString:USRT03_FAVO_TYPE]) {
        self.favoType = value;
    }else if ([item isEqualToString:USRT03_FAVO_TIME]){
        self.favoTime = value;
    }else if ([item isEqualToString:USRT03_LINE_ID]){
        self.lineId = value;
    }else if ([item isEqualToString:USRT03_STAT_ID]){
        self.statId = value;
    }else if ([item isEqualToString:USRT03_STAT_EXIT_ID]){
        self.statExitId = value;
    }else if ([item isEqualToString:USRT03_LMAK_ID]){
        self.lmakId = value;
    }else if ([item isEqualToString:USRT03_RUTE_ID]){
        self.ruteId = value;
    }else if ([item isEqualToString:USRT03_EXI1]){
        self.ext1 = value;
    }else if ([item isEqualToString:USRT03_EXI2]){
        self.ext2 = value;
    }else if ([item isEqualToString:USRT03_EXI3]){
        self.ext3 = value;
    }else if ([item isEqualToString:USRT03_EXI4]){
        self.ext4 = value;
    }else if ([item isEqualToString:USRT03_EXI5]){
        self.ext5 = value;
    }else{
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqualToString:USRT03_FAVO_TYPE]) {
        return self.favoType;
    }else if ([item isEqualToString:USRT03_FAVO_TIME]){
        return self.favoTime;
    }else if ([item isEqualToString:USRT03_LINE_ID]){
        return self.lineId;
    }else if ([item isEqualToString:USRT03_STAT_ID]){
        return self.statId;
    }else if ([item isEqualToString:USRT03_STAT_EXIT_ID]){
        return self.statExitId;
    }else if ([item isEqualToString:USRT03_LMAK_ID]){
        return self.lmakId;
    }else if ([item isEqualToString:USRT03_RUTE_ID]){
        return self.ruteId;
    }else if ([item isEqualToString:USRT03_EXI1]){
        return self.ext1;
    }else if ([item isEqualToString:USRT03_EXI2]){
        return self.ext2;
    }else if ([item isEqualToString:USRT03_EXI3]){
        return self.ext3;
    }else if ([item isEqualToString:USRT03_EXI4]){
        return self.ext4;
    }else if ([item isEqualToString:USRT03_EXI5]){
        return self.ext5;
    }else{
        return [super item:item];
    }
}
@end
