//
//  UsrT01ArrivalAlarmTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "UsrT01ArrivalAlarmTable.h"
@implementation UsrT01ArrivalAlarmTable

@synthesize arriAlamId;
@synthesize lineFromId;
//@synthesize lineFromNameLocl;
@synthesize statFromId;
//@synthesize statFromNameLocl;
@synthesize lineToId;
//@synthesize lineToNameLocl;
@synthesize statToId;
//@synthesize statToNameLocl;
@synthesize beepFlag;
@synthesize voleFlag;
@synthesize costTime;
@synthesize alarmTime;
@synthesize saveTime;
@synthesize onboardTime;
@synthesize cancelFlag;
@synthesize cancelTime;

-(id)init{
    self = [super init];
    if (self) {
        self.tableName = USRT01_ARRIVAL_ALARM;
        self.columns = [NSArray arrayWithObjects:USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID,
                                                USRT01_ARRIVAL_ALARM_LINE_FROM_ID,
//                                                USRT01_ARRIVAL_ALARM_LINE_FROM_NAME_LOCL,
                                                USRT01_ARRIVAL_ALARM_STAT_FROM_ID,
//                                                USRT01_ARRIVAL_ALARM_STAT_FROM_NAME_LOCL,
                                                USRT01_ARRIVAL_ALARM_LINE_TO_ID,
//                                                USRT01_ARRIVAL_ALARM_LINE_TO_NAME_LOCL,
                                                USRT01_ARRIVAL_ALARM_STAT_TO_ID,
//                                                USRT01_ARRIVAL_ALARM_STAT_TO_NAME_LOCL,
                                                USRT01_ARRIVAL_ALARM_BEEP_FLAG,
                                                USRT01_ARRIVAL_ALARM_VOLE_FLAG,
                                                USRT01_ARRIVAL_ALARM_COST_TIME,
                                                USRT01_ARRIVAL_ALARM_ALARM_TIME,
                                                USRT01_ARRIVAL_ALARM_SAVE_TIME,
                                                USRT01_ARRIVAL_ALARM_ONBOARD_TIME,
                                                USRT01_ARRIVAL_ALARM_CANCEL_FLAG,
                                                USRT01_ARRIVAL_ALARM_CANCEL_TIME,nil];
        self.dataTypes = [NSArray arrayWithObjects:ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
//                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
//                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
//                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
//                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,nil];
        self.primaryKeys = [NSArray arrayWithObjects:USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID,nil];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqualToString:USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID]) {
        self.arriAlamId = value;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_LINE_FROM_ID]){
        self.lineFromId = value;
    }
//    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_LINE_FROM_NAME_LOCL]){
//        self.lineFromNameLocl = value;
//    }
    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_STAT_FROM_ID]){
        self.statFromId = value;
    }
//    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_STAT_FROM_NAME_LOCL]){
//        self.statFromNameLocl = value;
//    }
    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_LINE_TO_ID]){
        self.lineToId = value;
    }
//    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_LINE_TO_NAME_LOCL]){
//        self.lineToNameLocl = value;
//    }
    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_STAT_TO_ID]){
        self.statToId = value;
    }
//    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_STAT_TO_NAME_LOCL]){
//        self.statToNameLocl = value;
//    }
    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_BEEP_FLAG]){
        self.beepFlag = value;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_VOLE_FLAG]){
        self.voleFlag = value;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_COST_TIME]){
        self.costTime = value;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_ALARM_TIME]){
        self.alarmTime = value;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_SAVE_TIME]){
        self.saveTime = value;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_ONBOARD_TIME]){
        self.onboardTime = value;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_CANCEL_FLAG]){
        self.cancelFlag = value;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_CANCEL_TIME]){
        self.cancelTime = value;
    }else {
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqualToString:USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID]) {
        return self.arriAlamId;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_LINE_FROM_ID]){
        return self.lineFromId;
    }
//    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_LINE_FROM_NAME_LOCL]){
//        return self.lineFromNameLocl;
//    }
    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_STAT_FROM_ID]){
        return self.statFromId;
    }
//    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_STAT_FROM_NAME_LOCL]){
//        return self.statFromNameLocl;
//    }
    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_LINE_TO_ID]){
        return self.lineToId;
    }
//    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_LINE_TO_NAME_LOCL]){
//        return self.lineToNameLocl;
//    }
    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_STAT_TO_ID]){
        return self.statToId;
    }
//    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_STAT_TO_NAME_LOCL]){
//        return self.statToNameLocl;
//    }
    else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_BEEP_FLAG]){
        return self.beepFlag;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_VOLE_FLAG]){
        return self.voleFlag;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_COST_TIME]){
        return self.costTime;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_ALARM_TIME]){
        return self.alarmTime;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_SAVE_TIME]){
        return self.saveTime;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_ONBOARD_TIME]){
        return self.onboardTime;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_CANCEL_FLAG]){
        return self.cancelFlag;
    }else if ([item isEqualToString:USRT01_ARRIVAL_ALARM_CANCEL_TIME]){
        return self.cancelTime;
    }else {
        return [super item:item ];
    }
}
@end