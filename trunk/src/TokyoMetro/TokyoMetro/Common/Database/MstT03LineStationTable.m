//
//  MstT03LineStationTable.m
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/12.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "MstT03LineStationTable.h"

@implementation MstT03LineStationTable
@synthesize statId;
@synthesize lineId;
@synthesize statSeq;

-(id)init{
    
    self = [super init];
    if (self) {
        self.tableName = MSTT03_LINE_STATION;
        self.columns = [NSArray arrayWithObjects:
                        MSTT03_STAT_ID,
                        MSTT03_LINE_ID,
                        MSTT03_STAT_SEQ, nil];
        self.dataTypes = [NSArray arrayWithObjects:
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT, nil];
        self.primaryKeys = [NSArray arrayWithObjects:MSTT03_STAT_ID, MSTT03_LINE_ID, nil];
        
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if([item isEqual:MSTT03_STAT_ID]){
        self.statId = value;
    }else if([item isEqual:MSTT03_LINE_ID]){
        self.lineId = value;
    }else if([item isEqual:MSTT03_STAT_SEQ]){
        self.statSeq = value;
    }else{
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if([item isEqual:MSTT03_STAT_ID]){
        return self.statId;
    }else if([item isEqual:MSTT03_LINE_ID]){
        return self.lineId;
    }else if([item isEqual:MSTT03_STAT_SEQ]){
        return self.statSeq;
    }else{
        return [super item:item];
    }
}

@end