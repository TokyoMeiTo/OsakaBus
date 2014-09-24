
//
//  InfT05LineKnowledgeTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define INFT05_LINE_KNOWLEDGE                       @"INFT05_LINE_KNOWLEDGE"
#define INFT05_LINE_KNOWLEDGE_LINE_KNOW_ID          @"LINE_KNOW_ID"
#define INFT05_LINE_KNOWLEDGE_LINE_ID               @"LINE_ID"
#define INFT05_LINE_KNOWLEDGE_LINE_NAME             @"LINE_NAME"
#define INFT05_LINE_KNOWLEDGE_LINE_KNOW_TITLE       @"LINE_KNOW_TITLE"
#define INFT05_LINE_KNOWLEDGE_LINE_KNOW_CONTENT     @"LINE_KNOW_CONTENT"
#define INFT05_LINE_KNOWLEDGE_READ_FLAG             @"READ_FLAG"
#define INFT05_LINE_KONWLEDGE_READ_TIME             @"READ_TIME"
#define INFT05_LINE_KNOWLEDGE_FAVO_FLAG             @"FAVO_FLAG"
#define INFT05_LINE_KNOWLEDGE_FAVO_TIME             @"FAVO_TIME"

@interface InfT05LineKnowledgeTable : ODBDataTable{
    
}

@property(copy,nonatomic) NSString* lineKnowId;
@property(copy,nonatomic) NSString* lineId;
@property(copy,nonatomic) NSString* lineName;
@property(copy,nonatomic) NSString* lineKnowTitle;
@property(copy,nonatomic) NSString* lineKnowContent;
@property(copy,nonatomic) NSString* readFlag;
@property(copy,nonatomic) NSString* readTime;
@property(copy,nonatomic) NSString* favoFlag;
@property(copy,nonatomic) NSString* favoTime;

@end