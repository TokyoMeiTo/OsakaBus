//
//  StaT03ComercialInsideTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/10/10.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "StaT03ComercialInsideTable.h"

@implementation StaT03ComervialInsideTable

@synthesize comeInsiId;
@synthesize comeInsiName;
@synthesize comeInsiType;
@synthesize comeInsiTag;
@synthesize comeInsiPrice;
@synthesize comeInsiLocaCh;
@synthesize comeInsiLocaJp;
@synthesize comeInsiBisiHour;
@synthesize comeInsiImage;
@synthesize favoTime;
@synthesize favoFlag;

-(id)init{
    self = [super init];
    if (self) {
        self.tableName = STAT03_COMERCIAL_INSIDE;
        self.columns = [NSArray arrayWithObjects:STAT03_COME_INSI_ID,
                                                STAT03_COME_INSI_NAME,
                                                STAT03_COME_INSI_TYPE,
                                                STAT03_COME_INSI_TAG,
                                                STAT03_COME_INSI_PRICE,
                                                STAT03_COME_INSI_LOCA_CH,
                                                STAT03_COME_INSI_LOCA_JP,
                                                STAT03_COME_INSI_BISI_HOUR,
                                                STAT03_COME_INSI_IMAGE,
                                                STAT03_FAVO_FLAG,
                        STAT03_FAVO_TIME,nil];
        self.dataTypes = [NSArray arrayWithObjects:ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,nil];
        self.primaryKeys = [NSArray arrayWithObjects:STAT03_COME_INSI_ID, nil];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqualToString:STAT03_COME_INSI_ID]) {
        self.comeInsiId = value;
    }else if ([item isEqualToString:STAT03_COME_INSI_NAME]){
        self.comeInsiName = value;
    }else if ([item isEqualToString:STAT03_COME_INSI_TYPE]){
        self.comeInsiType = value;
    }else if ([item isEqualToString:STAT03_COME_INSI_TAG]){
        self.comeInsiTag = value;
    }else if ([item isEqualToString:STAT03_COME_INSI_PRICE]){
        self.comeInsiPrice = value;
    }else if ([item isEqualToString:STAT03_COME_INSI_LOCA_CH]){
        self.comeInsiLocaCh = value;
    }else if ([item isEqualToString:STAT03_COME_INSI_LOCA_JP]){
        self.comeInsiLocaJp = value;
    }else if ([item isEqualToString:STAT03_COME_INSI_BISI_HOUR]){
        self.comeInsiBisiHour = value;
    }else if ([item isEqualToString:STAT03_COME_INSI_IMAGE]){
        self.comeInsiImage = value;
    }else if ([item isEqualToString:STAT03_FAVO_FLAG]){
        self.favoFlag = value;
    }else if ([item isEqualToString:STAT03_FAVO_TIME]){
        self.favoTime = value;
    }else{
        return [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqualToString:STAT03_COME_INSI_ID]) {
        return self.comeInsiId;
    }else if ([item isEqualToString:STAT03_COME_INSI_NAME]){
        return self.comeInsiName;
    }else if ([item isEqualToString:STAT03_COME_INSI_TYPE]){
        return self.comeInsiType;
    }else if ([item isEqualToString:STAT03_COME_INSI_TAG]){
        return self.comeInsiTag;
    }else if ([item isEqualToString:STAT03_COME_INSI_PRICE]){
        return self.comeInsiPrice;
    }else if ([item isEqualToString:STAT03_COME_INSI_LOCA_CH]){
        return self.comeInsiLocaCh;
    }else if ([item isEqualToString:STAT03_COME_INSI_LOCA_JP]){
        return self.comeInsiLocaJp;
    }else if ([item isEqualToString:STAT03_COME_INSI_BISI_HOUR]){
        return self.comeInsiBisiHour;
    }else if ([item isEqualToString:STAT03_COME_INSI_IMAGE]){
        return self.comeInsiImage;
    }else if ([item isEqualToString:STAT03_FAVO_FLAG]){
        return self.favoFlag;
    }else if ([item isEqualToString:STAT03_FAVO_TIME]){
        return self.favoTime;
    }else{
        return [super item:item];
    }
}
@end
