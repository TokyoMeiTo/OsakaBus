//
//  LinT01TrainScheduleTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define LINT01_TRAIN_SCHEDULE                   @"LINT01_TRAIN_SCHEDULE"
#define LINT01_TRAIN_SCHEDULE_LINE_ID           @"LINE_ID"
#define LINT01_TRAIN_SCHEDULE_STAT_ID           @"STAT_ID"
#define LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID      @"DIRT_STAT_ID"
#define LINT01_TRAIN_SCHEDULE_DEST_STAT_ID      @"DEST_STAT_ID"
#define LINT01_TRAIN_SCHEDULE_SCHE_TYPE         @"SCHE_TYPE"
#define LINT01_TRAIN_SCHEDULE_DEPA_TIME         @"DEPA_TIME"
#define LINT01_TRAIN_SCHEDULE_TRAN_TYPE         @"TRAN_TYPE"
#define LINT01_TRAIN_SCHEDULE_FIRST_TRAIN_FLAG  @"FIRST_TRAIN_FLAG"

@interface LinT01TrainScheduleTrainTable:ODBDataTable{
    
}

@property (copy,nonatomic) NSString* lineId;
@property (copy,nonatomic) NSString* statId;
@property (copy,nonatomic) NSString* dirtStatId;
@property (copy,nonatomic) NSString* destStatId;
@property (copy,nonatomic) NSString* scheType;
@property (copy,nonatomic) NSString* depaTime;
@property (copy,nonatomic) NSString* tranType;
@property (copy,nonatomic) NSString* firstTrainFlag;

@end