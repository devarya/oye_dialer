//
//  RESTInteraction.h
//  IntigrityAnswers
//
//  Created by Manish on 10/11/11.
//  Copyright 2011 Aryavrat infotech. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import <foundation/Foundation.h>
#import "Reachability.h"

#import "ASIFormDataRequest.h"
#import "TouchXML.h"
#import "LoginInfo.h"
#import "CallLogData.h"
#import "callLogonViewController.h"
#import "callLogListViewController.h"
#import "GlobalData.h"
#import "LineListData.h"
#import "addProfileViewController.h"
#import "callDialerViewController.h"
#import "StaticData.h"
#import "AccessNumbers.h"
#import "CallSetUp.h"
#import "Country.h"
#import "XMLReaderTopupOperatorList.h"
#import "XMLReaderTopupHistory.h"
#import "MobileTopup.h"
#import "ClientInfo.h"
@protocol RESTInteractionDelegate
-(void)addOperator:(MobileOperator *)mo;
-(void)addMobileTopup:(MobileTopup *)mt;
@end
@interface RESTInteraction : NSObject<XMLReaderTopupOperatorListDelegate,XMLReaderTopupHistoryDelegate> {
	Reachability* internetReachable;
    Reachability* hostReachable;
    NSURL *urlLogin;
    NSURL *urlCallLog;
    NSURL *urlCallerIDsGet;
    NSURL *urlCallBackLineList;
    NSURL *urlAccessNo;
    NSURL *urlProfileSet;
    NSURL *urlCallBack;
    NSURL *urlCallSetup;
    NSURL *urlDirectDialSetup;
    NSURL *urlLocation;
    NSURL *urlPhoneAreaGet;
    NSURL *urlCallingCountryList;
    NSURL *urlCallingRates;
    NSURL *urlTopupOperatorList;
    NSURL *urlTopupCharge;
    NSURL *urlAboutUsDetail;
    NSURL *urlEnableSipCalling;
    NSURL *urlClientPinGet;
    NSURL *urlTopupHistory;
    NSURL *urlAnnounce;
    NSURL *urlInviteFriends;
    NSURL *urlReteriveBillingInfo;
    NSURL *urlSaveBillingInfo;
    NSURL *urlChargeAccount;
    CallSetUp *callsetupObject;
    AccessNumbers *accessnumObj;
    BOOL canAccessMore;
    NSString *callFromFlag;
    NSString *lastSpeedDialNumber;
    NSUserDefaults *pref;
    NSString *topupChargeFromPage;
    NSString *loginApiCallFor;
}
+ (id)restInteractionManager;
- (void)getLoginData:(NSString *)userName :(NSString *)password :(BOOL)isSave;
- (void)getCallLogData:(NSString *)nor :(NSString *)lastcdrd :(NSString *)clientID;
- (void)getCallBackLinesList:(NSString *)clientID;

-(void)callMeBack:(NSString *)destNo :(NSString *)callFrom;

/* Added By Pardeep */
-(void)callSetUp:(NSString *)phoneNumber :(NSString *)promoCode :(NSString *)pinCode callFor:(NSString *)callFor;
-(void)callForPin:(NSString *)phoneNumber :(NSString *)promoCode :(NSString *)pinCode callFor:(NSString *)callFor;
-(void)sendRequestForDialSetup :(NSString *)contactNubmer : (NSString *)callFrom;
@property (nonatomic,assign) id <RESTInteractionDelegate>delegate;
@property(atomic) BOOL canAccessMore;
@property(nonatomic,retain) NSString *lastSpeedDialNumber;
@property(atomic,retain) NSUserDefaults *pref;

///////Added on 18 oct 2012 by Manish/////////////
-(void)GetAreaForPhone:(NSString *)number;
-(void)GetCountryList;
-(void)GetAreaList:(NSString *)countryName;
-(void)GetTopupOperators:(NSString *)phoneNo;
-(void)MakeTopupCharge:(NSString *)MobileNo PaymentId:(NSString *)paymentid amount:(NSString *)amount confirmationOrder:(NSString *)confirmationOrder mobileOrderId:(NSString *)mobileOrderId fromPage:(NSString *)fromPage;
-(void)GetAboutUsDetail;
//////////////////////////////////////////////////

-(void)EnableSipCalling:(BOOL)isEnable;

- (void)getTopupHistoryData:(NSString *)lineNo :(NSString *)lastpaymentId :(NSString *)clientID;
-(void)announcement;
- (void)announceAsyncSuccess:(ASIFormDataRequest *)request;
-(void)sendInviteFriends:(NSString *)jsondata ownerName:(NSString *)ownerName;
-(void)getBillingInfo;
-(void)saveBillingInfo:(ClientInfo *)ci isCcNo:(BOOL)isCcNo;
-(void)chargeAccount:(NSString *)amount;
@end
