//
//  InfT01StrategyTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/10/10.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "InfT01StrategyTable.h"

@implementation InfT01StrategyTable

@synthesize favoFlag;
@synthesize favoTime;
@synthesize readFlag;
@synthesize readTime;
@synthesize straDescription;
@synthesize straId;
@synthesize spplPeople;
@synthesize straSeason;
@synthesize straTheme;

-(id)init{
    self = [super init];
    if (self) {
        self.tableName = INFT01_STRATEGY;
        self.columns = [NSArray arrayWithObjects:INFT01_STRA_ID,
                                                INFT01_STRA_THEME,
                                                INFT01_SPPL_PEOPLE,
                                                INFT01_STRA_DESCRIPTION,
                                                INFT01_READ_TIME,
                                                INFT01_READ_FLAG,
                                                INFT01_FAVO_FLAG,
                                                INFT01_FAVO_TIME,
                                                INFT01_STRA_SEASON, nil];
        self.dataTypes = [NSArray arrayWithObjects:ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT, nil];
        self.primaryKeys = [NSArray arrayWithObjects:INFT01_STRA_ID, nil];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqualToString:INFT01_STRA_ID]) {
        self.straId = value;
    }else if ([item isEqualToString:INFT01_STRA_THEME]){
        self.straTheme = value;
    }else if ([item isEqualToString:INFT01_SPPL_PEOPLE]){
        self.spplPeople = value;
    }else if ([item isEqualToString:INFT01_STRA_DESCRIPTION]){
        self.straDescription = value;
    }else if ([item isEqualToString:INFT01_STRA_SEASON]){
        self.straSeason = value;
    }else if ([item isEqualToString:INFT01_FAVO_FLAG]){
        self.favoFlag = value;
    }else if ([item isEqualToString:INFT01_FAVO_TIME]){
        self.favoTime = value;
    }else if ([item isEqualToString:INFT01_READ_FLAG]){
        self.readFlag = value;
    }else if ([item isEqualToString:INFT01_READ_TIME]){
        self.readTime = value;
    }else {
        return [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqualToString:INFT01_STRA_ID]) {
        return self.straId;
    }else if ([item isEqualToString:INFT01_STRA_THEME]){
        return self.straTheme;
    }else if ([item isEqualToString:INFT01_SPPL_PEOPLE]){
        return self.spplPeople;
    }else if ([item isEqualToString:INFT01_STRA_DESCRIPTION]){
        return self.straDescription;
    }else if ([item isEqualToString:INFT01_STRA_SEASON]){
        return self.straSeason;
    }else if ([item isEqualToString:INFT01_FAVO_FLAG]){
        return self.favoFlag;
    }else if ([item isEqualToString:INFT01_FAVO_TIME]){
        return self.favoTime;
    }else if ([item isEqualToString:INFT01_READ_FLAG]){
        return self.readFlag;
    }else if ([item isEqualToString:INFT01_READ_TIME]){
        return self.readTime;
    }else {
        return [super item:item];
    }
}
@end