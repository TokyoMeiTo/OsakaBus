//
//  ODBDataBase.h
//  ONTS
//
//  Created by ohs on 12/05/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FMDatabase.h"
#import "ODBConfig.h"

@interface ODBDataBase : NSObject

+ (ODBDataBase *) getInstance;
- (FMDatabase *) loadDB;

@end
