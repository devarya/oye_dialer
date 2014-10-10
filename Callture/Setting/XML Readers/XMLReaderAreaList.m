//
//  XMLReaderAreaList.m
//  Callture
//
//  Created by user on 17/10/12.
//
//

#import "XMLReaderAreaList.h"
#import "GlobalData.h"
#import "Constants.h"
#import "Country.h"
@implementation XMLReaderAreaList
@synthesize currentObject;

-(id)init
{
    self = [super init];
	if (self != nil) {
        count = 0;
	}
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"AreaList"]) {
        arealist = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"Rate"]) {
        count++;
        if (count==1) {
            currentObject = [[Area alloc] init];
        }
    }
    self.contentOfCurrentProperty = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"XML"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AREALIST_UPDATED object:nil];
    }
    
    if ([elementName isEqualToString:@"AreaList"]) {
        [[GlobalData getSelectedCountry] setAreaList:[arealist mutableCopy]];
    }
    if ([elementName isEqualToString:@"Rate"]) {
        count--;
        if (count==0) {
           [arealist addObject:currentObject];
        }else
        {
            currentObject.rate = self.contentOfCurrentProperty;
        }
    }
    if ([elementName isEqualToString:@"RateCode"]) {
        currentObject.rateCode = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"Area"]) {
        currentObject.areaName = self.contentOfCurrentProperty;
    }
    self.contentOfCurrentProperty = nil;
}
@end
