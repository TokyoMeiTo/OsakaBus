//
//  InfT04StatKnowledgeTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "InfT04StatKnowledgeTable.h"
@implementation InfT04StatKnowledgeTable

@synthesize statKnowId;
@synthesize lineId;
@synthesize statId;
@synthesize lineName;
@synthesize statName;
@synthesize statKnowTitle;
@synthesize statKnowContent;
@synthesize readFlag;
@synthesize readTime;
@synthesize favoFlag;
@synthesize favoTime;

-(id)init{
    self = [super init];
    if (self) {
        self.tableName = INFT04_STAT_KNOWLEDGE;
        self.columns = [NSArray arrayWithObjects:INFT04_STAT_KNOWLEDGE_STAT_KNOW_ID,
                                                 INFT04_STAT_KNOWLEDGE_LINE_ID,
                                                 INFT04_STAT_KNOWLEDGE_STAT_ID,
                                                 INFT04_STAT_KNOWLEDGE_LINE_NAME,
                                                 INFT04_STAT_KNOWLEDGE_STAT_NAME,
                                                 INFT04_STAT_KNOWLEDGE_STAT_KNOW_TITLE,
                                                 INFT04_STAT_KNOWLEDGE_STAT_KNOW_CONTENT,
                                                 INFT04_STAT_KNOWLEDGE_READ_FLAG,
                                                 INFT04_STAT_KNOWLEDGE_READ_TIME,
                                                 INFT04_STAT_KNOWLEDGE_FAVO_FALG
                                                 INFT04_STAT_KNOWLEDGE_FAVO_TIME,nil];
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
                                                   ODB_DATATYPE_TEXT,nil];
        self.primaryKeys = [NSArray arrayWithObjects:INFT04_STAT_KNOWLEDGE_STAT_KNOW_ID,nil ];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqualToString:INFT04_STAT_KNOWLEDGE_STAT_KNOW_ID]) {
        self.statKnowId = value;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_LINE_ID]){
        self.lineId = value;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_STAT_ID]){
        self.statId = value;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_LINE_NAME]){
        self.lineName = value;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_STAT_NAME]){
        self.statName = value;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_STAT_KNOW_TITLE]){
        self.statKnowTitle = value;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_STAT_KNOW_CONTENT]){
        self.statKnowContent = value;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_READ_FLAG]){
        self.readFlag = value;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_READ_TIME]){
        self.readTime = value;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_FAVO_FALG]){
        self.favoFlag = value;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_FAVO_TIME]){
        self.favoTime = value;
    }else {
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqualToString:INFT04_STAT_KNOWLEDGE_STAT_KNOW_ID]) {
        return self.statKnowId;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_LINE_ID]){
        return self.lineId;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_STAT_ID]){
        return self.statId;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_LINE_NAME]){
        return self.lineName;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_STAT_NAME]){
        return self.statName;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_STAT_KNOW_TITLE]){
        return self.statKnowTitle;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_STAT_KNOW_CONTENT]){
        return self.statKnowContent;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_READ_FLAG]){
        return self.readFlag;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_READ_TIME]){
        return self.readTime;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_FAVO_FALG]){
        return self.favoFlag;
    }else if([item isEqualToString:INFT04_STAT_KNOWLEDGE_FAVO_TIME]){
        return self.favoTime; 
    }else {
        return [super item:item ];
    }
}
@end
