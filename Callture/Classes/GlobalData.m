//
//  GlobalData.m
//  Callture
//
//  Created by Manish on 16/12/11.
//  Copyright (c) 2011 Aryavrat Infotech Pvt. All rights reserved.
//
#import <sys/utsname.h>
#import "GlobalData.h"
#import "RESTInteraction.h"
#import "LineListData.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
static NSString *ownername = nil;
static GlobalData *globalData = nil;
static NSMutableArray *callOptions = nil;
static NSMutableArray *callOptionPriorityList = nil;
static NSMutableArray *shareOptions = nil;
static NSMutableArray *callerIds = nil;
static NSString *clientID = nil;
static NSString *apikey = nil;
static NSString *clientName = nil;
static NSString *userName = nil;
static NSMutableArray *callBackLineList = nil;
static NSString *callThruAccessNo = nil;
static NSString *callBackAccessNo = nil;
static NSString *lastCDRD = nil;
static NSInteger counter = 0;
static NSMutableArray *countryList;
static Country *selectedCountry;
static Country *countryForPhone;
static AppInfo *appInfo = nil;
static NSString *sipServer;
static NSString *sipUserName;
static NSString *sipPassword;
static NSString *devicetoken=@"";
//added by par
static NSString *phoneNumber;
static BOOL isCallTypeSaved = NO;
@implementation GlobalData
+(id)GlobalManager
{
    @synchronized(self) {
        if (globalData == nil)
        {
            globalData = [[self alloc] init];
        }
    }
    return globalData;
}

+(BOOL)IsCallTypeSaved
{
    return isCallTypeSaved;
}

+(void)SetIsCallTypeSaved:(BOOL)iscalltypesaved
{
    isCallTypeSaved = iscalltypesaved;
}

+(NSString *)DiviceToken
{
    return devicetoken;
}
+(void)SetDiviceToken:(NSString *)token
{
    devicetoken = token;
}

+(NSInteger)GetCounter
{
    counter++;
    return counter;
}

+(NSString *)GetLastCDRD
{
    return lastCDRD;
}

+(void)SetLastCDRD:(NSString *)lastcdrd
{
    lastCDRD = lastcdrd;
}

+(NSMutableArray *)getCountryList
{
    return countryList;
}

+(void)setCountryList:(NSMutableArray *)arr
{
    countryList = [arr mutableCopy];
}

+(Country *)getSelectedCountry
{
    return selectedCountry;
}
+(void)setSelectedCountry:(Country *)country
{
    selectedCountry = country;
}

+(Country *)getCountryForPhone
{
    return countryForPhone;
}
+(void)setCountryForPhone:(Country *)country
{
    countryForPhone = country;
}

+(void)setAccessNumber:(NSString *)callThruAccNo :(NSString *)callBackAccNo
{
    callBackAccessNo = [NSString stringWithString:callBackAccNo];
    callThruAccessNo = [NSString stringWithString:callThruAccNo];
}


+(NSMutableArray*)sortArray:(NSMutableArray*)arrayIn withKey:(NSString*)key
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                         initWithKey:key ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSMutableArray *sortedArray = [[arrayIn sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    return sortedArray;
}

+(id)GetCallBackLineList
{
    return callBackLineList;
}

+(void)SetCallBackLineList:(NSMutableArray *)arr
{
    callBackLineList = arr;
}

+(id)GetCallerIds
{
    return callerIds;
}

+(void)SetCallerIds:(NSMutableArray *)arr
{
    callerIds = arr;
}

+(id)ClientID
{
    if(clientID==nil)
    {
        clientID = @"0";
    }
    return clientID;
}

+(void)SetClientID:(NSString *)clientid
{
    clientID = clientid;
}

+(id)ApiKey
{
    if (apikey==nil) {
        apikey = @"";
    }
    return apikey;
}
+(void)SetApiKey:(NSString *)apiKey
{
    apikey = apiKey;
}

+(id)ClientName
{
    if(clientName==nil)
    {
        clientName = @"0";
    }
    return clientName;
}

+(void)SetClientName:(NSString *)clientname
{
    clientName = clientname;
}

+(id)UserName
{
    if(userName==nil)
    {
        userName = @"0";
    }
    return userName;
}

+(void)SetUserName:(NSString *)username
{
    userName = username;
}

+(id)GetShareOption
{
    if(shareOptions==nil)
    {
        shareOptions = [[NSMutableArray alloc]initWithCapacity:2];
        [shareOptions addObject:LIKE_US_ON_FACEBOOK];
        [shareOptions addObject:LIKE_US_ON_TWITTER];
    }
    return shareOptions;
}

+(id)GetCallOptions
{
    if(callOptions==nil)
    {
        if ([[[UIDevice currentDevice] model] rangeOfString:@"Phone"].location != NSNotFound &&
            [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location == NSNotFound )
        {
            callOptions = [[NSMutableArray alloc]initWithCapacity:3];
            [callOptions addObject:LOCAL_ACCESS];
            [callOptions addObject:CALL_BACK];
            [callOptions addObject:SIP_VOIP];
        }else
        {
            callOptions = [[NSMutableArray alloc]initWithCapacity:1];
            [callOptions addObject:SIP_VOIP];
        }
        
    }
    return callOptions;
}

+(NSString *)GetCalloptionsWithPriority
{
    NSString *str = [[self GetCallOptionPriorityList] componentsJoinedByString:@","];
    return str;
}

+(id)GetCallOptionPriorityList
{
    if(callOptionPriorityList==nil)
    {
        if ([[[UIDevice currentDevice] model] rangeOfString:@"Phone"].location != NSNotFound &&
            [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location == NSNotFound )
        {
            callOptionPriorityList = [[NSMutableArray alloc]initWithCapacity:4];
            [callOptionPriorityList addObject:LOCAL_ACCESS];
            [callOptionPriorityList addObject:CALL_BACK];
            [callOptionPriorityList addObject:SIP_VOIP];
        }else
        {
            callOptionPriorityList = [[NSMutableArray alloc]initWithCapacity:1];
            [callOptionPriorityList addObject:SIP_VOIP];
        }
        
    }
    return callOptionPriorityList;
}
+(void)SetCallOptionPriorityList:(NSMutableArray *)arr
{
    callOptionPriorityList = arr;
}

+(NSString *)GetCountryName
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
   // NSString *country = [locale displayNameForKey: NSLocaleCountryCode value: countryCode];
    return countryCode;
}

+(NSString *)GetOwnerName
{
    if (!ownername) {
        ownername = [UIDevice currentDevice].name;
    }
    return ownername;
}

+(void)SetOwnerName:(NSString *)ownerName
{
    ownername = ownerName;
}


+(NSString *)filterDialString:(NSString *)destNumber
{
    destNumber = [destNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    destNumber = [destNumber stringByReplacingOccurrencesOfString:@" " withString:@""]; 
    destNumber = [destNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    destNumber = [destNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    destNumber = [destNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return destNumber;
}

//added by par

+(void)SetRegisterPhoneNumber:(NSString *)contactno
{
    phoneNumber = contactno;
}

+(id)GetRegisterPhoneno
{
    if(phoneNumber==nil)
    {
        phoneNumber = @"0";
    }
    return phoneNumber;
}

 //vishnu
+(NSString*)getApp_Version{
    
    NSDictionary *dicInfoList = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [dicInfoList valueForKey:KEY_APP_VERSION];
    
    return appVersion;
}

+(NSString*)getApp_Name{
    
    NSDictionary *dicInfoList = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [dicInfoList valueForKey:KEY_APP_NAME];
    //appName = [appName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return appName;
}

+(NSString*)getDeviceOwner_Name
{
    NSString *deviceOwner = [[UIDevice currentDevice] name];
    return deviceOwner;
}

+(NSString*)getApp_Platform
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceName = [device model];
    NSString *platFormVersion = [NSString stringWithFormat:@"%@^%@^%@",deviceName,[self getModel],[[UIDevice currentDevice] systemVersion]];
    return platFormVersion;
}

+(NSString *)getModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    if ([sDeviceModel isEqual:@"i386"])      return @"Simulator";  //iPhone Simulator
    if ([sDeviceModel isEqual:@"iPhone1,1"]) return @"1G";   //iPhone 1G
    if ([sDeviceModel isEqual:@"iPhone1,2"]) return @"3G";   //iPhone 3G
    if ([sDeviceModel isEqual:@"iPhone2,1"]) return @"3GS";  //iPhone 3GS
    if ([sDeviceModel isEqual:@"iPhone3,1"]) return @"4 AT&T";  //iPhone 4 - AT&T
    if ([sDeviceModel isEqual:@"iPhone3,2"]) return @"4 Other";  //iPhone 4 - Other carrier
    if ([sDeviceModel isEqual:@"iPhone3,3"]) return @"4";    //iPhone 4 - Other carrier
    if ([sDeviceModel isEqual:@"iPhone4,1"]) return @"4S";   //iPhone 4S
    if ([sDeviceModel isEqual:@"iPhone5,1"]) return @"5";    //iPhone 5 (GSM)
    if ([sDeviceModel isEqual:@"iPod1,1"])   return @"1stGen"; //iPod Touch 1G
    if ([sDeviceModel isEqual:@"iPod2,1"])   return @"2ndGen"; //iPod Touch 2G
    if ([sDeviceModel isEqual:@"iPod3,1"])   return @"3rdGen"; //iPod Touch 3G
    if ([sDeviceModel isEqual:@"iPod4,1"])   return @"4thGen"; //iPod Touch 4G
    if ([sDeviceModel isEqual:@"iPad1,1"])   return @"WiFi";   //iPad Wifi
    if ([sDeviceModel isEqual:@"iPad1,2"])   return @"3G";     //iPad 3G
    if ([sDeviceModel isEqual:@"iPad2,1"])   return @"2";      //iPad 2 (WiFi)
    if ([sDeviceModel isEqual:@"iPad2,2"])   return @"2";      //iPad 2 (GSM)
    if ([sDeviceModel isEqual:@"iPad2,3"])   return @"2";      //iPad 2 (CDMA)
    
    NSString *aux = [[sDeviceModel componentsSeparatedByString:@","] objectAtIndex:0];
    
    //If a newer version exist
    if ([aux rangeOfString:@"iPhone"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] intValue];
        if (version == 3) return @"4";
            if (version >= 4) return @"4s";
        
    }
    if ([aux rangeOfString:@"iPod"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPod" withString:@""] intValue];
        if (version >=4) return @"4thGen";
    }
    if ([aux rangeOfString:@"iPad"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPad" withString:@""] intValue];
        if (version ==1) return @"3G";
        if (version >=2) return @"2";
    }
    //If none was found, send the original string
    return sDeviceModel;
}
/////////

+(AppInfo *)getAppInfo
{
    if (!appInfo) {
        appInfo = [[AppInfo alloc]init];
    }
    return appInfo;
}
+(void)setAppInfo:(AppInfo *)appinfo
{
    appInfo = appinfo;
}

+(NSString *)SipServer
{
    return sipServer;
}
+(NSString *)SipUserName
{
    return sipUserName;
}
+(NSString *)SipPassword
{
    return sipPassword;
}

+(void)setSipServer:(NSString *)server
{
    sipServer = server;
}

+(void)setSipUserName:(NSString *)username
{
    sipUserName = username;
}

+(void)setSipPassword:(NSString *)password
{
    sipPassword = password;
}

+(BOOL)isNetworkAvailable
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        return NO;
    } else {
        BOOL connectedToInternet;
        NSURL *url = [[NSURL alloc] initWithString:@"http://www.google.com"];
        NSURLRequest *someRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:
                                     NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:8.0];
        connectedToInternet = NO;
        if ([NSURLConnection sendSynchronousRequest:someRequest returningResponse:nil error:nil]) { //check if it connects without an error
            
            connectedToInternet = YES; //if so, set connectedToInternet to YES
            
        }
        return connectedToInternet;
    }
}

+(BOOL)isReachableViaWiFi
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    return [reach isReachableViaWiFi];
}

+(void)downloadAppImages:(NSString *)path
{
    
}

@end
