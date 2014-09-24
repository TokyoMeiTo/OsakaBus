//
//  InfT03RescureTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define INFT03_RESCURE                  @"INFT03_RESCURE"
#define INFT03_RESCURE_RESC_ID          @"RESC_ID"
#define INFT03_RESCURE_RESC_LOCA        @"RESC_LOCA"
#define INFT03_RESCURE_RESC_TYPE        @"RESC_TYPE"
#define INFT03_RESCURE_RESC_CONTENT_CN  @"RESC_CONTENT_CN"
#define INFT03_RESCURE_RESC_CONTENT_JP  @"RESC_CONTENT_JP"
#define INFT03_RESCURE_READ_FLAG        @"READ_FLAG"
#define INFT03_RESCURE_READ_TIME        @"READ_TIME"
#define INFT03_RESCURE_FAVO_FLAG        @"FAVO_FLAG"
#define INFT03_RESCURE_FAVO_TIME        @"FACO_TIME"

@interface InfT03RescureTable : ODBDataTable{
}

@property(copy,nonatomic) NSString* rescId;
@property(copy,nonatomic) NSString* rescLoca;
@property(copy,nonatomic) NSString* rescType;
@property(copy,nonatomic) NSString* rescContentCn;
@property(copy,nonatomic) NSString* rescContentJp;
@property(copy,nonatomic) NSString* readFlag;
@property(copy,nonatomic) NSString* readTime;
@property(copy,nonatomic) NSString* favoFlag;
@property(copy,nonatomic) NSString* favoTime;


@end