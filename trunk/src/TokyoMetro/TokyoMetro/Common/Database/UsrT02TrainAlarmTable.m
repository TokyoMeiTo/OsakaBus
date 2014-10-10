//
//  UsrT02TrainAlarmTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "UsrT02TrainAlarmTable.h"
@implementation UsrT02TrainAlarmTable

@synthesize traiAlamId;
@synthesize lineId;
@synthesize lineNameLocl;
@synthesize statId;
@synthesize statNameLocl;
@synthesize firstTime;
@synthesize lastTime;
@synthesize traiDirt;
@synthesize firstFlag;
@synthesize lastFlag;
@synthesize beepFlag;
@synthesize voleFlag;
@synthesize alarmTime;
@synthesize saveTime;


-(id)init{
    self = [super init];
    if (self) {
        self.tableName = USRT02_TRAIN_ALARM;
        self.columns = [NSArray arrayWithObjects:USRT02_TRAIN_ALARM_TRAI_ALAM_ID,
                                                USRT02_TRAIN_ALARM_LINE_ID,
                                                USRT02_TRAIN_ALARM_LINE_NAME_LOCL,
                                                USRT02_TRAIN_ALARM_STAT_ID,
                                                USRT02_TRAIN_ALARM_STAT_NAME_LOCL,
                                                USRT02_TRAIN_ALARM_FIRST_TIME,
                                                USRT02_TRAIN_ALARM_LAST_TIME,
                                                USRT02_TRAIN_ALARM_TRAI_DIRT,
                                                USRT02_TRAIN_ALARM_FIRST_FLAG,
                                                USRT02_TRAIN_ALARM_LAST_FLAG,
                                                USRT02_TRAIN_ALARM_BEEP_FLAG,
                                                USRT02_TRAIN_ALARM_VOLE_FLAG,
                                                USRT02_TRAIN_ALARM_ALARM_TIME,
                                                USRT02_TRAIN_ALARM_SAVE_TIEM,nil];
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
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,
                                                    ODB_DATATYPE_TEXT,nil];
        self.primaryKeys = [NSArray arrayWithObjects:USRT02_TRAIN_ALARM_TRAI_ALAM_ID,nil ];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqualToString:USRT02_TRAIN_ALARM_TRAI_ALAM_ID]) {
        self.traiAlamId = value;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_LINE_ID]){
        self.lineId = value;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_LINE_NAME_LOCL]){
        self.lineNameLocl = value;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_STAT_ID]){
        self.statId = value;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_STAT_NAME_LOCL]){
        self.statNameLocl = value;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_FIRST_TIME]){
        self.firstTime = value;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_LAST_TIME]){
        self.lastTime = value;
    }else if ([item isEqualToString:USRT02_TRAIN_ALARM_TRAI_DIRT]){
        self.traiDirt = value;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_FIRST_FLAG]){
        self.firstFlag = value;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_LAST_FLAG]){
        self.lastFlag = value;
    }else if ([item isEqualToString:USRT02_TRAIN_ALARM_BEEP_FLAG]){
        self.beepFlag = value;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_VOLE_FLAG]){
        self.voleFlag = value;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_ALARM_TIME]){
        self.alarmTime = value;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_SAVE_TIEM]){
        self.saveTime = value;
    }else{
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqualToString:USRT02_TRAIN_ALARM_TRAI_ALAM_ID]) {
        return self.traiAlamId;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_LINE_ID]){
        return self.lineId;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_LINE_NAME_LOCL]){
        return self.lineNameLocl;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_STAT_ID]){
        return self.statId;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_STAT_NAME_LOCL]){
        return self.statNameLocl;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_FIRST_TIME]){
        return self.firstTime;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_LAST_TIME]){
        return self.lastTime;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_TRAI_DIRT]){
        return self.traiDirt;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_FIRST_FLAG]){
        return self.firstFlag;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_LAST_FLAG]){
        return self.lastFlag;
    }else if ([item isEqualToString:USRT02_TRAIN_ALARM_BEEP_FLAG]){
        return self.beepFlag;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_VOLE_FLAG]){
        return self.voleFlag;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_ALARM_TIME]){
        return self.alarmTime;
    }else if([item isEqualToString:USRT02_TRAIN_ALARM_SAVE_TIEM]){
        return self.saveTime;
    }else{
       return  [super item:item ];
    }
}

@end