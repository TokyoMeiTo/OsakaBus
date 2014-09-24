//
//  InfT02_TipsTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define INFT02_TIPS             @"INFT02_TIPS"
#define INFT02_TIPS_ID          @"TIPS_ID"
#define INFT02_TIPS_TYPE        @"TIPS_TYPE"
#define INFT02_TIPS_SUB_TYPE    @"TIPS_SUB_TYPE"
#define INFT02_TIPS_TITLE       @"TIPS_TITLE"
#define INFT02_TIPS_CONTENT     @"TIPS_CONTENT"
#define INFT02_READ_FLAG        @"READ_FLAG"
#define INFT02_REAG_TIME        @"READ_TIME"
#define INFT02_FAVO_FLAG        @"FAVO_FLAG"
#define INFT02_FAVO_TIME        @"FAVO_TIME"

@interface InfT02TipsTable : ODBDataTable{
}

@property (copy,nonatomic) NSString* tipsId;
@property (copy,nonatomic) NSString* tipsType;
@property (copy,nonatomic) NSString* tipsSubType;
@property (copy,nonatomic) NSString* tipsTitle;
@property (copy,nonatomic) NSString* tipsContent;
@property (copy,nonatomic) NSString* readFlag;
@property (copy,nonatomic) NSString* readTime;
@property (copy,nonatomic) NSString* favoFlag;
@property (copy,nonatomic) NSString* favoTime;

@end