//
//  BaseXMLReader.h
//  CollegeSuperFans
//
//  Created by Jerry Walton on 5/20/10.
//  Copyright 2010 Smartphones Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseXMLReader : NSObject <NSXMLParserDelegate> {
	
@private        
    NSMutableString *contentOfCurrentProperty;
}

@property(nonatomic,retain)NSMutableString *contentOfCurrentProperty;

- (BOOL)parseXMLFileWithString:(NSString *)xmlStr parseError:(NSError **)error;

@end
