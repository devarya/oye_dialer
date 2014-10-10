/*
 *  Constants.h
 *  CollegeSuperFans
 *
 *  Created by 360mind on 12/3/09.
 *  Copyright Smartphones Technologies, Inc 2009. All rights reserved.
 *
 */
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)

#define NOTIFICATION_COUNTRYLIST_UPDATED @"NotificationCountryListUpdated"
#define NOTIFICATION_COUNTRYLIST_FAILED @"NotificationCountryListFailed"

#define NOTIFICATION_CONTACT_SELECTED_ON_RATES @"NotificationContactSelectedOnRates"
#define NOTIFICATION_CONTACT_SELECTED_ON_RATES_FAILED @"NotificationContactSelectedOnRatesFailed"

#define NOTIFICATION_CONTACT_SELECTED_ON_TOPUP @"NotificationContactSelectedOnTopup"
#define NOTIFICATION_CONTACT_SELECTED_ON_TOPUP_FAILED @"NotificationContactSelectedOnTopupFailed"

#define NOTIFICATION_CONTACT_SELECTED_ON_TOPUP_WEB @"NotificationContactSelectedOnTopupWeb"
#define NOTIFICATION_CONTACT_SELECTED_ON_TOPUP_WEB_FAILED @"NotificationContactSelectedOnTopupWebFailed"

#define NOTIFICATION_CALL_LOG_DATA_LOADED @"callLogDataLoaded"
#define NOTIFICATION_CALL_LOG_DATA_FAILED @"callLogDataFailed"

#define NOTIFICATION_AREALIST_UPDATED @"NotificationAreaListUpdated"
#define NOTIFICATION_AREALIST_FAILED @"NotificationAreaListFailed"

#define NOTIFICATION_RATES_FOR_PHONE @"NotificationRatesForPhone"
#define NOTIFICATION_RATES_FOR_PHONE_FAILED @"NotificationRatesForPhoneFailed"

#define NOTIFICATION_OPERATORLIST_UPDATED @"NotificationOperatorListUpdated"
#define NOTIFICATION_OPERATORLIST_FAILED @"NotificationOperatorListFailed"

#define NOTIFICATION_CLIENTINFO_SUCCESS @"NotificationClientInfoSuccess"
#define NOTIFICATION_CLIENTINFO_FAILED @"NotificationClientInfoFailed"

#define NOTIFICATION_SAVE_BILLING_INFO_SUCCESS @"NotificationSaveBillingInfoSuccess"
#define NOTIFICATION_SAVE_BILLING_INFO_FAILED @"NotificationSaveBillingInfoFailed"

#define NOTIFICATION_ACCOUNT_CHARGED_SUCCESS @"NotificationAccountChargedSuccess"
#define NOTIFICATION_ACCOUNT_CHARGED_FAILED @"NotificationAccountChargedFailed"

#define NOTIFICATION_INVITE_FRIENDS_SUCCESS @"NotificationInviteFriendsSuccess"
#define NOTIFICATION_INVITE_FRIENDS_FAILED @"NotificationInviteFriendsFailed"

#define NOTIFICATION_MOBILETOPUPLIST_UPDATED @"NotificationMobileTopupListUpdated"
#define NOTIFICATION_MOBILETOPUPLIST_FAILED @"NotificationMobileTopupListFailed"

#define NOTIFICATION_TOPUP_CHARGE_COMPLETED @"NotificationTopupChargeCompleted"
#define NOTIFICATION_TOPUP_CHARGE_FAILED @"NotificationTopupChargeFailed"

#define NOTIFICATION_CONFIRMATION_TOPUP_CHARGE_COMPLETED @"NotificationConfirmationTopupChargeCompleted"
#define NOTIFICATION_CONFIRMATION_TOPUP_CHARGE_FAILED @"NotificationConfirmationTopupChargeFailed"

#define NOTIFICATION_APP_INFO @"NotificationAPpInfo"
#define NOTIFICATION_APP_INFO_FAILED @"NotificationAPpInfoFailed"

#define NOTIFICATION_GET_PIN @"NotificationGetPin"
#define NOTIFICATION_GET_PIN_FAILED @"NotificationGetPinFailed"

#define NOTIFICATION_ENABLE_SIP @"NotificationEnableSip"
#define NOTIFICATION_ENABLE_SIP_FAILED @"NotificationEnableSipFailed"

#define NOTIFICATION_CALLBACKLINELIST_UPDATED @"notificationCallbackLinelistUpdated"
#define NOTIFICATION_CALLBACKLINELIST_FAILED @"notificationCallbackLinelistFailed"

#define NOTIFICATION_SIP_CONNECTED @"notificationSipConnected"
#define NOTIFICATION_SIP_CONNECT_FAILED @"notificationSipConnectFailed"

#define NOTIFICATION_LINE_INFO_SUCCESS @"notificationLineInfoSuccess"
#define NOTIFICATION_LINE_INFO_FAIL @"notificationLineInfoFail"

#define NOTIFICATION_LOGOUT @"notificationLogout"

#define TITLE_RECENT_CALLS_LOG @"Recent Calls"

#define OPTIONS @"Options"
#define ABOUT_OYE @"About Oye"
//#define MOBILE_RECHARGE @"Mobile Recharge"
//#define TOPUP_CONFIRMATION_TITLE @"Topup Confirmation"
//#define TOPUP @"Topups"
#define TOPUPWEB @"Topupsweb"
//#define MORE_SETTINGS @"More Options"
//#define ABOUT @"About"
//#define EARN_FREE_CREDIT @"Follow Us"
//#define GET_RATES @"Get Rates"
//#define CALL_OPTION @"Call Options"
//#define CALLERID "Caller ID"
#define BILLING_ACCOUNT @"Billing Account"
#define SECTION_OPTION @"OPTION"
#define SECTION_COUNTRY @"COUNTRY"
#define SECTION_AREA @"AREA"

#define ACTIVATION @"Activation"
#define LOGIN @"Login"
#define TEXTTOPIN @"TextToPin"

#define TOPUPINFO @"topupinfo"

#define CALL_BACK @"Callback"
#define LOCAL_ACCESS @"Local Access"
#define SIP_VOIP @"Internet"
#define NONE @"None"

#define LIKE_US_ON_FACEBOOK @"Like us on Facebook"
#define LIKE_US_ON_TWITTER @"Follow us on Twitter"

#define SIP_USERID @"UserId"
#define SIP_PWD @"Pwd"
#define SIP_PROXY @"Proxy"
#define SIP_REGISTRATIONTIMEOUT @"RegisterationTimeout"


#define OPERATOR @"OPERATOR"
#define AMOUNT @"AMOUNT"
#define LOCATION_COUNTRY @"Canada"
#define LOCAL_AREA @"IB-CA-GTA"
#define UNKNOWN_INT_VALUE -1


#define CALLBACK_NUMBER @"CALLBACKNUMBER"
#define CALLER_ID @"CALLERID"
#define CALLOPTION1 @"CALLOPTION1"
#define LINE_NO @"LINE_NO"
#define PUBLIC_PIN @"PUBLIC_PIN"
#define DIAL_STRING @"DIAL_STRING"
#define USE_WIFI_IFAVAILABLE @"usewifiifavailable"
#define ANNOUNCE_MINUTES @"announceminutes"
#define ANNOUNCE_BALANCE @"announcebalance"

#define LAST_DIALED_NUMBER @"lastdialednumber"

#define IMAGE_UPDATE_DATE @"imageupdatedate"

#define REMOTE_NOTIFICATION_CALL @"call"
#define REMOTE_NOTIFICATION_MESSAGE @"messages"
#define REMOTE_NOTIFICATION_CALLEND @"callend"
#define REMOTE_NOTIFICATION_DEFAULT @"default"
#define REMOTE_NOTIFICATION_TOP_UP @"topup"
#define REMOTE_NOTIFICATION_ADD_FUNDS @"addfunds"
#define REMOTE_NOTIFICATION_CALL_OPTION @"calloptions"
#define REMOTE_NOTIFICATION_CALL_RATES @"callrates"
#define REMOTE_NOTIFICATION_INVITE_FRIENDS @"invitefriends"
#define REMOTE_NOTIFICATION_MORE_OPTIONS @"moreoptions"



