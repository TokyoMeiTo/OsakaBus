//
//  ODBDataTable.m
//  ONTSDatabase
//
//  Created by ohs on 12-3-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ODBDataTable.h"

@implementation ODBDataTable

@synthesize tableName = _tableName;
@synthesize columns = _columns;
@synthesize dataTypes = _dataTypes;
@synthesize primaryKeys = _primaryKeys;
@synthesize rowid = _rowid;

- (void) dealloc
{
    [_tableName release];
    [_columns release];
    [_dataTypes release];
    [_primaryKeys release];
    [_rowid release];
    
    [super dealloc];
}

- (id) item:(NSString *) item
{
    if([item isEqual:ODB_TABLE_ROWID])
    {
        return self.rowid;
    }else
    {
        return nil;
    }
}

- (void) item:(NSString *) item value:(id)value
{
    if([item isEqual:ODB_TABLE_ROWID])
    {
        //拷贝赋值给rowid
        _rowid = [value copy];
    }else
    {
    }
}

- (void) reset
{    
    _rowid = @"";
}


- (BOOL) exsit
{
    if([self count] > 0)
    {
        return YES;
    }else
    {
        return NO;
    }
}

- (NSUInteger) count
{
    //返回结果
    NSUInteger result = 0;
    
    NSString *sql = @"select count(*) from %@ where 1 = 1 ";
    sql = [NSString stringWithFormat:sql,self.tableName];
    
    //参数列表
    NSMutableArray *arguments = [[[NSMutableArray alloc] init]autorelease];
    
    for (NSUInteger i = 0;  i < [self.columns count] ; i++) {
        
        NSString *column = [self.columns objectAtIndex:i];
        NSObject *value = [self item:column];
        
        //追加SQL
        if(value && ![value isEqual:@""])
        {
            sql = [sql stringByAppendingFormat:@"and %@ = ? ", column];
            [arguments addObject:value];
        }
    }
    
    FMDatabase *fmdb = [[ODBDataBase getInstance]loadDB];
    NSLog(@"SQL:%@",sql);
    FMResultSet *rs = [fmdb executeQuery:sql withArgumentsInArray:arguments];
        
    if ([rs next]) {
        
        NSObject *obj =  [rs objectForColumnIndex:0];
        //获取数据
        if([obj isKindOfClass:[NSNumber class]])
        {
            NSLog(@"COUNT:%d",((NSNumber *)obj).intValue);
            result = ((NSNumber *)obj).intValue;
        }
    }
    
    [rs close];
    [fmdb close];
    return result;
}

- (ODBDataTable *) select
{
    NSString *sql = @"select *, %@ from %@ where 1 = 1 ";
    sql = [NSString stringWithFormat:sql,ODB_TABLE_ROWID,self.tableName];
    
    //参数列表
    NSMutableArray *arguments = [[[NSMutableArray alloc] init]autorelease];
    
    for (NSUInteger i = 0;  i < [self.columns count] ; i++) {
        
        NSString *column = [self.columns objectAtIndex:i];
        NSObject *value = [self item:column];
        
        //追加SQL
        if(value && ![value isEqual:@""])
        {
            sql = [sql stringByAppendingFormat:@"and %@ = ? ", column];
            [arguments addObject:value];
        }
    }
    
    //只选取第一行数据
    sql = [sql stringByAppendingFormat:@"%@", @"limit 0,1 "];
    
    NSLog(@"SQL:%@",sql);
    FMDatabase *fmdb = [[ODBDataBase getInstance]loadDB];
    FMResultSet *rs = [fmdb executeQuery:sql withArgumentsInArray:arguments];
    while ([rs next]) {        
        //按照行顺序读取数据并写入
        for (NSUInteger i = 0;  i < [self.columns count] ; i++) {
            NSString *column = [self.columns objectAtIndex:i];
            NSString *datatype = [self.dataTypes objectAtIndex:i];
            if ([datatype isEqual:ODB_DATATYPE_TEXT]) {
                //设置文本格式
                [self item:column value:[rs stringForColumn:column]];
            }else if([datatype isEqual:ODB_DATATYPE_INTEGER]) {
                //设置整数格式
                [self item:column value:[NSNumber numberWithInt:[rs intForColumn:column]]];
            }else if([datatype isEqual:ODB_DATATYPE_REAL]) {
                //设置浮点数格式
                [self item:column value:[NSNumber numberWithDouble:[rs doubleForColumn:column]]];
            }else if([datatype isEqual:ODB_DATATYPE_BLOB]) {
                //设置BLOB数格式
                [self item:column value:[NSNumber numberWithDouble:[rs doubleForColumn:column]]];
            }else if([datatype isEqual:ODB_DATATYPE_DATE]) {
                //设置BLOB数格式
                [self item:column value:[rs dataForColumn:column]];
            }else
            {
                [self item:column value:nil];
            }
        }
        
        //设置ROWID
        if([rs stringForColumn:ODB_TABLE_ROWID])
        {
//            NSLog(@"ROWID:%@",[rs stringForColumn:ODB_TABLE_ROWID]);
            [self item:ODB_TABLE_ROWID value:[rs stringForColumn:ODB_TABLE_ROWID]];
        }else
        {
            NSLog(@"ROWID is no in SELECT list");
            [self item:ODB_TABLE_ROWID value:nil];
        }
    }
    [rs close];
    [fmdb close];
    return self;
}

- (NSArray *) selectAll
{
    NSString *sql = @"select *, %@ from %@ where 1 = 1 ";
    sql = [NSString stringWithFormat:sql,ODB_TABLE_ROWID,self.tableName];
    
    //参数列表
    NSMutableArray *arguments = [[[NSMutableArray alloc] init]autorelease];
    
    for (NSUInteger i = 0;  i < [self.columns count] ; i++) {
        
        NSString *column = [self.columns objectAtIndex:i];
        NSObject *value = [self item:column];
        
        //追加SQL
        if(value && ![value isEqual:@""])
        {
            sql = [sql stringByAppendingFormat:@"and %@ = ? ", column];
            [arguments addObject:value];
        }
    }
        
    NSLog(@"SQL:%@",sql);
    //返回执行
    return [self excuteQuery:sql withArgumentsInArray:arguments];
}

- (NSArray *) selectLike
{
    NSString *sql = @"select *, %@ from %@ where 1 = 1 ";
    sql = [NSString stringWithFormat:sql,ODB_TABLE_ROWID,self.tableName];
    
    //参数列表
    NSMutableArray *arguments = [[[NSMutableArray alloc] init]autorelease];
    
    for (NSUInteger i = 0;  i < [self.columns count] ; i++) {
        //获取列名
        NSString *column = [self.columns objectAtIndex:i];
        //列数据类型
        NSObject *value = [self item:column];
        
        //追加SQL
        if(value && ![value isEqual:@""])
        {
            if([[self.dataTypes objectAtIndex:i] isEqualToString:ODB_DATATYPE_INTEGER] ||
               [[self.dataTypes objectAtIndex:i] isEqualToString:ODB_DATATYPE_REAL] ||
               [[self.dataTypes objectAtIndex:i] isEqualToString:ODB_DATATYPE_DATE])
            {
                sql = [sql stringByAppendingFormat:@"and %@ = ? ", column];
                [arguments addObject:value];
            }else
            {
                sql = [sql stringByAppendingFormat:@"and %@ like ? ", column];
                //[arguments addObject:value];
                [arguments addObject:[NSString stringWithFormat:@"%%%@%%",value]];
            }
        }
    }
    
    NSLog(@"SQL:%@",sql);
    //返回执行
    return [self excuteQuery:sql withArgumentsInArray:arguments];
}

- (NSArray *) selectTop:(NSUInteger)top
{
    if(top < 1)
    {
        return nil;
    }
    
    NSString *sql = @"select *, %@ from %@ where 1 = 1 ";
    sql = [NSString stringWithFormat:sql,ODB_TABLE_ROWID,self.tableName];
    
    //参数列表
    NSMutableArray *arguments = [[[NSMutableArray alloc] init]autorelease];
    
    for (NSUInteger i = 0;  i < [self.columns count] ; i++) {
        
        NSString *column = [self.columns objectAtIndex:i];
        NSObject *value = [self item:column];
        
        //追加SQL
        if(value && ![value isEqual:@""])
        {
            sql = [sql stringByAppendingFormat:@"and %@ = ? ", column];
            [arguments addObject:value];
        }
    }
    
    //追加TOP
    sql = [sql stringByAppendingFormat:@"limit 0,%d ", top];
    
    NSLog(@"SQL:%@",sql);
    //返回执行
    return [self excuteQuery:sql withArgumentsInArray:arguments];
}

- (NSArray *) selectWithOrder:(NSString *) order desc:(BOOL) desc
{    
    NSString *sql = @"select *, %@ from %@ where 1 = 1 ";
    sql = [NSString stringWithFormat:sql,ODB_TABLE_ROWID,self.tableName];
    
    //参数列表
    NSMutableArray *arguments = [[[NSMutableArray alloc] init]autorelease];
    
    for (NSUInteger i = 0;  i < [self.columns count] ; i++) {
        
        NSString *column = [self.columns objectAtIndex:i];
        NSObject *value = [self item:column];
        
        //追加SQL
        if(value && ![value isEqual:@""])
        {
            sql = [sql stringByAppendingFormat:@"and %@ = ? ", column];
            [arguments addObject:value];
        }
    }
    
    //追加Order by
    if(desc){
        sql = [sql stringByAppendingFormat:@"order by %@ %@ ", order , @"desc"];
    }else{
        sql = [sql stringByAppendingFormat:@"order by %@", order];
    } 
    
    NSLog(@"SQL:%@",sql);
    
    //返回执行
    return [self excuteQuery:sql withArgumentsInArray:arguments];
}

- (BOOL) update
{
    if(nil == [self item:ODB_TABLE_ROWID])
    {
        return NO;
    }
    
    NSString *sql = @"update %@ set ";
    sql = [NSString stringWithFormat:sql,self.tableName];
    
    //参数列表
    NSMutableArray *arguments = [[[NSMutableArray alloc] init]autorelease];
    
    for (NSUInteger i = 0;  i < [self.columns count] ; i++) {
        
        NSString *column = [self.columns objectAtIndex:i];
        NSObject *value = [self item:column];
        
        sql = [sql stringByAppendingFormat:@"%@ = ? ", column];
        //增加逗号
        if(i < [self.columns count] -1)
        {
            sql = [sql stringByAppendingString:@","];
        }
        
        //追加SQL
        if(value && ![value isEqual:@""])
        {
            [arguments addObject:value];
        }
    }
    
    sql = [sql stringByAppendingString:@"where 1 = 1 "];
    
    //将RowID作为参数传递
    sql = [sql stringByAppendingFormat:@"and %@ = ? ", ODB_TABLE_ROWID];
    [arguments addObject:[self item:ODB_TABLE_ROWID]];
    
    NSLog(@"SQL:%@",sql);
    FMDatabase *fmdb = [[ODBDataBase getInstance]loadDB];
    return [fmdb executeUpdate:sql withArgumentsInArray:arguments];
}

- (BOOL) delete
{
    if(nil == [self item:ODB_TABLE_ROWID])
    {
        return NO;
    }
    
    NSString *sql = @"delete from %@ where 1 = 1 ";
    
    NSMutableArray *arguments = [[[NSMutableArray alloc] init]autorelease];
    
    sql = [NSString stringWithFormat:sql,self.tableName];
    
    //将RowID作为参数传递
    sql = [sql stringByAppendingFormat:@"and %@ = ? ", ODB_TABLE_ROWID];
    [arguments addObject:[self item:ODB_TABLE_ROWID]];
    
    NSLog(@"SQL:%@",sql);
    FMDatabase *fmdb = [[ODBDataBase getInstance]loadDB];
    return [fmdb executeUpdate:sql withArgumentsInArray:arguments];
}


- (BOOL) updateAll
{
    if([self item:ODB_TABLE_ROWID])
    {
        NSLog(@"ROWID is not empty, multi-row operation is canceled, Method update will be called");
        return [self update];
    }
    
    NSString *sql = @"update %@ set ";
    sql = [NSString stringWithFormat:sql,self.tableName];
    
    //参数列表
    NSMutableArray *arguments = [[[NSMutableArray alloc] init]autorelease];
    
    for (NSUInteger i = 0;  i < [self.columns count] ; i++) {
        
        NSString *column = [self.columns objectAtIndex:i];
        NSObject *value = [self item:column];
        
        sql = [sql stringByAppendingFormat:@"%@ = ? ", column];
        //增加逗号
        if(i < [self.columns count] -1)
        {
            sql = [sql stringByAppendingString:@","];
        }
        
        //追加SQL
        if(value && ![value isEqual:@""])
        {
            [arguments addObject:value];
        }
    }
    
    sql = [sql stringByAppendingString:@"where 1 = 1 "];
    
    for (NSUInteger i = 0;  i < [self.primaryKeys count] ; i++) {
        
        NSString *column = [self.primaryKeys objectAtIndex:i];
        NSObject *value = [self item:column];
        
        //追加SQL
        if(value && ![value isEqual:@""])
        {
            sql = [sql stringByAppendingFormat:@"and %@ = ? ", column];
            [arguments addObject:value];
        }
    }
        
    NSLog(@"SQL:%@",sql);
    if (![arguments count]) {
        NSLog(@"Warning: All data will be updated");
    }
    FMDatabase *fmdb = [[ODBDataBase getInstance]loadDB];
    return [fmdb executeUpdate:sql withArgumentsInArray:arguments];
}

- (BOOL) deleteAll
{
    if([self item:ODB_TABLE_ROWID])
    {
        NSLog(@"ROWID is not empty, multi-row operation is canceled, Method update will be called");
        return [self delete];
    }
    
    NSString *sql = @"delete from %@ where 1 = 1 ";
    
    NSMutableArray *arguments = [[[NSMutableArray alloc] init]autorelease];
    
    sql = [NSString stringWithFormat:sql,self.tableName];
    
    for (NSUInteger i = 0;  i < [self.primaryKeys count] ; i++) {
        
        NSString *column = [self.primaryKeys objectAtIndex:i];
        NSObject *value = [self item:column];
        
        //追加SQL
        if(value && ![value isEqual:@""])
        {
            sql = [sql stringByAppendingFormat:@"and %@ = ? ", column];
            [arguments addObject:value];
        }
    }
    
    NSLog(@"SQL:%@",sql);
    if (0 == [arguments count]) {
        NSLog(@"delete operation without conditions is no allowed");
        return NO;
    }else
    {
        NSLog(@"Warning: multi-row of data in conditions will be deleted");
        FMDatabase *fmdb = [[ODBDataBase getInstance]loadDB];
        return [fmdb executeUpdate:sql withArgumentsInArray:arguments];
    }
}

- (BOOL) insert
{
    NSString *sql = @"insert into %@ values(";
    sql = [NSString stringWithFormat:sql,self.tableName];
    
    //参数列表
    NSMutableArray *arguments = [[[NSMutableArray alloc] init]autorelease];
    
    for (NSUInteger i = 0;  i < [self.columns count] ; i++) {
        
        NSString *column = [self.columns objectAtIndex:i];
        NSObject *value = [self item:column];
        
        //追加SQL
        sql = [sql stringByAppendingString:@"? "];
        //增加逗号和括号
        if(i < [self.columns count] -1)
        {
            sql = [sql stringByAppendingString:@","];
        }else
        {
            sql = [sql stringByAppendingString:@")"];
        }
        
        //追加SQL
        if(value && ![value isEqual:@""])
        {
            [arguments addObject:value];
        }else
        {
            [arguments addObject:@""];
        }
    }
    
    NSLog(@"SQL:%@",sql);
    FMDatabase *fmdb = [[ODBDataBase getInstance]loadDB];
    return [fmdb executeUpdate:sql withArgumentsInArray:arguments];
}

- (NSArray *) excuteQuery:(NSString *)sql
{
    return  [self excuteQuery:sql withArgumentsInArray:nil];
}

- (NSArray *) excuteQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments
{
    FMDatabase *fmdb = [[ODBDataBase getInstance]loadDB];
    FMResultSet *rs = [fmdb executeQuery:sql withArgumentsInArray:arguments];
    NSMutableArray *result = [[[NSMutableArray alloc]init] autorelease];
    while ([rs next]) {
        
        //创建新的数据对象，注意这里使用反射创建对象
        ODBDataTable *dt = [[[[self class] alloc]init]autorelease];
        
        //按照行顺序读取数据并写入
        for (NSUInteger i = 0;  i < [self.columns count] ; i++) {
            NSString *column = [self.columns objectAtIndex:i];
            NSString *datatype = [self.dataTypes objectAtIndex:i];
            if ([datatype isEqual:ODB_DATATYPE_TEXT]) {
                //设置文本格式
                [dt item:column value:[rs stringForColumn:column]];
            }else if([datatype isEqual:ODB_DATATYPE_INTEGER]) {
                //设置整数格式
                [dt item:column value:[NSNumber numberWithInt:[rs intForColumn:column]]];
            }else if([datatype isEqual:ODB_DATATYPE_REAL]) {
                //设置浮点数格式
                [dt item:column value:[NSNumber numberWithDouble:[rs doubleForColumn:column]]];
            }else if([datatype isEqual:ODB_DATATYPE_BLOB]) {
                //设置BLOB数格式
                [dt item:column value:[NSNumber numberWithDouble:[rs doubleForColumn:column]]];
            }else if([datatype isEqual:ODB_DATATYPE_DATE]) {
                //设置DATA数格式
                [dt item:column value:[rs dataForColumn:column]];
            }else
            {
                [dt item:column value:nil];
            }
        }
        
        //设置ROWID
        if([rs stringForColumn:ODB_TABLE_ROWID])
        {
//            NSLog(@"ROWID:%@",[rs stringForColumn:ODB_TABLE_ROWID]);
            [dt item:ODB_TABLE_ROWID value:[rs stringForColumn:ODB_TABLE_ROWID]];
        }else
        {
            NSLog(@"ROWID is no in SELECT list");
            [dt item:ODB_TABLE_ROWID value:nil];
        }
        
        //增加到result中去
        [result addObject:dt];
    }
    [rs close];
    [fmdb close];
    return result;
}

- (BOOL) excuteUpdate:(NSString *)sql
{
    return [self excuteUpdate:sql withArgumentsInArray:nil];
}

- (BOOL) excuteUpdate:(NSString *)sql withArgumentsInArray:(NSArray *)arguments
{
    FMDatabase *fmdb = [[ODBDataBase getInstance]loadDB];
    return [fmdb executeUpdate:sql withArgumentsInArray:arguments];
}

@end
