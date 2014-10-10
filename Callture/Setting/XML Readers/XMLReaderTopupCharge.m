//
//  XMLReaderTopupCharge.m
//  Oye
//
//  Created by user on 25/10/12.
//
//

#import "XMLReaderTopupCharge.h"
#import "Constants.h"
#import "GlobalData.h"
@implementation XMLReaderTopupCharge
@synthesize callingFrom;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"Result"]) {
        currentObject = [[TopupInfo alloc] init];
    }
    self.contentOfCurrentProperty = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"Result"]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:currentObject forKey:TOPUPINFO];
        if ([callingFrom isEqualToString:[GlobalData getAppInfo].topUps]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOPUP_CHARGE_COMPLETED object:nil userInfo:dict];
        }else if ([callingFrom isEqualToString:[GlobalData getAppInfo].topupConfirmation]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONFIRMATION_TOPUP_CHARGE_COMPLETED object:nil userInfo:dict];
        }
    }
    if ([elementName isEqualToString:@"LCost"]) {
        currentObject.lcost = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"MobilePaymentID"]) {
        currentObject.mobilePaymentID = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"MobileTelNo"]) {
        currentObject.MobileTelNo = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"PostedCountry"]) {
        currentObject.PostedCountry = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"PostedCountryCode"]) {
        currentObject.PostedCountryCode = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"PostedOperator"]) {
        currentObject.PostedOperator = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"PostedOperatorTelNo"]) {
        currentObject.PostedOperatorTelNo = self.contentOfCurrentProperty;
    }if ([elementName isEqualToString:@"RateCode"]) {
        currentObject.RateCode = self.contentOfCurrentProperty;
    }if ([elementName isEqualToString:@"L_Balance"]) {
        currentObject.L_Balance = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"LineNo"]) {
        currentObject.LineNo = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"PostedOperatorCode"]) {
            currentObject.PostedOperatorCode = self.contentOfCurrentProperty;
    }if ([elementName isEqualToString:@"PostedAmount"]) {
        currentObject.PostedAmount = self.contentOfCurrentProperty;
    }if ([elementName isEqualToString:@"PostedTax"]) {
        currentObject.PostedTax = self.contentOfCurrentProperty;
    }if ([elementName isEqualToString:@"PostedCurrencyCode"]) {
        currentObject.PostedCurrencyCode = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"ResultStr"]) {
        currentObject.ResultStr = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"ResultId"]) {
        currentObject.ResultId = [self.contentOfCurrentProperty integerValue];
    }
    self.contentOfCurrentProperty = nil;
}
@end
