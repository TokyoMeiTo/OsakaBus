//
//  UsrT03FavoriteTable.h
//  TokyoMetro
//
//  Created by lusy on 2014/09/26.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODB.h"

#define USRT03_FAVORITE         @"USRT03_FAVORITE"
#define USRT03_FAVO_TYPE        @"FAVO_TYPE"
#define USRT03_FAVO_TIME        @"FAVO_TIME"
#define USRT03_LINE_ID          @"LINE_ID"
#define USRT03_STAT_ID          @"STAT_ID"
#define USRT03_STAT_EXIT_ID     @"STAT_ID_EXIT_ID"
#define USRT03_LMAK_ID          @"LMAK_ID"
#define USRT03_RUTE_ID          @"RUTE_ID"
#define USRT03_EXI1             @"EXT1"
#define USRT03_EXI2             @"EXT2"
#define USRT03_EXI3             @"EXT3"
#define USRT03_EXI4             @"EXT4"
#define USRT03_EXI5             @"EXT5"

@interface UsrT03FavoriteTable : ODBDataTable{
    
}
@property(copy,nonatomic) NSString* favoType;
@property(copy,nonatomic) NSString* favoTime;
@property(copy,nonatomic) NSString* lineId;
@property(copy,nonatomic) NSString* statId;
@property(copy,nonatomic) NSString* statExitId;
@property(copy,nonatomic) NSString* lmakId;
@property(copy,nonatomic) NSString* ruteId;
@property(copy,nonatomic) NSString* ext1;
@property(copy,nonatomic) NSString* ext2;
@property(copy,nonatomic) NSString* ext3;
@property(copy,nonatomic) NSString* ext4;
@property(copy,nonatomic) NSString* ext5;

@end
