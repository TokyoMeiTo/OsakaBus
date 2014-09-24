//
//  UsrT01ArrivalAlarmTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define USRT01_ARRIVAL_ALARM                        @"USRT01_ARRIVAL_ALARM"
#define USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID           @"ARRI_ALAM_ID"
#define USRT01_ARRIVAL_ALARM_LINE_FROM_ID           @"LINE_FROM_ID"
#define USRT01_ARRIVAL_ALARM_LINE_FROM_NAME_LOCL    @"LINE_FROM_NAME_LOCL"
#define USRT01_ARRIVAL_ALARM_STAT_FROM_ID           @"STAT_FROM_ID"
#define USRT01_ARRIVAL_ALARM_STAT_FROM_NAME_LOCL    @"STAT_FROM_NAME_LOCL"
#define USRT01_ARRIVAL_ALARM_LINE_TO_ID             @"LINE_TO_ID"
#define USRT01_ARRIVAL_ALARM_LINE_TO_NAME_LOCL      @"LINE_TO_NAME_LOCL"
#define USRT01_ARRIVAL_ALARM_STAT_TO_ID             @"STAT_TO_ID"
#define USRT01_ARRIVAL_ALARM_STAT_TO_NAME_LOCL      @"STAT_TO_NAME_LOCL"
#define USRT01_ARRIVAL_ALARM_BEEP_FLAG              @"BEEP_FLAG"
#define USRT01_ARRIVAL_ALARM_VOLE_FLAG              @"VOLE_FLAG"
#define USRT01_ARRIVAL_ALARM_COST_TIME              @"COST_TIME"
#define USRT01_ARRIVAL_ALARM_ALARM_TIME             @"ALARM_TIME"
#define USRT01_ARRIVAL_ALARM_SAVE_TIME              @"SAVE_TIME"
#define USRT01_ARRIVAL_ALARM_ONBOARD_TIME           @"ONBOARD_TIME"
#define USRT01_ARRIVAL_ALARM_CANCEL_FLAG            @"CANCEL_FLAG"
#define USRT01_ARRIVAL_ALARM_CANCEL_TIME            @"CANCEL_TIME"

@interface UsrT01ArrivalAlarmTable : ODBDataTable{
    
}

@property(copy,nonatomic)NSString* arriAlamId;
@property(copy,nonatomic)NSString* lineFromId;
@property(copy,nonatomic)NSString* lineFromNameLocl;
@property(copy,nonatomic)NSString* statFromId;
@property(copy,nonatomic)NSString* statFromNameLocl;
@property(copy,nonatomic)NSString* lineToId;
@property(copy,nonatomic)NSString* lineToNameLocl;
@property(copy,nonatomic)NSString* statToId;
@property(copy,nonatomic)NSString* statToNameLocl;
@property(copy,nonatomic)NSString* beepFlag;
@property(copy,nonatomic)NSString* voleFlag;
@property(copy,nonatomic)NSString* costTime;
@property(copy,nonatomic)NSString* alarmTime;
@property(copy,nonatomic)NSString* saveTime;
@property(copy,nonatomic)NSString* onboardTime;
@property(copy,nonatomic)NSString* cancelFlag;
@property(copy,nonatomic)NSString* cancelTime;


@end
