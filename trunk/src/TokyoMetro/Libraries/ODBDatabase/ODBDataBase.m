//
//  ODBDataBase.m
//  ONTS
//
//  Created by ohs on 12/05/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ODBDataBase.h"

@implementation ODBDataBase

static ODBDataBase *instance = nil;

//获取单例
+(ODBDataBase *)getInstance
{
    @synchronized(self) 
    {
        if (instance == nil) 
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

//读取数据库
-(FMDatabase* )loadDB
{
    //将文件拷贝到路径
    NSFileManager * fileMan = [NSFileManager defaultManager];
    if (![fileMan fileExistsAtPath:ODB_DATABASE_FULL_PATH]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:ODB_DATABASE_NAME ofType:ODB_DATABASE_EXT_NAME];
        NSData * database = [NSData dataWithContentsOfFile:path];
        [database writeToFile:ODB_DATABASE_FULL_PATH atomically:YES];
    }
    
    FMDatabase * fmdb = [FMDatabase databaseWithPath:ODB_DATABASE_FULL_PATH];
    if (![fmdb open]) {
        NSLog(@"Could not open db.");
        [fmdb release];
        return nil;
    }
    //开启缓存
    [fmdb setShouldCacheStatements:YES];
    return fmdb;
}

@end
