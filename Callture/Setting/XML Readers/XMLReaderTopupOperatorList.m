//
//  XMLReaderTopupOperatorList.m
//  Oye
//
//  Created by user on 23/10/12.
//
//

#import "XMLReaderTopupOperatorList.h"
#import "Constants.h"
@implementation XMLReaderTopupOperatorList
@synthesize delegate;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"MobileOperator"]) {
            currentObject = [[MobileOperator alloc] init];
    }
    self.contentOfCurrentProperty = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"ResultStr"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_OPERATORLIST_UPDATED object:self.contentOfCurrentProperty];
    }
    
    if ([elementName isEqualToString:@"MobileOperatorList"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_OPERATORLIST_UPDATED object:nil];
    }
    if ([elementName isEqualToString:@"MobileOperator"]) {
        [delegate addOperator:currentObject];
    }
    if ([elementName isEqualToString:@"MobileOperatorID"]) {
        currentObject.mobileOperatorID = [self.contentOfCurrentProperty intValue];
    }
    if ([elementName isEqualToString:@"Country"]) {
        currentObject.country = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"CountryCode"]) {
        currentObject.countryCode = [self.contentOfCurrentProperty intValue];
    }
    if ([elementName isEqualToString:@"Operator"]) {
        currentObject.operatorName = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"MobTelNoInputMask"]) {
        currentObject.mobTelNoInputMask = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"CurrencyCode"]) {
        currentObject.currencyCode = self.contentOfCurrentProperty;
    }if ([elementName isEqualToString:@"L_Rate"]) {
        currentObject.L_Rate = [self.contentOfCurrentProperty floatValue];
    }if ([elementName isEqualToString:@"MinAmount"]) {
        currentObject.minAmount = [self.contentOfCurrentProperty floatValue];
    }
    if ([elementName isEqualToString:@"MaxAmount"]) {
        currentObject.maxAmount = [self.contentOfCurrentProperty floatValue];
    }
    if ([elementName isEqualToString:@"FixedAmounts"]) {
        //currentObject.fixedAmounts = self.contentOfCurrentProperty;
        if (self.contentOfCurrentProperty.length>0) {
            currentObject.fixedAmountsList = [self.contentOfCurrentProperty componentsSeparatedByString:@","];
        }
    }if ([elementName isEqualToString:@"CurrencyRate"]) {
        currentObject.currencyRate = [self.contentOfCurrentProperty floatValue];
    }if ([elementName isEqualToString:@"TaxRate"]) {
        currentObject.taxRate = [self.contentOfCurrentProperty floatValue];
    }if ([elementName isEqualToString:@"MarkupFixed"]) {
        currentObject.markupFixed = [self.contentOfCurrentProperty floatValue];
    }
    if ([elementName isEqualToString:@"MarkupPercent"]) {
        currentObject.markupPercent = [self.contentOfCurrentProperty floatValue];
    }
    self.contentOfCurrentProperty = nil;
}
@end
