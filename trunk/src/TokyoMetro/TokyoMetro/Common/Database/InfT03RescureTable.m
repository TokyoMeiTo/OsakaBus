//
//  InfT03RescureTable.m
//  TokyoMetro
//
//  Created by lusy on 2014/09/19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "InfT03RescureTable.h"
@implementation InfT03RescureTable

@synthesize rescId;
@synthesize rescLoca;
@synthesize rescType;
@synthesize rescContentCn;
@synthesize rescContentJp;
@synthesize readFlag;
@synthesize readTime;
@synthesize favoFlag;
@synthesize favoTime;

-(id)init{
    self = [super init];
    if (self) {
        self.tableName = INFT03_RESCURE;
        self.columns = [NSArray arrayWithObjects:
                        INFT03_RESCURE_RESC_ID,
                        INFT03_RESCURE_RESC_LOCA,
                        INFT03_RESCURE_RESC_TYPE,
                        INFT03_RESCURE_RESC_CONTENT_CN,
                        INFT03_RESCURE_RESC_CONTENT_JP,
                        INFT03_RESCURE_READ_FLAG,
                        INFT03_RESCURE_READ_TIME,
                        INFT03_RESCURE_READ_FLAG,
                        INFT03_RESCURE_FAVO_TIME,
                        nil];
        
        self.dataTypes = [NSArray arrayWithObjects:
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          ODB_DATATYPE_TEXT,
                          nil];
        self.primaryKeys = [NSArray arrayWithObjects:INFT03_RESCURE_RESC_ID,nil];
    }
    return self;
}

-(void)item:(NSString *)item value:(id)value{
    if ([item isEqual:INFT03_RESCURE_RESC_ID]) {
        self.rescId = value;
    }else if([item isEqual:INFT03_RESCURE_RESC_LOCA]){
        self.rescLoca = value;
    }else if([item isEqual:INFT03_RESCURE_RESC_TYPE]){
        self.rescType = value;
    }else if([item isEqual:INFT03_RESCURE_RESC_CONTENT_CN]){
        self.rescContentCn = value;
    }else if([item isEqual:INFT03_RESCURE_RESC_CONTENT_JP]){
        self.rescContentJp = value;
    }else if([item isEqual:INFT03_RESCURE_READ_FLAG]){
        self.readFlag = value;
    }else if([item isEqual:INFT03_RESCURE_READ_TIME]){
        self.readTime = value;
    }else if([item isEqual:INFT03_RESCURE_FAVO_FLAG]){
        self.favoFlag = value;
    }else if([item isEqual:INFT03_RESCURE_FAVO_TIME]){
        self.favoTime = value;
    }else {
        [super item:item value:value];
    }
}

-(id)item:(NSString *)item{
    if ([item isEqual:INFT03_RESCURE_RESC_ID]) {
        return self.rescId;
    }else if([item isEqual:INFT03_RESCURE_RESC_LOCA]){
        return self.rescLoca;
    }else if([item isEqual:INFT03_RESCURE_RESC_TYPE]){
        return self.rescType;
    }else if([item isEqual:INFT03_RESCURE_RESC_CONTENT_CN]){
        return self.rescContentCn;
    }else if([item isEqual:INFT03_RESCURE_RESC_CONTENT_JP]){
        return self.rescContentJp;
    }else if([item isEqual:INFT03_RESCURE_READ_FLAG]){
        return self.readFlag;
    }else if([item isEqual:INFT03_RESCURE_READ_TIME]){
        return self.readTime;
    }else if([item isEqual:INFT03_RESCURE_FAVO_FLAG]){
        return self.favoFlag;
    }else if([item isEqual:INFT03_RESCURE_FAVO_TIME]){
        return self.favoTime;
    }else {
        return [super item:item ];
    }
}


@end


