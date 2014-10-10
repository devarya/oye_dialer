//
//  AboutUsViewController.m
//  Oye
//
//  Created by user on 26/10/12.
//
//

#import "AboutUsViewController.h"
#import "Constants.h"
#import "UnderlineButton.h"
#import "GlobalData.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

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
    [imgLogo setImage:[GlobalData getAppInfo].imgLogo];
    //self.title = ABOUT_OYE;
   
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setMinimumFontSize:12.0];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor = [GlobalData getAppInfo].topBarTextColor;
    self.navigationItem.titleView = label;
    label.text = ABOUT_OYE;
    
    //// Add Image on navigation bar right side
    UIButton *btnImage =[[UIButton alloc] init];
    [btnImage setBackgroundImage:[GlobalData getAppInfo].imgTopRightLogo forState:UIControlStateNormal];
    btnImage.userInteractionEnabled = NO;
    btnImage.frame = CGRectMake(100, 100, 40, 40);
    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithCustomView:btnImage];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    //self.navigationItem.
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
    
    //self.navigationController.navigationBar.tintColor = [GlobalData getAppInfo].topBarBgColor;
    
    
    lblAppVersion.text = [NSString stringWithFormat:@"%@: %@",[GlobalData getAppInfo].version,[GlobalData getApp_Version]];
    lblCS_Phone.text = [NSString stringWithFormat:@"%@: %@",[GlobalData getAppInfo].customerService,[GlobalData getAppInfo].CS_Phone];
    lblAppDescription.text = [GlobalData getAppInfo].appDescription;
    CGSize constraintSize, offset1;
    constraintSize.width  = 300.0f;
    constraintSize.height = MAXFLOAT;
    
    NSString * btnText = [GlobalData getAppInfo].webSite;
    
    
    UnderlineButton * myButton = [UnderlineButton buttonWithType:UIButtonTypeCustom];
    offset1                    = [btnText sizeWithFont:[UIFont boldSystemFontOfSize:15]
                                     constrainedToSize:constraintSize
                                         lineBreakMode:UILineBreakModeTailTruncation];
    myButton.frame = CGRectMake((320/2-offset1.width/2), 198, offset1.width, 21);
    [myButton setTitle:btnText forState:UIControlStateNormal];
    
    [myButton setTitleColor:[UIColor colorWithRed:58.0/255.0 green:110.0/255.0 blue:199.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [myButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [myButton addTarget:self action:@selector(gotoWebSite:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myButton];
    
    //<marquee bgcolor="orange" direction=up width=100 height=50>Text will Move</marquee>
    NSString *myHTML =[NSString stringWithFormat:@"<html><body><p1><font face=\"Helvetica\"> <marquee scrollamount=1 direction=up width=100%% height=100%%>%@</marquee></font></p1></body></html>",[GlobalData getAppInfo].aboutText];
    [webview loadHTMLString:myHTML baseURL:nil];
    
    [GlobalData getAppInfo].copyright = [[GlobalData getAppInfo].copyright stringByReplacingOccurrencesOfString:@"&copy;" withString:@"\u00A9"];
    [lblCopyRight setText:[GlobalData getAppInfo].copyright];
// Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    
}

-(IBAction)gotoWebSite:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%@",btn.titleLabel.text);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",btn.titleLabel.text]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
