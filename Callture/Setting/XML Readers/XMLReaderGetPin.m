//
//  XMLReaderGetPin.m
//  Oye Dialer
//
//  Created by user on 29/11/12.
//
//

#import "XMLReaderGetPin.h"
#import "Constants.h"
@implementation XMLReaderGetPin
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
    self.contentOfCurrentProperty = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"ResultStr"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PIN object:self.contentOfCurrentProperty];
    }
    self.contentOfCurrentProperty = nil;
}
@end
