//
//  CmnT04ImageTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/26.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "CmnT04ImageTable.h"

@implementation CmnT04ImageTable

@synthesize imagId;
@synthesize imagPath;
@synthesize imagUrl;

-(id)init{
    self= [super init];
    if (self) {
        self.tableName = CMNT04_IMAGE;
        self.columns = [NSArray arrayWithObjects:
                        CMNT04_IMAG_ID,
                        CMNT04_IMAG_PATH,
                        CMNT04_IMAG_URL
                        , nil];
        self.dataTypes = [NSArray arrayWithObjects:
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT
                          , nil];
        self.primaryKeys = [NSArray arrayWithObjects:CMNT04_IMAG_ID, nil];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqual:CMNT04_IMAG_ID]) {
        self.imagId = value;
    }else if ([item isEqual:CMNT04_IMAG_PATH]){
        self.imagPath = value;
    }else if ([item isEqual:CMNT04_IMAG_URL]){
        self.imagUrl = value;
    }else{
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqual:CMNT04_IMAG_ID]) {
        return self.imagId;
    }else if ([item isEqual:CMNT04_IMAG_PATH]){
        return self.imagPath;
    }else if ([item isEqual:CMNT04_IMAG_URL]){
        return self.imagUrl;
    }else{
        return [super item:item];
    }
}

@end
