//
//  RESTInteraction.m
//  IntigrityAnswers
//
//  Created by Manish on 10/11/11.
//  Copyright 2011 Aryavrat infotech. All rights reserved.
//
#import "RESTInteraction.h"
#import "LocationData.h"
#import "XMLReaderPhoneArea.h"
#import "XMLReaderCountryList.h"
#import "XMLReaderAreaList.h"
#import "XMLReaderTopupOperatorList.h"
#import "Constants.h"
#import "XMLReaderTopupCharge.h"
#import "XMLReaderAppInfo.h"
#import "XMLReaderEnableSip.h"
#import "XMLReaderGetPin.h"
#import "ABContactsHelper.h"
#import "XMLReaderLineInfo.h"
#import "XMLReaderClientInfo.h"
#import "XMLReaderBillingInfoSave.h"
#import "XMLReaderChargeAccount.h"
#import "XMLReaderInviteFriends.h"
static RESTInteraction *restManager = nil;

@implementation RESTInteraction
@synthesize canAccessMore,lastSpeedDialNumber;
@synthesize pref,delegate;

+ (id)restInteractionManager {
    @synchronized(self) {
        if (restManager == nil)
            restManager = [[self alloc] init];
        
    }
    return restManager;
}

- (id)init {
    if (self = [super init]) {
        urlLogin = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/UserLogin.asp"];
        urlCallLog = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/CallLogList.asp"];
        urlCallerIDsGet = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/CallerIDsGet.asp"];
        urlCallBackLineList = [[NSURL alloc]initWithString:@"https://api.callture.net/mobi/bizzapp/Callbacklineslist.asp"];
        urlAccessNo = [[NSURL alloc]initWithString:@"https://api.callture.net/mobi/bizzapp/AccessNumbersGet.asp"] ;
        urlProfileSet = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/ProfileSet.asp"] ;
        urlCallBack = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/CallMeBack.asp"] ;
        urlCallSetup = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/ClientSetup.asp"];
        urlClientPinGet = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/ClientPinGet.asp"];
        urlDirectDialSetup = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/DirectDialSet.asp"];
        urlLocation = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/ServiceLocationGetMobi.asp"];
        
        urlPhoneAreaGet = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/PhoneAreaGet.asp"];
        urlCallingCountryList = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/CallingCountryList.asp"];
        urlCallingRates = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/CallingRates.asp"];
        urlTopupOperatorList = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/TopupOperatorList.asp"];
        urlTopupCharge = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/TopupCharge.asp"];
        urlAboutUsDetail = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/AppSettings.asp"];
        urlEnableSipCalling = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/EnableSipCalling.asp"];
        urlTopupHistory = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/TopupHistory.asp"];
        urlAnnounce=[[NSURL alloc]initWithString:@"https://api.callture.net/mobi/bizzapp/LineInfoSet.asp"];
        urlInviteFriends = [[NSURL alloc]initWithString:@"https://api.callture.net/mobi/bizzapp/InviteFriends.asp"];
        urlReteriveBillingInfo = [[NSURL alloc]initWithString:@"https://api.callture.net/mobi/bizzapp/ClientInfoGet.asp"];
        urlSaveBillingInfo = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/ClientInfoSet.asp"];
        urlChargeAccount = [[NSURL alloc] initWithString:@"https://api.callture.net/mobi/bizzapp/CCChargeMobi.asp"];
        canAccessMore = YES;
        lastSpeedDialNumber = @"";
    }
    return self;
}

-(void)EnableSipCalling:(BOOL)isEnable
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlEnableSipCalling];
	[request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:CALLOPTION1] forKey:@"CallType"];
    
    request.timeOutSeconds=9999999999;
    if (isEnable) {
        [request setPostValue:@"true" forKey:@"Enable"];
    }else{
        [request setPostValue:@"false" forKey:@"Enable"];
    }
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(enableSipCallingAsyncFail:)];
    [request setDidFinishSelector:@selector(enableSipCallingAsyncSuccess:)];
	[request startSynchronous];
}

- (void)enableSipCallingAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
	NSError *parseError = nil;
	XMLReaderEnableSip *streamingParser = [[XMLReaderEnableSip alloc] init];
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
}

- (void)enableSipCallingAsyncFail:(ASIFormDataRequest *)request
{
    
}


-(void)GetAreaForPhone:(NSString *)number
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlPhoneAreaGet];
	[request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    [request setPostValue:number forKey:@"PhoneNo"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    
    request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getAreaForPhoneAsyncFail:)];
    [request setDidFinishSelector:@selector(getAreaForPhoneAsyncSuccess:)];
	[request startSynchronous];
}

- (void)getAreaForPhoneAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
	NSError *parseError = nil;
	XMLReaderPhoneArea *streamingParser = [[XMLReaderPhoneArea alloc] init];
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

- (void)getAreaForPhoneAsyncFail:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RATES_FOR_PHONE_FAILED object:nil];
}

-(void)GetCountryList
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlCallingCountryList];
	[request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getCountryListAsyncFail:)];
    [request setDidFinishSelector:@selector(getCountryListAsyncSuccess:)];
	[request startSynchronous];
}

- (void)getCountryListAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
	NSError *parseError = nil;
	XMLReaderCountryList *streamingParser = [[XMLReaderCountryList alloc] init];
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

- (void)getCountryListAsyncFail:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COUNTRYLIST_FAILED object:nil];
}

-(void)GetAreaList:(NSString *)countryName
{
    //TelNo=919530204199&LineNo=78960259&CountryName=india&CallType=Callback&LocalCountry=Canada&LocalArea=""
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlCallingRates];
	[request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:countryName forKey:@"CountryName"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:CALLOPTION1] forKey:@"CallType"];
    [request setPostValue:LOCATION_COUNTRY forKey:@"LocalCountry"];
    [request setPostValue:LOCAL_AREA forKey:@"LocalArea"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getAreaListAsyncFail:)];
    [request setDidFinishSelector:@selector(getAreaListAsyncSuccess:)];
	[request startSynchronous];
}

- (void)getAreaListAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
	NSError *parseError = nil;
	XMLReaderAreaList *streamingParser = [[XMLReaderAreaList alloc] init];
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
}

- (void)getAreaListAsyncFail:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AREALIST_FAILED object:nil];
}

-(void)GetAboutUsDetail
{
    //TelNo=919530204199&LineNo=78960259&CountryName=india&CallType=Callback&LocalCountry=Canada&LocalArea=""
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlAboutUsDetail];
	[request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    request.timeOutSeconds=9999999999;
    ////
    //    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    //[request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    //
    //    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    //    [request setPostValue:[GlobalData GetDefaultProfile].profileBillingAccount forKey:@"LineNo"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getAboutUsAsyncFail:)];
    [request setDidFinishSelector:@selector(getAboutUsAsyncSuccess:)];
	[request startSynchronous];
}

- (void)getAboutUsAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
	NSError *parseError = nil;
	XMLReaderAppInfo *streamingParser = [[XMLReaderAppInfo alloc] init];
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

- (void)getAboutUsAsyncFail:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APP_INFO_FAILED object:nil];
}


-(void)MakeTopupCharge:(NSString *)MobileNo PaymentId:(NSString *)paymentid amount:(NSString *)amount confirmationOrder:(NSString *)confirmationOrder mobileOrderId:(NSString *)mobileOrderId fromPage:(NSString *)fromPage
{
    topupChargeFromPage = fromPage;
    //PaymentId=0&Amount=13.00&ConfirmedOrder=false&MobileOperatorID=112&SenderName=&RecipientName=
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlTopupCharge];
    [request setTimeOutSeconds:60];
	[request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:MobileNo forKey:@"MobileNo"];
    [request setPostValue:paymentid forKey:@"PaymentId"];
    [request setPostValue:amount forKey:@"Amount"];
    [request setPostValue:confirmationOrder forKey:@"ConfirmedOrder"];
    [request setPostValue:mobileOrderId forKey:@"MobileOperatorID"];
    [request setPostValue:@"" forKey:@"SenderName"];
    [request setPostValue:@"" forKey:@"RecipientName"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(makeTopupChargeAsyncFail:)];
    [request setDidFinishSelector:@selector(makeTopupChargeAsyncSuccess:)];
	[request startSynchronous];
}

- (void)makeTopupChargeAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
	NSError *parseError = nil;
	XMLReaderTopupCharge *streamingParser = [[XMLReaderTopupCharge alloc] init];
    streamingParser.callingFrom = topupChargeFromPage;
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

- (void)makeTopupChargeAsyncFail:(ASIHTTPRequest *)request
{
    if ([topupChargeFromPage isEqualToString:[GlobalData getAppInfo].topUps]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOPUP_CHARGE_FAILED object:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONFIRMATION_TOPUP_CHARGE_FAILED object:nil];
    }
}

- (void)getTopupOperatorsAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
	NSError *parseError = nil;
	XMLReaderTopupOperatorList *streamingParser = [[XMLReaderTopupOperatorList alloc] init];
    streamingParser.delegate = self;
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

- (void)getTopupOperatorsAsyncFail:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_OPERATORLIST_FAILED object:nil];
}

-(void)GetTopupOperators:(NSString *)phoneNo
{
    //TelNo=919530204199&LineNo=78960259&CountryName=india&CallType=Callback&LocalCountry=Canada&LocalArea=""
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlTopupOperatorList];
	[request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    
    [request setPostValue:phoneNo forKey:@"MobileNo"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getTopupOperatorsAsyncFail:)];
    [request setDidFinishSelector:@selector(getTopupOperatorsAsyncSuccess:)];
	[request startSynchronous];
}

-(void)addOperator:(MobileOperator *)mo
{
    [delegate addOperator:mo];
}

-(void)addMobileTopup:(MobileTopup *)mt
{
    [delegate addMobileTopup:mt];
}


- (void)getLoginData:(NSString *)userName :(NSString *)password :(BOOL)isSave{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlLogin];
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
	[request setPostValue:[NSString stringWithFormat:@"%@",userName] forKey:@"LoginUsr"];
	[request setPostValue:[NSString stringWithFormat:@"%@",password] forKey:@"LoginPwd"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
	[request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    request.timeOutSeconds=9999999999;
    ////
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getFirsttimeDataAsyncFail:)];
    [request setDidFinishSelector:@selector(getFirsttimeDataAsyncSuccess:)];
	[request startSynchronous];
}

- (void)getFirsttimeDataAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
	responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    
	NSError *error = nil;
	CXMLDocument *xml = [[CXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
	if (error == nil) {
		NSArray *nodes = [[xml rootElement] nodesForXPath:@"//XML/Auth/AuthInfo" error:&error];
		if(error == nil)
		{
			if ([nodes count]>0) {
                LoginInfo *li = [LoginInfo LoginManager];
				for (CXMLNode *itemNode in nodes)
				{
					for (CXMLNode *childNode in [itemNode children])
					{
						NSString *nodeName = [childNode name]; // should contain item_1 in first iteration
						NSString *nodeValue = [childNode stringValue]; // should contain 'text' in first iteration
						if([nodeName isEqualToString:@"ResultID"])
						{
							li.ResultID = nodeValue;
						}
						if([nodeName isEqualToString:@"ResultStr"])
						{
							li.ResultStr = nodeValue;
						}
						if([nodeName isEqualToString: @"UserKey"])
						{
							li.UserKey = nodeValue;
						}
						if([nodeName isEqualToString: @"ClientId"])
						{
							li.ClientId = nodeValue;
						}
						if([nodeName isEqualToString:@"ClientName"])
						{
							li.ClientName = nodeValue;
						}
                        						
					}
				}
                [[callLogonViewController logOnManager] getResultOfLogin:li];
			}else {
				[[callLogonViewController logOnManager] getResultOfLogin:nil];
			}
		}else {
			[[callLogonViewController logOnManager] getResultOfLogin:nil];
		}
        
		
	}else {
		NSLog(@"Error occure from cullture API");
		[[callLogonViewController logOnManager] getResultOfLogin:nil];
	}
    
    
}

- (void)getFirsttimeDataAsyncFail:(ASIHTTPRequest *)request
{
    [[callLogonViewController logOnManager] getResultOfLogin:nil];
    //NSError *error = [request error];
}

- (void)getCallLogData:(NSString *)nor :(NSString *)lastcdrd :(NSString *)clientID{
    lastcdrd = (lastcdrd == nil)?@"0":lastcdrd;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlCallLog];
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ApiKey] forKey:@"key"];
	[request setPostValue:[NSString stringWithFormat:@"%@",nor] forKey:@"NoOfRows"];
	[request setPostValue:[NSString stringWithFormat:@"%@",lastcdrd] forKey:@"CDRID"];
	[request setPostValue:[NSString stringWithFormat:@"%@",clientID] forKey:@"ClientID"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    request.timeOutSeconds=9999999999;
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getCallLogDataAsyncFail:)];
    [request setDidFinishSelector:@selector(getCallLogDataAsyncSuccess:)];
	[request startSynchronous];
}

- (void)getCallLogDataAsyncSuccess:(ASIFormDataRequest *)request
{
    [self continueCallLogAccess:request];
    //    NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
    //    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
    //                                        initWithTarget:self
    //                                        selector:@selector(continueCallLogAccess:)
    //                                        object:request];
    //    [queue addOperation:operation];
    //    [operation release];
}

-(void)continueCallLogAccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	NSError *error = nil;
	CXMLDocument *xml = [[CXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
	if (error == nil) {
		NSArray *nodes = [[xml rootElement] nodesForXPath:@"//XML/CallsList" error:&error];
		if(error == nil)
		{
			if ([nodes count]>0) {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
				for (CXMLNode *itemNode in nodes)
				{
					for (CXMLNode *childNode in [itemNode children])
					{
                        CallLogData *cld = [[CallLogData alloc]init];
                        for (CXMLNode *node in [childNode children])
                        {
                            NSString *nodeName = [node name]; // should contain item_1 in first iteration
                            NSString *nodeValue = [node stringValue];
                            
                            if([nodeName isEqualToString:@"CDRID"])
                            {
                                cld.CDRID = nodeValue;
                            }
                            if([nodeName isEqualToString:@"LineNo"])
                            {
                                cld.LineNo = nodeValue;
                            }
                            if([nodeName isEqualToString: @"CallerID"])
                            {
                                cld.CallerID = nodeValue;
                            }
                            if([nodeName isEqualToString: @"StartTime"])
                            {
                                cld.StartTime = nodeValue;
                            }
                            if([nodeName isEqualToString:@"Duration"])
                            {
                                cld.CallDuration = nodeValue;
                            }
                            if([nodeName isEqualToString: @"CalledNo"])
                            {
                                cld.CalledNo = nodeValue;
                            }
                            if([nodeName isEqualToString:@"ConnectStatus"])
                            {
                                cld.ConnectStatus = nodeValue;
                            }
                            if([nodeName isEqualToString:@"CallType"])
                            {
                                cld.callType = [nodeValue intValue];
                            }
                            if([nodeName isEqualToString:@"FormattedDate"])
                            {
                                cld.FormattedDate = nodeValue;
                            }
                        }
                        if(cld.callType == 0)
                        {
                            if (cld.CallerID.length>0)
                            {
                                NSString *displayNum = [[[ABContactsHelper contactsMatchingPhone:cld.CallerID] objectAtIndex:0]contactName];
                                if(displayNum == nil || displayNum.length==0)
                                {
                                    NSRange firstCharRange = NSMakeRange(0,1);
                                    NSString* firstCharacter = [cld.CallerID substringWithRange:firstCharRange];
                                    if ([firstCharacter isEqualToString:@"1"])
                                    {
                                        NSRange range = NSMakeRange(1,cld.CallerID.length-1);
                                        NSString* subStr = [cld.CallerID substringWithRange:range];
                                        displayNum = [[[ABContactsHelper contactsMatchingPhone:subStr]objectAtIndex:0]contactName];
                                        if(displayNum == nil || displayNum.length==0)
                                            cld.CallerName = cld.CallerID;
                                        else
                                            cld.CallerName = displayNum;
                                    }else
                                        cld.CallerName = cld.CallerID;
                                }
                                else
                                {
                                    cld.CallerName = displayNum;
                                }
                                [arr addObject:cld];
                            }
                        }else
                        {
                            if (cld.CalledNo.length>0)
                            {
                                NSString *displayNum = [[[ABContactsHelper contactsMatchingPhone:cld.CalledNo] objectAtIndex:0]contactName];
                                if(displayNum == nil || displayNum.length==0)
                                {
                                    NSRange firstCharRange = NSMakeRange(0,1);
                                    NSString* firstCharacter = [cld.CalledNo substringWithRange:firstCharRange];
                                    if ([firstCharacter isEqualToString:@"1"])
                                    {
                                        NSRange range = NSMakeRange(1,cld.CalledNo.length-1);
                                        NSString* subStr = [cld.CalledNo substringWithRange:range];
                                        displayNum = [[[ABContactsHelper contactsMatchingPhone:subStr]objectAtIndex:0]contactName];
                                        if(displayNum == nil || displayNum.length==0)
                                            cld.CallerName = cld.CalledNo;
                                        else
                                            cld.CallerName = displayNum;
                                    }else
                                        cld.CallerName = cld.CalledNo;
                                }
                                else
                                {
                                    cld.CallerName = displayNum;
                                }
                                [arr addObject:cld];
                            }
                        }
                    }
                }
                [[callLogListViewController currentView] updateLogList:[arr mutableCopy]];
            }
            else
            {
                [[callLogListViewController currentView] updateLogList:nil];
            }
        }else
        {
            [[callLogListViewController currentView] updateLogList:nil];
        }
    }else
    {
        [[callLogListViewController currentView] updateLogList:nil];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_CALL_LOG_DATA_LOADED object:nil];
}

- (void)getCallLogDataAsyncFail:(ASIHTTPRequest *)request
{
    [[callLogListViewController currentView] updateLogList:nil];
}

- (void)getCallBackLinesList:(NSString *)clientID{
    //APIusr, APIpwd, AppName, AppVer, AppPlatform
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlCallBackLineList];
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
	[request setPostValue:[GlobalData ApiKey] forKey:@"key"];
	[request setPostValue:[NSString stringWithFormat:@"%@",clientID] forKey:@"ClientID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    
	request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getCallBackLinesListAsyncFail:)];
    [request setDidFinishSelector:@selector(getCallBackLinesListAsyncSuccess:)];
	[request startSynchronous];
}

- (void)getCallBackLinesListAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    //  NSLog(@"%@",responseString);
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	NSError *error = nil;
	CXMLDocument *xml = [[CXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
	if (error == nil) {
        NSArray *nodes = [[xml rootElement] nodesForXPath:@"//XML/CallBackDIDs" error:&error];
		if(error == nil)
		{
            if ([nodes count]>0) {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
				for (CXMLNode *itemNode in nodes)
				{
					for (CXMLNode *childNode in [itemNode children])
					{
                        LineListData *lld = [[LineListData alloc]init];
                        for (CXMLNode *node in [childNode children])
                        {
                            NSString *nodeName = [node name]; // should contain item_1 in first iteration
                            NSString *nodeValue = [node stringValue];
                            
                            if([nodeName isEqualToString:@"LineNo"])
                            {
                                lld.LineNo = nodeValue;
                            }
                            if([nodeName isEqualToString:@"CallbackNo"])
                            {
                                lld.CallbackNo = nodeValue;
                            }
                            if([nodeName isEqualToString:@"Balance"])
                            {
                                lld.Balance = nodeValue;
                            }
                            if([nodeName isEqualToString:@"Description"])
                            {
                                lld.Description = nodeValue;
                            }
                            if([nodeName isEqualToString:@"PublicPIN"])
                            {
                                lld.PublicPIN = nodeValue;
                            }
                            if([nodeName isEqualToString:@"Deactivated"])
                            {
                                lld.Deactivated = nodeValue;
                            }
                            if([nodeName isEqualToString:@"VirtualDID"])
                            {
                                lld.VirtualDID = nodeValue;
                            }
                            if([nodeName isEqualToString:@"CallerID"])
                            {
                                lld.CallerID = nodeValue;
                            }
                            if([nodeName isEqualToString:@"DialOutString"])
                            {
                                lld.DialOutString = nodeValue;
                            }
                            if([nodeName isEqualToString:@"PlayMinutes"])
                            {
                                if (![GlobalData IsCallTypeSaved]) {
                                    [[NSUserDefaults standardUserDefaults] setValue:nodeValue forKey:ANNOUNCE_MINUTES];
                                }
                            }
                            if([nodeName isEqualToString:@"PlayBalance"])
                            {
                                if (![GlobalData IsCallTypeSaved]) {
                                    [[NSUserDefaults standardUserDefaults] setValue:nodeValue forKey:ANNOUNCE_BALANCE];
                                }
                            }
                            if([nodeName isEqualToString:@"UseWifiEnabled"])
                            {
                                if (![GlobalData IsCallTypeSaved]) {
                                    NSString *isWifi = [nodeValue isEqualToString:@"True"]?@"YES":@"NO";
                                    [[NSUserDefaults standardUserDefaults] setValue:isWifi forKey:USE_WIFI_IFAVAILABLE];
                                }
                            }
                            if([nodeName isEqualToString:@"CallType"])
                            {
                                if (![GlobalData IsCallTypeSaved]) {
                                    [[NSUserDefaults standardUserDefaults] setValue:nodeValue forKey:CALLOPTION1];
                                }
                            }
                        }
                        [arr addObject:lld];
                    }
                }
                [GlobalData SetIsCallTypeSaved:YES];
                [GlobalData SetCallBackLineList:[arr mutableCopy]];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CALLBACKLINELIST_UPDATED object:nil];
            }
        }
    }
}

- (void)getCallBackLinesListAsyncFail:(ASIFormDataRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CALLBACKLINELIST_FAILED object:nil];
}

-(void)callMeBack:(NSString *)destNo :(NSString *)callFrom
{
    NSString *mynumber = [NSString stringWithString:destNo];
    mynumber = [mynumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mynumber = [mynumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mynumber = [mynumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mynumber = [mynumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //NSLog(@"%@",urlCallBack);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlCallBack];
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ApiKey] forKey:@"key"];
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"NO"];
    [request setPostValue:[NSString stringWithFormat:@"%@",mynumber] forKey:@"DestNo"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
	request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(callMeBackAsyncFail:)];
    [request setDidFinishSelector:@selector(callMeBackAsyncSuccess:)];
	[request startSynchronous];
}

- (void)callMeBackAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    //NSLog(@"%@",responseString);
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	NSError *error = nil;
	CXMLDocument *xml = [[CXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
	if (error == nil) {
        NSArray *nodes = [[xml rootElement] nodesForXPath:@"//XML/Status/Description" error:&error];
		if(error == nil)
		{
            if ([nodes count]>0) {
				for (CXMLNode *itemNode in nodes)
				{
                    NSArray *nodes = [[xml rootElement] nodesForXPath:@"//XML/Result/ResultStr" error:&error];
                    if ([nodes count]>0)
                    {
                        for (CXMLNode *itemNode in nodes)
                        {
//                            if([callingFrom isEqualToString:TITLE_RECENT_CALLS_LOG])
//                            {
//                                [[callLogListViewController currentView] updateCallBackStatus:[itemNode stringValue]];
//                            }
//                            else if([callingFrom isEqualToString:@"Keypad"])
//                            {
//                                [[callDialerViewController currentView] updateCallBackStatus:[itemNode stringValue]];
//                            }
//                            else
//                            {
//                                [[callLogonViewController logOnManager] updateCallBackStatus:[itemNode stringValue]];
//                            }
                            [[[UIAlertView alloc]initWithTitle:@"Message" message:[itemNode stringValue] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                            return;
                        }
                    }else
                    {
//                        if([callingFrom isEqualToString:TITLE_RECENT_CALLS_LOG])
//                        {
//                            [[callLogListViewController currentView] updateCallBackStatus:[itemNode stringValue]];
//                        }
//                        else if([callingFrom isEqualToString:@"Keypad"])
//                        {
//                            [[callDialerViewController currentView] updateCallBackStatus:[itemNode stringValue]];
//                        }
//                        else
//                        {
//                            [[callLogonViewController logOnManager] updateCallBackStatus:[itemNode stringValue]];
//                        }
                        [[[UIAlertView alloc]initWithTitle:@"Message" message:[itemNode stringValue] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                        return;
                    }
                }
            }
        }
    }
//    if([callingFrom isEqualToString:TITLE_RECENT_CALLS_LOG])
//    {
//        [[callLogListViewController currentView] updateCallBackStatus:nil];
//    }else if([callingFrom isEqualToString:@"Keypad"])
//    {
//        [[callDialerViewController currentView] updateCallBackStatus:nil];
//    }
//    else
//    {
//        [[callLogonViewController logOnManager] updateCallBackStatus:nil];
//    }
}

- (void)callMeBackAsyncFail:(ASIFormDataRequest *)request
{
//    if([callingFrom isEqualToString:TITLE_RECENT_CALLS_LOG])
//    {
//        [[callLogListViewController currentView] updateCallBackStatus:nil];
//    }
//    else if([callingFrom isEqualToString:@"Keypad"])
//    {
//        [[callDialerViewController currentView] updateCallBackStatus:nil];
//    }
}

/*
 CallSetUp Filtration
 Added By: Pardeep
 Dated: 26 july 2012
 */
-(void)callSetUp:(NSString *)phoneNumber :(NSString *)promoCode :(NSString *)pinCode callFor:(NSString *)callFor
{
    loginApiCallFor = callFor;
    callsetupObject = [CallSetUp CallSetupManager];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlCallSetup];
    
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    //vishnu
    [request setPostValue:[GlobalData getDeviceOwner_Name] forKey:@"ownername"];
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    request.timeOutSeconds=9999999999;
    ////
    callsetupObject.phoneNumber = phoneNumber;
    
    if([phoneNumber length] > 0 ){
        [request setPostValue:[NSString stringWithFormat:@"%@",phoneNumber] forKey:@"TelNo"];
    }
    
    if([promoCode length] > 0 ){
        [request setPostValue:[NSString stringWithFormat:@"%@",promoCode] forKey:@"PromoCode"];
    }
    
    if([pinCode length] > 0 ){
        [request setPostValue:[NSString stringWithFormat:@"%@",pinCode] forKey:@"PIN"];
    }
    NSLog(@"%@",[GlobalData DiviceToken]);
    [request setPostValue:[GlobalData DiviceToken] forKey:@"DeviceToken"];
    
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(callSetUpAsyncFail:)];
    [request setDidFinishSelector:@selector(callSetUpAsyncSuccess:)];
	[request startSynchronous];
}

-(void)callForPin:(NSString *)phoneNumber :(NSString *)promoCode :(NSString *)pinCode callFor:(NSString *)callFor
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlClientPinGet];
    
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    if([phoneNumber length] > 0 ){
        [request setPostValue:[NSString stringWithFormat:@"%@",phoneNumber] forKey:@"TelNo"];
    }
    
    if([promoCode length] > 0 ){
        [request setPostValue:[NSString stringWithFormat:@"%@",promoCode] forKey:@"PromoCode"];
    }
    
    if([pinCode length] > 0 ){
        [request setPostValue:[NSString stringWithFormat:@"%@",pinCode] forKey:@"PIN"];
    }
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getClientPinAsyncFail:)];
    [request setDidFinishSelector:@selector(getClientPinAsyncSuccess:)];
	[request startSynchronous];
}

-(void)getClientPinAsyncFail:(ASIFormDataRequest *)request
{
    [[[callLogonViewController logOnManager]loader]removeFromSuperview];
    UIAlertView *alertMsg = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Unable to process for get passcode, Please try again!!" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
    [alertMsg show];
}

- (void)getClientPinAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"Reponse string is %@",responseString);
	responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    NSError *parseError = nil;
    XMLReaderGetPin *streamingParser = [[XMLReaderGetPin alloc] init];
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[callLogonViewController logOnManager]loader]removeFromSuperview];
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
}

- (void)callSetUpAsyncFail:(ASIFormDataRequest *)request
{
    [[[callLogonViewController logOnManager]loader]removeFromSuperview];
    UIAlertView *alertMsg = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Unable to process the number for Call SetUp, Please try again!!" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
    [alertMsg show];
    
}

- (void)callSetUpAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    //  NSLog(@"Reponse string is %@",responseString);
	responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    
	NSError *error = nil;
	CXMLDocument *xml = [[CXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
	if (error == nil) {
		NSArray *nodes = [[xml rootElement] nodesForXPath:@"//XML/ClientSetup" error:&error];
		if(error == nil)
		{
			if ([nodes count]>0) {
                
				for (CXMLNode *itemNode in nodes)
				{
					for (CXMLNode *childNode in [itemNode children])
					{
						NSString *nodeName = [childNode name]; // should contain item_1 in first iteration
						NSString *nodeValue = [childNode stringValue]; // should contain 'text' in first iteration
						if([nodeName isEqualToString:@"ResultId"])
						{
                            callsetupObject.ResultId = nodeValue;
						}
						if([nodeName isEqualToString:@"Result"])
						{
							callsetupObject.ResultStr = nodeValue;
						}
                        if([nodeName isEqualToString:@"ClientId"])
						{
							callsetupObject.clientid = nodeValue;
                            
						}if([nodeName isEqualToString:@"Username"])
						{
							callsetupObject.username = nodeValue;
                            
						}if([nodeName isEqualToString:@"Password"])
						{
							callsetupObject.password = nodeValue;
						}
                        if([nodeName isEqualToString:@"Ownername"])
						{
							callsetupObject.OwnerName = nodeValue;
                            [GlobalData SetOwnerName:nodeValue];
						}
						
					}
				}
                [[callLogonViewController logOnManager] getResultOfActivate:callsetupObject callfor:loginApiCallFor];
                //[[callLogonViewController logOnManager] getResultOfLogin:li];
			} else {
                [[callLogonViewController logOnManager] getResultOfActivate:nil callfor:loginApiCallFor];
				// [[callLogonViewController logOnManager] getResultOfLogin:nil];
			}
        } else {
            [[callLogonViewController logOnManager] getResultOfActivate:nil callfor:loginApiCallFor];
            // [[callLogonViewController logOnManager] getResultOfLogin:nil];
		}
        
		
	}else {
        //	NSLog(@"Error occure from cullture API");
		[[callLogonViewController logOnManager] getResultOfLogin:nil];
	}
    
}


-(void)sendRequestForDialSetup :(NSString *)contactNubmer :(NSString *)callFrom
{
    callFromFlag = callFrom;
    NSString *registerSaveNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"phonenumber"];
    
    NSString *latitude = [[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"];
    
    if(latitude.length == 0)
    {
        latitude = @"0";
    }
    
    NSString *longatitude = [[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"];
    
    if(longatitude.length == 0)
    {
        longatitude = @"0";
    }
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlDirectDialSetup];
    
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
  	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
	//vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    [request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    ////
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"No"];
    request.timeOutSeconds=9999999999;
    if (registerSaveNumber.length > 0)
    {
        [request setPostValue:[NSString stringWithFormat:@"%@",registerSaveNumber] forKey:@"TelNo"];
    }else
    {
        if([callsetupObject.phoneNumber length] > 0 )
        {
            [request setPostValue:[NSString stringWithFormat:@"%@",callsetupObject.phoneNumber] forKey:@"TelNo"];
        }
    }
    
    if([contactNubmer length] > 0 ){
        [request setPostValue:[NSString stringWithFormat:@"%@",contactNubmer] forKey:@"DestNo"];
    }
    if (canAccessMore || [callFromFlag isEqualToString:@"other"]) {
        [request setPostValue:[NSString stringWithFormat:@"%@",lastSpeedDialNumber] forKey:@"SpeedDialNo"];
        [request setPostValue:[NSString stringWithFormat:@"%@",latitude] forKey:@"Lat"];
        [request setPostValue:[NSString stringWithFormat:@"%@",longatitude] forKey:@"Lng"];
        [request setPostValue:[NSString stringWithFormat:@"%@",@"ADD"] forKey:@"Action"];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(DialSetUpAsyncFail:)];
        [request setDidFinishSelector:@selector(DialSetUpAsyncSuccessResponse:)];
        [request startSynchronous];
    }
}
- (void)DialSetUpAsyncSuccessResponse:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
	responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    
	NSError *error = nil;
	CXMLDocument *xml = [[CXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
	if (error == nil) {
		NSArray *nodes = [[xml rootElement] nodesForXPath:@"//XML/DirectDial" error:&error];
		if(error == nil)
		{
			if ([nodes count]>0) {
                AccessNumbers *accessnoObj = [[AccessNumbers alloc]init];
				for (CXMLNode *itemNode in nodes)
				{
					for (CXMLNode *childNode in [itemNode children])
					{
						NSString *nodeName = [childNode name];
						NSString *nodeValue = [childNode stringValue];
						if([nodeName isEqualToString:@"DestNo"])
						{
                            accessnoObj.destnumber = nodeValue;
						}
						if([nodeName isEqualToString:@"AccessNumber"])
						{
							accessnoObj.accessNumber = nodeValue;
						}
                        if([nodeName isEqualToString:@"SpeedDialNo"])
						{
                            if ([nodeValue isEqualToString:@"99"])
                            {
                                canAccessMore = NO;
                                lastSpeedDialNumber = @"99";
                                [self AddSpeedDialNoInAddressBook:accessnoObj.accessNumber];
                            }else {
                                lastSpeedDialNumber = @"";
                            }
							accessnoObj.speeddialnumber = nodeValue;
                            
						}if([nodeName isEqualToString:@"Action"])
						{
							accessnoObj.action = nodeValue;
                        }
                        if([nodeName isEqualToString:@"TelNo"])
						{
							accessnoObj.telenumber = nodeValue;
                            
						}
                        if([nodeName isEqualToString:@"Country"])
						{
							accessnoObj.country = nodeValue;
                            
						}if([nodeName isEqualToString:@"Province"])
						{
							accessnoObj.province = nodeValue;
                            
						}if([nodeName isEqualToString:@"City"])
						{
							accessnoObj.city = nodeValue;
                    	}
						
					}
				}
                
                if ([callFromFlag isEqualToString:@"other"]) {
                    if([accessnoObj.accessNumber length] > 0){
                        if ([lastSpeedDialNumber length] > 0 && ![lastSpeedDialNumber isEqualToString:@"99"]) {
                            [self performSelectorOnMainThread:@selector(sendNotification:) withObject:accessnoObj waitUntilDone:NO];
                        }
                        if ([[[UIDevice currentDevice] model] rangeOfString:@"Phone"].location != NSNotFound &&
                            [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location == NSNotFound ) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",accessnoObj.accessNumber]]];
                        }
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Sorry a Local Access Number is not available yet for your local calling area" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }else{
                    [self performSelectorOnMainThread:@selector(sendNotification:) withObject:accessnoObj waitUntilDone:NO];
                }
            } 
        }
	}else
    {
		NSLog(@"Error occure from OyaDialer API");
	}
}

-(void)AddSpeedDialNoInAddressBook:(NSString *)accessNo
{
    CFErrorRef error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFStringRef cfName = objc_unretainedPointer([GlobalData getApp_Name]);
    NSArray *people = (__bridge NSArray *)ABAddressBookCopyPeopleWithName(addressBook, cfName);
    //NSArray *peopleArray = (NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    // Display "Appleseed" information if found in the address book
    if ((people != nil) && people.count > 0)
    {
        //Creates a pass test block to see if the ABRecord has the same name as delete
        __block ABRecordRef delete = ABPersonCreate();
        
        ABRecordSetValue(delete, kABPersonFirstNameProperty, cfName, nil);
        BOOL (^predicate)(id obj, NSUInteger idx, BOOL *stop) = ^(id obj, NSUInteger idx, BOOL *stop) {
            ABRecordRef person = (__bridge ABRecordRef)obj;
            CFComparisonResult result =  ABPersonComparePeopleByName(person, delete, kABPersonSortByLastName);
            bool pass = (result == kCFCompareEqualTo);
            if (pass) {
                delete = person;
            }
            return (BOOL) pass;
        };
        
        int idx = [people indexOfObjectPassingTest:predicate];
        bool removed = ABAddressBookRemoveRecord(addressBook, delete, &error);
        bool saved = ABAddressBookSave(addressBook, &error);
        if (removed && saved) {
            ABAddressBookRef addressBook = ABAddressBookCreate();
            ABRecordRef person = ABPersonCreate();
            CFErrorRef anError;
            ABRecordSetValue(person, kABPersonFirstNameProperty, cfName, &anError);
            ABMutableMultiValueRef phoneNumberMultiValue =  ABMultiValueCreateMutable(kABPersonPhoneProperty);
            ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(accessNo),  kABPersonPhoneMobileLabel, NULL);
            ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
            
            NSData * dataRef = UIImagePNGRepresentation([UIImage imageNamed:@"icon-small.png"]);
            ABPersonSetImageData(person, (__bridge CFDataRef)dataRef, nil);
            
            ABAddressBookAddRecord(addressBook, person, &anError);
            ABAddressBookSave(addressBook, &anError);
            CFRelease(addressBook);
        }
    }else
    {
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABRecordRef person = ABPersonCreate();
        CFErrorRef anError;
        ABRecordSetValue(person, kABPersonFirstNameProperty, cfName, &anError);
        ABMutableMultiValueRef phoneNumberMultiValue =  ABMultiValueCreateMutable(kABPersonPhoneProperty);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(accessNo),  kABPersonPhoneMobileLabel, NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
        
        NSData * dataRef = UIImagePNGRepresentation([UIImage imageNamed:@"icon-small.png"]);
        ABPersonSetImageData(person, (__bridge CFDataRef)dataRef, nil);
        
        ABAddressBookAddRecord(addressBook, person, &anError);
        ABAddressBookSave(addressBook, &anError);
        CFRelease(addressBook);
    }
}

- (void)checkViews:(NSArray *)subviews {
    Class AVClass = [UIAlertView class];
    Class ASClass = [UIActionSheet class];
    for (UIView * subview in subviews){
        if ([subview isKindOfClass:AVClass]){
            [(UIAlertView *)subview dismissWithClickedButtonIndex:[(UIAlertView *)subview cancelButtonIndex] animated:NO];
        } else if ([subview isKindOfClass:ASClass]){
            [(UIActionSheet *)subview dismissWithClickedButtonIndex:[(UIActionSheet *)subview cancelButtonIndex] animated:NO];
        } else {
            [self checkViews:subview.subviews];
        }
    }
}

-(void)sendNotification:(AccessNumbers *)obj {
    if ([obj.accessNumber length] > 2  &&  ![obj.speeddialnumber isEqualToString:@"99"])
    {
        pref = [NSUserDefaults standardUserDefaults];
        [pref setObject:obj.accessNumber forKey:obj.destnumber];
        [pref synchronize];
    }
}

- (void)DialSetUpAsyncFail:(ASIFormDataRequest *)request
{
    
}


- (void)getTopupHistoryData:(NSString *)lineNo :(NSString *)lastpaymentId :(NSString *)clientID{
    //lastcdrd = (lastcdrd == nil)?@"0":lastcdrd;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlTopupHistory];
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    //vishnu
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ApiKey] forKey:@"key"];
	[request setPostValue:[NSString stringWithFormat:@"%@",lineNo] forKey:@"LineNo"];
	[request setPostValue:[NSString stringWithFormat:@"%@",lastpaymentId] forKey:@"LastPaymentId"];
	[request setPostValue:[NSString stringWithFormat:@"%@",clientID] forKey:@"ClientID"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getTopupHistoryAsyncFail:)];
    [request setDidFinishSelector:@selector(getTopupHistoryAsyncSuccess:)];
	[request startSynchronous];
}

- (void)getTopupHistoryAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    NSError *parseError = nil;
	XMLReaderTopupHistory *streamingParser = [[XMLReaderTopupHistory alloc] init];
    streamingParser.delegate = self;
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
}

-(void)announcement
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlAnnounce];
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    
    
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]valueForKey:ANNOUNCE_MINUTES] forKey:@"PlayMinutes"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]valueForKey:ANNOUNCE_BALANCE] forKey:@"PlayBalance"];
    NSString *isWifi = ([[[NSUserDefaults standardUserDefaults] valueForKey:USE_WIFI_IFAVAILABLE] isEqualToString:@"YES"])?@"True":@"False";
    [request setPostValue:isWifi forKey:@"UseWifiEnabled"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(announceAsyncFail:)];
    [request setDidFinishSelector:@selector(announceAsyncSuccess:)];
	[request startSynchronous];
    
}

- (void)announceAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"Reponse string is %@",responseString);
	responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    NSError *parseError = nil;
    XMLReaderLineInfo *streamingParser = [[XMLReaderLineInfo alloc] init];
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}


- (void)getTopupHistoryAsyncFail:(ASIFormDataRequest *)request
{
    //[self continueCallLogAccess:request];
}

-(void)sendInviteFriends:(NSString *)jsondata ownerName:(NSString *)ownerName
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlInviteFriends];
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    
    [request setPostValue:ownerName forKey:@"ownername"];
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    [request setPostValue:jsondata forKey:@"selContacts"];
    request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(inviteFriendsAsyncFail:)];
    [request setDidFinishSelector:@selector(inviteFriendsAsyncSuccess:)];
	[request startSynchronous];

}

- (void)inviteFriendsAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
	responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    NSError *parseError = nil;
    XMLReaderInviteFriends *streamingParser = [[XMLReaderInviteFriends alloc] init];
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}


- (void)inviteFriendsAsyncFail:(ASIFormDataRequest *)request
{
    [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Failed to sent request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

-(void)getBillingInfo
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlReteriveBillingInfo];
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    
    
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    [request setPostValue:@"1" forKey:@"BillingInfo"];
    request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getBillingInfoAsyncFail:)];
    [request setDidFinishSelector:@selector(getBillingInfosAsyncSuccess:)];
	[request startSynchronous];
    
}

- (void)getBillingInfosAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"Reponse string is %@",responseString);
	responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    NSError *parseError = nil;
    XMLReaderClientInfo *streamingParser = [[XMLReaderClientInfo alloc] init];
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}


- (void)getBillingInfoAsyncFail:(ASIFormDataRequest *)request
{
    [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Failed to sent request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

-(void)saveBillingInfo:(ClientInfo *)ci isCcNo:(BOOL)isCcNo
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlSaveBillingInfo];
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    
    
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    
    [request setPostValue:ci.clientName forKey:@"ClientName"];
    [request setPostValue:ci.contactName forKey:@"ContactName"];
    [request setPostValue:ci.address1 forKey:@"Address1"];
    [request setPostValue:ci.address2 forKey:@"Address2"];
    [request setPostValue:ci.city forKey:@"City"];
    [request setPostValue:ci.province forKey:@"Province"];
    [request setPostValue:ci.postalCode forKey:@"PostalCode"];
    [request setPostValue:ci.country forKey:@"Country"];
    
    [request setPostValue:ci.tellNo forKey:@"TelNo"];
    [request setPostValue:ci.faxNo forKey:@"FaxNo"];
    [request setPostValue:ci.email forKey:@"Email"];
    [request setPostValue:ci.timezoneId forKey:@"TimezoneId"];
    [request setPostValue:isCcNo?ci.ccNumber:@"" forKey:@"CC_No"];
    [request setPostValue:ci.ccExp forKey:@"CC_Exp"];
    [request setPostValue:ci.ccName forKey:@"CC_Name"];
    [request setPostValue:ci.ccCvv forKey:@"CC_CVV"];
    
    [request setPostValue:ci.bAddress1 forKey:@"B_Address1"];
    [request setPostValue:ci.bAddress2 forKey:@"B_Address2"];
    [request setPostValue:ci.bCity forKey:@"B_City"];
    [request setPostValue:ci.bPostalCode forKey:@"B_PostalCode"];
    [request setPostValue:ci.bProvince forKey:@"B_Province"];
    [request setPostValue:ci.bCountry forKey:@"B_Country"];
    
    request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(saveBillingInfoAsyncFail:)];
    [request setDidFinishSelector:@selector(saveBillingInfosAsyncSuccess:)];
	[request startSynchronous];
}

-(void)saveBillingInfosAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"Reponse string is %@",responseString);
	responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    NSError *parseError = nil;
    XMLReaderBillingInfoSave *streamingParser = [[XMLReaderBillingInfoSave alloc] init];
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

-(void)saveBillingInfoAsyncFail:(ASIFormDataRequest *)request
{
    [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Failed to sent request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

-(void)chargeAccount:(NSString *)amount
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlChargeAccount];
    [request setPostValue:[StaticData APIUSR] forKey:@"APIusr"];
	[request setPostValue:[StaticData APIPWD] forKey:@"APIpwd"];
    
    
    [request setPostValue:[GlobalData getApp_Name] forKey:@"AppName"];
    [request setPostValue:[GlobalData getApp_Version] forKey:@"AppVer"];
    [request setPostValue:[GlobalData getApp_Platform] forKey:@"AppPlatform"];
    ////
    [request setPostValue:[GlobalData ApiKey] forKey:@"Key"];
    [request setPostValue:[GlobalData ClientID] forKey:@"CLID"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"LineNo"];
    [request setPostValue:[GlobalData GetCountryName] forKey:@"ccode"];
    [request setPostValue:[GlobalData GetRegisterPhoneno] forKey:@"TelNo"];
    [request setPostValue:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Lang"];
    [request setPostValue:amount forKey:@"Amount"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userid"] forKey:@"LoginUsr"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] forKey:@"NO"];
    request.timeOutSeconds=9999999999;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(chargeAccountAsyncFail:)];
    [request setDidFinishSelector:@selector(chargeAccountAsyncSuccess:)];
	[request startSynchronous];
}

-(void)chargeAccountAsyncSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"Reponse string is %@",responseString);
	responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    NSError *parseError = nil;
    XMLReaderChargeAccount *streamingParser = [[XMLReaderChargeAccount alloc] init];
    if(![streamingParser parseXMLFileWithString:responseString parseError:&parseError])
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Data reteriving failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
}

-(void)chargeAccountAsyncFail:(ASIFormDataRequest *)request
{
    [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Failed to sent request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

@end
