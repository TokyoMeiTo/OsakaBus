//
//  LinT06FareTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/23.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define LINT06_FARE                         @"LINT06_FARE"
#define LINT06_FARE_RUTE_ID                 @"RUTE_ID"
#define LINT06_FARE_FARE_ADULT              @"FARE_ADULT"
#define LINT06_FARE_FARE_CHILD              @"FARE_CHILD"
#define LINT06_FARE_FARE_ID_ADULT           @"FARE_ID_ADULT"
#define LINT06_FARE_FARE_ID_CHILD           @"FARE_ID_CHILD"
@interface LinT06FareTable : ODBDataTable{
}

@property(copy,nonatomic)NSString* ruteId;
@property(copy,nonatomic)NSString* fareAdult;
@property(copy,nonatomic)NSString* fareChild;
@property(copy,nonatomic)NSString* fareIdAdult;
@property(copy,nonatomic)NSString* fareIdChild;

@end