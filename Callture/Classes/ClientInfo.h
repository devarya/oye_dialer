//
//  ClientInfo.h
//  Oye Dialer
//
//  Created by manish on 22/06/13.
//
//

#import "BaseXMLReader.h"

@interface ClientInfo : BaseXMLReader
@property (nonatomic,retain) NSString *clientId;
@property (nonatomic,retain) NSString *clientNo;
@property (nonatomic,retain) NSString *clientName;
@property (nonatomic,retain) NSString *contactName;
@property (nonatomic,retain) NSString *address1;
@property (nonatomic,retain) NSString *address2;
@property (nonatomic,retain) NSString *city;
@property (nonatomic,retain) NSString *province;
@property (nonatomic,retain) NSString *postalCode;
@property (nonatomic,retain) NSString *country;
@property (nonatomic,retain) NSString *tellNo;
@property (nonatomic,retain) NSString *faxNo;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *timezoneId;
@property (nonatomic,retain) NSString *currencyId;
@property (nonatomic,retain) NSString *balance;
@property (nonatomic,retain) NSString *postpaidBalance;
@property (nonatomic) BOOL rechargeOption;
@property (nonatomic) BOOL allowAutoCharge;
@property (nonatomic) BOOL canModifyCC;
@property (nonatomic,retain) NSString *clientOptions;

@property (nonatomic,retain) NSString *ccType;
@property (nonatomic,retain) NSString *bAddress1;
@property (nonatomic,retain) NSString *bAddress2;
@property (nonatomic,retain) NSString *bCity;
@property (nonatomic,retain) NSString *bProvince;
@property (nonatomic,retain) NSString *bPostalCode;
@property (nonatomic,retain) NSString *bZip;
@property (nonatomic,retain) NSString *bCountry;


@property (nonatomic,retain) NSString *ccNumber;
@property (nonatomic,retain) NSString *ccName;
@property (nonatomic,retain) NSString *ccExp;
@property (nonatomic,retain) NSString *ccCvv;
@property (nonatomic,retain) NSMutableArray *ccAllowAmounts;
@end
