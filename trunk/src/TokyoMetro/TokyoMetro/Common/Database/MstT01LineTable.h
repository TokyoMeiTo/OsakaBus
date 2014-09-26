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
#define MSTT01_LINE_NAME_EXT1     @"LINE_NAME_EXT1"
#define MSTT01_LINE_NAME_EXT2     @"LINE_NAME_EXT2"
#define MSTT01_LINE_NAME_EXT3     @"LINE_NAME_EXT3"
#define MSTT01_LINE_NAME_EXT4     @"LINE_NAME_EXT4"
#define MSTT01_LINE_NAME_EXT5     @"LINE_NAME_EXT5"
#define MSTT01_LINE_NAME_EXT6     @"LINE_NAME_EXT6"
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
@property (copy,nonatomic) NSString* lineNameExt1;
@property (copy,nonatomic) NSString* lineNameExt2;
@property (copy,nonatomic) NSString* lineNameExt3;
@property (copy,nonatomic) NSString* lineNameExt4;
@property (copy,nonatomic) NSString* lineNameExt5;
@property (copy,nonatomic) NSString* lineNameExt6;
@property (copy,nonatomic) NSString* lineLon;
@property (copy,nonatomic) NSString* lineLat;
@property (copy,nonatomic) NSString* linePref;
@property (copy,nonatomic) NSString* lineComp;

@end