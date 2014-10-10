//
//  MobileOperator.h
//  Oye
//
//  Created by user on 23/10/12.
//
//

#import <Foundation/Foundation.h>

@interface MobileOperator : NSObject
{
    /*
     <MobileOperatorID>189</MobileOperatorID>
     <Country>Spain</Country>
     <CountryCode>34</CountryCode>
     <Operator>Blau</Operator>
     <MobTelNoInputMask>+ (34)-xxx-xxx-xxx</MobTelNoInputMask>
     <CurrencyCode>EUR</CurrencyCode>
     <L_Rate>1.1</L_Rate>
     <MinAmount>0</MinAmount>
     <MaxAmount>0</MaxAmount>
     <FixedAmounts>8.80,16.50</FixedAmounts>
     <CurrencyRate>0.625</CurrencyRate>
     <TaxRate>0</TaxRate>
     <MarkupFixed>0</MarkupFixed>
     <MarkupPercent>0</MarkupPercent>
    */
    NSInteger mobileOperatorID;
    NSString *country;
    NSInteger countryCode;
    NSString *operatorName;
    NSString *mobTelNoInputMask;
    NSString *currencyCode;
    float L_Rate;
    float minAmount;
    float maxAmount;
    float currencyRate;
    float taxRate;
    float markupFixed;
    float markupPercent;
    NSArray *fixedAmountsList;
    NSString *resultStr;
}
@property (nonatomic,retain) NSString *country;
@property (nonatomic,retain) NSString *operatorName;
@property (nonatomic,retain) NSString *mobTelNoInputMask;
@property (nonatomic,retain) NSString *currencyCode;
@property (nonatomic) NSInteger mobileOperatorID;
@property (nonatomic) NSInteger countryCode;
@property (nonatomic) float L_Rate;
@property (nonatomic) float minAmount;
@property (nonatomic) float maxAmount;
@property (nonatomic) float currencyRate;
@property (nonatomic) float taxRate;
@property (nonatomic) float markupFixed;
@property (nonatomic) float markupPercent;
@property (nonatomic,retain) NSString *resultStr;
@property (nonatomic, retain) NSArray *fixedAmountsList;
@end
