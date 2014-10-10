//
//  ChargeViewController.m
//  Oye Dialer
//
//  Created by user on 24/06/13.
//
//

#import "ChargeViewController.h"
#import "GlobalData.h"
#import <QuartzCore/QuartzCore.h>
#import "RESTInteraction.h"
#import "Constants.h"
@interface ChargeViewController ()

@end

@implementation ChargeViewController

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
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChargedSucceed:) name:NOTIFICATION_ACCOUNT_CHARGED_SUCCESS object:nil];
    [self.view setBackgroundColor:[GlobalData getAppInfo].pageBgColor];
  
    //self.title = @"Recharge";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setMinimumFontSize:12.0];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor = [GlobalData getAppInfo].topBarTextColor;
    self.navigationItem.titleView = label;
    label.text = @"Recharge";
    
    //// Add Image on navigation bar right side
    UIButton *btnImage =[[UIButton alloc] init];
    [btnImage setBackgroundImage:[GlobalData getAppInfo].imgTopRightLogo forState:UIControlStateNormal];
    btnImage.userInteractionEnabled = NO;
    btnImage.frame = CGRectMake(100, 100, 40, 40);
    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithCustomView:btnImage];
    self.navigationItem.rightBarButtonItem = btnItem;
    btnSend.layer.borderColor = [[UIColor colorWithRed:22.0/255.0 green:46.0/255.0 blue:81.0/255.0 alpha:1.0] CGColor];
    btnSend.layer.borderWidth = 0.5;
    btnSend.layer.cornerRadius = 10;
    [btnSend setTitle:[GlobalData getAppInfo].send forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

-(void)accountChargedSucceed:(NSNotification *)notification
{
    NSMutableDictionary *dict = (NSMutableDictionary *)notification.object;
    [[[UIAlertView alloc]initWithTitle:@"Message" message:[dict valueForKey:@"ResultStr"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
//    if ([[dict valueForKey:@"ResultId"] integerValue] == 1)
//    {
//        
//    }else
//    {
//        [[UIAlertView alloc]initWithTitle:@"Message" message:[dict valueForKey:@"ResultStr"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)recharge:(id)sender
{
    if ([textAmount.text integerValue]>0) {
        hud = [[MBProgressHUD alloc]initWithView:self.view];
        hud.delegate=self;
        [self.view addSubview:hud];
        [hud showWhileExecuting:@selector(requestForChargeAccount) onTarget:self withObject:nil animated:TRUE];
        
    }else
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter valid amount" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

}

-(void)requestForChargeAccount
{
    [[RESTInteraction restInteractionManager] chargeAccount:textAmount.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
