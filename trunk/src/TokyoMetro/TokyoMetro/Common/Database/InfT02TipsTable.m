//
//  InfT02_TipsTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "InfT02TipsTable.h"

@implementation InfT02TipsTable

@synthesize tipsId;
@synthesize tipsType;
@synthesize tipsSubType;
@synthesize tipsTitle;
@synthesize tipsContent;
@synthesize readFlag;
@synthesize readTime;
@synthesize favoFlag;
@synthesize favoTime;

-(id)init{
    self = [super init];
    if (self) {
        self.tableName = INFT02_TIPS;
        self.columns = [NSArray arrayWithObjects:
                        INFT02_TIPS_ID,
                        INFT02_TIPS_TYPE,
                        INFT02_TIPS_SUB_TYPE,
                        INFT02_TIPS_TITLE,
                        INFT02_TIPS_CONTENT,
                        INFT02_READ_FLAG,
                        INFT02_REAG_TIME,
                        INFT02_FAVO_FLAG,
                        INFT02_FAVO_TIME,nil];
        self.dataTypes = [NSArray arrayWithObjects:
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,nil];
        self.primaryKeys = [NSArray arrayWithObjects:INFT02_TIPS_ID,nil];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqualToString:INFT02_TIPS_ID]) {
        self.tipsId = value;
    }else if([item isEqualToString:INFT02_TIPS_TYPE]){
        self.tipsType = value;
    }else if([item isEqualToString:INFT02_TIPS_SUB_TYPE]){
        self.tipsSubType = value;
    }else if([item isEqualToString:INFT02_TIPS_TITLE]){
        self.tipsTitle = value;
    }else if([item isEqualToString:INFT02_TIPS_CONTENT]){
        self.tipsContent = value;
    }else if([item isEqualToString:INFT02_READ_FLAG]){
        self.readFlag = value;
    }else if([item isEqualToString:INFT02_REAG_TIME]){
        self.readTime = value;
    }else if([item isEqualToString:INFT02_FAVO_FLAG]){
        self.favoFlag = value;
    }else if([item isEqualToString:INFT02_FAVO_TIME]){
        self.favoTime = value;
    }else {
        [super item:item value:value];
    }
}


-(id)item:(NSString *)item{
    if ([item isEqualToString:INFT02_TIPS_ID]) {
        return  self.tipsId;
    }else if([item isEqualToString:INFT02_TIPS_TYPE]){
        return self.tipsType;
    }else if([item isEqualToString:INFT02_TIPS_SUB_TYPE]){
        return self.tipsSubType;
    }else if([item isEqualToString:INFT02_TIPS_TITLE]){
        return self.tipsTitle;
    }else if([item isEqualToString:INFT02_TIPS_CONTENT]){
        return self.tipsContent;
    }else if([item isEqualToString:INFT02_READ_FLAG]){
        return self.readFlag;
    }else if([item isEqualToString:INFT02_REAG_TIME]){
        return self.readTime;
    }else if([item isEqualToString:INFT02_FAVO_FLAG]){
        return self.favoFlag;
    }else if([item isEqualToString:INFT02_FAVO_TIME]){
        return self.favoTime;
    }else {
        return [super item:item];
    }
}

@end