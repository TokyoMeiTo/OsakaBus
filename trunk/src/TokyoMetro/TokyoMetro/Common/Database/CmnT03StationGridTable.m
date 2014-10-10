//
//  CmnT03StationGridTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "CmnT03StationGridTable.h"

@implementation CmnT03StationGridTable
@synthesize statId;
@synthesize pontXFrom;
@synthesize pontYFrom;
@synthesize pontXTo;
@synthesize pontYTo;

-(id)init{

    self = [super init];
    if (self) {
        self.tableName = CMNT03_STATION_GRID;
        self.columns = [NSArray arrayWithObjects:
                        CMNT03_STAT_ID,
                        CMNT03_PONT_X_FROM,
                        CMNT03_PONT_Y_FROM,
                        CMNT03_PONT_X_TO,
                        CMNT03_PONT_Y_TO, nil];
        self.dataTypes = [NSArray arrayWithObjects:
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_INTEGER,
                          ODB_DATATYPE_INTEGER,
                          ODB_DATATYPE_INTEGER,
                          ODB_DATATYPE_INTEGER, nil];
        self.primaryKeys = [NSArray arrayWithObjects:CMNT03_STAT_ID, nil];
    }
    return self;
}



-(void)item:(NSString *)item value:(id)value{
    if ([item isEqualToString:CMNT03_STAT_ID]) {
        self.statId = value;
    }else if([item isEqualToString:CMNT03_PONT_X_FROM]){
        self.pontXFrom = value;
    }else if([item isEqualToString:CMNT03_PONT_Y_FROM]){
        self.pontYFrom = value;
    }else if([item isEqualToString:CMNT03_PONT_X_TO]){
        self.pontXTo = value;
    }else if([item isEqualToString:CMNT03_PONT_Y_TO]){
        self.pontYTo = value;
    }else {
        [super item:item value:value];
    }
    
}

-(id)item:(NSString *)item{

    if ([item isEqualToString:CMNT03_STAT_ID]) {
        return self.statId;
    }else if([item isEqualToString:CMNT03_PONT_X_FROM]){
        return self.pontXFrom;
    }else if([item isEqualToString:CMNT03_PONT_Y_FROM]){
        return self.pontYFrom;
    }else if([item isEqualToString:CMNT03_PONT_X_TO]){
        return self.pontXTo;
    }else if([item isEqualToString:CMNT03_PONT_Y_TO]){
        return self.pontYTo;
    }else {
       return [super item:item ];
    }
}


@end
