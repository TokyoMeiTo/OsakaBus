//
//  LinT06FareTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/23.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

//
//  LinT04RouteTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/23.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "LinT06FareTable.h"

@implementation LinT06FareTable

@synthesize ruteId;
@synthesize fareAdult;
@synthesize fareIdChild;
@synthesize fareIdAdult;
@synthesize fareChild;

-(id)init{
    self = [super init];
    if (self) {
        self.tableName = LINT06_FARE;
        self.columns = [NSArray arrayWithObjects:
                        LINT06_FARE_RUTE_ID,
                        LINT06_FARE_FARE_ADULT,
                        LINT06_FARE_FARE_CHILD,
                        LINT06_FARE_FARE_ID_CHILD,
                        LINT06_FARE_FARE_ID_CHILD,nil];
        self.dataTypes = [NSArray arrayWithObjects:
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,nil];
        self.primaryKeys = [NSArray arrayWithObjects:LINT06_FARE_RUTE_ID ,nil];
    }
    return  self;
}


-(void)item:(NSString *)item value:(id)value{
    if ([item isEqual:LINT06_FARE_RUTE_ID]) {
        self.ruteId = value;
    }else if([item isEqual:LINT06_FARE_FARE_ADULT]){
        self.fareAdult = value;
    }else if([item isEqual:LINT06_FARE_FARE_CHILD]){
        self.fareChild = value;
    }else if([item isEqual:LINT06_FARE_FARE_ID_ADULT]){
        self.fareIdAdult = value;
    }else if([item isEqual:LINT06_FARE_FARE_ID_CHILD]){
        self.fareIdChild = value;
    }else{
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqual:LINT06_FARE_RUTE_ID]) {
        return self.ruteId;
    }else if([item isEqual:LINT06_FARE_FARE_ADULT]){
        return self.fareAdult;
    }else if([item isEqual:LINT06_FARE_FARE_CHILD]){
        return self.fareChild;
    }else if([item isEqual:LINT06_FARE_FARE_ID_ADULT]){
        return self.fareIdAdult;
    }else if([item isEqual:LINT06_FARE_FARE_ID_CHILD]){
        return self.fareIdChild;
    }else{
        return  [super item:item];
    }
}
@end