//
//  NSString+Convert.h
//  TokyoMetro
//
//  Created by limc on 2014/09/02.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Convert)

//"" -> nil
-(NSString *) blankIsNil;
//"" -> " "
-(NSString *) blankIsSpace;
//"" -> 0
-(NSString *) blankIsZero;
//"" -> replace
-(NSString *) blankIs:(NSString *)replace;


//" " -> nil
-(NSString *) spaceIsNil;
//" " -> ""
-(NSString *) spaceIsBlank;
//" " -> 0
-(NSString *) spaceIsZero;
//" " -> replace
-(NSString *) spaceIs:(NSString *)replace;
@end
