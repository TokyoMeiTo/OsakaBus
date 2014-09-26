//
//  LinT03TrainMovingTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "LinT03TrainMovingTable.h"

@implementation LinT03TrainMovingTable

@synthesize lineId;
@synthesize timeMoving;
@synthesize timeValid;
@synthesize movingInfo;
@synthesize updateTime;

-(id)init{
    
    self = [super init];
    if (self) {
        self.tableName = LINT03_TRAIN_MOVING;
        self.columns = [NSArray arrayWithObjects:
                        LINT03_TRAIN_MOVING_LINE_ID,
                        LINT03_TRAIN_MOVING_TIME_MOVING,
                        LINT03_TRAIN_MOVING_TIME_VALID,
                        LINT03_TRAIN_MOVING_MOVING_INFO,
                        LINT03_TRAIN_MOVING_UPDATE_TIME, nil];
        self.dataTypes = [NSArray arrayWithObjects:
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,nil];
        self.primaryKeys = [NSArray arrayWithObjects:LINT03_TRAIN_MOVING_LINE_ID, nil];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqual:LINT03_TRAIN_MOVING_LINE_ID]) {
        self.lineId = value;
    }else if ([item isEqual:LINT03_TRAIN_MOVING_TIME_MOVING]){
        self.timeMoving = value;
    }else if ([item isEqual:LINT03_TRAIN_MOVING_TIME_VALID]){
        self.timeValid = value;
    }else if ([item isEqual:LINT03_TRAIN_MOVING_MOVING_INFO]){
        self.movingInfo = value;
    }else if ([item isEqual:LINT03_TRAIN_MOVING_UPDATE_TIME]){
        self.updateTime = value;
    }else{
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqual:LINT03_TRAIN_MOVING_LINE_ID]) {
        return self.lineId;
    }else if ([item isEqual:LINT03_TRAIN_MOVING_TIME_MOVING]){
        return self.timeMoving;
    }else if ([item isEqual:LINT03_TRAIN_MOVING_TIME_VALID]){
        return self.timeValid;
    }else if ([item isEqual:LINT03_TRAIN_MOVING_MOVING_INFO]){
        return self.movingInfo;
    }else if ([item isEqual:LINT03_TRAIN_MOVING_UPDATE_TIME]){
        return self.updateTime;
    }else{
       return  [super item:item];
    }
}

@end
