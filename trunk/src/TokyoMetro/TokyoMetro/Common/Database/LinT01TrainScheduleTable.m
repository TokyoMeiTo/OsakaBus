//
//  LinT01TrainScheduleTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "LinT01TrainScheduleTable.h"

@implementation LinT01TrainScheduleTrainTable

@synthesize lineId;
@synthesize statId;
@synthesize dirtStatId;
@synthesize destStatId;
@synthesize scheType;
@synthesize depaTime;
@synthesize tranType;
@synthesize firstTrainFlag;


-(id)init{
    self = [super init];
    if (self) {
        self.tableName = LINT01_TRAIN_SCHEDULE;
        self.columns = [NSArray arrayWithObjects:
                        LINT01_TRAIN_SCHEDULE_LINE_ID,
                        LINT01_TRAIN_SCHEDULE_STAT_ID,
                        LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID,
                        LINT01_TRAIN_SCHEDULE_DEST_STAT_ID,
                        LINT01_TRAIN_SCHEDULE_SCHE_TYPE,
                        LINT01_TRAIN_SCHEDULE_DEPA_TIME,
                        LINT01_TRAIN_SCHEDULE_TRAN_TYPE,
                        LINT01_TRAIN_SCHEDULE_FIRST_TRAIN_FLAG, nil];
        self.dataTypes = [NSArray arrayWithObjects:
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,nil];
        self.primaryKeys = [NSArray arrayWithObjects:LINT01_TRAIN_SCHEDULE_LINE_ID, nil];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_LINE_ID]) {
        self.lineId = value;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_STAT_ID]){
        self.statId = value;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID]){
        self.dirtStatId = value;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_DEST_STAT_ID]){
        self.destStatId = value;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_SCHE_TYPE]){
        self.scheType = value;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_DEPA_TIME]){
        self.depaTime = value;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_TRAN_TYPE]){
        self.tranType = value;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_FIRST_TRAIN_FLAG]){
        self.firstTrainFlag = value;
    }else{
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_LINE_ID]) {
        return self.lineId;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_STAT_ID]){
        return self.statId;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID]){
        return self.dirtStatId;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_DEST_STAT_ID]){
        return self.destStatId;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_SCHE_TYPE]){
        return self.scheType;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_DEPA_TIME]){
        return self.depaTime;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_TRAN_TYPE]){
        return self.tranType;
    }else if ([item isEqualToString:LINT01_TRAIN_SCHEDULE_FIRST_TRAIN_FLAG]){
        return self.firstTrainFlag;
    }else{
        return [super item:item];
    }
}

@end