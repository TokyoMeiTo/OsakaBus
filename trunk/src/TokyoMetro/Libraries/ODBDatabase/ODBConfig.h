//
//  ODBConfig.h
//  ONTSDatabase
//
//  Created by ohs on 12/03/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef ODBConfig_h
#define ODBConfig_h

//App's document folder path 
#define ODB_APP_DOC_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//Sqlite Version
#define ODB_DATABASE_SQLITE_VERSION 3

//database name
#define ODB_DATABASE_NAME @"work"
#define ODB_DATABASE_EXT_NAME @"db"
#define ODB_DATABASE_FULL_NAME [NSString stringWithFormat:@"/%@.%@",ODB_DATABASE_NAME,ODB_DATABASE_EXT_NAME]
#define ODB_DATABASE_FULL_PATH [ODB_APP_DOC_PATH stringByAppendingPathComponent:ODB_DATABASE_NAME]

//database connect username
#define ODB_DATABASE_USERNAME @""
//database connect password
#define ODB_DATABASE_PASSWORD @""

#define ODB_ENABLE_CREATE NO
#define ODB_ENABLE_UPDATE YES
#define ODB_ENABLE_DELETE NO

#define ODB_DATATYPE_TEXT   @"text"
#define ODB_DATATYPE_BLOB   @"blob"
#define ODB_DATATYPE_INTEGER @"integer"
#define ODB_DATATYPE_REAL @"real"
#define ODB_DATATYPE_DATE @"date"

#endif
