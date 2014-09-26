//
//  StaT04FacilityTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/26.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "StaT04FacilityTable.h"

@implementation StaT04FacilityTable

@synthesize faciId;
@synthesize lineId;
@synthesize statId;
@synthesize faciType;
@synthesize faciName;
@synthesize faciDesp;
@synthesize faciLocl;
@synthesize escaDirt;
@synthesize whelCairAces;
@synthesize babyCair;
@synthesize babyChgnTabl;
@synthesize toilOstm;

-(id)init{
    self = [super init];
    
    if (self) {
        self.tableName = STAT04_FACILITY;
        self.columns = [NSArray arrayWithObjects:
                        STAT04_FACI_ID,
                        STAT04_LINE_ID,
                        STAT04_STAT_ID,
                        STAT04_FACI_TYPE,
                        STAT04_FACI_NAME,
                        STAT04_FACI_DESP,
                        STAT04_FACI_LOCL,
                        STAT04_ESCA_DIRT,
                        STAT04_WHEL_CAIR_ACES,
                        STAT04_BABY_CAIR,
                        STAT04_BABY_CHGN_TABL,
                        STAT04_TOIL_OSTM
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
        self.primaryKeys = [NSArray arrayWithObjects:STAT04_FACI_ID, nil];
    }
    
    
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqual:STAT04_FACI_ID]) {
        self.faciId = value;
    }else if ([item isEqual:STAT04_LINE_ID]){
        self.lineId = value;
    }else if ([item isEqual:STAT04_STAT_ID]){
        self.statId = value;
    }else if ([item isEqual:STAT04_FACI_TYPE]){
        self.faciType = value;
    }else if ([item isEqual:STAT04_FACI_NAME]){
        self.faciName = value;
    }else if ([item isEqual:STAT04_FACI_DESP]){
        self.faciDesp = value;
    }else if ([item isEqual:STAT04_FACI_LOCL]){
        self.faciLocl = value;
    }else if ([item isEqual:STAT04_ESCA_DIRT]){
        self.escaDirt = value;
    }else if ([item isEqual:STAT04_WHEL_CAIR_ACES]){
        self.whelCairAces = value;
    }else if ([item isEqual:STAT04_BABY_CAIR]){
        self.babyCair = value;
    }else if ([item isEqual:STAT04_BABY_CHGN_TABL]){
        self.babyChgnTabl = value;
    }else if ([item isEqual:STAT04_TOIL_OSTM]){
        self.toilOstm = value;
    }else{
        [super item:item value:value];
    }
        
}

-(id)item:(NSString *)item{
    if ([item isEqual:STAT04_FACI_ID]) {
        return self.faciId;
    }else if ([item isEqual:STAT04_LINE_ID]){
        return self.lineId;
    }else if ([item isEqual:STAT04_STAT_ID]){
        return self.statId;
    }else if ([item isEqual:STAT04_FACI_TYPE]){
        return self.faciType;
    }else if ([item isEqual:STAT04_FACI_NAME]){
        return self.faciName;
    }else if ([item isEqual:STAT04_FACI_DESP]){
        return self.faciDesp;
    }else if ([item isEqual:STAT04_FACI_LOCL]){
        return self.faciLocl;
    }else if ([item isEqual:STAT04_ESCA_DIRT]){
        return self.escaDirt;
    }else if ([item isEqual:STAT04_WHEL_CAIR_ACES]){
        return self.whelCairAces;
    }else if ([item isEqual:STAT04_BABY_CAIR]){
        return self.babyCair;
    }else if ([item isEqual:STAT04_BABY_CHGN_TABL]){
        return self.babyChgnTabl;
    }else if ([item isEqual:STAT04_TOIL_OSTM]){
        return self.toilOstm;
    }else{
        return [super item:item];
    }
}

@end
