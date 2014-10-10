//
//  AppInfo.m
//  Oye
//
//  Created by user on 26/10/12.
//
//

#import "AppInfo.h"
#import "Constants.h"
@implementation AppInfo
@synthesize aboutText,appDescription,appName,copyright,CS_Email,CS_Phone,facebookAppId,facebookAppSecret,resellerId,twitterAppKey,TwitterAppSecret,webSite,facebookPage,TwitterPage,LoginPage;

@synthesize enter10DigitMobileNo,activate,login,promoCode,didntgetpasscode,sentInText,enterPasscode,callMe,pleaseEnterPhoneNumber,pleaseEnterPromocode,pleaseEnterPasscode,loginFailed,
networkNotAvailable,Balance,pleaseDialAnumber,sendRechargeTo,recipientsMobileNumber,mobileOperator,pleaseSelectOperator,amountToSend,pleaseSelectAmount,recepientWillReceive,send,recentTransactions,pleaseEnterAvalidNumber,amountSelectionOrEnteringAmountIsRequired,failedToLoadMobileOperators,failedToProcess,number,country,operatorMobile,custService,currency,amount,sentAmount,amountCharged,transId,name,tax,confirmTransaction,cancel,failedToGetResponseFromServer,strAppDescription,phoneNo,logOut,callOptions,followUs,getRates,aboutUs,moreOptions,byNumber,internationalNumber,byArea,pleaseSelect,pleaseSelectArea,strLblCountry,area,yourRates,pleaseSelectCountry,failedToLoadCountryList,failedToLoadAreaList,failedToLoadRatesList,clientWelcome,keypad,contacts,topUps,options,urlOptionsPage,urlTopUpPage,urlContactsPage,operatorWithColon,topupConfirmation,mobileRecharge,ratesCalculator,sendAmount,loading,passcodeSentInText,addFundsPage,messagePage,showAddFunds,showMessage,addFunds,messages,callRates,invite,callType,announceBalance,announceMinutes,useWifiWhenAvailable,announcements,selectFriends,showInviteFriends,close,pullUpToRefresh,releaseToRefresh,colLoginBg,colWhiteBg,colTitle,colTabColor,imgSendBtn,imgCancelBtn,imgDropDownBg,imgDialer4,imgDialer5,saveBillingInfo,billingAddress,cardInformation,expMonth,expYear,creditCardNo,nameOnCreditCard,securityCode,AddressLine2,city,province,streetAddress,version,customerService,enterAmount,statePostalCode,selectAmount,next,chargeMyCreditCard, strSelectAll,inviteFriends,from,showTopUps,pageBgColor,pageTextColor,pageDimTextColor,topBarBgColor,topBarTextColor,bottomBarBgColor,bottomBarTextColor,bottomBarDimTextColor,dataViewBgColor,dataViewTextColor,dataViewDimTextColor,imagePath,imageUpdateDate,imgLogo,imgContacts,imgLogout,imgTopRightLogo,imgCellDropDown,imgArrow,imgArrowDown,selectContacts,all,referFriends,colDialerText,recharge,colDialerDialText,colLoginDimTextColor,colLoginText,strClose,strView,strMessage,strWantToGoMsg,strWantToGoTopUp;

-(id)init
{
    if (!self) {
        self = [super init];
    }
    //vishnu
    strClose = @"Close";
    strView = @"View";
    strWantToGoTopUp = @"Do you want to view TopUp";
    strWantToGoMsg = @"Do you want to view Messages";
    strMessage = @"Message";
    

    all =@"All";
    referFriends = @"Refer Friends";
    selectContacts = @"Select Contacts";
    from = @"From:";
    inviteFriends = @"Invite Friends";
    chargeMyCreditCard = @"Charge my Credit Card";
    next = @"Next";
    selectAmount = @"Select Amount";
    statePostalCode = @"State/Postal Code";
    enterAmount = @"Enter Amount";
    customerService = @"Customer Service";
    version = @"version";
    streetAddress = @"Street Address";
    AddressLine2 = @"Address Line2";
    city = @"City";
    province = @"Province / State";
    nameOnCreditCard = @"Name on Credit Card";
    creditCardNo = @"Credit Card No";
    securityCode = @"Security Code (CVV)";
    expMonth = @"Exp Month";
    expYear = @"Exp Year";
    cardInformation = @"Card Information";
    billingAddress = @"Billing Address";
    saveBillingInfo = @"Save Billing Info";
    
    imgDialer4 = [UIImage imageNamed:@"dialer.png"];
    imgDialer5 = [UIImage imageNamed:@"dialer_320*500.png"];
    imgSendBtn = [UIImage imageNamed:@"bg_send.png"];
    imgCancelBtn = [UIImage imageNamed:@"bg_btnCancel.png"];
    imgDropDownBg = [UIImage imageNamed:@"btnBg2.png"];
    
    imgLogo = [UIImage imageNamed:@"OyeLogo.png"];
    imgContacts = [UIImage imageNamed:@"contacts.png"];
    imgLogout = [UIImage imageNamed:@"log-out_65_25with-txt.png"];
    imgTopRightLogo = [UIImage imageNamed:@"icon 40*40.png"];
    imgCellDropDown = [UIImage imageNamed:@"cell-btn.png"];
    
    imgArrow = [UIImage imageNamed:@"cell-btn.png"];
    imgArrowDown = [UIImage imageNamed:@"cell-btn.png"];
    
//    colLoginBg = [UIColor colorWithRed:56.0/255.0 green:89.0/255.0 blue:164.0/255.0 alpha:1.0];
//    colWhiteBg = [UIColor whiteColor];
//    colTitle = [UIColor colorWithRed:58.0/255.0 green:103.0/255.0 blue:158.0/255.0 alpha:1];
//    colTabColor = [UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
    
    pageBgColor = [UIColor whiteColor];
    dataViewBgColor = [UIColor whiteColor];
    topBarBgColor = [UIColor colorWithRed:58.0/255.0 green:103.0/255.0 blue:158.0/255.0 alpha:1];
    bottomBarBgColor = [UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
    colDialerText = [UIColor blackColor];
    colLoginBg = [UIColor colorWithRed:56.0/255.0 green:89.0/255.0 blue:164.0/255.0 alpha:1.0];
    colLoginText = [UIColor blackColor];
    colLoginDimTextColor = [UIColor grayColor];
    colDialerDialText = [UIColor colorWithRed:59.0/255.0 green:103.0/255.0 blue:159.0/255.0 alpha:1.0];
    pageTextColor = [UIColor blackColor];
    topBarTextColor = [UIColor whiteColor];
    bottomBarTextColor = [UIColor whiteColor];
    dataViewTextColor = [UIColor blackColor];
    dataViewDimTextColor = [UIColor grayColor];
    
    
    releaseToRefresh = @"Release to refresh...";
    pullUpToRefresh = @"Pull up to refresh...";
    close = @"Close";
    selectFriends = @"Contacts";
    announcements = @"Announcements";
    announceMinutes = @"Announce Minutes";
    announceBalance = @"Announce Balance";
    useWifiWhenAvailable = @"Use Wifi when available";
    callType = @"Call Type";
    invite = @"Invite";
    callRates = @"Call Rates";
    messages = @"Messages";
    amount = @"Amount:";
    enter10DigitMobileNo = @"Enter your 10 digit Mobile Number";
    clientWelcome = @"New Client. Welcome !";
    promoCode = @"Promocode";
    passcodeSentInText = @"Passcode sent in text";
    didntgetpasscode = @"Didn't get passcode?";
    enterPasscode = @"Enter passcode";
    callMe = @"Call Me";
    activate = @"Activate";
    login = @"login";
    Balance = @"Balance";
    mobileRecharge = @"Mobile Recharge";
    sendRechargeTo = @"Send recharge to:";
    recipientsMobileNumber = @"Recipient's Mobile Number";
    mobileOperator = @"Mobile Operator:";
    pleaseSelectOperator = @"Please Select Operator";
    amountToSend = @"Amount to send:";
    pleaseSelectAmount = @"Please Select Amount";
    recepientWillReceive = @"Recepient will receive:";
    send = @"Send";
    recentTransactions = @"Recent Transactions";
    topupConfirmation = @"Topup confirmation";
    number = @"Number:";
    country = @"Country:";
    operatorWithColon = @"Operator:";
    custService = @"Cust Service:";
    currency = @"Currency:";
    amount = @"Amount:";
    tax = @"Tax:";
    sendAmount = @"Sent Amount:";
    amountCharged = @"Amount Charged:";
    transId = @"Trans ID:";
    name = @"Name";
    confirmTransaction = @"Confirm Transaction";
    cancel = @"Cancel";
    options = @"Options";
    phoneNo = @"Phone no";
    Balance = @"Balance:";
    logOut = @"Logout";
    callOptions = @"Call Options";
    followUs = @"Follow Us";
    getRates = @"Call Rates";
    aboutUs = @"About Us";
    moreOptions = @"More Options";
    ratesCalculator = @"Rates calculator";
    byNumber = @"By Number";
    internationalNumber = @"International Number";
    byArea = @"By Area";
    country = @"Country";
    pleaseSelect = @"Please select";
    area = @"Area";
    yourRates = @"Your Rates";
    loading = @"Loading";
    pleaseEnterPhoneNumber = @"Please Enter PhoneNumber";
    pleaseEnterPromocode = @"Please Enter Promocode";
    pleaseEnterPasscode = @"Please Enter Passcode";
    loginFailed = @"Login Failed";
    networkNotAvailable = @"Network Not Available";
    pleaseDialAnumber = @"Please dial a number";
    pleaseEnterAvalidNumber = @"Please Enter a valid Number";
    amountSelectionOrEnteringAmountIsRequired = @"Amount Selection Or Entering Amount is Required";
    failedToLoadMobileOperators = @"Failed to Load Mobile Operators";
    failedToProcess = @"Failed to Process";
    failedToGetResponseFromServer = @"Failed to Get Response From Server";
    pleaseSelectCountry = @"Please Select Country";
    failedToLoadCountryList = @"Failed to Load Country List";
    failedToLoadAreaList = @"Failed to Load Area List";
    failedToLoadRatesList = @"Failed to Load Rates List";
    keypad = @"Keypad";
    contacts = @"Contacts";
    topUps = @"Top Ups";
    options = @"Options";
    addFunds = @"Add Funds";
    strSelectAll  = @"Select All";
    return  self;
}

@end
