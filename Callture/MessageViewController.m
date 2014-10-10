//
//  MessageViewController.m
//  Oye Dialer
//
//  Created by user on 10/06/13.
//
//

#import "MessageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalData.h"
@interface MessageViewController ()
{

}
@end

@implementation MessageViewController
@synthesize wView,urlRequest;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [activity stopAnimating];
    [btnSend setBackgroundImage:[GlobalData getAppInfo].imgSendBtn forState:UIControlStateNormal];
    [self.view setBackgroundColor:[GlobalData getAppInfo].pageBgColor];
    
   // self.title = @"New Message";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setMinimumFontSize:12.0];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor = [GlobalData getAppInfo].topBarTextColor;
    self.navigationItem.titleView = label;
    label.text = @"New Message";
    
    //// Add Image on navigation bar right side
    UIButton *btnImage =[[UIButton alloc] init];
    [btnImage setBackgroundImage:[GlobalData getAppInfo].imgTopRightLogo forState:UIControlStateNormal];
    btnImage.userInteractionEnabled = NO;
    btnImage.frame = CGRectMake(100, 100, 40, 40);
    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithCustomView:btnImage];
    self.navigationItem.rightBarButtonItem = btnItem;
    if ([GlobalData getAppInfo].messagePage)
    {
        wView.hidden = NO;
    }
    else
    {
        wView.hidden = YES;
    }
    viewPhoneNumber.shadowRadius = 2;
    viewPhoneNumber.cornerRadius = 5;
    viewPhoneNumber.shadowMask = YIInnerShadowMaskAll;
    
    viewMessage.shadowRadius = 2;
    viewMessage.cornerRadius = 5;
    viewMessage.shadowMask = YIInnerShadowMaskAll;
    [textview setPlaceholder:@"Your SMS Messsage"];
    [textview setPlaceholderTextColor:[UIColor lightGrayColor]];
    
    btnSend.layer.borderColor = [[UIColor colorWithRed:22.0/255.0 green:46.0/255.0 blue:81.0/255.0 alpha:1.0] CGColor];
    btnSend.layer.borderWidth = 0.5;
    btnSend.layer.cornerRadius = 10;
    [btnSend setTitle:[GlobalData getAppInfo].send forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
    //vishnu
    [wView loadRequest:urlRequest];
    //vishnu
}

-(void)viewDidAppear:(BOOL)animated
{
    scrollview.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        //vishnu
        isMessageScreen = NO;
        //vishnu
    }
    [super viewWillDisappear:animated];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([GlobalData getAppInfo].messagePage)
    {
        if ([[request.URL scheme] isEqual:@"myapp"])
        {
            //vishnu
            isMessageScreen = NO;
            //vishnu
            [self.navigationController popViewControllerAnimated:YES];
            return NO; // Tells the webView not to load the URL
        }
        else
        {
            return YES; // Tells the webView to go ahead and load the URL
        }
    }
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([GlobalData getAppInfo].messagePage)
    {
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
    BOOL isEmpty = string==nil || [string length]==0;
    if (isEmpty) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [activity startAnimating];
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([GlobalData getAppInfo].messagePage)
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
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([GlobalData getAppInfo].messagePage)
    {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];

    [activity stopAnimating];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
