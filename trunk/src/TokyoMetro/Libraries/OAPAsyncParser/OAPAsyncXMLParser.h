//
//  OAPAsyncXMLParser.h
//  OkasanNetworkTest
//
//  Created by ohs on 12/05/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAPAsyncParser.h"

@interface OAPAsyncXMLParser : OAPAsyncParser<NSXMLParserDelegate>
{
    NSXMLParser *_xmlParser;
}

@property(retain,nonatomic) NSXMLParser *xmlParser;



@end