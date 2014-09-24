//
//  ODBDataTable.h
//  ONTSDatabase
//
//  Created by ohs on 12-3-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODBDataBase.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"

#define ODB_TABLE_ROWID @"ROWID"

/*! ENUM
 使用Like方式进行模糊查找时的类型
 */
typedef enum
{
    ODBDataTableLikeTypeNone            = 0,      //AAA => EQUAL 'AAA'
    ODBDataTableLikeTypeContain         = 1,      //AAA => LIKE  '%AAA%'
    ODBDataTableLikeTypeStartWith       = 2,      //AAA => LIKE  'AAA%'
    ODBDataTableLikeTypeEndWith         = 3,      //AAA => LIKE  '%AAA'
    ODBDataTableLikeTypeCustom          = 4,      //AAA => LIKE  'AAA'
}ODBDataTableLikeType;

@interface ODBDataTable : NSObject{
    NSString * _tableName;
    NSArray  * _columns;
    NSArray  * _dataTypes;
    NSArray  * _primaryKeys;
    NSString * _rowid;
}

//---------------------------------------------------------------------//
//                 以下数据均为只读数据，用于表结构定义
//---------------------------------------------------------------------//
/*!
 Table Name
 数据表名
 */
@property(copy, nonatomic) NSString *tableName;

/*!
 数据列列表
 */
@property(retain, nonatomic) NSArray *columns;

/*!
 各数据列对应的数据类型
 */
@property(retain, nonatomic) NSArray *dataTypes;

/*!
 主键列列表
 */
@property(retain, nonatomic) NSArray *primaryKeys;

/*!
 SQLite数据行标示符
 */
@property(copy, nonatomic) NSString *rowid;

//---------------------------------------------------------------------//
//                  以下方法子类必须继承并实现
//---------------------------------------------------------------------//

/*! @abstract
 重置数据行数据，用于清理取得的数据，这里用于循环内table操作
 */
- (void) reset;

/*!@abstract
 item选择器，用于使用字符串属性反射方式获取列表行数据
 [self item:@"ROWID"] 相当于 self.rowid
 
 @param item
 需要取得值的属性
 
 @return id
 取得的属性的值
 
 */
- (id) item:(NSString *) item;

/*! @abstract
 item选择器，用于使用字符串属性反射方式对表行数据进行赋值
 [self item:@"ROWID" value:@"1111"] 相当于 self.rowid = @"1111"
 
 @param item
 需要被赋指的属性名
 
 @param value
 值
 
 */
- (void) item:(NSString *) item value:(id)value;

//---------------------------------------------------------------------//
//                 以下方法会构造SQL文并执行
//---------------------------------------------------------------------//

/*! @abstract
 判断数据行是否存在，这里没有使用Select Exsit判断，
 而是通过Select Count返回的数据行数进行判断
 */
- (BOOL) exsit;

/*! @abstract
 统计符合条件的数据行,这里使用了Select Count返回的数据
 
 @return NSUInteger
 数据行数
 */
- (NSUInteger) count;

/*! @abstract
 基础select方法，通过对象的属性进行查询
 注意，这里只取返回结果集的第一条数据进行解析，并赋值到对象
 
 @return ODBDataTable *
 查询出的ODBDataTable行结果
 */
- (ODBDataTable *) select;

/*! @abstract
 查询数据表中的所有符合条件的数据，当前对象的所有属性均未设置时，将查询所有数据
 */
- (NSArray *) selectAll;

/*! @abstract
 与SelectAll方法相同，只是在查询时使用Like运算而非EQUAL运算进行查询，用于模糊查询，
 全部字符类型属性列都按Like方式匹配
 */
- (NSArray *) selectLike;

/*! @abstract
 查询最先特定行数的数据，用于分页查找
 
 @param top
 结果的最先行行数
 */
- (NSArray *) selectTop:(NSUInteger)top;

/*! @abstract
 对查询结果进行排序，一个排序序列
 */
- (NSArray *) selectWithOrder:(NSString *) order desc:(BOOL) desc;

/*! @abstract
 对单行数据进行更新，使用rowid作为主key作为判断条件更新，一次只能更新一条数据
 */
- (BOOL) update;

/*! @abstract
 对单行数据进行删除
 */
- (BOOL) delete;

/*! @abstract
 对多行数据进行更新，只能在rowid为空的条件下才能使用，根据用户自行设定的属性进行更新
 对多条数据进行更新会产生不可预料的后果，请谨慎使用
 */
- (BOOL) updateAll;

/*! @abstract
 对多行数据进行删除，只能在rowid为空的条件下才能使用，根据用户自行设定的属性进行删除
 对多条数据进行删除会产生不可预料的后果，请谨慎使用
 */
- (BOOL) deleteAll;

/*! @abstract
 插入单行数据
 */
- (BOOL) insert;

//---------------------------------------------------------------------//
//               以下方法尚未实现或存在问题
//---------------------------------------------------------------------//

/*! @abstract
 查询指定页所有行的数据，用于分页查找
 
 @param page
 页面编号
 
 @param size
 页面大小
 */
//- (NSArray *) selectPage:(NSUInteger)page size:(NSUInteger) size;

/*! @abstract
 对查询结果进行排序，多个排序序列
 */
//- (NSArray *) selectWithOrder:(NSDictionary *) dict ;

/*! @abstract
 对查询结果进行排序，两个排序序列
 */
//- (NSArray *) selectWithOrder:(NSString *) order1
//                        desc1:(BOOL) desc1
//                       order2:(NSString *) order1
//                        desc2:(BOOL) desc1;

/*! @abstract
 与SelectAll方法相同，只是在查询时使用Like运算而非EQUAL运算进行查询，用于模糊查询，
 指定其中的某一列进行模糊查询，其他列不使用模糊查询
 */
//- (NSArray *) selectLike:(NSString *) like type:(ODBDataTableLikeType) type;

/*! @abstract
 与SelectAll方法相同，只是在查询时使用Like运算而非EQUAL运算进行查询，用于模糊查询，
 指定其中的某两列进行模糊查询，其他列不使用模糊查询
 */
//- (NSArray *) selectLike:(NSString *) like1
//                    type1:(ODBDataTableLikeType) type1
//                    like2:(NSString *) like2
//                    type2:(ODBDataTableLikeType) type2;

/*! @abstract
 与SelectAll方法相同，只是在查询时使用Like运算而非EQUAL运算进行查询，用于模糊查询，
 可以指定任意列数据进行Like运算，指定列之外的不使用Like运算
 */
//- (NSArray *) selectLike:(NSDictionary *) columes ;

/*! @abstract
 对单行数据进行更新，使用rowid作为主key作为判断条件更新，一次只能更新一条数据
 如果数据表中未查找到符合条件的数据，将会将本条数据插入到数据表中
 */
//- (BOOL) updateOrInsert;

//---------------------------------------------------------------------//
//               以下方法用于执行SQL文，支持带参数和不带参数
//---------------------------------------------------------------------//

/*! @abstract
 执行指定的查询SQL文，不带参数模式
 */
- (NSArray *) excuteQuery:(NSString *)sql;

/*! @abstract
 执行指定的查询SQL文，带参数模式
 */
- (NSArray *) excuteQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;

/*! @abstract
 执行指定的更新SQL文，不带参数模式
 */
- (BOOL) excuteUpdate:(NSString *)sql;

/*! @abstract
 执行指定的更新SQL文，不带参数模式
 */
- (BOOL) excuteUpdate:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;

@end
