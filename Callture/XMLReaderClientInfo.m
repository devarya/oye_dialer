//
//  XMLReaderClientInfo.m
//  Oye Dialer
//
//  Created by manish on 22/06/13.
//
//

#import "XMLReaderClientInfo.h"
#import "Constants.h"
@implementation XMLReaderClientInfo
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"ClientInfo"]) {
        currentObject = [[ClientInfo alloc] init];
    }
    self.contentOfCurrentProperty = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"ClientInfo"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CLIENTINFO_SUCCESS object:currentObject];
    }
    if ([elementName isEqualToString:@"ClientId"]) {
        currentObject.clientId = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"ClientNo"]) {
        currentObject.clientNo = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"ClientName"]) {
        currentObject.clientName = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"ContactName"]) {
        currentObject.contactName = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"Address1"]) {
        currentObject.address1 = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"Address2"]) {
        currentObject.address2 = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"City"]) {
        currentObject.city = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"Province"]) {
        currentObject.province = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"PostalCode"]) {
        currentObject.postalCode = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"Country"]) {
        currentObject.country = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"TelNo"]) {
        currentObject.tellNo = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"FaxNo"]) {
        currentObject.faxNo = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"Email"]) {
        currentObject.email = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"TimezoneId"]) {
        currentObject.timezoneId = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"CurrencyId"]) {
        currentObject.currencyId = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"Balance"]) {
        currentObject.balance = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"PostPaidBalance"]) {
        currentObject.postpaidBalance = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"RechargeOption"]) {
        currentObject.rechargeOption = [self.contentOfCurrentProperty isEqualToString:@"True"]?YES:NO;
    }
    if ([elementName isEqualToString:@"AllowAutoCharge"]) {
        currentObject.allowAutoCharge = [self.contentOfCurrentProperty isEqualToString:@"True"]?YES:NO;
    }
    if ([elementName isEqualToString:@"CanModifyCC"]) {
        currentObject.canModifyCC = [self.contentOfCurrentProperty isEqualToString:@"True"]?YES:NO;
    }
    if ([elementName isEqualToString:@"ClientOptions"]) {
        currentObject.clientOptions = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"CC_AllowAmounts"]) {
        NSLog(@"%@",[self.contentOfCurrentProperty componentsSeparatedByString:@","]);
        currentObject.ccAllowAmounts = [[self.contentOfCurrentProperty componentsSeparatedByString:@","] mutableCopy];
    }
    if ([elementName isEqualToString:@"CC_Type"]) {
        currentObject.ccType = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"CC_Name"]) {
        currentObject.ccName = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"CC_No"]) {
        currentObject.ccNumber = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"CC_Exp"]) {
        currentObject.ccExp = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"B_Address1"]) {
        currentObject.bAddress1 = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"B_Address2"]) {
        currentObject.bAddress2 = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"B_City"]) {
        currentObject.bCity = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"B_Province"]) {
        currentObject.bProvince = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"B_PostalCode"]) {
        currentObject.bPostalCode = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"B_Zip"]) {
        currentObject.bZip = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"B_Country"]) {
        currentObject.bCountry = self.contentOfCurrentProperty;
    }
    self.contentOfCurrentProperty = nil;
}
@end
