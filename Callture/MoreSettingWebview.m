//
//  MoreSettingWebview.m
//  Oye Dialer
//
//  Created by user on 04/03/13.
//
//

#import "MoreSettingWebview.h"
#import "Constants.h"
#import "GlobalData.h"
@interface MoreSettingWebview ()

@end

@implementation MoreSettingWebview
@synthesize moreSetting,request;

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
    [self.view setBackgroundColor:[GlobalData getAppInfo].pageBgColor];
    //// Add Image on navigation bar right side
    UIButton *btnImage =[[UIButton alloc] init];
    [btnImage setBackgroundImage:[GlobalData getAppInfo].imgTopRightLogo forState:UIControlStateNormal];
    btnImage.userInteractionEnabled = NO;
    btnImage.frame = CGRectMake(100, 100, 40, 40);
    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithCustomView:btnImage];
    self.navigationItem.rightBarButtonItem = btnItem;
   
    //self.title = [GlobalData getAppInfo].moreOptions;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setMinimumFontSize:12.0];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor = [GlobalData getAppInfo].topBarTextColor;
    self.navigationItem.titleView = label;
    label.text = [GlobalData getAppInfo].moreOptions;
    //vishnu
    [moreSetting loadRequest:request];
    //vishnu
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request.URL scheme] isEqual:@"myapp"])
    {
        //vishnu
        isMoreOptionsScreen = NO;
        //vishnu
        [self.navigationController popViewControllerAnimated:YES];
        return NO; // Tells the webView not to load the URL
    }
    else
    {
        return YES; // Tells the webView to go ahead and load the URL
    }
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
    BOOL isEmpty = string==nil || [string length]==0;
    if (isEmpty) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [activity startAnimating];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
    BOOL isEmpty = string==nil || [string length]==0;
    if (isEmpty) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [activity stopAnimating];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
       [activity stopAnimating];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
