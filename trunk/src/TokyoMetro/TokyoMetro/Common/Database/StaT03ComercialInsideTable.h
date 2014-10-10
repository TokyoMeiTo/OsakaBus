//
//  StaT03ComervialInsideTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/10/10.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define STAT03_COMERCIAL_INSIDE     @"STAT03_COMERCIAL_INSIDE"
#define STAT03_COME_INSI_ID         @"COME_INSI_ID"
#define STAT03_COME_INSI_NAME       @"COME_INSI_NAME"
#define STAT03_COME_INSI_TYPE       @"COME_INSI_TYPE"
#define STAT03_COME_INSI_TAG        @"COME_INSI_TAG"
#define STAT03_COME_INSI_PRICE      @"COME_INSI_PRICE"
#define STAT03_COME_INSI_LOCA_CH    @"COME_INSI_LOCA_CH"
#define STAT03_COME_INSI_LOCA_JP    @"COME_INSI_LOCA_JP"
#define STAT03_COME_INSI_BISI_HOUR  @"COME_INSI_BISI_HOUR"
#define STAT03_COME_INSI_IMAGE      @"COME_INSI_IMAGE"
#define STAT03_FAVO_FLAG            @"FAVO_FLAG"
#define STAT03_FAVO_TIME            @"FAVO_TIME"

@interface StaT03ComervialInsideTable : ODBDataTable{
    
}

@property(copy,nonatomic) NSString* comeInsiId;
@property(copy,nonatomic) NSString* comeInsiName;
@property(copy,nonatomic) NSString* comeInsiType;
@property(copy,nonatomic) NSString* comeInsiTag;
@property(copy,nonatomic) NSString* comeInsiPrice;
@property(copy,nonatomic) NSString* comeInsiLocaCh;
@property(copy,nonatomic) NSString* comeInsiLocaJp;
@property(copy,nonatomic) NSString* comeInsiBisiHour;
@property(copy,nonatomic) NSString* comeInsiImage;
@property(copy,nonatomic) NSString* favoFlag;
@property(copy,nonatomic) NSString* favoTime;

@end
