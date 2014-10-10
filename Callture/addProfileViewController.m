//
//  addProfileViewController.m
//  Callture
//
//  Created by Manish on 14/12/11.
//  Copyright (c) 2011 Aryavrat Infotech Pvt. All rights reserved.
//
#define SCROLLVIEW_HEIGHT 460
#define SCROLLVIEW_WIDTH  320

#define SCROLLVIEW_CONTENT_HEIGHT 720
#define SCROLLVIEW_CONTENT_WIDTH  320
#import "addProfileViewController.h"
#import "RESTInteraction.h"
#import "GlobalData.h"
#import "LineListData.h"
#import "callDialerViewController.h"
#import "GradientView.h"
#import "OptionTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomCellBackgroundView.h"
#import "CallOptionView.h"
#import "Constants.h"
#import "AboutUsViewController.h"
#import "webViewPopup.h"
#import "InviteFriendViewController.h"
#import "AddFundsViewController.h"
#import "MoreSettingWebview.h"
#import "MessageViewController.h"
static addProfileViewController *curViewController;
@implementation addProfileViewController
@synthesize mytable,isADDBtn,btnBg,canshow,delegate;

+ (addProfileViewController*)currentView
{
    return curViewController;
}
+ (void)setCurrentView:(addProfileViewController*)newView
{
    if(curViewController != newView)
	{
		curViewController = newView;
	}
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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Memory Warning in addProfileViewController" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    [self.view setBackgroundColor:[GlobalData getAppInfo].pageBgColor];
    if([GlobalData getAppInfo].urlOptionsPage)
    {
        webViewOptionsPage.hidden = NO;
        NSString *urlStr;
        if (![GlobalData isNetworkAvailable])
        {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        }
        urlStr = [GlobalData getAppInfo].urlOptionsPage;
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[UserName]" withString:[GlobalData UserName]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[key]" withString:[GlobalData ApiKey]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppName]" withString:[GlobalData getApp_Name]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppPlatform]" withString:[GlobalData getApp_Platform]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[LineNo]" withString:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[TellNo]" withString:[GlobalData GetRegisterPhoneno]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Lang]" withString:[[NSLocale preferredLanguages] objectAtIndex:0]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *strWebsiteUrl = [NSString stringWithFormat:@"%@",urlStr];
        NSURL *url = [NSURL URLWithString:strWebsiteUrl];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [webViewOptionsPage loadRequest:requestObj];
        
        self.navigationController.navigationBar.hidden = YES;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linelistUpdated) name:NOTIFICATION_CALLBACKLINELIST_UPDATED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linelistFailed) name:NOTIFICATION_CALLBACKLINELIST_FAILED object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sipConnected) name:NOTIFICATION_SIP_CONNECTED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sipConnectionFailed) name:NOTIFICATION_SIP_CONNECT_FAILED object:nil];
        
        isLoaded = YES;
        isModified = NO;
        mytable.sectionHeaderHeight = 5;
        mytable.sectionFooterHeight = 0;
        
       // self.title = [GlobalData getAppInfo].options;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        label.backgroundColor = [UIColor clearColor];
        [label setMinimumFontSize:12.0];
        label.font = [UIFont boldSystemFontOfSize:18.0];
        label.textAlignment = UITextAlignmentCenter;
        label.adjustsFontSizeToFitWidth=YES;
        label.textColor = [GlobalData getAppInfo].topBarTextColor;
        self.navigationItem.titleView = label;
        label.text = [GlobalData getAppInfo].options;
        
        //self.navigationItem.
        
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
            //self.navigationController.navigationBar.translucent = NO;
        }
        else
        {
            self.navigationController.navigationBar.tintColor = [GlobalData getAppInfo].topBarBgColor;
        }
        
        //self.navigationController.navigationBar.tintColor = [GlobalData getAppInfo].topBarBgColor;
        
        
        UIView *container = [[UIView alloc]initWithFrame:CGRectMake(252, 6, 65, 25)];
        UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLogout setBackgroundImage:[GlobalData getAppInfo].imgLogout forState:UIControlStateNormal];
        [btnLogout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        btnLogout.frame = container.bounds;
        [container addSubview:btnLogout];
        [tblHeaderView addSubview:container];
        
        // UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithCustomView:container];
        // self.navigationItem.rightBarButtonItem = flipButton;
        // [flipButton release];
        
        
        [self.mytable.layer setShadowColor:[[UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0] CGColor]];
        [self.mytable.layer setShadowOffset:CGSizeMake(0, 0)];
        [self.mytable.layer setShadowRadius:2.0];
        [self.mytable.layer setShadowOpacity:1];
        mytable.clipsToBounds = NO;
        mytable.layer.masksToBounds = NO;
        mytable.backgroundView = nil;
        mytable.backgroundColor = [UIColor clearColor];
        mytable.layer.cornerRadius = 5.0;
        mytable.layer.masksToBounds = YES;
        mytable.clipsToBounds = YES;
        
        UILabel *lblPhoneNo = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
        [lblPhoneNo setBackgroundColor:[UIColor clearColor]];
        [lblPhoneNo setText:[GlobalData getAppInfo].phoneNo];
        [lblPhoneNo setFont:[UIFont systemFontOfSize:17]];
        lblPhoneNoValue = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 150, 20)];
        [lblPhoneNoValue setBackgroundColor:[UIColor clearColor]];
        [lblPhoneNoValue setText:[GlobalData GetRegisterPhoneno]];
        [lblPhoneNoValue setFont:[UIFont boldSystemFontOfSize:17]];
        
        lblPhoneNoValue.textColor = [GlobalData getAppInfo].pageTextColor;
        
        UILabel *lblBalance = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 100, 20)];
        [lblBalance setBackgroundColor:[UIColor clearColor]];
        [lblBalance setText:[GlobalData getAppInfo].Balance];
        [lblBalance setFont:[UIFont systemFontOfSize:17]];
        lblBalanceValue = [[UILabel alloc]initWithFrame:CGRectMake(130, 40, 150, 20)];
        [lblBalanceValue setBackgroundColor:[UIColor clearColor]];
        
        lblBalanceValue.textColor = [GlobalData getAppInfo].pageTextColor;
        lblPhoneNo.textColor = [GlobalData getAppInfo].pageTextColor;
        lblBalance.textColor = [GlobalData getAppInfo].pageTextColor;
        
        
        [lblBalanceValue setFont:[UIFont boldSystemFontOfSize:17]];
        
        [tblHeaderView addSubview:lblPhoneNo];
        [tblHeaderView addSubview:lblPhoneNoValue];
        [tblHeaderView addSubview:lblBalance];
        [tblHeaderView addSubview:lblBalanceValue];
    }
}

-(void)sipConnected
{
    [self performSelector:@selector(hideLoader) withObject:nil afterDelay:0.2];
}

-(void)sipConnectionFailed
{
    [self performSelector:@selector(hideLoader) withObject:nil afterDelay:0.2];
}

-(void)linelistUpdated
{
    isLineListDataLoading = NO;
    [loader removeFromSuperview];
    [self refreshData];
}

-(void)linelistFailed
{
    isLineListDataLoading = NO;
    [loader removeFromSuperview];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Register for the events
    if (callOptView) {
        [callOptView removeFromSuperview];
        callOptView = nil;
    }
    if (isLoaded && !isLineListDataLoading)
    {
        [self performSelectorInBackground:@selector(getLineListData) withObject:nil];
    }
}



-(void)getLineListData
{
    if ([GlobalData isNetworkAvailable])
    {
        isLineListDataLoading = YES;
        [[RESTInteraction restInteractionManager]getCallBackLinesList:[GlobalData ClientID]];
    }else
    {
        [self performSelectorOnMainThread:@selector(showMessage:) withObject:[GlobalData getAppInfo].networkNotAvailable waitUntilDone:NO];
    }
}

-(void)showMessage:(NSString *)msg
{
    [[[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

-(void)refreshData
{
    if (isLoaded) {
        [lblPhoneNoValue setText:[GlobalData GetRegisterPhoneno]];
        if ([[GlobalData GetCallBackLineList] count]>0) {
            LineListData *lld = [[GlobalData GetCallBackLineList] objectAtIndex:0];
            float balance = [[lld Balance] floatValue];
            [lblBalanceValue setText:[NSString stringWithFormat:@"$ %.02f",balance]];
        }else
        {
            [lblBalanceValue setText:@""];
        }
    }
    
    [addProfileViewController setCurrentView:self];
    [mytable reloadData];
	//Initially the keyboard is hidden
	keyboardVisible = NO;
    canshow=YES;
}


-(void)logout
{
    [delegate logout];
}

-(void) viewWillDisappear:(BOOL)animated
{
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(void)showLoader
{
    if (![self.view.subviews containsObject:loader]) {
        loader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
        [loader setBackgroundColor:[UIColor blackColor]];
        [loader setAlpha:0.5];
        UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        aiv.frame = CGRectMake(135, 160, 50, 50);
        [aiv startAnimating];
        [loader addSubview:aiv];
        [self.view addSubview:loader];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

///////////////////////////////////////vishnu/////////////////////////////////////////
-(void)gotoAddFundScreen{
    
    
    NSString *urlStr;
    if (![GlobalData isNetworkAvailable])
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    isAddFundScreen = YES;
    urlStr = [GlobalData getAppInfo].addFundsPage;
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[UserName]" withString:[GlobalData UserName]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[key]" withString:[GlobalData ApiKey]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppName]" withString:[GlobalData getApp_Name]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppPlatform]" withString:[GlobalData getApp_Platform]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[LineNo]" withString:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[TellNo]" withString:[GlobalData GetRegisterPhoneno]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Lang]" withString:[[NSLocale preferredLanguages] objectAtIndex:0]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Country]" withString:[GlobalData GetCountryName]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[CLID]" withString:[GlobalData ClientID]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AddFundsViewController *addFundsView = [[AddFundsViewController alloc]initWithNibName:@"AddFundsViewController" bundle:nil];
    //addFundsView.navigationController.navigationBar.hidden = YES;
    
    
    NSString *strWebsiteUrl = [NSString stringWithFormat:@"%@",urlStr];
    NSURL *url = [NSURL URLWithString:strWebsiteUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    addFundsView.request = requestObj;
    [self.navigationController pushViewController:addFundsView animated:YES];
}
-(void)gotoCallOptionScreen{
    
    isCallOptionScreen = YES;
    covc = [[CallOptionViewController alloc]initWithNibName:@"CallOptionViewController" bundle:nil];
    [self.navigationController pushViewController:covc animated:YES];
}
-(void)gotoMessageScreen{
    
    
    NSString *urlStr;
    if ([GlobalData getAppInfo].messagePage) {
        if (![GlobalData isNetworkAvailable])
        {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        }
        isMessageScreen = YES;
        urlStr = [GlobalData getAppInfo].messagePage;
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[UserName]" withString:[GlobalData UserName]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[key]" withString:[GlobalData ApiKey]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppName]" withString:[GlobalData getApp_Name]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppPlatform]" withString:[GlobalData getApp_Platform]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[LineNo]" withString:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[TellNo]" withString:[GlobalData GetRegisterPhoneno]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Lang]" withString:[[NSLocale preferredLanguages] objectAtIndex:0]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Country]" withString:[GlobalData GetCountryName]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[CLID]" withString:[GlobalData ClientID]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        MessageViewController *mvc = [[MessageViewController alloc] init];
        NSString *strWebsiteUrl = [NSString stringWithFormat:@"%@",urlStr];
        NSURL *url = [NSURL URLWithString:strWebsiteUrl];
        mvc.urlRequest = [NSURLRequest requestWithURL:url];
        [self.navigationController pushViewController:mvc animated:YES];
    }else
    {
        isMessageScreen = YES;
        MessageViewController *mvc = [[MessageViewController alloc] init];
        [self.navigationController pushViewController:mvc animated:YES];
    }
    
}
-(void)gotoCallRatesScreen{
    
    
    if (![GlobalData isNetworkAvailable])
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    isCallRatesScreen = YES;
    getRatesViewController *getRatesView = [getRatesViewController new];
    getRatesView.delegate = self;
    [self.navigationController pushViewController:getRatesView animated:YES];
    getRatesView = nil;
}

-(void)gotoInviteFriendsScreen{
    
    isInviteFriendsScreen = YES;
    [self.navigationController pushViewController:[InviteFriendViewController new] animated:YES];
}

-(void)gotoMoreOptionsScreen{
    
    NSString *urlStr;
    if (![GlobalData isNetworkAvailable])
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    isMoreOptionsScreen = YES;
    urlStr = [GlobalData getAppInfo].LoginPage;
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[UserName]" withString:[GlobalData UserName]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[key]" withString:[GlobalData ApiKey]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppName]" withString:[GlobalData getApp_Name]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppPlatform]" withString:[GlobalData getApp_Platform]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[LineNo]" withString:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[TellNo]" withString:[GlobalData GetRegisterPhoneno]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Lang]" withString:[[NSLocale preferredLanguages] objectAtIndex:0]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Country]" withString:[GlobalData GetCountryName]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[CLID]" withString:[GlobalData ClientID]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MoreSettingWebview *moresettingwenview = [[MoreSettingWebview alloc]initWithNibName:@"MoreSettingWebview" bundle:nil];
    moresettingwenview.navigationController.navigationBar.hidden = YES;
    
    
    NSString *strWebsiteUrl = [NSString stringWithFormat:@"%@",urlStr];
    NSURL *url = [NSURL URLWithString:strWebsiteUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    moresettingwenview.request = requestObj;
    [self.navigationController pushViewController:moresettingwenview animated:YES];

}
///////////////////////////////////////vishnu/////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	NSString *str = cell.textLabel.text;  
    NSString *urlStr;
    if ([str isEqualToString:[GlobalData getAppInfo].messages])
    {
        isMessageScreen = YES;
        if ([GlobalData getAppInfo].messagePage) {
            if (![GlobalData isNetworkAvailable])
            {
                [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                return;
            }
            urlStr = [GlobalData getAppInfo].messagePage;
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[UserName]" withString:[GlobalData UserName]];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[key]" withString:[GlobalData ApiKey]];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppName]" withString:[GlobalData getApp_Name]];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppPlatform]" withString:[GlobalData getApp_Platform]];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[LineNo]" withString:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO]];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[TellNo]" withString:[GlobalData GetRegisterPhoneno]];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Lang]" withString:[[NSLocale preferredLanguages] objectAtIndex:0]];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Country]" withString:[GlobalData GetCountryName]];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[CLID]" withString:[GlobalData ClientID]];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
            urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            MessageViewController *mvc = [[MessageViewController alloc] init];
            NSString *strWebsiteUrl = [NSString stringWithFormat:@"%@",urlStr];
            NSURL *url = [NSURL URLWithString:strWebsiteUrl];
            mvc.urlRequest = [NSURLRequest requestWithURL:url];
            [self.navigationController pushViewController:mvc animated:YES];
        }else
        {
            MessageViewController *mvc = [[MessageViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }
        
    }else
    if ([str isEqualToString:[GlobalData getAppInfo].addFunds])
    {
        if (![GlobalData isNetworkAvailable])
        {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        }
        urlStr = [GlobalData getAppInfo].addFundsPage;
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[UserName]" withString:[GlobalData UserName]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[key]" withString:[GlobalData ApiKey]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppName]" withString:[GlobalData getApp_Name]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppPlatform]" withString:[GlobalData getApp_Platform]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[LineNo]" withString:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[TellNo]" withString:[GlobalData GetRegisterPhoneno]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Lang]" withString:[[NSLocale preferredLanguages] objectAtIndex:0]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Country]" withString:[GlobalData GetCountryName]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[CLID]" withString:[GlobalData ClientID]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        AddFundsViewController *addFundsView = [[AddFundsViewController alloc]initWithNibName:@"AddFundsViewController" bundle:nil];
        //addFundsView.navigationController.navigationBar.hidden = YES;
        
        
        NSString *strWebsiteUrl = [NSString stringWithFormat:@"%@",urlStr];
        NSURL *url = [NSURL URLWithString:strWebsiteUrl];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        addFundsView.request=requestObj;
        [self.navigationController pushViewController:addFundsView animated:YES];
        //[addFundsView.wView loadRequest:requestObj];
    }else if([str isEqualToString:[GlobalData getAppInfo].topUps])
    {
        self.tabBarController.selectedIndex = 2;
    }
	else
    if([str isEqualToString:[GlobalData getAppInfo].moreOptions])
    {
        if (![GlobalData isNetworkAvailable])
        {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        }
        urlStr = [GlobalData getAppInfo].LoginPage;
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[UserName]" withString:[GlobalData UserName]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[key]" withString:[GlobalData ApiKey]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppName]" withString:[GlobalData getApp_Name]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[AppPlatform]" withString:[GlobalData getApp_Platform]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[LineNo]" withString:[[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[TellNo]" withString:[GlobalData GetRegisterPhoneno]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Lang]" withString:[[NSLocale preferredLanguages] objectAtIndex:0]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[Country]" withString:[GlobalData GetCountryName]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"[CLID]" withString:[GlobalData ClientID]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        MoreSettingWebview *moresettingwenview = [[MoreSettingWebview alloc]initWithNibName:@"MoreSettingWebview" bundle:nil];
        moresettingwenview.navigationController.navigationBar.hidden = YES;

        
        NSString *strWebsiteUrl = [NSString stringWithFormat:@"%@",urlStr];
        NSURL *url = [NSURL URLWithString:strWebsiteUrl];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        moresettingwenview.request=requestObj;
        [self.navigationController pushViewController:moresettingwenview animated:YES];
        //[moresettingwenview.moreSetting loadRequest:requestObj];
 
   
    }
    else
    if([str isEqualToString:[GlobalData getAppInfo].followUs])
    {
        if (![GlobalData isNetworkAvailable])
        {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        }
        callOptView = [[CallOptionView alloc]initWithFrame:self.view.bounds tableFram:CGRectMake(0, 0, 290, 44*[[GlobalData GetShareOption] count]+20)];
        callOptView.section = [GlobalData getAppInfo].followUs;
        callOptView.center = self.view.center;
        callOptView.dataList = [GlobalData GetShareOption];
        //callOptView.selectedData = profileData.profile_calltype;
        callOptView.delegate = self;
        [self.view addSubview:callOptView];
        
    }else if([str isEqualToString:[GlobalData getAppInfo].callRates])
    {
        if (![GlobalData isNetworkAvailable])
        {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        }
        getRatesViewController *getRatesView = [getRatesViewController new];
        getRatesView.delegate = self;
        [self.navigationController pushViewController:getRatesView animated:YES];
        getRatesView = nil;
    }else if([str isEqualToString:[GlobalData getAppInfo].callOptions])
    {
        covc = [[CallOptionViewController alloc]initWithNibName:@"CallOptionViewController" bundle:nil];
        [self.navigationController pushViewController:covc animated:YES];
    }
    else if([str isEqualToString:[GlobalData getAppInfo].aboutText])
    {
        //[[RESTInteraction restInteractionManager] GetAboutUsDetail];
        [self.navigationController pushViewController:[AboutUsViewController new] animated:YES];
    }else if ([str isEqualToString:[GlobalData getAppInfo].inviteFriends])
    {
        [self.navigationController pushViewController:[InviteFriendViewController new] animated:YES];
    }
}

-(void)sip_Cleanup
{
    //[delegate sip_Cleanup];
}

-(void)sip_Connect
{
    //[delegate sip_Connect];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 7;
    
    if (![GlobalData getAppInfo].showTopUps) {
        count--;
    }
    if (![GlobalData getAppInfo].showMessage) {
        count--;
    }
    if (![GlobalData getAppInfo].showAddFunds) {
        count--;
    }
    if (![GlobalData getAppInfo].showInviteFriends) {
        count--;
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    OptionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[OptionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *accessorImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
        cell.accessoryView = accessorImg;
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg-Option.png"]];
    }
    
    CustomCellBackgroundViewPosition pos;
	
	pos = CustomCellBackgroundViewPositionBottom;
	
	if (indexPath.row == 0) {
		pos = CustomCellBackgroundViewPositionTop;
	} else {
		if (indexPath.row < 4) {
			pos = CustomCellBackgroundViewPositionMiddle;
		}
	}
    
    CustomCellBackgroundView *bkgView = [[CustomCellBackgroundView alloc] initWithFrame:cell.frame];
    bkgView.borderColor = [UIColor clearColor];
	bkgView.fillColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OptionsPage_bg.png"]];//[[cellListForSection
	
    
	bkgView.position = pos;
	cell.selectedBackgroundView = bkgView;
    
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    cell.textLabel.textColor = [GlobalData getAppInfo].dataViewTextColor;
    
    switch (indexPath.row)
    {
        case 0:
            if ([GlobalData getAppInfo].showAddFunds)
            {
                [cell.textLabel setText:[GlobalData getAppInfo].addFunds];
            }else
            {
                [cell.textLabel setText:[GlobalData getAppInfo].callOptions];
            }
            break;
        case 1:
            if ([GlobalData getAppInfo].showAddFunds)
            {
                [cell.textLabel setText:[GlobalData getAppInfo].callOptions];
            }else
            {
                if([GlobalData getAppInfo].showTopUps)
                {
                    [cell.textLabel setText:[GlobalData getAppInfo].topUps];
                }
                else
                {
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].messages];
                    }
                    else
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].callRates];
                    }
                }
            }
            break;
        case 2:
            if ([GlobalData getAppInfo].showAddFunds)
            {
                if([GlobalData getAppInfo].showTopUps)
                {
                    [cell.textLabel setText:[GlobalData getAppInfo].topUps];
                }
                else
                {
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].messages];
                    }
                    else
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].callRates];
                        
                    }
                }
            }
            else
            {
                if ([GlobalData getAppInfo].showTopUps)
                {
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].messages];
                    }
                    else
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].callRates];
                    }
                    
                }
                else
                {
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].callRates];
                    }
                    else
                    {
                        if ([GlobalData getAppInfo].showInviteFriends)
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].inviteFriends];
                        }else
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                        }
                    }
                    
                    
                }
            }
            break;
        case 3:
            if ([GlobalData getAppInfo].showAddFunds)
            {
                if([GlobalData getAppInfo].showTopUps)
                {
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].messages];
                    }else
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].callRates];
                    }
                }
                else
                {
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].callRates];
                    }else
                    {
                        if ([GlobalData getAppInfo].showInviteFriends)
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].inviteFriends];
                        }else
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                        }
                    }
                }
            }
            else
            {
                if([GlobalData getAppInfo].showTopUps)
                {
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].callRates];
                    }else
                    {
                        if ([GlobalData getAppInfo].showInviteFriends)
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].inviteFriends];
                        }else
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                        }
                    }
                }
                else{
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        if ([GlobalData getAppInfo].showInviteFriends)
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].inviteFriends];
                        }else
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                        }
                    }else
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                    }
                }
            }
            break;
        case 4:
            if ([GlobalData getAppInfo].showAddFunds)
            {
                if([GlobalData getAppInfo].showTopUps)
                {
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].callRates];
                    }else
                    {
                        if ([GlobalData getAppInfo].showInviteFriends)
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].inviteFriends];
                        }else
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                        }
                    }
                }
                else{
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        if ([GlobalData getAppInfo].showInviteFriends)
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].inviteFriends];
                        }else
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                        }
                    }else
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                        
                    }
                }
            }else
            {
                if([GlobalData getAppInfo].showTopUps)
                {
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        if ([GlobalData getAppInfo].showInviteFriends)
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].inviteFriends];
                        }
                        else
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                        }
                        
                    }else
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                    }
                }
                else{
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                    }
                }
            }
            break;
        case 5:
            if ([GlobalData getAppInfo].showAddFunds)
            {
                if([GlobalData getAppInfo].showTopUps)
                {
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        if ([GlobalData getAppInfo].showInviteFriends)
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].inviteFriends];
                        }
                        else
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                        }
                    }else
                    {
                        if ([GlobalData getAppInfo].showInviteFriends)
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                        }
                    }
                }
                else
                {
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        if ([GlobalData getAppInfo].showInviteFriends)
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                        }
                    }
                }
            }else
            {
                if([GlobalData getAppInfo].showTopUps)
                {
                    if ([GlobalData getAppInfo].showMessage)
                    {
                        if ([GlobalData getAppInfo].showInviteFriends)
                        {
                            [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
                        }
                    }
                }
            }
            break;
        case 6:
            [cell.textLabel setText:[GlobalData getAppInfo].moreOptions];
            break;
        default:
            break;
            
    }
    return cell;
}


-(void)updateData:(NSString *)data section:(NSString *)section
{
    [self showLoader];
    [callOptView removeFromSuperview];
    callOptView = nil;
    BOOL isSipConnecting = NO;
    if (data) {
        if ([section isEqualToString:[GlobalData getAppInfo].followUs]) {
            if ([data isEqualToString:LIKE_US_ON_FACEBOOK]) {
                facebookPopup = [[webViewPopup alloc] initWithURL:[GlobalData getAppInfo].facebookPage params:nil isViewInvisible:YES];
                [facebookPopup show];
            }else if ([data isEqualToString:LIKE_US_ON_TWITTER]) {
                facebookPopup = [[webViewPopup alloc] initWithURL:[GlobalData getAppInfo].TwitterPage params:nil isViewInvisible:YES];
                [facebookPopup show];
            }
        }
    }
    if (!isSipConnecting) {
        [self performSelector:@selector(hideLoader) withObject:nil afterDelay:0.2];
    }

}

-(void)hideLoader
{
    [loader removeFromSuperview];
}

-(void)gotoContact:(NSString *)onPage
{
    [delegate gotoNativeContacts:onPage];
}

@end
