//
//  CmnT03StationGridTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define CMNT03_STATION_GRID         @"CMNT03_STATION_GRID"
#define CMNT03_STAT_ID              @"STAT_ID"
#define CMNT03_PONT_X_FROM          @"PONT_X_FROM"
#define CMNT03_PONT_Y_FROM          @"PONT_Y_FROM"
#define CMNT03_PONT_X_TO            @"PONT_X_TO"
#define CMNT03_PONT_Y_TO            @"PONT_Y_TO"

@interface CmnT03StationGridTable : ODBDataTable{
}
@property (copy,nonatomic) NSString* statId;
@property (copy,nonatomic) NSNumber* pontXFrom;
@property (copy,nonatomic) NSNumber* pontYFrom;
@property (copy,nonatomic) NSNumber* pontXTo;
@property (copy,nonatomic) NSNumber* pontYTo;

@end