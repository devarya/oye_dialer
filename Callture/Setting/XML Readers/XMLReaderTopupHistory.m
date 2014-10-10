//
//  XMLReaderTopupHistory.m
//  Oye Dialer
//
//  Created by user on 29/11/12.
//
//

/*
 <MobileTopupList>
 <MobileTopup>
 <MobilePaymentID>875536</MobilePaymentID>
 <RequestDate>2012-11-24T02:25:12.533000000</RequestDate>
 <LineNo>1972422</LineNo>
 <MobileTelNo>923014231423</MobileTelNo>
 <Amount>5.75</Amount>
 <PostedCurrencyCode/>
 <PostedAmount>0</PostedAmount>
 <Status>
 Balance is not enough in pin. Current Balance is 0.44 Required Balance is 5.75
 </Status>
 <RecepientsName/>
 <ProcessStatusID>10</ProcessStatusID>
 </MobileTopup>
*/

#import "XMLReaderTopupHistory.h"
#import "Constants.h"
@implementation XMLReaderTopupHistory
@synthesize delegate;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"MobileTopupList"]) {
        topupList = [[NSMutableArray alloc]init];
    }
    if ([elementName isEqualToString:@"MobileTopup"]) {
        currentObject = [[MobileTopup alloc] init];
    }
    self.contentOfCurrentProperty = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (qName) {
        elementName = qName;
    }
    
    if ([elementName isEqualToString:@"MobileTopupList"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MOBILETOPUPLIST_UPDATED object:[topupList mutableCopy]];
    }
    if ([elementName isEqualToString:@"MobileTopup"]) {
        [topupList addObject:currentObject];
        //[delegate addMobileTopup:currentObject];
    }
    if ([elementName isEqualToString:@"MobilePaymentID"]) {
        currentObject.mobilePaymentID = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"RequestDate"]) {
        currentObject.requestDate = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"LineNo"]) {
        currentObject.lineNo = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"MobileTelNo"]) {
        currentObject.mobileTelNo = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"Amount"]) {
        currentObject.amount = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"PostedCurrencyCode"]) {
        currentObject.postedCurrencyCode = self.contentOfCurrentProperty;
    }if ([elementName isEqualToString:@"PostedAmount"]) {
        currentObject.postedAmount = self.contentOfCurrentProperty;
    }if ([elementName isEqualToString:@"Status"]) {
        currentObject.status = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"RecepientsName"]) {
        currentObject.recepientsName = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"ProcessStatusID"]) {
        currentObject.processStatusID = self.contentOfCurrentProperty;
    }
    self.contentOfCurrentProperty = nil;
}
@end
