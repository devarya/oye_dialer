//
//  TopUpViewController.m
//  Callture
//
//  Created by user on 10/10/12.
//
//

#import "TopUpViewController.h"
#import "Constants.h"
#import "RESTInteraction.h"
#import <QuartzCore/QuartzCore.h>
#import "MobileOperator.h"
#import "Constants.h"
#import "TableCell.h"
#import "SipManager.h"
#import "callLogonViewController.h"
#import "JSON.h"

#define SCROLLVIEW_CONTENT_HEIGHT 420
#define SCROLLVIEW_CONTENT_WIDTH  320
#define REFRESH_HEADER_HEIGHT 52.0f
@interface TopUpViewController ()
{
    //NSString *dialString;
}
@end

@implementation TopUpViewController
@synthesize refreshArrow,refreshHeaderView,refreshLabel,refreshSpinner,textLoading,textPull,textRelease;
@synthesize phoneCallDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *backView = [[UIView alloc] init];
    [backView setBackgroundColor:[GlobalData getAppInfo].dataViewBgColor];
    
    [tableTopupHistory setBackgroundView:backView];
    
    
    [self.view setBackgroundColor:[GlobalData getAppInfo].pageBgColor];
    [viewRecentTransTitle setBackgroundColor:[GlobalData getAppInfo].topBarBgColor];
    [btnSend setBackgroundImage:[GlobalData getAppInfo].imgSendBtn forState:UIControlStateNormal];
    [btnAmtToSend setBackgroundImage:[GlobalData getAppInfo].imgDropDownBg forState:UIControlStateNormal];
    [btnOperatorList setBackgroundImage:[GlobalData getAppInfo].imgDropDownBg forState:UIControlStateNormal];
    arrContactsData = [[NSMutableArray alloc]init];
    [lblMobileNo setText:[GlobalData getAppInfo].sendRechargeTo];
    [txtMobileNo setPlaceholder:[GlobalData getAppInfo].recipientsMobileNumber];
    [lblMobileOperator setText:[GlobalData getAppInfo].mobileOperator];
    [btnOperatorList setTitle:[GlobalData getAppInfo].pleaseSelectOperator forState:UIControlStateNormal];
    [lblAmtToSend setText:[GlobalData getAppInfo].amountToSend];
    [btnAmtToSend setTitle:[GlobalData getAppInfo].amountToSend forState:UIControlStateNormal];
    [lblRecepientAmt setText:[GlobalData getAppInfo].recepientWillReceive];
    [btnSend setTitle:[GlobalData getAppInfo].send forState:UIControlStateNormal];
    [lblRecentTranscations setText:[GlobalData getAppInfo].recentTransactions];
    // https://support.telcan.net/app/AppTest.asp
    
    lblMobileNo.textColor = [GlobalData getAppInfo].pageTextColor;
    lblMobileOperator.textColor = [GlobalData getAppInfo].pageTextColor;
    lblAmtToSend.textColor = [GlobalData getAppInfo].pageTextColor;
    lblRecepientAmt.textColor = [GlobalData getAppInfo].pageTextColor;
    lblRecentTranscations.textColor = [GlobalData getAppInfo].topBarTextColor;
    
    
    if([GlobalData getAppInfo].urlTopUpPage)
    {
        webViewTopUpPage.hidden = NO;
        isWebViewLoaded=YES;
        historyView.hidden = YES;
        NSString *urlStr;
        if (![GlobalData isNetworkAvailable])
        {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedNoWeb:) name:NOTIFICATION_CONTACT_SELECTED_ON_TOPUP_WEB object:nil];
        urlStr = [GlobalData getAppInfo].urlTopUpPage;
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[UserName]" withString:[GlobalData UserName]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[key]" withString:[GlobalData ApiKey]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppName]" withString:[GlobalData getApp_Name]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppPlatform]" withString:[GlobalData getApp_Platform]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[LineNo]" withString:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"https://" withString:@"https://"];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *strWebsiteUrl = [NSString stringWithFormat:@"%@",urlStr];
        NSURL *url = [NSURL URLWithString:strWebsiteUrl];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self showLoader];
        [webViewTopUpPage loadRequest:requestObj];
        
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.navigationController.navigationBar.hidden = YES;
        
    }
    else
    {
        isWebViewLoaded=NO;
        isLogout = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:NOTIFICATION_LOGOUT object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operatorListUpdated:) name:NOTIFICATION_OPERATORLIST_UPDATED object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mobileTopupListUpdated:) name:NOTIFICATION_MOBILETOPUPLIST_UPDATED object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topUpChargeCompleted:) name:NOTIFICATION_TOPUP_CHARGE_COMPLETED object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedNo:) name:NOTIFICATION_CONTACT_SELECTED_ON_TOPUP object:nil];
            

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operatorListFailed) name:NOTIFICATION_OPERATORLIST_FAILED object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topUpChargeFailed) name:NOTIFICATION_TOPUP_CHARGE_FAILED object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector (keyboardDidShow:)
         name: UIKeyboardDidShowNotification
         object:nil];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector (keyboardDidHide:)
         name: UIKeyboardDidHideNotification
         object:nil];
        objDateFormatter = [[NSDateFormatter alloc] init];
        
        historyView.layer.cornerRadius = 10.0;
        historyView.layer.borderWidth = 1.0;
        historyView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        isgetNoFromContacts = NO;
        
        //self.title = MOBILE_RECHARGE;
      //  [self.navigationItem setTitle:[GlobalData getAppInfo].mobileRecharge];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        label.backgroundColor = [UIColor clearColor];
        [label setMinimumFontSize:12.0];
        label.font = [UIFont boldSystemFontOfSize:18.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth=YES;
        label.textColor = [GlobalData getAppInfo].topBarTextColor;
        self.navigationItem.titleView = label;
        label.text = [GlobalData getAppInfo].mobileRecharge;
        
        
        //// Add Image on navigation bar right side
        UIButton *btnImage =[[UIButton alloc] init];
        [btnImage setBackgroundImage:[GlobalData getAppInfo].imgTopRightLogo forState:UIControlStateNormal];
        btnImage.userInteractionEnabled = NO;
        btnImage.frame = CGRectMake(100, 100, 40, 40);
        UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithCustomView:btnImage];
        self.navigationItem.rightBarButtonItem = btnItem;
        NSString *strVersion =[[UIDevice currentDevice] systemVersion];
        BOOL isIos7=[strVersion floatValue]>=7.0;
        if (isIos7)
        {
            self.navigationController.navigationBar.barTintColor = [GlobalData getAppInfo].topBarBgColor;
           // self.navigationController.navigationBar.translucent = NO;
        }
        else
        {
            self.navigationController.navigationBar.tintColor = [GlobalData getAppInfo].topBarBgColor;
        }
        
        btnSend.layer.borderColor = [[UIColor colorWithRed:22.0/255.0 green:46.0/255.0 blue:81.0/255.0 alpha:1.0] CGColor];
        btnSend.layer.borderWidth = 0.5;
        btnSend.layer.cornerRadius = 10;
        
        btnAmtToSend.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        btnAmtToSend.layer.borderWidth = 0.5;
        btnAmtToSend.layer.cornerRadius = 10;
        
        btnOperatorList.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        btnOperatorList.layer.borderWidth = 0.5;
        btnOperatorList.layer.cornerRadius = 10;
        
        btnContact.layer.cornerRadius = 5.0f;
        [btnContact setBackgroundImage:[GlobalData getAppInfo].imgContacts forState:UIControlStateNormal];
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        numberToolbar.barStyle = UIBarStyleBlackTranslucent;
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                               nil];
        [numberToolbar sizeToFit];
        txtMobileNo.inputAccessoryView = numberToolbar;
        
        numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        numberToolbar.barStyle = UIBarStyleBlackTranslucent;
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithDecimalPad)],
                               nil];
        [numberToolbar sizeToFit];
        txtAmtToSend.inputAccessoryView = numberToolbar;
        // Do any additional setup after loading the view from its nib.
        [self setupStrings];
        [self addPullToRefreshHeader];
        
        [activityIndicator startAnimating];
        [loaderBg setHidden:NO];
        [self performSelectorInBackground:@selector(getTopUpHistory) withObject:nil];
  }
}

-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
    if (isWebViewLoaded)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
  
    }
        
    if (optView)
    {
        [optView removeFromSuperview];
        optView = nil;
    }
    if (!isgetNoFromContacts && ![GlobalData getAppInfo].urlTopUpPage) {
        txtMobileNo.text = @"";
        [self mobileNoChanged:nil];
        historyView.hidden = NO;
    }else
    {
        isgetNoFromContacts = NO;
    }
    
	//Initially the keyboard is hidden
	keyboardVisible = NO;
   
    if (isLogout)
    {
        [activityIndicator startAnimating];
        [loaderBg setHidden:NO];
        [self performSelectorInBackground:@selector(getTopUpHistory) withObject:nil];
        isLogout = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (![GlobalData isNetworkAvailable]) {
        
        [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    if (isWebViewLoaded)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
        
    }
    
}

#pragma mark WEBVIEW DELEGATE METHODS
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request.URL absoluteString] isEqualToString:@"myapp://getContact"])
    {
        [[callLogonViewController logOnManager] gotoAddressBook:TOPUPWEB];
        return NO; // Tells the webView not to load the URL
    }else if([[request.URL absoluteString] isEqualToString:@"myapp://logout"])
    {
        [[callLogonViewController logOnManager] logout];
        return NO;
    }else if([[request.URL absoluteString] isEqualToString:@"myapp://getAppParams"])
    {
        NSString *iswifi = [GlobalData isReachableViaWiFi]?@"yes":@"no";
        NSString *connected = [[SipManager voipManager] isConnected]?@"yes":@"no";
        NSString *parameter = [NSString stringWithFormat:@"wifi=%@|calltype=%@|registered=%@",iswifi,[[NSUserDefaults standardUserDefaults] valueForKey:CALLOPTION1],connected];
        [webViewTopUpPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setAppParams('%@')",parameter]];
        return NO;
    }
    else if ([[request.URL absoluteString] isEqualToString:@"myapp://getContacts"])
    {
        [self setAllAddressBookListData];
    }
    
    else if ([[request.URL absoluteString] isEqualToString:@"myapp://getContacts2"])
    {
        [self getAllAddressBookData2];
    }
    
    else if([[request.URL absoluteString] rangeOfString:@"myapp://getContactByName"].location != NSNotFound)
    {
//     NSString *strName = [[[request.URL absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:1];
//        [self getContactsByName:strName];
    }
    else if([[request.URL absoluteString] rangeOfString:@"myapp://getContactByTelNo"].location != NSNotFound)
    {
//      NSString *strNumber = [[[request.URL absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:1];
//        [self getContactsByNumber:strNumber];
    }
    else if([[request.URL absoluteString] rangeOfString:@"myapp://getContactById"].location != NSNotFound)
    {
//        NSString *strID = [[[request.URL absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:1];
//        [self getContactsById:strID];
    }
    
    else if([[request.URL absoluteString] rangeOfString:@"myapp://setCall"].location == NSNotFound)
    {
        return YES; // Tells the webView to go ahead and load the URL
    }
    else
    {
        NSString *str = [[[request.URL absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:1];
        NSString *dialString = [[str componentsSeparatedByString:@","] objectAtIndex:0];
        NSString *calling = [[str componentsSeparatedByString:@","] objectAtIndex:1];
        if ([calling isEqualToString:@"true"])
        {
            if([dialString length]>0)
            {
                HUD=[[MBProgressHUD alloc] initWithView:self.view];
                HUD.delegate=self;
                [self.view addSubview:HUD];
                [HUD showWhileExecuting:@selector(startCalling:) onTarget:self withObject:dialString animated:TRUE];
            }
        }else
        {
            [SipManager voipManager].selectedNum = dialString;
            self.tabBarController.selectedIndex = 0;
        }
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    //    NSString *iswifi = [GlobalData isReachableViaWiFi]?@"yes":@"no";
    //    NSString *connected = [[SipManager voipManager] isConnected]?@"yes":@"no";
    //    NSString *parameter = [NSString stringWithFormat:@"wifi=%@|calltype=%@|registered=%@",iswifi,[[NSUserDefaults standardUserDefaults] valueForKey:CALLOPTION1],connected];
    //    [webViewTopUpPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setAppParams('%@')",parameter]];
    [loader removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
}


//// Get details by Name
-(void)getContactsByName:(NSString *)name
{
    NSError *error;
    NSString *idValue;
    NSMutableArray *arrNames = [[NSMutableArray alloc]init];
    
    [self getAllAddressBookData];
    
    for(int i=0; i < [arrContactsData count]; i++)
    {
        NSString *strName = [[arrContactsData objectAtIndex:i] objectForKey:@"name"];
        if([name isEqualToString:strName])
        {
            idValue = [NSString stringWithFormat:@"%d",i];
            [arrNames addObject:[arrContactsData objectAtIndex:i]];
        }
    }
    NSLog(@"%@", idValue);
    NSLog(@"%@", arrNames);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrNames options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSArray *results = [jsonString JSONValue];
    
    NSDictionary *finalData = [NSDictionary dictionaryWithObject:results forKey:@"contact"];
    NSString *finalJSON = [finalData JSONRepresentation];
    NSLog(@"%@", finalJSON);
    [webViewTopUpPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setContactByName('%@','%@')",idValue, finalJSON]];
}

//// Get details by Contact Number
-(void)getContactsByNumber:(NSString *)phoneNo
{
    NSError *error;
    NSString *idValue;
    NSMutableArray *arrNumbers = [[NSMutableArray alloc]init];
    
    [self getAllAddressBookData];
    
    for(int i=0; i < [arrContactsData count]; i++)
    {
        NSString *strNumber = [[arrContactsData objectAtIndex:i] objectForKey:@"phone"];
        if([phoneNo isEqualToString:strNumber])
        {
            idValue = [NSString stringWithFormat:@"%d",i];
            [arrNumbers addObject:[arrContactsData objectAtIndex:i]];
        }
    }
    NSLog(@"%@", idValue);
    NSLog(@"%@", arrNumbers);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrNumbers options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSArray *results = [jsonString JSONValue];
    
    NSDictionary *finalData = [NSDictionary dictionaryWithObject:results forKey:@"contact"];
    NSString *finalJSON = [finalData JSONRepresentation];
    NSLog(@"%@", finalJSON);
    [webViewTopUpPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setContactByTelNo('%@','%@')",idValue, finalJSON]];
}

//// Get details by Contact ID No
-(void)getContactsById:(NSString *)idNo
{
    NSError *error;
    NSString *idValue;
    NSMutableArray *arrId = [[NSMutableArray alloc]init];
    
    [self getAllAddressBookData];
    
    for(int i=0; i < [arrContactsData count]; i++)
    {
        NSString *strId = [[arrContactsData objectAtIndex:i] objectForKey:@"id"];
        if([idNo isEqualToString:strId])
        {
            idValue = [NSString stringWithFormat:@"%d",i];
            [arrId addObject:[arrContactsData objectAtIndex:i]];
        }
    }
    NSLog(@"%@", idValue);
    NSLog(@"%@", arrId);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrId options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSArray *results = [jsonString JSONValue];
    
    NSDictionary *finalData = [NSDictionary dictionaryWithObject:results forKey:@"contact"];
    NSString *finalJSON = [finalData JSONRepresentation];
    NSLog(@"%@", finalJSON);
    [webViewTopUpPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setContactById('%@','%@')",idValue, finalJSON]];
}

//////// get all conatcts data others 2
-(void)getAllAddressBookData2
{
    @try {
        NSError *error;
        NSMutableArray *arrContacts2 = [NSMutableArray new];
        ABAddressBookRef addressBook = ABAddressBookCreate();
        
        if (addressBook != nil)
        {
            NSLog(@"Successfully accessed the address book.");
            
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex nPeople= ABAddressBookGetPersonCount(addressBook);
            
            NSUInteger peopleCounter = 0;
            for (peopleCounter = 0;peopleCounter < nPeople; peopleCounter++)
            {
                NSMutableDictionary *contactDictionary = [NSMutableDictionary new];
                ABRecordRef thisPerson = CFArrayGetValueAtIndex(allPeople,peopleCounter);
                
                NSString *strName = [NSString stringWithFormat:@"%@ %@", (__bridge  NSString *)ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty), (__bridge  NSString *)ABRecordCopyValue(thisPerson,kABPersonLastNameProperty)];
                
                [contactDictionary setValue:strName forKey:@"name"];
                
                ABMultiValueRef phoneNumbers = ABRecordCopyValue(thisPerson,kABPersonPhoneProperty);
                NSString *strPhoneNo = [NSString stringWithFormat:@"%@,%@,%@",(__bridge  NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, 0), (__bridge  NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, 1), (__bridge  NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, 2)];
                
                [contactDictionary setValue:strPhoneNo forKey:@"phoneNo"];
                
                NSString *birthDay = [NSString stringWithFormat:@"%@", (__bridge  NSString *)ABRecordCopyValue(thisPerson, kABPersonBirthdayProperty)];
                
                [contactDictionary setValue:birthDay forKey:@"birthday"];
                
                ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,peopleCounter);
                
                NSString *strEmail;
                ABMultiValueRef email = ABRecordCopyValue(ref, kABPersonEmailProperty);
                CFStringRef tempEmailref = ABMultiValueCopyValueAtIndex(email, 0);
                strEmail = (__bridge   NSString *)tempEmailref;
                
                if(strEmail == nil)
                {
                    strEmail = @"";
                }
                [contactDictionary setValue:strEmail forKey:@"email"];
                
                [arrContacts2 addObject:contactDictionary];
            }
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrContacts2 options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSArray *results = [jsonString JSONValue];
        
        NSDictionary *finalData = [NSDictionary dictionaryWithObject:results forKey:@"contact"];
        NSString *finalJSON = [finalData JSONRepresentation];
        NSLog(@"%@", finalJSON);
        
        [webViewTopUpPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setContacts2('%@')",finalJSON]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}

/// get all data from Address book
-(void)getAllAddressBookData
{
    @try {
        ABAddressBookRef addressBook = ABAddressBookCreate();
        NSMutableArray *contacts = [[NSMutableArray alloc]init];
        
        if (addressBook != nil)
        {
            NSLog(@"Successfully accessed the address book.");
            
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex nPeople= ABAddressBookGetPersonCount(addressBook);
            NSUInteger peopleCounter = 0;
            
            for (peopleCounter = 0;peopleCounter < nPeople; peopleCounter++)
            {
                ABRecordRef thisPerson = CFArrayGetValueAtIndex(allPeople,peopleCounter);
                NSMutableDictionary *dictContact = [[NSMutableDictionary alloc]init];
                
                NSString *strId = [NSString stringWithFormat:@"%d",peopleCounter];
                [dictContact setValue:strId forKey:@"id"];
                
                //////// Name
                NSString *strFirstName = (__bridge NSString *)(ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty));
                strFirstName = [strFirstName stringByReplacingOccurrencesOfString:@"(" withString:@""];
                strFirstName = [strFirstName stringByReplacingOccurrencesOfString:@")" withString:@""];
                strFirstName = [strFirstName stringByReplacingOccurrencesOfString:@"&" withString:@""];
                strFirstName = [strFirstName stringByReplacingOccurrencesOfString:@"<" withString:@""];
                strFirstName = [strFirstName stringByReplacingOccurrencesOfString:@">" withString:@""];
                [dictContact setValue:strFirstName forKey:@"firstName"];
                NSString *strLastName  = (__bridge NSString *)(ABRecordCopyValue(thisPerson, kABPersonLastNameProperty));
                strLastName = [strLastName stringByReplacingOccurrencesOfString:@"(" withString:@""];
                strLastName = [strLastName stringByReplacingOccurrencesOfString:@")" withString:@""];
                strLastName = [strLastName stringByReplacingOccurrencesOfString:@"&" withString:@""];
                strLastName = [strLastName stringByReplacingOccurrencesOfString:@"<" withString:@""];
                strLastName = [strLastName stringByReplacingOccurrencesOfString:@">" withString:@""];
                [dictContact setValue:strLastName forKey:@"lastName"];
                
//                ///////Phone no
//                ABMultiValueRef phoneNumbers = ABRecordCopyValue(thisPerson,kABPersonPhoneProperty);
//                NSString *strPhoneNo = [NSString stringWithFormat:@"%@,%@,%@",( NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, 0), ( NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, 1), ( NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, 2)];
//                [dictContact setValue:strPhoneNo forKey:@"phoneNo"];
                
                NSMutableArray *arrPhone = [[NSMutableArray alloc]init];
               ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(thisPerson, kABPersonPhoneProperty));
               for(CFIndex i = 0; i <ABMultiValueGetCount(phones); i++)
               {
                   CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
                   CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, i);
                   NSString *phoneLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
                   NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
                   phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
                   phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
                   phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"&" withString:@""];
                   phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"<" withString:@""];
                   phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@">" withString:@""];
                   phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                   [arrPhone addObject:[NSString stringWithFormat:@"%@: %@", phoneLabel, phoneNumber]];
               }
                
              [dictContact setObject:arrPhone forKey:@"PhoneNo"];
                
                ///////// Email Id
                ABMultiValueRef multiValue = ABRecordCopyValue(thisPerson, kABPersonEmailProperty);
                CFStringRef labelEmail = ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(multiValue, 0));
                NSString *strEmailId = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multiValue, 0);
                NSLog(@"%@: %@", labelEmail, strEmailId);
                if(strEmailId == nil)
                {
                    strEmailId = @"";
                }
                [dictContact setValue:[NSString stringWithFormat:@"%@", strEmailId] forKey:@"email"];
                
                
                [contacts addObject:dictContact];
                arrContactsData = [contacts mutableCopy];
            }
        }

    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}

////// Set all addressbook list data
-(void)setAllAddressBookListData
{
    [self getAllAddressBookData];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrContactsData options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSArray *results = [jsonString JSONValue];
    
    NSDictionary *finalData = [NSDictionary dictionaryWithObject:results forKey:@"contact"];
    NSString *finalJSON = [finalData JSONRepresentation];
    finalJSON = [finalJSON stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSLog(@"%@", finalJSON);
    
    [webViewTopUpPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setContacts('%@')",finalJSON]];
}

-(void)startCalling:(NSString *)dialString
{
    [[SipManager voipManager] doCall:dialString];
}

//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
//    BOOL isEmpty = string==nil || [string length]==0;
//    if (isEmpty) {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
//    BOOL isEmpty = string==nil || [string length]==0;
//    if (isEmpty) {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }else
//    {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }
//}


-(void)logout
{
    isLogout = YES;
    lastTransactionId = nil;
    mobileTopupList = nil;
}


-(void)getTopUpHistory
{
    if (!lastTransactionId) {
        lastTransactionId = @"";
        mobileTopupList = [[NSMutableArray alloc]init];
    }
    RESTInteraction *rest = [RESTInteraction restInteractionManager];
    rest.delegate = self;
    [rest getTopupHistoryData:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO] :lastTransactionId :[GlobalData ClientID]];
}

-(void)addMobileTopup:(MobileTopup *)mt
{
    if (!mobileTopupList) {
        mobileTopupList = [[NSMutableArray alloc]init];
    }
    [mobileTopupList addObject:mt];
}

-(void) keyboardDidShow: (NSNotification *)notif {
	NSLog(@"Keyboard is visible");
	// If keyboard is visible, return
	if (keyboardVisible) {
		NSLog(@"Keyboard is already visible. Ignore notification.");
		return;
	}
	
	// Get the size of the keyboard.
    CGRect keyboardEndFrame;
    
    
	NSDictionary* info = [notif userInfo];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	CGSize keyboardSize = keyboardEndFrame.size;
	
	// Save the current location so we can restore
	// when keyboard is dismissed
	offset = scrollview.contentOffset;
	
	// Resize the scroll view to make room for the keyboard
	CGRect viewFrame = scrollview.frame;
	viewFrame.size.height -= keyboardSize.height;
	scrollview.frame = viewFrame;
	
	CGRect textFieldRect = [activeField frame];
	textFieldRect.origin.y += 10;
	[scrollview scrollRectToVisible:textFieldRect animated:YES];
	
	NSLog(@"ao fim");
	// Keyboard is now visible
	keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
	// Is the keyboard already shown
	if (!keyboardVisible) {
		NSLog(@"Keyboard is already hidden. Ignore notification.");
		return;
	}
	
	// Reset the frame scroll view to its original value
	scrollview.frame = CGRectMake(0, 0, SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
	
	// Reset the scrollview to previous location
	scrollview.contentOffset = offset;
	
	// Keyboard is no longer visible
	keyboardVisible = NO;
	
}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
	activeField = textField;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}



-(void)operatorListFailed
{
    [loader removeFromSuperview];
    [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Failed to load mobile operators." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

-(void)topUpChargeFailed
{
    [loader removeFromSuperview];
    [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Failed to process." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

-(void)getSelectedNo:(NSNotification *)notification
{
    isgetNoFromContacts = YES;
    NSString *selectedNo = (NSString *)notification.object;
    txtMobileNo.text = [GlobalData filterDialString:selectedNo];
    isMobileNoChanged = YES;
    [self mobileNoChanged:nil];
    //[self proceedNo:nil];
}

-(void)getSelectedNoWeb:(NSNotification *)notification
{
    NSString *selectedNo = (NSString *)notification.object;
    [webViewTopUpPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setContact('%@')",selectedNo]];
}

-(IBAction)gotoContacts:(id)sender
{
    [[callLogonViewController logOnManager] gotoAddressBook:[GlobalData getAppInfo].topUps];
}

-(IBAction)mobileNoChanged:(id)sender
{
    NSIndexPath *selection = [tableTopupHistory indexPathForSelectedRow];
    if (selection) {
        [tableTopupHistory deselectRowAtIndexPath:selection animated:YES];
    }
    if ([self.view.subviews containsObject:optView]) {
        [optView removeFromSuperview];
        optView = nil;
    }
    if (txtMobileNo.text.length>0) {
        historyView.hidden = YES;
    }else
    {
        historyView.hidden = NO;
    }
    
    selectedAmount = nil;
    selectedMo = nil;
    isMobileNoChanged = YES;
    [lblAmtToSend setHidden:YES];
    [lblRecepientAmt setHidden:YES];
    [lblMobileOperator setHidden:YES];
    [txtAmtToSend setHidden:YES];
    txtAmtToSend.text = @"";
    [txtRecepientAmt setHidden:YES];
    txtRecepientAmt.text = @"";
    [btnAmtToSend setHidden:YES];
    [btnOperatorList setHidden:YES];
    [btnSend setHidden:YES];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(callProcessPhoneNo) object:nil];
    if (txtMobileNo.text.length>9)
    {
        if (isgetNoFromContacts) {
            [self performSelector:@selector(callProcessPhoneNo) withObject:nil afterDelay:0];
        }else
        {
            [self performSelector:@selector(callProcessPhoneNo) withObject:nil afterDelay:1.1];
        }
    }
}

-(void)callProcessPhoneNo
{
    if (txtMobileNo.text.length>=10) {
        [self proceedNo:nil];
    }
}

-(void)doneWithNumberPad
{
    if (txtMobileNo.text.length>0) {
        [self proceedNo:nil];
    }else
    {
        [txtMobileNo resignFirstResponder];
    }
}

-(void)doneWithDecimalPad
{
    [txtAmtToSend resignFirstResponder];
}

-(void)mobileTopupListUpdated:(NSNotification *)notification
{
    [self performSelector:@selector(stopLoading)];
    NSMutableArray *arr = [notification object];
    if (arr) {
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0, arr.count)];
        [mobileTopupList insertObjects:arr atIndexes:indexSet];
    }
    if (mobileTopupList.count>0) {
        MobileTopup *mt = [mobileTopupList objectAtIndex:0];
        lastTransactionId = mt.mobilePaymentID;
    }
   
    [self performSelectorOnMainThread:@selector(reloadHistory) withObject:nil waitUntilDone:NO];
}

-(void)reloadHistory
{
    [activityIndicator stopAnimating];
    [tableTopupHistory reloadData];
    [loaderBg setHidden:YES];
}

-(void)operatorListUpdated:(NSNotification *)notification
{
    [loader removeFromSuperview];
    if (operatorList.count>0) {
        lblMobileOperator.hidden = NO;
        btnOperatorList.hidden = NO;
        if (operatorList.count==1)
        {
            selectedMo = [operatorList objectAtIndex:0];
            [btnOperatorList setTitle:[NSString stringWithFormat:@"%@ - %@",selectedMo.country,selectedMo.operatorName] forState:UIControlStateNormal];
            [self proceedAfterSelectOperator];
        }else
        {
            [btnOperatorList setTitle:[GlobalData getAppInfo].pleaseSelectOperator forState:UIControlStateNormal];
        }
    }else
    {
        if (notification.object) {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:[NSString stringWithFormat:@"%@",notification.object] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }
}

-(void)topUpChargeCompleted:(NSNotification *)notification
{
    [loader removeFromSuperview];
    TopupInfo *topupData = (TopupInfo *)[[notification userInfo] objectForKey:TOPUPINFO];
    if (topupData.ResultId==-1) {
        TopUpConfirmationViewController *tcv = [TopUpConfirmationViewController new];
        tcv.delegate = self;
        tcv.topupInfo = (TopupInfo *)[[notification userInfo] objectForKey:TOPUPINFO];
        tcv.operatorId = [NSString stringWithFormat:@"%d",selectedMo.mobileOperatorID];
        tcv.amtCharged = selectedAmount;
        tcv.amountToSend = amountToSend;
        [self.navigationController pushViewController:tcv animated:YES];
    }else
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:topupData.ResultStr delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

-(void)updateRecentsTransaction
{
    [activityIndicator startAnimating];
    [loaderBg setHidden:NO];
    [self performSelectorInBackground:@selector(getTopUpHistory) withObject:nil];
}

-(IBAction)proceedNo:(id)sender
{
    [txtMobileNo resignFirstResponder];
    if (isMobileNoChanged) {
        isMobileNoChanged = NO;
        if (txtMobileNo.text.length>=10) {
            [self showLoader];
            operatorList = [[NSMutableArray alloc]init];
            [self performSelectorInBackground:@selector(getMobileOperators:) withObject:txtMobileNo.text];
        }else
        {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].pleaseEnterAvalidNumber delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }
}

-(void)getMobileOperators:(NSString *)number
{
        RESTInteraction *rest = [RESTInteraction restInteractionManager];
        rest.delegate = self;
        [rest GetTopupOperators:number];
}

-(void)addOperator:(MobileOperator *)mo
{
    [operatorList addObject:mo];
}

-(IBAction)selectOperator:(id)sender
{
    if (operatorList.count>1) {
        if (!optView) {
            if (((44*operatorList.count)+20)>self.view.bounds.size.height) {
                optView = [[CallOptionView alloc]initWithFrame:self.view.bounds tableFram:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
                optView.table.bounces = YES;
                optView.table.scrollEnabled = YES;
            }else
            {
                optView = [[CallOptionView alloc]initWithFrame:self.view.bounds tableFram:CGRectMake(0, 0, 320, (44*operatorList.count)+20)];
                optView.table.bounces = NO;
                optView.table.scrollEnabled = NO;
            }
        }else
        {
            if (((44*operatorList.count)+20)>self.view.bounds.size.height) {
                optView.table.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
                optView.table.bounces = YES;
                optView.table.scrollEnabled = YES;
            }else
            {
                optView.table.frame = CGRectMake(0, 0, 320, (44*operatorList.count)+20);
                optView.table.bounces = NO;
                optView.table.scrollEnabled = NO;
            }
        }
        optView.section = OPERATOR;
        optView.center = self.view.center;
        optView.dataList = operatorList;
        optView.selectedData = selectedMo;
        optView.delegate = self;
        [optView.table reloadData];
        
        if (![self.view.subviews containsObject:optView]) {
            [optView setAlpha:0.0];
            [self.view addSubview:optView];
            [UIView beginAnimations:nil context:nil];
            [optView setAlpha:1.0];
            [UIView commitAnimations];
        }
    }
}

-(void)updateData:(NSObject *)data section:(NSString *)section
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView animateWithDuration:0.2
                     animations:^{optView.alpha = 0.0;}
                     completion:^(BOOL finished){[optView removeFromSuperview];}];
    optView = nil;
    [UIView commitAnimations];
    if (data) {
        if ([section isEqualToString:AMOUNT]) {
            selectedAmount = (NSString *)data;
            [btnAmtToSend setTitle:[NSString stringWithFormat:@"$ %@",selectedAmount] forState:UIControlStateNormal];
            [txtRecepientAmt setText:[self getCalculatedAmount:[selectedAmount floatValue]]];
        }else
        {
            selectedAmount = @"";
            selectedMo = (MobileOperator *)data;
            [self proceedAfterSelectOperator];
        }
    }
}

-(void)proceedAfterSelectOperator
{
    amountList = [[NSMutableArray alloc]initWithArray:selectedMo.fixedAmountsList];
    [btnOperatorList setTitle:[NSString stringWithFormat:@"%@ - %@",selectedMo.country,selectedMo.operatorName] forState:UIControlStateNormal];
    lblAmtToSend.hidden = NO;
    lblRecepientAmt.hidden = NO;
    txtRecepientAmt.hidden = NO;
    btnSend.hidden = NO;
    if (selectedMo.fixedAmountsList.count>0)
    {
        btnAmtToSend.hidden = NO;
        if (selectedMo.fixedAmountsList.count==1)
        {
            selectedAmount = [selectedMo.fixedAmountsList objectAtIndex:0];
            [btnAmtToSend setTitle:[NSString stringWithFormat:@"$ %@",selectedAmount] forState:UIControlStateNormal];
            [txtRecepientAmt setText:[self getCalculatedAmount:[selectedAmount floatValue]]];
        }else
        {
            [btnAmtToSend setTitle:[GlobalData getAppInfo].pleaseSelectAmount forState:UIControlStateNormal];
        }
    }else
    {
        txtAmtToSend.placeholder = [NSString stringWithFormat:@"Between $%.2f and $%.2f",selectedMo.minAmount,selectedMo.maxAmount];
        txtAmtToSend.hidden = NO;
    }
    //[self setAssetPosition];
}

//-(void)setAssetPosition
//{
//    if (selectedMo.fixedAmountsList>0) {
//        CGRect rect1 = lblRecepientAmt.frame;
//        rect1.origin.y = 244;
//        lblRecepientAmt.frame = rect1;
//        
//        rect1 = txtRecepientAmt.frame;
//        rect1.origin.y = 275;
//        txtRecepientAmt.frame = rect1;
//        
//        rect1 = btnSend.frame;
//        rect1.origin.y = 315;
//        btnSend.frame = rect1;
//    }else
//    {
//        CGRect rect1 = lblRecepientAmt.frame;
//        rect1.origin.y = 234;
//        lblRecepientAmt.frame = rect1;
//        
//        rect1 = txtRecepientAmt.frame;
//        rect1.origin.y = 265;
//        txtRecepientAmt.frame = rect1;
//        
//        rect1 = btnSend.frame;
//        rect1.origin.y = 305;
//        btnSend.frame = rect1;
//    }
//}

-(NSString *)getCalculatedAmount:(float)SourceAmount
{
    float TransactionAmount, AmountReceiveTotal, AmountReceive, TaxAmount;
    //NSLog(@"%f %f %f",selectedMo.L_Rate,selectedMo.currencyRate,selectedMo.taxRate);
    TransactionAmount = SourceAmount / selectedMo.L_Rate;
    AmountReceiveTotal = TransactionAmount * selectedMo.currencyRate;
    AmountReceive = AmountReceiveTotal / (1 + selectedMo.taxRate);
    TaxAmount = AmountReceiveTotal - AmountReceive;
    return [NSString stringWithFormat:@"%@ %.2f (includes %@ %.2f tax)",selectedMo.currencyCode,AmountReceiveTotal,selectedMo.currencyCode,TaxAmount];
   // Calculation = " Tax: " + TaxAmount.toFixed(4) + "   Total: " + AmountReceiveTotal.toFixed(4);
    
//    if (selectedMo.markupFixed != 0)
//        SenderAmount = SourceAmount + selectedMo.markupFixed;
//    else if (selectedMo.markupPercent != 0)
//        SenderAmount = SourceAmount * (1 + (selectedMo.markupPercent / 100));
//    else
//        SenderAmount = SourceAmount;
}

-(IBAction)selectAmount:(id)sender
{
    if (!optView) {
        if (((44*amountList.count)+20)>self.view.bounds.size.height) {
            optView = [[CallOptionView alloc]initWithFrame:self.view.bounds tableFram:CGRectMake(0, 0, 220, self.view.bounds.size.height)];
            optView.table.bounces = YES;
        }else
        {
            optView = [[CallOptionView alloc]initWithFrame:self.view.bounds tableFram:CGRectMake(0, 0, 220, (44*amountList.count)+20)];
            optView.table.bounces = NO;
        }
    }else
    {
        if (((44*amountList.count)+20)>self.view.bounds.size.height) {
            optView.table.frame = CGRectMake(0, 0, 220, self.view.bounds.size.height);
            optView.table.bounces = YES;
        }else
        {
            optView.table.frame = CGRectMake(0, 0, 220, (44*amountList.count)+20);
            optView.table.bounces = NO;
        }
    }
    optView.section = AMOUNT;
    optView.center = self.view.center;
    optView.dataList = amountList;
    optView.selectedData = selectedAmount;
    optView.delegate = self;
    [optView.table reloadData];
    
    if (![self.view.subviews containsObject:optView]) {
        [optView setAlpha:0.0];
        [self.view addSubview:optView];
        [UIView beginAnimations:nil context:nil];
        [optView setAlpha:1.0];
        [UIView commitAnimations];
    }
}

-(IBAction)amountToSendChanged:(id)sender
{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendAmtDidChanged) object:nil];
//    [self performSelector:@selector(sendAmtDidChanged) withObject:nil afterDelay:1.0];
    [self sendAmtDidChanged];
}

-(void)sendAmtDidChanged
{
    float amtToSend = [txtAmtToSend.text floatValue];
    [txtRecepientAmt setText:[self getCalculatedAmount:amtToSend]];
    //if (amtToSend>=selectedMo.minAmount && amtToSend<=selectedMo.maxAmount) {
        
//    }else
//    {
//        [[[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter valid amount" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
//    }
}

-(IBAction)tapOnSend:(id)sender
{
    if (selectedMo.fixedAmountsList.count>0)
    {
        if (selectedAmount) {
            [self showLoader];
            [self performSelectorInBackground:@selector(proceedCharge:) withObject:selectedAmount];
        }else
        {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].amountSelectionOrEnteringAmountIsRequired delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        
        //[[RESTInteraction restInteractionManager] MakeTopupCharge:txtMobileNo.text PaymentId:@"0" amount:selectedAmount confirmationOrder:@"false" mobileOrderId:[NSString stringWithFormat:@"%d",selectedMo.mobileOperatorID]];
    }else
    {
        float amtToSend = [txtAmtToSend.text floatValue];
        if (amtToSend>=selectedMo.minAmount && amtToSend<=selectedMo.maxAmount)
        {
            [self showLoader];
            [self performSelectorInBackground:@selector(proceedCharge:) withObject:txtAmtToSend.text];
            //[[RESTInteraction restInteractionManager] MakeTopupCharge:txtMobileNo.text PaymentId:@"0" amount:txtAmtToSend.text confirmationOrder:@"false" mobileOrderId:[NSString stringWithFormat:@"%d",selectedMo.mobileOperatorID]];
        }else
        {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:[NSString stringWithFormat:@"Please enter a valid amount between %.2f and %.2f", selectedMo.minAmount, selectedMo.maxAmount] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }
}

-(void)proceedCharge:(NSString *)amount
{
    amountToSend = [amount floatValue]/selectedMo.L_Rate;
    NSString *strAmount = [NSString stringWithFormat:@"%f",amountToSend];
    [[RESTInteraction restInteractionManager] MakeTopupCharge:txtMobileNo.text PaymentId:@"0" amount:strAmount confirmationOrder:@"false" mobileOrderId:[NSString stringWithFormat:@"%d",selectedMo.mobileOperatorID] fromPage:[GlobalData getAppInfo].topUps];
}

-(void)showLoader
{
    loader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    [loader setBackgroundColor:[UIColor blackColor]];
    [loader setAlpha:0.5];
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.frame = CGRectMake(135, 160, 50, 50);
    [aiv startAnimating];
    [loader addSubview:aiv];
    [self.view addSubview:loader];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Datasource

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
//    view.backgroundColor = [UIColor greenColor];
//    return view;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mobileTopupList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[TableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        UIImageView *accessorImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
        cell.accessoryView = accessorImg;
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg-Option.png"]];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    
    MobileTopup *mt = [mobileTopupList objectAtIndex:indexPath.row];

    [objDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *reqDate = [objDateFormatter dateFromString:mt.requestDate];
    if (!reqDate) {
        [objDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        reqDate = [objDateFormatter dateFromString:mt.requestDate];
    }
    [objDateFormatter setDateFormat:@"dd-MMM hh:mma"];
    //NSLog(@"%@",[objDateFormatter stringFromDate:reqDate]);
    NSString *strDate = [objDateFormatter stringFromDate:reqDate];
    strDate = [strDate stringByReplacingOccurrencesOfString:@"AM" withString:@"am"];
    strDate = [strDate stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
    cell.detailTextLabel.text = strDate;
    cell.detailTextLabel.textColor = [GlobalData getAppInfo].dataViewDimTextColor;
   // [objDateFormatter release];
    //[reqDate release];
    
    cell.textLabel.text = mt.mobileTelNo;
    cell.textLabel.textColor = [GlobalData getAppInfo].dataViewTextColor;
    if ([mt.processStatusID isEqualToString:@"100"]) {
        cell.lblAmount.text = [NSString stringWithFormat:@"$%.2f > %@ %.2f",[mt.amount floatValue],mt.postedCurrencyCode,[mt.postedAmount floatValue]];
    }else if ([mt.processStatusID isEqualToString:@"0"]) {
        cell.lblAmount.text = @"Incomplete";
    }else
    {
        cell.lblAmount.text =@"Failed";
    }
    
    cell.lblAmount.textColor = [GlobalData getAppInfo].dataViewDimTextColor;
    
    //[cell setTopupData:mt];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MobileTopup *mt = [mobileTopupList objectAtIndex:indexPath.row];
    txtMobileNo.text = mt.mobileTelNo;
    [self mobileNoChanged:nil];
    //[self proceedNo:<#(id)#>];
}





//refresh on pull
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            tableTopupHistory.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            tableTopupHistory.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = self.textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = self.textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        tableTopupHistory.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        tableTopupHistory.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    
    [self performSelectorInBackground:@selector(getTopUpHistory) withObject:nil];
    
}
- (void)setupStrings
{
    NSString *strRefreshTitle=@"Pull up to refresh...";
    NSString *strRefreshEndTitle=@"Release to refresh...";
    NSString *strRefreshLoading=@"Loading...";
    textPull = [[NSString alloc] initWithString:strRefreshTitle];
    textRelease = [[NSString alloc] initWithString:strRefreshEndTitle];
    textLoading = [[NSString alloc] initWithString:strRefreshLoading];
}

- (void)addPullToRefreshHeader
{
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowCallHistory.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [tableTopupHistory addSubview:refreshHeaderView];
}





@end
