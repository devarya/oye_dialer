//
//  callLogonViewController.h
//  Callture
//
//  Created by Manish on 07/12/11.
//  Copyright (c) 2011 Aryavrat Infotech Pvt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInfo.h"
#import "CallSetUp.h"
#import "AccessNumbers.h"
#import <CoreLocation/CoreLocation.h>
#import "addProfileViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PhoneCallDelegate.h"
#import "ContactsViewController.h"

@class callLogonViewController;
@protocol callLogonViewControllerDelegate <NSObject>
-(void)ShowNativeContacts:(NSString *)onPage;
@end
@interface callLogonViewController : UIViewController<UITextFieldDelegate,optionsDelegate,UITabBarControllerDelegate,ABPeoplePickerNavigationControllerDelegate,PhoneCallDelegate,MBProgressHUDDelegate>
{
    IBOutlet UIView *addDefaultProfileView;
    IBOutlet UIView *containerView;
    IBOutlet UITextField *txtMyNo;
    UIView *loader;
    UIButton *newbtnBg;
    
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnCreate;
    IBOutlet UIScrollView *scrollview;
    /*
     Added By Pardeep Singal
     Dated: 26 July
     */
    
    IBOutlet UITextField *txtPhoneNumber;
    IBOutlet UITextField *txtPromoCode;
    
    NSString *vphoneNumber;
    NSString *vuserId;
    NSString *vpassword;
    
    NSString *huserId;
    NSString *hpassword;
    
    
    CallSetUp *li;
    
    NSUserDefaults *userLoginpref;
    
    AccessNumbers *accessnumObj;
    UIView *tblfooterview;
    
    //CLLocationManager *locationManager;
    NSString *dialStr;
    
    IBOutlet UIView *loginView;
    
    
    NSInteger currentState;
    NSInteger countForTextToPasscode;
    
    NSString *apiCallFor;
    
//    IBOutlet UILabel *lblCopyright;
    
    addProfileViewController *apvc;
    
    UIView *splashView;
    
    BOOL isViewLoaded;
    BOOL keyboardVisible;
    BOOL isPinReceived;
    CGPoint offset;
	UITextField *activeField;
    BOOL isSipConnected;
    
    ////// Outlets for languages /////////
    IBOutlet UILabel *lbldGetPasscode;
    //IBOutlet UILabel *lblSentInText;
    IBOutlet UILabel *lblNewClient;
    IBOutlet UILabel *lblPhoneNumber;
    IBOutlet UILabel *lblPromoCode;
    IBOutlet UILabel *lblPinCode;
    IBOutlet UILabel *lblEnter10DigitNo;
    IBOutlet UITextField *txtPinCode;
    IBOutlet UIButton *btnTextMyPasscode;
    IBOutlet UIButton *btnActivate;
    IBOutlet UILabel *lblCopyright;
    
    IBOutlet UIImageView *imgLogo;
    IBOutlet UILabel *lblAppName;
    
    IBOutlet UILabel *lblAppVersion;
    
    MBProgressHUD *HUD;
}

@property(nonatomic,assign) id <callLogonViewControllerDelegate> delegate;
@property (retain, nonatomic) UITabBarController *tabBarController;

@property (retain, nonatomic) UISwitch *switchForSave;
@property (retain, nonatomic) UITextField *txtUserId;
@property (retain, nonatomic) UITextField *txtPaddword;
@property (retain, nonatomic) IBOutlet UILabel *lblSite;

@property(retain,nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property(retain,nonatomic) IBOutlet UITextField *txtPromoCode;
@property(retain,nonatomic) IBOutlet UITextField *txtPinCode;

@property(retain,nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property(retain,nonatomic) IBOutlet UILabel *lblPromoCode;
@property(retain,nonatomic) IBOutlet UILabel *lblPinCode;

@property (retain, nonatomic) IBOutlet NSUserDefaults *userLoginpref;


@property(retain,nonatomic) IBOutlet NSString *vphoneNumber;
@property(retain,nonatomic) IBOutlet NSString *vuserId;
@property(retain,nonatomic) IBOutlet NSString *vpassword;

@property(retain,nonatomic) IBOutlet NSString *huserId;
@property(retain,nonatomic) IBOutlet NSString *hpassword;

@property(retain,atomic) UIView *tblfooterview;
@property(retain,atomic) UIView *loader;

+ (id)logOnManager;
-(IBAction)clickOnActivate:(UIButton *)sender;
-(IBAction)textFieldDoneEditing:(id)sender;
-(IBAction)didEndOnExit:(id)sender;
-(IBAction)phoneNoChanged:(id)sender;
-(IBAction)textMyPasscode:(id)sender;
-(void)gotoCallList;
-(void)getResultOfLogin:(LoginInfo *)li;
-(IBAction)testEvent:(UIButton *)sender;
-(void)continueAfterSetProfile;
-(void)getResultOfActivate:(CallSetUp *)callobj callfor:(NSString *)callFor;
-(void)sendRequestForLoginData:(NSString *)userid :(NSString *)pwd;
-(void)updateCallBackStatus:(NSString *)msg;
-(IBAction)testmymethod:(id)sender;
-(void)gotoAddressBook:(NSString *)onPage;
-(void)setAppData;
//vishnu
-(void)enableSip:(NSNotification *)notification;
@end
