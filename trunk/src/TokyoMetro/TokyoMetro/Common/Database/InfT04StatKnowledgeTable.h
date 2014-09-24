//
//  InfT04StatKnowledgeTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define INFT04_STAT_KNOWLEDGE                   @"INTF04_STAT_KNOWLEDGE"
#define INFT04_STAT_KNOWLEDGE_STAT_KNOW_ID      @"STAT_KNOW_ID"
#define INFT04_STAT_KNOWLEDGE_LINE_ID           @"LINE_ID"
#define INFT04_STAT_KNOWLEDGE_STAT_ID           @"STAT_ID"
#define INFT04_STAT_KNOWLEDGE_LINE_NAME         @"LINE_NAME"
#define INFT04_STAT_KNOWLEDGE_STAT_NAME         @"STAT_NAME"
#define INFT04_STAT_KNOWLEDGE_STAT_KNOW_TITLE   @"STAT_KNOW_TITLE"
#define INFT04_STAT_KNOWLEDGE_STAT_KNOW_CONTENT @"STAT_KNOW_CONTENT"
#define INFT04_STAT_KNOWLEDGE_READ_FLAG         @"READ_FLAG"
#define INFT04_STAT_KNOWLEDGE_READ_TIME         @"READ_TIME"
#define INFT04_STAT_KNOWLEDGE_FAVO_FALG         @"FAVO_FLAG"
#define INFT04_STAT_KNOWLEDGE_FAVO_TIME         @"FAVO_TIME"

@interface InfT04StatKnowledgeTable : ODBDataTable{
}
@property (copy,nonatomic) NSString* statKnowId;
@property (copy,nonatomic) NSString* lineId;
@property (copy,nonatomic) NSString* statId;
@property (copy,nonatomic) NSString* lineName;
@property (copy,nonatomic) NSString* statName;
@property (copy,nonatomic) NSString* statKnowTitle;
@property (copy,nonatomic) NSString* statKnowContent;
@property (copy,nonatomic) NSString* readFlag;
@property (copy,nonatomic) NSString* readTime;
@property (copy,nonatomic) NSString* favoFlag;
@property (copy,nonatomic) NSString* favoTime;
@end