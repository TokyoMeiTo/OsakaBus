//
//  MstT01LineTable.h
//  TokyoMetro
//
//  Created by limc on 2014/09/12.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define MSTT01_LINE               @"MSTT01_LINE"
#define MSTT01_LINE_ID            @"LINE_ID"
#define MSTT01_LINE_METRO_ID      @"LINE_METRO_ID"
#define MSTT01_LINE_METRO_ID_FULL @"LINE_METRO_ID_FULL"
#define MSTT01_LINE_NAME          @"LINE_NAME"
#define MSTT01_LINE_NAME_KANA     @"LINE_NAME_KANA"
#define MSTT01_LINE_NAME_ROME     @"LINE_NAME_ROME"
#define MSTT01_LINE_NAME_EXIT1    @"LINE_NAME_EXIT1"
#define MSTT01_LINE_NAME_EXIT2    @"LINE_NAME_EXIT2"
#define MSTT01_LINE_NAME_EXIT3    @"LINE_NAME_EXIT3"
#define MSTT01_LINE_NAME_EXIT4    @"LINE_NAME_EXIT4"
#define MSTT01_LINE_NAME_EXIT5    @"LINE_NAME_EXIT5"
#define MSTT01_LINE_NAME_EXIT6    @"LINE_NAME_EXIT6"
#define MSTT01_LINE_LON           @"LINE_LON"
#define MSTT01_LINE_LAT           @"LINE_LAT"
#define MSTT01_LINE_PREF          @"LINE_PREF"
#define MSTT01_LINE_COMP          @"LINE_COMP"

@interface MstT01LineTable : ODBDataTable{
}
@property (copy,nonatomic) NSString* lineId;
@property (copy,nonatomic) NSString* lineMetroId;
@property (copy,nonatomic) NSString* lineMetroIdFull;
@property (copy,nonatomic) NSString* lineName;
@property (copy,nonatomic) NSString* lineNameKana;
@property (copy,nonatomic) NSString* lineNameRome;
@property (copy,nonatomic) NSString* lineNameExit1;
@property (copy,nonatomic) NSString* lineNameExit2;
@property (copy,nonatomic) NSString* lineNameExit3;
@property (copy,nonatomic) NSString* lineNameExit4;
@property (copy,nonatomic) NSString* lineNameExit5;
@property (copy,nonatomic) NSString* lineNameExit6;
@property (copy,nonatomic) NSString* lineLon;
@property (copy,nonatomic) NSString* lineLat;
@property (copy,nonatomic) NSString* linePref;
@property (copy,nonatomic) NSString* lineComp;

@end