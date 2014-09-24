//
//  OWINAsyncXMLParser.h
//  OWIN
//
//  Created by ohs on 12/05/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OAPAsyncXMLParser.h"

typedef enum
{
    OWINAsyncXMLParserMsgNoDataError = 1001,
    OWINAsyncXMLParserSsrIsFalseError = 1002
}OWINAsyncXMLParserError;

@protocol OWINAsyncXMLParserDelegate <OAPAsyncParserDelegate>

@optional
- (void) parseDidGotMessage:(id) parser;

@end


@interface OWINAsyncXMLParser : OAPAsyncXMLParser
{
    NSString *_serverMsg;
}

@property(copy,nonatomic) NSString *serverMsg;

@end
