//
//  LinT06RouteDetailTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "LinT05RouteDetailTable.h"
@implementation LinT05RouteDetailTable

@synthesize ruteId;
@synthesize ruteIdGroupId;
@synthesize exchStatId;
@synthesize exchLineId;
@synthesize exchDestId;
@synthesize exchType;
@synthesize exchSeq;
@synthesize moveTime;
@synthesize waitTime;

-(id)init{
    self = [super init];
    if (self) {
        self.tableName = LINT05_ROUTE_DETAIL;
        self.columns = [NSArray arrayWithObjects:
                        LINT05_ROUTE_DETAIL_RUTE_ID,
                        LINT05_ROUTE_DETAIL_RUTE_ID_GROUP_ID,
                        LINT05_ROUTE_DETAIL_EXCH_STAT_ID,
                        LINT05_ROUTE_DETAIL_EXCH_LINE_ID,
                        LINT05_ROUTE_DETAIL_EXCH_DEST_ID,
                        LINT05_ROUTE_DETAIL_EXCH_TYPE,
                        LINT05_ROUTE_DETAIL_EXCH_SEQ,
                        LINT05_ROUTE_DETAIL_MOVE_TIME,
                        LINT05_ROUTE_DETAIL_WAIT_TIME,nil];
        self.dataTypes = [NSArray arrayWithObjects:
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_INTEGER,
                          ODB_DATATYPE_INTEGER,
                          ODB_DATATYPE_INTEGER,nil];
        self.primaryKeys = [NSArray arrayWithObjects:LINT05_ROUTE_DETAIL_RUTE_ID, nil];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqual:LINT05_ROUTE_DETAIL_RUTE_ID]) {
        self.ruteId = value;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_RUTE_ID_GROUP_ID]){
        self.ruteIdGroupId = value;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_EXCH_STAT_ID]){
        self.exchStatId = value;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_EXCH_LINE_ID]){
        self.exchLineId = value;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_EXCH_DEST_ID]){
        self.exchDestId = value;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_EXCH_TYPE]){
        self.exchType = value;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_EXCH_SEQ]){
        self.exchSeq = value;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_MOVE_TIME]){
        self.moveTime = value;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_WAIT_TIME]){
        self.waitTime = value;
    }else{
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqual:LINT05_ROUTE_DETAIL_RUTE_ID]) {
        return self.ruteId;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_RUTE_ID_GROUP_ID]){
        return self.ruteIdGroupId;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_EXCH_STAT_ID]){
        return self.exchStatId;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_EXCH_LINE_ID]){
        return self.exchLineId;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_EXCH_DEST_ID]){
        return self.exchDestId;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_EXCH_TYPE]){
        return self.exchType;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_EXCH_SEQ]){
        return self.exchSeq;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_MOVE_TIME]){
        return self.moveTime;
    }else if ([item isEqual:LINT05_ROUTE_DETAIL_WAIT_TIME]){
        return self.waitTime;
    }else{
        return [super item:item];
    }
}
@end