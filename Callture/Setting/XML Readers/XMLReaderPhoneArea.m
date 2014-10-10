//
//  XMLReaderPhoneArea.m
//  Callture
//
//  Created by user on 17/10/12.
//
//

#import "XMLReaderPhoneArea.h"
#import "RESTInteraction.h"
#import "Constants.h"
#import "GlobalData.h"
@implementation XMLReaderPhoneArea
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
    if ([elementName isEqualToString:@"Country"]) {
        if (count==1) {
            currentObject = [[Country alloc] init];
            count = 0;
        }else
        {
            count++;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RATES_FOR_PHONE object:nil];
    }
    if ([elementName isEqualToString:@"Country"]) {
        if (count==1)
        {
            [GlobalData setCountryForPhone:currentObject];
        }
        else
        {
            currentObject.countryName = self.contentOfCurrentProperty;
        }
        count++;
    }
    if ([elementName isEqualToString:@"Area"]) {
        currentObject.selectedArea = self.contentOfCurrentProperty;
    }
//    if ([elementName isEqualToString:@"AreaCode"]) {
//        currentObject.are = self.contentOfCurrentProperty;
//    }
//    if ([elementName isEqualToString:@"RateCode"]) {
//        currentObject.selectedArea = self.contentOfCurrentProperty;
//    }
    self.contentOfCurrentProperty = nil;
}
@end
