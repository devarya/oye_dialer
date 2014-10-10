//
//  GlobalData.h
//  Callture
//
//  Created by Manish on 16/12/11.
//  Copyright (c) 2011 Aryavrat Infotech Pvt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "Country.h"
#import "AppInfo.h"
//vishnu
#define KEY_APP_VERSION @"CFBundleVersion"
#define KEY_APP_NAME @"CFBundleName"
////////
//#define SERVER @"64.34.222.236"
//#define USER_NAME @"1030001"
//#define PASSWORD @"1068483618"

BOOL isAddFundScreen;
BOOL isCallOptionScreen;
BOOL isMessageScreen;
BOOL isCallRatesScreen;
BOOL isInviteFriendsScreen;
BOOL isMoreOptionsScreen;
@interface GlobalData : NSObject

+(NSInteger)GetCounter;
+(id)GlobalManager;
//+(id)GetCallOptions;
+(NSString *)GetCalloptionsWithPriority;
+(id)GetCallOptionPriorityList;
+(void)SetCallOptionPriorityList:(NSMutableArray *)arr;
+(id)GetShareOption;
+(id)GetCallerIds;
+(void)SetCallerIds:(NSMutableArray *)arr;
+(id)ClientID;
+(void)SetClientID:(NSString *)clientid;
+(id)ApiKey;
+(void)SetApiKey:(NSString *)apiKey;
+(id)GetCallBackLineList;
+(void)SetCallBackLineList:(NSMutableArray *)arr;
+(void)setAccessNumber:(NSString *)callThruAccNo :(NSString *)callBackAccNo;
+(NSInteger)GetCounter;
+(NSString *)GetLastCDRD;
+(void)SetLastCDRD:(NSString *)lastcdrd;
+(id)ClientName;
+(void)SetClientName:(NSString *)clientname;
+(NSMutableArray*)sortArray:(NSMutableArray*)arrayIn withKey:(NSString*)key;
+(NSString *)filterDialString:(NSString *)destNumber;
//added by par
+(void)SetRegisterPhoneNumber:(NSString *)contactno;
+(id)GetRegisterPhoneno;
+(NSString*)getApp_Version;
+(NSString*)getApp_Name;
+(NSString*)getApp_Platform;
+(NSString*)getDeviceOwner_Name;
+(NSMutableArray *)getCountryList;
+(void)setCountryList:(NSMutableArray *)arr;
+(Country *)getSelectedCountry;
+(void)setSelectedCountry:(Country *)country;
+(Country *)getCountryForPhone;
+(void)setCountryForPhone:(Country *)country;
+(AppInfo *)getAppInfo;
+(void)setAppInfo:(AppInfo *)appinfo;

+(id)UserName;
+(void)SetUserName:(NSString *)username;
+(BOOL)isNetworkAvailable;

+(NSString *)SipServer;
+(NSString *)SipUserName;
+(NSString *)SipPassword;
+(NSString *)DiviceToken;
+(void)SetDiviceToken:(NSString *)token;
+(BOOL)isReachableViaWiFi;
+(BOOL)IsCallTypeSaved;
+(void)SetIsCallTypeSaved:(BOOL)iscalltypesaved;
+(NSString *)GetCountryName;
+(NSString *)GetOwnerName;
+(void)SetOwnerName:(NSString *)ownerName;

+(void)downloadAppImages:(NSString *)path;
@end
