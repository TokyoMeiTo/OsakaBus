//
//  InfT01StrategyTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/10/10.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define INFT01_STRATEGY             @"INFT01_STRATEGY"
#define INFT01_STRA_ID              @"STRA_ID"
#define INFT01_STRA_THEME           @"STRA_THEME"
#define INFT01_SPPL_PEOPLE          @"SPPL_PEOPLE"
#define INFT01_STRA_SEASON          @"STRA_SEASON"
#define INFT01_STRA_DESCRIPTION     @"STRA_DESCRIPTION"
#define INFT01_READ_FLAG            @"READ_FLAG"
#define INFT01_READ_TIME            @"READ_TIME"
#define INFT01_FAVO_FLAG            @"FAVO_FLAG"
#define INFT01_FAVO_TIME            @"FAVO_TIME"

@interface InfT01StrategyTable : ODBDataTable{
}

@property(copy,nonatomic) NSString* straId;
@property(copy,nonatomic) NSString* straTheme;
@property(copy,nonatomic) NSString* spplPeople;
@property(copy,nonatomic) NSString* straSeason;
@property(copy,nonatomic) NSString* straDescription;
@property(copy,nonatomic) NSString* readFlag;
@property(copy,nonatomic) NSString* readTime;
@property(copy,nonatomic) NSString* favoFlag;
@property(copy,nonatomic) NSString* favoTime;

@end