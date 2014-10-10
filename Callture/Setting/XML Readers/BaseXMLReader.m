//
//  BaseXMLReader.m
//  CollegeSuperFans
//
//  Created by Jerry Walton on 5/20/10.
//  Copyright 2010 Smartphones Technologies, Inc. All rights reserved.
//

#import "BaseXMLReader.h"


@implementation BaseXMLReader

@synthesize contentOfCurrentProperty;


- (id) init {
	self = [super init];
	if (self != nil) {
	}
	return self;
}


- (BOOL)parseXMLData:(NSData *)data parseError:(NSError **)error {
	BOOL success = YES;
	
    NSXMLParser *parser;
	parser = [[NSXMLParser alloc] initWithData:data];
	
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
		success = NO;
	}
	
	return success;
}


- (BOOL)parseXMLFileWithString:(NSString *)xmlStr parseError:(NSError **)error {	
    NSData *data = [xmlStr dataUsingEncoding:NSISOLatin1StringEncoding];
	return [self parseXMLData:data parseError:error];
}	


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	self.contentOfCurrentProperty = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {     
	
	contentOfCurrentProperty = nil;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (string) {
		[self.contentOfCurrentProperty appendString:string];
	}
}


@end
