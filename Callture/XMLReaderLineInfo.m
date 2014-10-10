//
//  XMLReaderLineInfo.m
//  Oye Dialer
//
//  Created by user on 13/03/13.
//
//

#import "XMLReaderLineInfo.h"
#import "Constants.h"

@implementation XMLReaderLineInfo

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
    if ([elementName isEqualToString:@"ResultId"]) {
        if (  [self.contentOfCurrentProperty isEqualToString:@"1"]) {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LINE_INFO_SUCCESS object:nil];
        }else
        {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LINE_INFO_FAIL object:nil];
        }
    }

    self.contentOfCurrentProperty = nil;
}



@end
