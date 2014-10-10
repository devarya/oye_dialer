//
//  callLogonViewController.m
//  Callture
//
//  Created by Manish on 07/12/11.
//  Copyright (c) 2011 Aryavrat Infotech Pvt. All rights reserved.
//


#import "callAppDelegate.h"
#import "RESTInteraction.h"
#import "callLogListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalData.h"
#import "preloader.h"
#import "LineListData.h"
#import "addProfileViewController.h"
#import "callDialerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ABContactsHelper.h"
#import "TopUpViewController.h"
#import "ReviewTableViewCell.h"
#import "Constants.h"
#import "callLogonViewController.h"
#import "SipManager.h"
#define SCROLLVIEW_CONTENT_HEIGHT 460
#define SCROLLVIEW_CONTENT_WIDTH  320

static callLogonViewController *loginManager = nil;
@implementation callLogonViewController
@synthesize tabBarController = _tabBarController;
@synthesize switchForSave,txtUserId,txtPaddword,lblSite,tblfooterview,loader,delegate,hpassword,huserId;

@synthesize txtPinCode,txtPhoneNumber,txtPromoCode;
@synthesize lblPinCode,lblPromoCode,lblPhoneNumber;
@synthesize vpassword,vuserId,vphoneNumber,userLoginpref;

+ (id)logOnManager {
    @synchronized(self) {
        if (loginManager == nil)
            loginManager = [[self alloc] init];
    }
    return loginManager;
}

-(IBAction)testEvent:(UIButton *)sender
{
    [[[UIAlertView alloc]initWithTitle:@"Test" message:@"Testing" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [lblAppName setTextColor:[GlobalData getAppInfo].colLoginText];
    [self.view setBackgroundColor:[GlobalData getAppInfo].colLoginBg];
    [imgLogo setImage:[GlobalData getAppInfo].imgLogo];
    lblCopyright.textColor = [GlobalData getAppInfo].colLoginText;
    lblAppVersion.textColor = [GlobalData getAppInfo].colLoginText;
    lblEnter10DigitNo.textColor = [GlobalData getAppInfo].dataViewTextColor;
    lblPromoCode.textColor = [GlobalData getAppInfo].colLoginText;
    lblPinCode.textColor = [GlobalData getAppInfo].colLoginText;
    lbldGetPasscode.textColor = [GlobalData getAppInfo].colLoginText;
    lblNewClient.textColor = [GlobalData getAppInfo].colLoginText;
    
    
    lblEnter10DigitNo.text = [GlobalData getAppInfo].enter10DigitMobileNo;
    lblPromoCode.text = [GlobalData getAppInfo].promoCode;
    txtPinCode.placeholder = [GlobalData getAppInfo].enterPasscode;
    lbldGetPasscode.text = [GlobalData getAppInfo].didntgetpasscode;
    lblNewClient.text = [GlobalData getAppInfo].clientWelcome;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableSip:) name:NOTIFICATION_ENABLE_SIP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sipEnableFailed:) name:NOTIFICATION_ENABLE_SIP_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appInfoLoaded:) name:NOTIFICATION_APP_INFO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appInfoLoadedFailed:) name:NOTIFICATION_APP_INFO_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgFromGetPin:) name:NOTIFICATION_GET_PIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgFromGetPinFailed:) name:NOTIFICATION_GET_PIN_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    txtPhoneNumber.inputAccessoryView = numberToolbar;
    txtPinCode.inputAccessoryView = numberToolbar;
    txtPromoCode.inputAccessoryView = numberToolbar;
    
    Reachability *internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    
    splashView = [[UIView alloc]initWithFrame:self.view.bounds];
    UIImageView *splashImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default.png"]];
    [splashView addSubview:splashImg];
    [self.view addSubview:splashView];
    
    if ([GlobalData isNetworkAvailable]) {
        if (![GlobalData getAppInfo]) {
            [self getAppInfo];
        }
    }else
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:[NSString stringWithFormat:@"Could not connect to internet, Internet connection is required for %@ to work properly. Please connect to the network and try again.", [GlobalData getApp_Name]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
    lblAppVersion.text = [NSString stringWithFormat:@"Version %@", [GlobalData getApp_Version]];
    
    //[delegate sip_Connect];
    [self setViewAfterGetAppData];
}

#pragma mark ALERTVIEW DELEGATE METHODS

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}

-(void)msgFromGetPin:(NSNotification *)notification
{
    isPinReceived = YES;
    [loader removeFromSuperview];
    if (notification.object) {
        NSString *msg = [NSString stringWithFormat:@"%@",notification.object];
        if (msg.length>0) {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        //[msg release];
    }
}

-(void)msgFromGetPinFailed:(NSNotification *)notification
{
    [loader removeFromSuperview];
}

-(void)doneWithNumberPad
{
    [self hideKeyBoard:nil];
}

-(void)sip_Connect
{
    //[delegate sip_Connect];
}

-(void)sip_Cleanup
{
    //[delegate sip_Cleanup];
}

-(BOOL)isNeedToConnectSip
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:USE_WIFI_IFAVAILABLE] isEqualToString:@"YES"])
    {
        return YES;
        //[delegate sip_Connect];
    }else
    {
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:CALLOPTION1] isEqualToString:SIP_VOIP])
        {
            return YES;
            //[delegate sip_Connect];
        }else
        {
            return NO;
            //[delegate sip_Cleanup];
        }
    }
}

-(void)enableSip:(NSNotification *)notification
{
    if (!isSipConnected && [self isNeedToConnectSip]) {
        [[SipManager voipManager] sip_Connect];
        isSipConnected = YES;
    }
}

-(void)sipEnableFailed:(NSNotification *)notification
{
    //[delegate sip_Cleanup];
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    if ([GlobalData isNetworkAvailable]) {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:CALLOPTION1] isEqualToString:SIP_VOIP]) {
            //[delegate sip_Connect];
        }
        if (![GlobalData getAppInfo]) {
            [self getAppInfo];
            
        }
        if (!isViewLoaded) {
            [self setViewAfterGetAppData];
        }
    }else{
        
        [[SipManager voipManager] sip_DisConnect];
    }
}

-(void)dialup:(NSString *)phoneNumber number:(BOOL)isNumber{
    
    [[SipManager voipManager] dialup:phoneNumber number:isNumber];
}

-(void)setViewAfterGetAppData
{
    isViewLoaded = YES;
    [self setAppData];
    loginManager = self;
    countForTextToPasscode = 0;
	vuserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
	vpassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
	vphoneNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"phonenumber"];
    
    if ([vuserId length] > 0  && [vpassword length] > 0 && [vphoneNumber length] > 0)
    {
        [GlobalData SetUserName:vuserId];
        txtPhoneNumber.text = vphoneNumber;
        txtPinCode.text = vpassword;
        [GlobalData SetRegisterPhoneNumber:vphoneNumber];
        if ([GlobalData isNetworkAvailable]) {
            [self showLoader];
            [[RESTInteraction restInteractionManager]getLoginData:vuserId :vpassword :YES];
        }
        
    }
    
    vuserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    if(vuserId.length > 1 )
    {
        
    }else{
        //[self addKeyPadObserver];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoweb:)];
        tapGesture.numberOfTapsRequired = 1;
        [lblSite addGestureRecognizer:tapGesture];
    }
    
    loginView.layer.cornerRadius = 10.0f;
    loginView.clipsToBounds = YES;
    loginView.center = self.view.center;
    loginView.layer.borderWidth = 1.0;
    loginView.layer.borderColor = [[GlobalData getAppInfo].dataViewDimTextColor CGColor];
    [loginView setBackgroundColor:[GlobalData getAppInfo].dataViewBgColor];
    btnActivate.layer.borderColor = [[UIColor colorWithRed:24.0/255.0 green:31.0/255.0 blue:60.0/255.0 alpha:1.0] CGColor];
    btnActivate.layer.borderWidth = 0.5;
    btnActivate.layer.cornerRadius = 10;
    btnActivate.clipsToBounds = YES;
    [btnActivate setBackgroundImage:[GlobalData getAppInfo].imgSendBtn forState:UIControlStateNormal];
    [btnActivate addTarget:self action:@selector(clickOnActivate:) forControlEvents:UIControlEventTouchUpInside];
    
    btnTextMyPasscode.layer.borderColor = [[UIColor colorWithRed:24.0/255.0 green:31.0/255.0 blue:60.0/255.0 alpha:1.0] CGColor];
    btnTextMyPasscode.layer.borderWidth = 0.5;
    btnTextMyPasscode.layer.cornerRadius = 10;
    btnTextMyPasscode.clipsToBounds = YES;
    [btnTextMyPasscode setBackgroundImage:[GlobalData getAppInfo].imgSendBtn forState:UIControlStateNormal];
    [self setLoginState:0];
    [splashView removeFromSuperview];
}

-(void)setAppData
{
    NSString *str = [GlobalData getAppInfo].copyright;
    str = [str stringByReplacingOccurrencesOfString:@"&copy;" withString:@"\u00A9"];
    lblCopyright.text = str;
    
    ///// Gaurav
    lblEnter10DigitNo.text = [GlobalData getAppInfo].enter10DigitMobileNo;
    lblPromoCode.text = [GlobalData getAppInfo].promoCode;
    txtPinCode.placeholder = [GlobalData getAppInfo].enterPasscode;
    lbldGetPasscode.text = [GlobalData getAppInfo].didntgetpasscode;
    lblNewClient.text = [GlobalData getAppInfo].clientWelcome;
}

-(void)setLoginState:(NSInteger)loginState
{
    currentState = loginState;
    switch (loginState) {
        case 0:
            txtPromoCode.text = @"";
            txtPinCode.text = @"";
            lblPinCode.hidden = YES;
            //lblSentInText.hidden = YES;
            lbldGetPasscode.hidden = YES;
            txtPinCode.hidden = YES;
            btnTextMyPasscode.hidden = YES;
            lblNewClient.hidden = YES;
            lblPromoCode.hidden = YES;
            txtPromoCode.hidden = YES;
            [loginView setFrame:CGRectMake(0, 0, 300, 122)];
            loginView.center = scrollview.center;
            [btnActivate setFrame:CGRectMake(44, 73, 212, 30)];
            [btnActivate setTitle:[GlobalData getAppInfo].activate forState:UIControlStateNormal];
            break;
        case 1:
            txtPromoCode.text = @"";
            txtPinCode.text = @"";
            lblPinCode.hidden = YES;
            //lblSentInText.hidden = YES;
            lbldGetPasscode.hidden = YES;
            txtPinCode.hidden = YES;
            btnTextMyPasscode.hidden = YES;
            
            lblNewClient.hidden = NO;
            lblPromoCode.hidden = NO;
            txtPromoCode.hidden = NO;
            [loginView setFrame:CGRectMake(0, 0, 300, 193)];
            loginView.center = scrollview.center;
            [btnActivate setFrame:CGRectMake(44, 154, 212, 30)];
            [btnActivate setTitle:@"Create >>" forState:UIControlStateNormal];
            break;
        case 2:
            txtPromoCode.text = @"";
            txtPinCode.text = @"";
            lblNewClient.hidden = YES;
            lblPromoCode.hidden = YES;
            lblPinCode.hidden = NO;
            //lblSentInText.hidden = NO;
            txtPinCode.hidden = NO;
            if (countForTextToPasscode<2) {
                btnTextMyPasscode.hidden = NO;
                lbldGetPasscode.hidden = NO;
                [btnActivate setFrame:CGRectMake(44, 137, 212, 30)];
               // [loginView setFrame:CGRectMake(0, 0, 300, 227)];
                [loginView setFrame:CGRectMake(11, 145, 300, 227)];
            }else
            {
                btnTextMyPasscode.hidden = YES;
                lbldGetPasscode.hidden = YES;
                [btnActivate setFrame:CGRectMake(44, 137, 212, 30)];
                //[loginView setFrame:CGRectMake(0, 0, 300, 180)];
                [loginView setFrame:CGRectMake(11, 145, 300, 180)];
            }
            
            [lblPinCode setFrame:CGRectMake(20, 72, 260, 21)];
            //[lblSentInText setFrame:CGRectMake(153, 72, 72, 21)];
            [txtPinCode setFrame:CGRectMake(44, 100, 212, 30)];
            [lbldGetPasscode setFrame:CGRectMake(22, 192, 136, 21)];
            [btnTextMyPasscode setFrame:CGRectMake(177, 192, 100, 22)];
            
            txtPromoCode.hidden = YES;
          //  loginView.center = scrollview.center;
            [btnActivate setTitle:[GlobalData getAppInfo].login forState:UIControlStateNormal];
            [btnTextMyPasscode setTitle:[GlobalData getAppInfo].callMe forState:UIControlStateNormal];
            
            lblPinCode.text = [GlobalData getAppInfo].passcodeSentInText;
            //lblSentInText.text = strCombinedFinal;
            
            break;
        case 3:
            txtPinCode.text = @"";
            lblNewClient.hidden = NO;
            lblPromoCode.hidden = NO;
            lblPinCode.hidden = NO;
            //lblSentInText.hidden = NO;
            txtPinCode.hidden = NO;
            if (countForTextToPasscode<2) {
                btnTextMyPasscode.hidden = NO;
                lbldGetPasscode.hidden = NO;
                [btnActivate setFrame:CGRectMake(44, 220, 212, 30)];
                [loginView setFrame:CGRectMake(0, 0, 300, 338)];
            }else
            {
                btnTextMyPasscode.hidden = YES;
                lbldGetPasscode.hidden = YES;
                [btnActivate setFrame:CGRectMake(44, 220, 212, 30)];
                [loginView setFrame:CGRectMake(0, 0, 300, 271)];
            }
            txtPromoCode.hidden = NO;
            
            [lblPinCode setFrame:CGRectMake(20, 154, 260, 21)];
            //[lblSentInText setFrame:CGRectMake(153, 154, 72, 21)];
            [txtPinCode setFrame:CGRectMake(44, 182, 212, 30)];
            [lbldGetPasscode setFrame:CGRectMake(22, 275, 136, 21)];
            [btnTextMyPasscode setFrame:CGRectMake(177, 275, 100, 22)];
            
            loginView.center = self.view.center;
            [btnActivate setTitle:[GlobalData getAppInfo].login forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}


#pragma mark IBACTION METHODS

-(IBAction)phoneNoChanged:(id)sender
{
    if (currentState!=0) {
        [self setLoginState:0];
    }
}

-(IBAction)textMyPasscode:(id)sender
{
    [self hideKeyBoard:nil];
    if ([GlobalData isNetworkAvailable]) {
        countForTextToPasscode++;
        if (countForTextToPasscode>=2) {
            [self setLoginState:2];
//            btnTextMyPasscode.hidden = YES;
//            lbldGetPasscode.hidden = YES;
        }
        [self showLoader];
        isPinReceived = NO;
        NSDictionary *dictArgs = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txtPhoneNumber.text,@"",@"", TEXTTOPIN, nil] forKeys:[NSArray arrayWithObjects:@"NUMBER",@"PROMOCODE",@"PASSCODE", @"CALLFOR", nil]];
        [self performSelectorInBackground:@selector(callRestForGetPin:) withObject:dictArgs];
        [self performSelector:@selector(removeloader) withObject:nil afterDelay:10.0];
    }else
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

-(IBAction)clickOnActivate:(UIButton *)sender
{
    [self hideKeyBoard:nil];
    if ([GlobalData isNetworkAvailable])
    {
        [self showLoader];
        NSString *contactNumber = txtPhoneNumber.text;
        if (![contactNumber length] > 0 ) {
            UIAlertView *errorMsg = [[UIAlertView alloc]initWithTitle:@"Warning" message:[GlobalData getAppInfo].pleaseEnterPhoneNumber delegate:nil cancelButtonTitle:@"Okay, thanks" otherButtonTitles:nil, nil];
            [errorMsg show];
            [loader removeFromSuperview];
            
        }else {
            if (currentState == 1) {
                if (txtPromoCode.text.length == 0) {
                    UIAlertView *errorMsg = [[UIAlertView alloc]initWithTitle:@"Warning" message:[GlobalData getAppInfo].pleaseEnterPasscode delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [errorMsg show];
                    [loader removeFromSuperview];
                }else
                {
                    NSDictionary *dictArgs = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txtPhoneNumber.text,txtPromoCode.text,txtPinCode.text, ACTIVATION, nil] forKeys:[NSArray arrayWithObjects:@"NUMBER",@"PROMOCODE",@"PASSCODE", @"CALLFOR", nil]];
                    [self performSelectorInBackground:@selector(callRestForCallSetup:) withObject:dictArgs];
                }
            }else if (currentState == 2) {
                if (txtPinCode.text.length == 0) {
                    UIAlertView *errorMsg = [[UIAlertView alloc]initWithTitle:@"Warning" message:[GlobalData getAppInfo].pleaseEnterPasscode delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [errorMsg show];
                    [loader removeFromSuperview];
                }
                else
                {
                    NSDictionary *dictArgs = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txtPhoneNumber.text,txtPromoCode.text,txtPinCode.text, LOGIN, nil] forKeys:[NSArray arrayWithObjects:@"NUMBER",@"PROMOCODE",@"PASSCODE", @"CALLFOR", nil]];
                    [self performSelectorInBackground:@selector(callRestForCallSetup:) withObject:dictArgs];
                }
            }else if (currentState == 3) {
                if (txtPromoCode.text.length == 0) {
                    UIAlertView *errorMsg = [[UIAlertView alloc]initWithTitle:@"Warning" message:[GlobalData getAppInfo].pleaseEnterPromocode delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [errorMsg show];
                    [loader removeFromSuperview];
                }else if (txtPinCode.text.length == 0) {
                    UIAlertView *errorMsg = [[UIAlertView alloc]initWithTitle:@"Warning" message:[GlobalData getAppInfo].pleaseEnterPasscode delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [errorMsg show];
                    [loader removeFromSuperview];
                }
                else
                {
                    NSDictionary *dictArgs = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txtPhoneNumber.text,txtPromoCode.text,txtPinCode.text, LOGIN, nil] forKeys:[NSArray arrayWithObjects:@"NUMBER",@"PROMOCODE",@"PASSCODE", @"CALLFOR", nil]];
                    [self performSelectorInBackground:@selector(callRestForCallSetup:) withObject:dictArgs];
                }
            }else
            {
                NSDictionary *dictArgs = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txtPhoneNumber.text,txtPromoCode.text,txtPinCode.text, ACTIVATION, nil] forKeys:[NSArray arrayWithObjects:@"NUMBER",@"PROMOCODE",@"PASSCODE", @"CALLFOR", nil]];
                [self performSelectorInBackground:@selector(callRestForCallSetup:) withObject:dictArgs];
            }
        }
    }else
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

-(IBAction)gotoweb:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.callture.com/line2"]];
}


#pragma mark OTHER METHODS
-(void)removeloader
{
    if (!isPinReceived) {
        [loader removeFromSuperview];
        [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Couldn't read server response, try again after 2 minutes" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

-(void)addKeyPadObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:) name: UIKeyboardDidShowNotification
	 object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


#pragma  mark TEXTFIELD DELEGATE METHODS
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


-(IBAction)keyboardWillShow:(id)sender
{
//    newbtnBg = [UIButton buttonWithType:UIButtonTypeCustom];
//    newbtnBg.frame = self.view.bounds;
//    [newbtnBg addTarget:self action:@selector(hideKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:newbtnBg];
}


-(IBAction)hideKeyBoard:(id)sender
{
    [txtPromoCode resignFirstResponder];
    [txtPinCode resignFirstResponder];
    [txtPhoneNumber resignFirstResponder];
}

-(void)appInfoLoaded:(NSNotification *)notification
{
    [self.view setBackgroundColor:[GlobalData getAppInfo].pageBgColor];
}

-(void)appInfoLoadedFailed:(NSNotification *)notification
{
    [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Failed to get App Info" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(IBAction)textFieldDoneEditing:(id)sender
{
	[sender resignFirstResponder];
}

-(void)logout
{
    //[delegate sip_DisConnect];
    isSipConnected = NO;
    [GlobalData SetIsCallTypeSaved:NO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SIP_USERID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SIP_PWD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SIP_PROXY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SIP_REGISTRATIONTIMEOUT];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CALLBACK_NUMBER];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CALLER_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CALLOPTION1];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LINE_NO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PUBLIC_PIN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DIAL_STRING];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LAST_DIALED_NUMBER];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUT object:nil];
    //[[SipManager voipManager] sip_Cleanup];
    [[RESTInteraction restInteractionManager] setCanAccessMore:YES];
    [[RESTInteraction restInteractionManager] setLastSpeedDialNumber:@""];
    countForTextToPasscode = 0;
    //[self addKeyPadObserver];
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:IMAGE_UPDATE_DATE];
    [self resetDefaults];
    if (str) {
        [[NSUserDefaults standardUserDefaults] setValue:str forKey:IMAGE_UPDATE_DATE];
        [[NSUserDefaults standardUserDefaults]  synchronize];
    }
    [self.tabBarController.view removeFromSuperview];
    [txtPhoneNumber setText:@""];
    [txtPinCode setText:@""];
    [txtPromoCode setText:@""];
    [self setLoginState:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgFromGetPin:) name:NOTIFICATION_GET_PIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgFromGetPinFailed:) name:NOTIFICATION_GET_PIN_FAILED object:nil];
    [self getAppInfo];
}

- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    
    NSString *value;
    NSString *key = @"WebKitLocalStorageDatabasePathPreferenceKey";
    value = [dict objectForKey: key];
    
    
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
}

-(void)gotoNativeContacts:(NSString *)onPage
{
    [delegate ShowNativeContacts:onPage];
}

-(void)gotoAddressBook:(NSString *)onPage
{
    [delegate ShowNativeContacts:onPage];
}

- (void)viewWillAppear:(BOOL)animated
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


-(void)showLoader
{
    loader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [loader setBackgroundColor:[UIColor blackColor]];
    [loader setAlpha:0.5];
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.frame = CGRectMake(135, 205, 50, 50);
    [aiv startAnimating];
    [loader addSubview:aiv];
    [self.view addSubview:loader];
    [self.view bringSubviewToFront:loader];
}

-(void)callRestForCallSetup:(NSDictionary *)args
{
    NSString *number = [args objectForKey:@"NUMBER"];
    NSString *promocode = [args objectForKey:@"PROMOCODE"];
    NSString *passcode = [args objectForKey:@"PASSCODE"];
    NSString *callfor = [args objectForKey:@"CALLFOR"];
    [[RESTInteraction restInteractionManager]callSetUp:number :promocode :passcode callFor:callfor];
}

-(void)callRestForGetPin:(NSDictionary *)args
{
    NSString *number = [args objectForKey:@"NUMBER"];
    NSString *promocode = [args objectForKey:@"PROMOCODE"];
    NSString *passcode = [args objectForKey:@"PASSCODE"];
    NSString *callfor = [args objectForKey:@"CALLFOR"];
    [[RESTInteraction restInteractionManager]callForPin:number :promocode :passcode callFor:callfor];
}

-(void)getResultOfLogin:(LoginInfo *)loginfo
{
	if (loginfo==nil) {
        [loader removeFromSuperview];
		[[[UIAlertView alloc]initWithTitle:nil message:@"Login Failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
	} else {
        if(loginfo.ClientId!=0)
        {
            [GlobalData SetClientID:loginfo.ClientId];
            [GlobalData SetClientName:loginfo.ClientName];
            [GlobalData SetApiKey:loginfo.UserKey];
            
            [[RESTInteraction restInteractionManager]getCallBackLinesList:[GlobalData ClientID]]; //billing a/c number
            [self continueAfterSetProfile];
            NSString *strCallOption1 = [[NSUserDefaults standardUserDefaults]valueForKey:CALLOPTION1];
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:USE_WIFI_IFAVAILABLE] isEqualToString:@"YES"]) {
                [[RESTInteraction restInteractionManager] EnableSipCalling:YES];
                //[delegate sip_Connect];
            }else
            {
                if ([strCallOption1 isEqualToString:SIP_VOIP]) {
                    [[RESTInteraction restInteractionManager] EnableSipCalling:YES];
                    //[delegate sip_Connect];
                }else
                {
                    [[RESTInteraction restInteractionManager] EnableSipCalling:NO];
                    //[delegate sip_Cleanup];
                }
            }
            vuserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
            
            if([vuserId isEqualToString:@""] || vuserId.length == 0)
            {
                userLoginpref   = [NSUserDefaults standardUserDefaults];
                [userLoginpref setObject:huserId forKey:@"userid"];
                [userLoginpref setObject:hpassword forKey:@"password"];
                [userLoginpref setObject:txtPhoneNumber.text forKey:@"phonenumber"];
                [userLoginpref synchronize];
            }
            [self gotoCallList];
            [loader removeFromSuperview];
        } else
        {
            [loader removeFromSuperview];
            if([loginfo.ResultStr length]>0)
            {
                [[[UIAlertView alloc]initWithTitle:nil message:loginfo.ResultStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
            }else
            {
                [[[UIAlertView alloc]initWithTitle:nil message:@"Login Failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
            }
            
        }
	}
}

-(IBAction)didEndOnExit:(id)sender
{
    [sender resignFirstResponder];
}

-(IBAction)testmymethod:(id)sender
{
    
    
}

-(void)continueAfterSetProfile
{
    LineListData *lld = [[GlobalData GetCallBackLineList]objectAtIndex:0];
    if (![self isValueExistForKey:CALLBACK_NUMBER]) {
        [[NSUserDefaults standardUserDefaults] setValue:txtPhoneNumber.text forKey:CALLBACK_NUMBER];
    }
    if (![self isValueExistForKey:CALLER_ID]) {
        [[NSUserDefaults standardUserDefaults] setValue:txtPhoneNumber.text forKey:CALLER_ID];
    }
    if (![self isValueExistForKey:CALLOPTION1]) {
        [[NSUserDefaults standardUserDefaults] setValue:LOCAL_ACCESS forKey:CALLOPTION1];
    }
    if (![self isValueExistForKey:LINE_NO]) {
        [[NSUserDefaults standardUserDefaults] setValue:lld.LineNo forKey:LINE_NO];
    }
    if (![self isValueExistForKey:PUBLIC_PIN]) {
        [[NSUserDefaults standardUserDefaults] setValue:lld.PublicPIN forKey:PUBLIC_PIN];
    }
    if (![self isValueExistForKey:DIAL_STRING]) {
        [[NSUserDefaults standardUserDefaults] setValue:lld.DialOutString forKey:DIAL_STRING];
    }
    if (![self isValueExistForKey:USE_WIFI_IFAVAILABLE]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:USE_WIFI_IFAVAILABLE];
    }
//    if (![self isValueExistForKey:ANNOUNCE_MINUTES]) {
//        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:ANNOUNCE_MINUTES];
//    }
//    if (![self isValueExistForKey:ANNOUNCE_BALANCE]) {
//        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:ANNOUNCE_BALANCE];
//    }
    
}

-(BOOL)isValueExistForKey:(NSString *)key
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key]) {
        return YES;
    }else
    {
        return NO;
    }
}

-(void)gotoCallList
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableSip:) name:NOTIFICATION_ENABLE_SIP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sipEnableFailed:) name:NOTIFICATION_ENABLE_SIP_FAILED object:nil];
	UIInterfaceOrientation toOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    callDialerViewController *dialerViewController = nil;
    
    if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
        dialerViewController = [[callDialerViewController alloc] initWithNibName:@"callDialerViewController" bundle:nil];
    }
    else
    {
        dialerViewController = [[callDialerViewController alloc] initWithNibName:@"callDialerViewController_4Inch" bundle:nil];
    }

    dialerViewController.phoneCallDelegate = self;
    dialerViewController.title = [GlobalData getAppInfo].keypad;
    dialerViewController.tabBarItem.image = [UIImage imageNamed:@"call"];
    
    TopUpViewController *topupViewController = [[TopUpViewController alloc]init];
    UINavigationController *navTopupController = [[UINavigationController alloc]initWithRootViewController:topupViewController];
    navTopupController.title = [GlobalData getAppInfo].topUps;
    navTopupController.tabBarItem.image = [UIImage imageNamed:@"topup.png"];
//    if (!self.tabBarController)
//    {
        self.tabBarController = [[UITabBarController alloc] init];
        self.tabBarController.delegate = self;
    
    NSString *strVersion=[[UIDevice currentDevice] systemVersion];
    BOOL isIos7= [strVersion floatValue] >=7.0;
    if (isIos7)
    {
        self.tabBarController.tabBar.barTintColor =[GlobalData getAppInfo].bottomBarBgColor;
    }
    else
    {
         self.tabBarController.tabBar.tintColor = [GlobalData getAppInfo].bottomBarBgColor;
    }
    
    
    
        [[UITabBarItem appearance] setTitleTextAttributes:@{
                                 UITextAttributeFont : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                            UITextAttributeTextColor:[GlobalData getAppInfo].bottomBarTextColor}
                                             forState:UIControlStateNormal];

    
        apvc = [addProfileViewController new] ;
        apvc.delegate = self;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:apvc];
        navController.title = [GlobalData getAppInfo].options;
        navController.tabBarItem.image = [UIImage imageNamed:@"settings"];
        
        if([GlobalData getAppInfo].urlContactsPage)
        {
            ContactsViewController *contactController = [[ContactsViewController alloc]init];
            UINavigationController *navContactController = [[UINavigationController alloc]initWithRootViewController:contactController];
            navContactController.title = [GlobalData getAppInfo].contacts;
            navContactController.tabBarItem.image = [UIImage imageNamed:@"user"];
            
            self.tabBarController.viewControllers = [NSArray arrayWithObjects:dialerViewController,navContactController,navTopupController,navController, nil];
            
        }
        else
        {
            ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
            picker.navigationBar.tintColor = [UIColor whiteColor];
            picker.peoplePickerDelegate = self;
            // picker
            [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
            
            
            [picker.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           nil]];
            // Display only a person's phone, email, and birthdate
            NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                                       [NSNumber numberWithInt:kABPersonEmailProperty],
                                       [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
            
            [picker setEditing:YES];
            picker.displayedProperties = displayedItems;
            picker.tabBarItem.image = [UIImage imageNamed:@"user"];
            picker.title = [GlobalData getAppInfo].contacts;
            self.tabBarController.viewControllers = [NSArray arrayWithObjects:dialerViewController, picker, navTopupController,navController, nil];
            
        }
        
        if(toOrientation == UIInterfaceOrientationPortrait ||
           toOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            self.tabBarController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
        }
        else
        {
             self.tabBarController.view.frame = CGRectMake(0,0,480,300);
        }
    //}
    self.tabBarController.selectedIndex = 0;
    [self.view addSubview:(self.tabBarController.view)];
}


-(void)getAppInfo
{
    [[RESTInteraction restInteractionManager] GetAboutUsDetail];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[callDialerViewController class]])
    {
        callDialerViewController *cdvc = (callDialerViewController *)[tabBarController.viewControllers objectAtIndex:0];
        [cdvc tapOnDialer];
    }
    else if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nc = (UINavigationController *)[tabBarController.viewControllers objectAtIndex:3];
        [nc popToRootViewControllerAnimated:YES];
    }
}


-(void)getResultOfActivate:(CallSetUp *)callobj callfor:(NSString *)callFor
{
    apiCallFor = callFor;
    [self performSelectorOnMainThread:@selector(processResultOnMainThread:) withObject:callobj waitUntilDone:YES];
}

-(void)processResultOnMainThread:(CallSetUp *)callobj
{
    //    CallSetUp *callobj = (CallSetUp *)[args objectForKey:@"CALLSETUP"];
    [loader removeFromSuperview];
	if (callobj==nil) {
		[[[UIAlertView alloc]initWithTitle:nil message:@"CallSetup Request failed , please try again!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
	} else {
        if([callobj.ResultId isEqualToString:@"1"])
        {
            if([txtPhoneNumber.text length] > 0)
            {
                [GlobalData SetRegisterPhoneNumber:txtPhoneNumber.text];
            }
            
            huserId = callobj.username;
            hpassword = callobj.password;
            [GlobalData SetUserName:huserId];
            
            [[RESTInteraction restInteractionManager] getLoginData:callobj.username :callobj.password :YES];
            
        }else if([callobj.ResultId isEqualToString:@"3"]) {
            [self setLoginState:1];
            //[self.customTableView reloadData];
            //[[[[UIAlertView alloc]initWithTitle:@"Message" message:callobj.ResultStr delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil]autorelease]show];
            
        }else if([callobj.ResultId isEqualToString:@"2"]) {
            if (txtPromoCode.text.length>0) {
                [self setLoginState:3];
            }else
            {
                [self setLoginState:2];
            }
            if ([apiCallFor isEqualToString:TEXTTOPIN]) {
                [[[UIAlertView alloc]initWithTitle:@"Message" message:callobj.ResultStr delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil]show];
            }
            
        }else if ([callobj.ResultId isEqualToString:@"4"])
        {
            if (txtPromoCode.text.length>0) {
                [self setLoginState:3];
            }else
            {
                [self setLoginState:2];
            }
            [[[UIAlertView alloc]initWithTitle:@"Message" message:callobj.ResultStr delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil]show];
        }
        else
        {
            if([callobj.ResultStr length]>0)
            {
                [[[UIAlertView alloc]initWithTitle:@"Message" message:callobj.ResultStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
            }else
            {
                [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Login Failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
            }
            
        }
	}
}

/*
 Start code
 added by Pardeep
 */
// specify the height of your footer section


#pragma mark TABLEVIEW DELEGATE METHODS
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //differ between your sections or if you
    //have only on section return a static value
    return 40;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(tblfooterview == nil)
    {
        tblfooterview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)] ;
        tblfooterview.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, 270, 50)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        bgView.layer.cornerRadius = 10.0f;
        [tblfooterview addSubview:bgView];
        
        //tblfooterview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIButton *activateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        activateBtn.frame = CGRectMake(0, 0, 152, 33);
        
        activateBtn.layer.borderColor = [[UIColor colorWithRed:24.0/255.0 green:31.0/255.0 blue:60.0/255.0 alpha:1.0] CGColor];
        activateBtn.layer.borderWidth = 0.5;
        activateBtn.layer.cornerRadius = 10;
        [activateBtn setTitle:[GlobalData getAppInfo].activate forState:UIControlStateNormal];
        activateBtn.clipsToBounds = YES;
        [activateBtn setBackgroundImage:[GlobalData getAppInfo].imgSendBtn forState:UIControlStateNormal];
        [activateBtn addTarget:self action:@selector(clickOnActivate:) forControlEvents:UIControlEventTouchUpInside];
        activateBtn.center = tblfooterview.center;
        //activateBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [tblfooterview addSubview:activateBtn];
        //[customTableView addSubview:tblfooterview];
    }
    return tblfooterview;
}

-(IBAction)logontome:(id)sender
{
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(void) touchesBegan :(NSSet *) touches withEvent:(UIEvent *)event
{
    [txtPhoneNumber resignFirstResponder];
    [txtPinCode resignFirstResponder];
    [txtPromoCode resignFirstResponder];
    
    
}
-(void)sendRequestForLoginData:(NSString *)userid :(NSString *)pwd
{
    //   NSLog(@"------------my userid is %@", userid);
    //   NSLog(@"------------my password is %@", pwd);
    
    [[RESTInteraction restInteractionManager] getLoginData:userid :pwd :YES];
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
//    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
//    NSString *latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
//    NSString *longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
//    userLoginpref   = [NSUserDefaults standardUserDefaults];
//    [userLoginpref setObject:latitude forKey:@"latitude"];
//    [userLoginpref setObject:longitude forKey:@"longitude"];
//     [userLoginpref synchronize];
//
//
//}


#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	return YES;
}

// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, property);
    CFStringRef phonenumberselected = ABMultiValueCopyValueAtIndex(multi, ABMultiValueGetIndexForIdentifier(multi, identifier));
        if (phonenumberselected)
        {
            NSString *selectedNo = (__bridge NSString *)phonenumberselected;
            selectedNo = [GlobalData filterDialString:selectedNo];
            HUD=[[MBProgressHUD alloc] initWithView:self.view];
            HUD.delegate=self;
            [self.view addSubview:HUD];
            [HUD showWhileExecuting:@selector(startCalling:) onTarget:self withObject:selectedNo animated:TRUE];
        }
	return NO;
}

-(void)startCalling:(NSString *)selectedNo
{
    [[SipManager voipManager] doCall:selectedNo];
}

-(void)updateCallBackStatus:(NSString *)msg
{
    if(msg!=nil)
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}


// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	self.tabBarController.selectedIndex = 0;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

@end
