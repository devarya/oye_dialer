//
//  XMLReaderEnableSip.m
//  Oye Dialer
//
//  Created by user on 19/11/12.
//
//

#import "XMLReaderEnableSip.h"
#import "Constants.h"
#import "GlobalData.h"
@implementation XMLReaderEnableSip
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
    if ([elementName isEqualToString:@"SipAccount"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ENABLE_SIP object:nil];
    }
    if ([elementName isEqualToString:@"UserId"]) {
        //NSLog(@"%@",self.contentOfCurrentProperty);
        [[NSUserDefaults standardUserDefaults] setObject:self.contentOfCurrentProperty forKey:SIP_USERID];
    }
    if ([elementName isEqualToString:@"Pwd"]) {
        //NSLog(@"%@",self.contentOfCurrentProperty);
        [[NSUserDefaults standardUserDefaults] setObject:self.contentOfCurrentProperty forKey:SIP_PWD];
    }
    if ([elementName isEqualToString:@"Proxy"]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.contentOfCurrentProperty forKey:SIP_PROXY];
    }
    if ([elementName isEqualToString:@"RegisterationTimeout"]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.contentOfCurrentProperty forKey:SIP_REGISTRATIONTIMEOUT];
    }
    self.contentOfCurrentProperty = nil;
}
@end
