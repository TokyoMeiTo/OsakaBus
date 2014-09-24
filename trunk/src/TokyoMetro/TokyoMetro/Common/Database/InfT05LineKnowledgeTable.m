//
//  InfT05LineKnowledgeTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "InfT05LineKnowledgeTable.h"
@implementation InfT05LineKnowledgeTable

@synthesize lineKnowId;
@synthesize lineId;
@synthesize lineName;
@synthesize lineKnowTitle;
@synthesize lineKnowContent;
@synthesize readFlag;
@synthesize readTime;
@synthesize favoFlag;
@synthesize favoTime;

-(id)init{
    self = [super init];
    if (self) {
        self.tableName = INFT05_LINE_KNOWLEDGE;
        self.columns = [NSArray arrayWithObjects:INFT05_LINE_KNOWLEDGE_LINE_KNOW_ID,
                                                 INFT05_LINE_KNOWLEDGE_LINE_ID,
                                                 INFT05_LINE_KNOWLEDGE_LINE_NAME,
                                                 INFT05_LINE_KNOWLEDGE_LINE_KNOW_TITLE,
                                                 INFT05_LINE_KNOWLEDGE_LINE_KNOW_CONTENT,
                                                 INFT05_LINE_KNOWLEDGE_READ_FLAG,
                                                 INFT05_LINE_KONWLEDGE_READ_TIME
                                                 INFT05_LINE_KNOWLEDGE_FAVO_FLAG,
                                                 INFT05_LINE_KNOWLEDGE_FAVO_TIME,nil];
        self.dataTypes = [NSArray arrayWithObjects:ODB_DATATYPE_TEXT,
                                                   ODB_DATATYPE_TEXT,
                                                   ODB_DATATYPE_TEXT,
                                                   ODB_DATATYPE_TEXT,
                                                   ODB_DATATYPE_TEXT,
                                                   ODB_DATATYPE_TEXT
                                                   ODB_DATATYPE_TEXT,
                                                   ODB_DATATYPE_TEXT,
                                                   ODB_DATATYPE_TEXT,nil];
        self.primaryKeys = [NSArray arrayWithObjects:INFT05_LINE_KNOWLEDGE_LINE_KNOW_ID,nil];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqualToString:INFT05_LINE_KNOWLEDGE_LINE_KNOW_ID]) {
        self.lineKnowId = value;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_LINE_ID]){
        self.lineId = value;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_LINE_NAME]){
        self.lineName = value;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_LINE_KNOW_TITLE]){
        self.lineKnowTitle = value;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_LINE_KNOW_CONTENT]){
        self.lineKnowContent = value;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_READ_FLAG]){
        self.readFlag = value;
    }else if([item isEqualToString:INFT05_LINE_KONWLEDGE_READ_TIME]){
        self.readTime = value;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_FAVO_FLAG]){
        self.favoFlag = value;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_FAVO_TIME]){
        self.favoTime = value;
    }else {
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqualToString:INFT05_LINE_KNOWLEDGE_LINE_KNOW_ID]) {
        return self.lineKnowId;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_LINE_ID]){
        return self.lineId;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_LINE_NAME]){
        return self.lineName;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_LINE_KNOW_TITLE]){
        return self.lineKnowTitle;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_LINE_KNOW_CONTENT]){
        return self.lineKnowContent;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_READ_FLAG]){
        return self.readFlag;
    }else if([item isEqualToString:INFT05_LINE_KONWLEDGE_READ_TIME]){
        return self.readTime;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_FAVO_FLAG]){
        return self.favoFlag;
    }else if([item isEqualToString:INFT05_LINE_KNOWLEDGE_FAVO_TIME]){
        return self.favoTime;
    }else {
        return [super item:item ];
    }
}

@end