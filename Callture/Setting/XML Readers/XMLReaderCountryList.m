//
//  XMLReaderCountryList.m
//  Callture
//
//  Created by user on 17/10/12.
//
//

#import "XMLReaderCountryList.h"
#import "GlobalData.h"
#import "Constants.h"
@implementation XMLReaderCountryList
@synthesize currentObject;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"CountryList"]) {
        countrylist = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"Country"]) {
        currentObject = [[Country alloc] init];
    }
    self.contentOfCurrentProperty = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"XML"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COUNTRYLIST_UPDATED object:nil];
    }
    if ([elementName isEqualToString:@"CountryList"]) {
        [GlobalData setCountryList:countrylist];
    }
    if ([elementName isEqualToString:@"Country"]) {
        [countrylist addObject:currentObject];
    }
    if ([elementName isEqualToString:@"CountryCode"]) {
        currentObject.countryCode = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"CountryName"]) {
        currentObject.countryName = self.contentOfCurrentProperty;
    }
    self.contentOfCurrentProperty = nil;
}

@end
