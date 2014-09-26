//
//  StaT04FacilityTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/26.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define STAT04_FACILITY         @"STAT04_FACILITY"
#define STAT04_FACI_ID          @"FACI_ID"
#define STAT04_LINE_ID          @"LINE_ID"
#define STAT04_STAT_ID          @"STAT_ID"
#define STAT04_FACI_TYPE        @"FACI_TYPE"
#define STAT04_FACI_NAME        @"FACI_NAME"
#define STAT04_FACI_DESP        @"FACI_DESP"
#define STAT04_FACI_LOCL        @"FACI_LOCL"
#define STAT04_ESCA_DIRT        @"ESCA_DIRT"
#define STAT04_WHEL_CAIR_ACES   @"WHEL_CAIR_ACES"
#define STAT04_BABY_CAIR        @"BABY_CAIR"
#define STAT04_BABY_CHGN_TABL   @"BABY_CHGN_TABL"
#define STAT04_TOIL_OSTM        @"TOIL_OSTM"

@interface StaT04FacilityTable : ODBDataTable{
    
}
@property(copy,nonatomic) NSString* faciId;
@property(copy,nonatomic) NSString* lineId;
@property(copy,nonatomic) NSString* statId;
@property(copy,nonatomic) NSString* faciType;
@property(copy,nonatomic) NSString* faciName;
@property(copy,nonatomic) NSString* faciDesp;
@property(copy,nonatomic) NSString* faciLocl;
@property(copy,nonatomic) NSString* escaDirt;
@property(copy,nonatomic) NSString* whelCairAces;
@property(copy,nonatomic) NSString* babyCair;
@property(copy,nonatomic) NSString* babyChgnTabl;
@property(copy,nonatomic) NSString* toilOstm;

@end