//
//  LinT03TrainMovingTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define LINT03_TRAIN_MOVING                 @"LINT03_TRAIN_MOVING"
#define LINT03_TRAIN_MOVING_LINE_ID         @"LINE_ID"
#define LINT03_TRAIN_MOVING_TIME_MOVING     @"TIME_MOVING"
#define LINT03_TRAIN_MOVING_TIME_VALID      @"TIME_VALID"
#define LINT03_TRAIN_MOVING_MOVING_INFO     @"MOVING_INFO"
#define LINT03_TRAIN_MOVING_UPDATE_TIME     @"UPDATE_TIME"

@interface LinT03TrainMovingTable : ODBDataTable{
    
}
@property(copy,nonatomic) NSString* lineId;
@property(copy,nonatomic) NSString* timeMoving;
@property(copy,nonatomic) NSString* timeValid;
@property(copy,nonatomic) NSString* movingInfo;
@property(copy,nonatomic) NSString* updateTime;
@end