//
//  LinT04RouteTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/23.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "LinT04RouteTable.h"

@implementation LinT04RouteTable

@synthesize ruteId;
@synthesize startStatId;
@synthesize startStatName;
@synthesize termStatId;
@synthesize termStatName;

-(id)init{
    self = [super init];
    if (self) {
        self.tableName = LINT04_ROUTE;
        self.columns = [NSArray arrayWithObjects:
                                                LINT04_ROUTE_RUTE_ID,
                                                LINT04_ROUTE_START_STAT_ID,
                                                LINT04_ROUTE_START_STAT_NAME,
                                                LINT04_ROUTE_TERM_STAT_ID,
                                                LINT04_ROUTE_TERM_STAT_NAME,nil];
        self.dataTypes = [NSArray arrayWithObjects:
                                                ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,
                                                ODB_DATATYPE_TEXT,nil];
        self.primaryKeys = [NSArray arrayWithObjects:LINT04_ROUTE_RUTE_ID ,nil];
    }
    return self;
}


-(void)item:(NSString *)item value:(id)value{
    if ([item isEqualToString:LINT04_ROUTE_RUTE_ID]) {
        self.ruteId = value;
    }else if([item isEqualToString:LINT04_ROUTE_START_STAT_ID]){
        self.startStatId = value;
    }else if([item isEqualToString:LINT04_ROUTE_START_STAT_NAME]){
        self.startStatName = value;
    }else if([item isEqualToString:LINT04_ROUTE_TERM_STAT_ID]){
        self.termStatId = value;
    }else if([item isEqualToString:LINT04_ROUTE_TERM_STAT_NAME]){
        self.termStatName = value;
    }else{
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqualToString:LINT04_ROUTE_RUTE_ID]) {
        return self.ruteId;
    }else if([item isEqualToString:LINT04_ROUTE_START_STAT_ID]){
        return self.startStatId;
    }else if([item isEqualToString:LINT04_ROUTE_START_STAT_NAME]){
        return self.startStatName;
    }else if([item isEqualToString:LINT04_ROUTE_TERM_STAT_ID]){
        return self.termStatId;
    }else if([item isEqualToString:LINT04_ROUTE_TERM_STAT_NAME]){
        return self.startStatName;
    }else{
       return  [super item:item];
    }
}
@end