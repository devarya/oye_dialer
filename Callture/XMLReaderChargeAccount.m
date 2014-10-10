//
//  XMLReaderChargeAccount.m
//  Oye Dialer
//
//  Created by user on 24/06/13.
//
//

#import "XMLReaderChargeAccount.h"
#import "Constants.h"
@implementation XMLReaderChargeAccount
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"Result"]) {
        dict = [[NSMutableDictionary alloc] init];
    }
    self.contentOfCurrentProperty = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"Result"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACCOUNT_CHARGED_SUCCESS object:dict];
    }
    if ([elementName isEqualToString:@"ResultId"]) {
        [dict setValue:self.contentOfCurrentProperty forKey:@"ResultId"];
    }
    if ([elementName isEqualToString:@"ResultStr"]) {
        [dict setValue:self.contentOfCurrentProperty forKey:@"ResultStr"];
    }
    self.contentOfCurrentProperty = nil;
}
@end
