//
//  TopUpConfirmationViewController.m
//  Oye
//
//  Created by user on 25/10/12.
//
//

#import "TopUpConfirmationViewController.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "RESTInteraction.h"
@interface TopUpConfirmationViewController ()

@end

@implementation TopUpConfirmationViewController
@synthesize topupInfo,operatorId,amtCharged,amountToSend,delegate;
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
    [btnCancel setBackgroundImage:[GlobalData getAppInfo].imgCancelBtn forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[GlobalData getAppInfo].imgSendBtn forState:UIControlStateNormal];
    [labelNumber setText:[GlobalData getAppInfo].number];
    [labelCountry setText:[GlobalData getAppInfo].country];
    [labelOperator setText:[GlobalData getAppInfo].operatorWithColon];
    [labelCustService setText:[GlobalData getAppInfo].custService];
    [labelCurrency setText:[GlobalData getAppInfo].currency];
    [labelAmount setText:[GlobalData getAppInfo].amount];
    [labelSentAmt setText:[GlobalData getAppInfo].sentAmount];
    [labelAmtCharged setText:[GlobalData getAppInfo].amountCharged];
    [labelTransId setText:[GlobalData getAppInfo].transId];
    [labelName setText:[NSString stringWithFormat:@"%@:",[GlobalData getAppInfo].name]];
    [labelTax setText:[GlobalData getAppInfo].tax];
    [btnConfirm setTitle:[GlobalData getAppInfo].confirmTransaction forState:UIControlStateNormal];
    [btnCancel setTitle:[GlobalData getAppInfo].cancel forState:UIControlStateNormal];
    [self.view setFrame:CGRectMake(0, 0, 320, 460)];
    
    //self.title = [GlobalData getAppInfo].topupConfirmation;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setMinimumFontSize:12.0];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor = [GlobalData getAppInfo].topBarTextColor;
    self.navigationItem.titleView = label;
    label.text = [GlobalData getAppInfo].topupConfirmation;
    
    //// Add Image on navigation bar right side
    UIButton *btnImage =[[UIButton alloc] init];
    [btnImage setBackgroundImage:[GlobalData getAppInfo].imgTopRightLogo forState:UIControlStateNormal];
    btnImage.userInteractionEnabled = NO;
    btnImage.frame = CGRectMake(100, 100, 40, 40);
    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithCustomView:btnImage];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    self.navigationController.navigationBar.tintColor = [GlobalData getAppInfo].topBarBgColor;
    
    btnConfirm.layer.borderColor = [[UIColor colorWithRed:22.0/255.0 green:46.0/255.0 blue:81.0/255.0 alpha:1.0] CGColor];
    btnConfirm.layer.borderWidth = 0.5;
    btnConfirm.layer.cornerRadius = 10;
    
    btnCancel.layer.borderColor = [[UIColor colorWithRed:22.0/255.0 green:46.0/255.0 blue:81.0/255.0 alpha:1.0] CGColor];
    btnCancel.layer.borderWidth = 0.5;
    btnCancel.layer.cornerRadius = 10;
    // Do any additional setup after loading the view from its nib.
    
    [self setData];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    
}

-(void)topUpConfirmationCompleted:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [loader removeFromSuperview];
    topupInfo = (TopupInfo *)[[notification userInfo] objectForKey:TOPUPINFO];
    if (topupInfo.ResultId == 1) {
        [self setData];
        btnConfirm.hidden = YES;
        [btnCancel setTitle:[GlobalData getAppInfo].close forState:UIControlStateNormal];
        [lblMessage setTextColor:[UIColor colorWithRed:17.0/255.0 green:102.0/255.0 blue:0.0/255.0 alpha:1.0]];
        lblMessage.hidden = NO;
        [lblMessage setText:topupInfo.ResultStr];
    }else
    {
        btnConfirm.hidden = YES;
        [btnCancel setTitle:[GlobalData getAppInfo].close forState:UIControlStateNormal];
        [lblMessage setTextColor:[UIColor colorWithRed:170.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
        lblMessage.hidden = NO;
        [lblMessage setText:topupInfo.ResultStr];
    }
    [delegate updateRecentsTransaction];
}

-(void)topUpConfirmationFailed:(NSNotification *)notification
{
    [loader removeFromSuperview];
    [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Failed to get response from server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
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

-(void)setData
{
    [lblNumber setText:topupInfo.MobileTelNo];
    [lblCountry setText:topupInfo.PostedCountry];
    [lblOperator setText:topupInfo.PostedOperator];
    [lblCurrency setText:topupInfo.PostedCurrencyCode];
    [lblCustService setText:[[topupInfo.PostedOperatorTelNo componentsSeparatedByString:@" "] objectAtIndex:0]];
    [lblAmtCharged setText:[NSString stringWithFormat:@"$ %@",amtCharged]];
    [lblAmount setText:[NSString stringWithFormat:@"%.2f",[topupInfo.PostedAmount floatValue]]];
    [lblTax setText:[NSString stringWithFormat:@"%.2f",[topupInfo.PostedTax floatValue]]];
    [lblSentAmt setText:[NSString stringWithFormat:@"%.2f",[topupInfo.PostedAmount floatValue]+[topupInfo.PostedTax floatValue]]];
    [lblTransId setText:topupInfo.mobilePaymentID];
}

-(IBAction)tapOnConfirm:(id)sender
{
    [self showLoader];
    [self performSelectorInBackground:@selector(proceedCharge) withObject:nil];
}

-(void)proceedCharge
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topUpConfirmationCompleted:) name:NOTIFICATION_CONFIRMATION_TOPUP_CHARGE_COMPLETED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topUpConfirmationFailed:) name:NOTIFICATION_CONFIRMATION_TOPUP_CHARGE_FAILED object:nil];
    NSString *strAmount = [NSString stringWithFormat:@"%f",amountToSend];
    [[RESTInteraction restInteractionManager] MakeTopupCharge:topupInfo.MobileTelNo PaymentId:topupInfo.mobilePaymentID amount:strAmount confirmationOrder:@"true" mobileOrderId:operatorId fromPage:[GlobalData getAppInfo].topupConfirmation];
}

-(IBAction)tapOnCancel:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
