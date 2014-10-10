//
//  AppInfo.h
//  Oye
//
//  Created by user on 26/10/12.
//
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject
{
    
}


@property (nonatomic,retain)UIColor *pageBgColor;
@property (nonatomic,retain)UIColor *pageTextColor;
@property (nonatomic,retain)UIColor *pageDimTextColor;
@property (nonatomic,retain)UIColor *topBarBgColor;
@property (nonatomic,retain)UIColor *topBarTextColor;
@property (nonatomic,retain)UIColor *bottomBarBgColor;
@property (nonatomic,retain)UIColor *bottomBarTextColor;
@property (nonatomic,retain)UIColor *bottomBarDimTextColor;
@property (nonatomic,retain)UIColor *dataViewBgColor;
@property (nonatomic,retain)UIColor *dataViewTextColor;
@property (nonatomic,retain)UIColor *dataViewDimTextColor;

@property (nonatomic,retain)NSString *all;
@property (nonatomic,retain)NSString *referFriends;
@property (nonatomic,retain)NSString *selectContacts;
@property (nonatomic,retain)NSString *from;
@property (nonatomic,retain)NSString *inviteFriends;
@property (nonatomic,retain) NSString *messages;
@property (nonatomic,retain) NSString *addFunds;
@property (nonatomic) BOOL showAddFunds;
@property (nonatomic) BOOL showMessage;
@property (nonatomic) BOOL showInviteFriends;
@property (nonatomic,retain) NSString *messagePage;
@property (nonatomic,retain) NSString *addFundsPage;
@property (nonatomic,retain) NSString *urlOptionsPage;
@property (nonatomic,retain) NSString *urlTopUpPage;
@property (nonatomic,retain) NSString *urlContactsPage;

@property (nonatomic,retain) NSString *keypad;
@property (nonatomic,retain) NSString *contacts;
@property (nonatomic,retain) NSString *topUps;
@property (nonatomic,retain) NSString *options;

@property (nonatomic,retain) NSString *resellerId;
@property (nonatomic,retain) NSString *appName;
@property (nonatomic,retain) NSString *appDescription;
@property (nonatomic,retain) NSString *webSite;
@property (nonatomic,retain) NSString *copyright;
@property (nonatomic,retain) NSString *aboutText;

@property (nonatomic,retain) NSString *CS_Email;
@property (nonatomic,retain) NSString *CS_Phone;
@property (nonatomic,retain) NSString *facebookAppId;
@property (nonatomic,retain) NSString *facebookAppSecret;
@property (nonatomic,retain) NSString *twitterAppKey;
@property (nonatomic,retain) NSString *TwitterAppSecret;
@property (nonatomic,retain) NSString *facebookPage;
@property (nonatomic,retain) NSString *TwitterPage;
@property (nonatomic,retain) NSString *LoginPage;

//@property (nonatomic,retain) NSString *copy_Right;
@property (nonatomic,retain) NSString *enter10DigitMobileNo;
@property (nonatomic,retain) NSString *activate;
@property (nonatomic,retain) NSString *login;
@property (nonatomic,retain) NSString *promoCode;
@property (nonatomic,retain) NSString *didntgetpasscode;
@property (nonatomic,retain) NSString *sentInText;
@property (nonatomic,retain) NSString *clientWelcome;
@property (nonatomic,retain) NSString *enterPasscode;
@property (nonatomic,retain) NSString *callMe;
@property (nonatomic,retain) NSString *pleaseEnterPhoneNumber;
@property (nonatomic,retain) NSString *pleaseEnterPromocode;
@property (nonatomic,retain) NSString *pleaseEnterPasscode;
@property (nonatomic,retain) NSString *loginFailed;
@property (nonatomic,retain) NSString *networkNotAvailable;

@property (nonatomic,retain) NSString *Balance;
@property (nonatomic,retain) NSString *pleaseDialAnumber;
@property (nonatomic,retain) NSString *sendRechargeTo;
@property (nonatomic,retain) NSString *recipientsMobileNumber;
@property (nonatomic,retain) NSString *mobileOperator;
@property (nonatomic,retain) NSString *pleaseSelectOperator;
@property (nonatomic,retain) NSString *amountToSend;
@property (nonatomic,retain) NSString *pleaseSelectAmount;
@property (nonatomic,retain) NSString *recepientWillReceive;
@property (nonatomic,retain) NSString *send;
@property (nonatomic,retain) NSString *recentTransactions;
@property (nonatomic,retain) NSString *pleaseEnterAvalidNumber;
@property (nonatomic,retain) NSString *amountSelectionOrEnteringAmountIsRequired;
@property (nonatomic,retain) NSString *failedToLoadMobileOperators;
@property (nonatomic,retain) NSString *failedToProcess;
@property (nonatomic,retain) NSString *number;
@property (nonatomic,retain) NSString *country;
@property (nonatomic,retain) NSString *operatorMobile;
@property (nonatomic,retain) NSString *custService;
@property (nonatomic,retain) NSString *currency;
@property (nonatomic,retain) NSString *amount;
@property (nonatomic,retain) NSString *sentAmount;
@property (nonatomic,retain) NSString *amountCharged;
@property (nonatomic,retain) NSString *transId;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *tax;
@property (nonatomic,retain) NSString *confirmTransaction;
@property (nonatomic,retain) NSString *cancel;
@property (nonatomic,retain) NSString *failedToGetResponseFromServer;

@property (nonatomic,retain) NSString *strAppDescription;
//@property (nonatomic,retain) NSString *appVersion;
//@property (nonatomic,strong) NSString *copy_RightApp;
@property (nonatomic,retain) NSString *phoneNo;
@property (nonatomic,retain) NSString *logOut;
@property (nonatomic,retain) NSString *callOptions;
@property (nonatomic,retain) NSString *followUs;
@property (nonatomic,retain) NSString *getRates;
@property (nonatomic,retain) NSString *aboutUs;
@property (nonatomic,retain) NSString *moreOptions;
@property (nonatomic,retain) NSString *byNumber;
@property (nonatomic,retain) NSString *internationalNumber;
@property (nonatomic,retain) NSString *byArea;
@property (nonatomic,retain) NSString *pleaseSelect;
@property (nonatomic,retain) NSString *pleaseSelectArea;
@property (nonatomic,retain) NSString *strLblCountry;
@property (nonatomic,retain) NSString *area;
@property (nonatomic,retain) NSString *yourRates;
@property (nonatomic,retain) NSString *pleaseSelectCountry;
@property (nonatomic,retain) NSString *failedToLoadCountryList;
@property (nonatomic,retain) NSString *failedToLoadAreaList;
@property (nonatomic,retain) NSString *failedToLoadRatesList;

@property (nonatomic,retain) NSString *mobileRecharge;
@property (nonatomic,retain) NSString *topupConfirmation;
@property (nonatomic,retain) NSString *operatorWithColon;
@property (nonatomic,retain) NSString *ratesCalculator;
@property (nonatomic,retain) NSString *sendAmount;
@property (nonatomic,retain) NSString *loading;
@property (nonatomic,retain) NSString *passcodeSentInText;
@property (nonatomic,retain) NSString *callRates;
@property (nonatomic,retain) NSString *invite;
@property (nonatomic,retain) NSString *callType;
@property (nonatomic,retain) NSString *useWifiWhenAvailable;
@property (nonatomic,retain) NSString *announceMinutes;
@property (nonatomic,retain) NSString *announceBalance;
@property (nonatomic,retain) NSString *announcements;
@property (nonatomic,retain) NSString *selectFriends;
@property (nonatomic,retain) NSString *close;
@property (nonatomic,retain) NSString *pullUpToRefresh;
@property (nonatomic,retain) NSString *releaseToRefresh;
@property (nonatomic,retain) NSString *saveBillingInfo;
@property (nonatomic,retain) NSString *cardInformation;
@property (nonatomic,retain) NSString *billingAddress;
@property (nonatomic,retain) NSString *expYear;
@property (nonatomic,retain) NSString *expMonth;
@property (nonatomic,retain) NSString *nameOnCreditCard;
@property (nonatomic,retain) NSString *creditCardNo;
@property (nonatomic,retain) NSString *securityCode;
@property (nonatomic,retain) NSString *streetAddress;
@property (nonatomic,retain) NSString *AddressLine2;
@property (nonatomic,retain) NSString *city;
@property (nonatomic,retain) NSString *province;
@property (nonatomic,retain) NSString *version;
@property (nonatomic,retain) NSString *customerService;

@property (nonatomic,retain) NSString *enterAmount;
@property (nonatomic,retain) NSString *recharge;
@property (nonatomic,retain) NSString *statePostalCode;
@property (nonatomic,retain) NSString *selectAmount;
@property (nonatomic,retain) NSString *next;
@property (nonatomic,retain) NSString *chargeMyCreditCard;
@property (nonatomic, retain) NSString *strSelectAll;

//////////Color Theme////////////////////////////////////
@property (nonatomic,retain) UIColor *colLoginBg;
@property (nonatomic,retain) UIColor *colLoginText;
@property (nonatomic,retain) UIColor *colLoginDimTextColor;
@property (nonatomic,retain) UIColor *colWhiteBg;
@property (nonatomic,retain) UIColor *colTitle;
@property (nonatomic,retain) UIColor *colTabColor;
@property (nonatomic,retain) UIColor *colDialerText;
@property (nonatomic,retain) UIColor *colDialerDialText;



@property (nonatomic,retain) UIImage *imgSendBtn;
@property (nonatomic,retain) UIImage *imgCancelBtn;
@property (nonatomic,retain) UIImage *imgDropDownBg;

@property (nonatomic,retain) UIImage *imgDialer4;
@property (nonatomic,retain) UIImage *imgDialer5;

@property (nonatomic,retain) UIImage *imgLogo;
@property (nonatomic,retain) UIImage *imgContacts;
@property (nonatomic,retain) UIImage *imgLogout;
@property (nonatomic,retain) UIImage *imgTopRightLogo;
@property (nonatomic,retain) UIImage *imgCellDropDown;

@property (nonatomic,retain)NSString *imagePath;
@property (nonatomic,retain)NSString *imageUpdateDate;

@property (nonatomic,retain)UIImage *imgArrow;
@property (nonatomic,retain)UIImage *imgArrowDown;
@property (nonatomic) BOOL showTopUps;
@property (nonatomic,retain) NSString *strClose;
@property (nonatomic,retain) NSString *strView;
@property (nonatomic,retain) NSString *strWantToGoMsg;
@property (nonatomic,retain) NSString *strWantToGoTopUp;
@property (nonatomic,retain) NSString *strMessage;
@end
