//
//  TopupInfo.h
//  Oye
//
//  Created by user on 25/10/12.
//
//

#import <Foundation/Foundation.h>

@interface TopupInfo : NSObject
{
    NSString *lcost;
    NSString *mobilePaymentID;
    NSString *MobileTelNo;
    NSString *PostedCountry;
    NSString *PostedCountryCode;
    NSString *PostedOperator;
    NSString *PostedOperatorTelNo;
    NSString *RateCode;
    NSString * L_Balance;
    NSString *LineNo;
    NSString *PostedOperatorCode;
    NSString *PostedAmount;
    NSString *PostedTax;
    NSString *PostedCurrencyCode;
    NSString *ResultStr;
    NSInteger ResultId;
}
@property (nonatomic,retain) NSString *lcost;
@property (nonatomic,retain) NSString *mobilePaymentID;
@property (nonatomic,retain) NSString *MobileTelNo;
@property (nonatomic,retain) NSString *PostedCountry;
@property (nonatomic,retain) NSString *PostedCountryCode;
@property (nonatomic,retain) NSString *PostedOperator;
@property (nonatomic,retain) NSString *PostedOperatorTelNo;
@property (nonatomic,retain) NSString *RateCode;
@property (nonatomic,retain) NSString *L_Balance;
@property (nonatomic,retain) NSString *LineNo;
@property (nonatomic,retain) NSString *PostedOperatorCode;
@property (nonatomic,retain) NSString *PostedAmount;
@property (nonatomic,retain) NSString *PostedTax;
@property (nonatomic,retain) NSString *PostedCurrencyCode;
@property (nonatomic,retain) NSString *ResultStr;
@property (nonatomic) NSInteger ResultId;
@end
