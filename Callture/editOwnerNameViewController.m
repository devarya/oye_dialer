//
//  editOwnerNameViewController.m
//  Oye Dialer
//
//  Created by user on 23/07/13.
//
//

#import "editOwnerNameViewController.h"
#import "GlobalData.h"
#import <QuartzCore/QuartzCore.h>
@implementation editOwnerNameViewController
@synthesize strOwnerName,delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btnImage =[[UIButton alloc] init];
    [btnImage setBackgroundImage:[GlobalData getAppInfo].imgTopRightLogo forState:UIControlStateNormal];
    btnImage.userInteractionEnabled = NO;
    btnImage.frame = CGRectMake(100, 100, 40, 40);
    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithCustomView:btnImage];
    self.navigationItem.rightBarButtonItem = btnItem;
    viewOwnerName.layer.cornerRadius = 5.0;
    viewOwnerName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    viewOwnerName.layer.borderWidth = 0.5;
    [self.view setBackgroundColor:[GlobalData getAppInfo].pageBgColor];
    tFieldName.text = strOwnerName;
    btnClear.hidden = NO;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (tFieldName.text.length>0) {
        [delegate setOwnerName:tFieldName.text];
    }else
    {
        [delegate setOwnerName:strOwnerName];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];

    [tFieldName becomeFirstResponder];
   // self.navigationItem.title = [GlobalData getAppInfo].name;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setMinimumFontSize:12.0];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor = [GlobalData getAppInfo].topBarTextColor;
    self.navigationItem.titleView = label;
    label.text = [GlobalData getAppInfo].name;
}

-(IBAction)btnClearTextClicked:(id)sender
{
    tFieldName.placeholder = strOwnerName;
    tFieldName.text = @"";
    btnClear.hidden = YES;
    [tFieldName becomeFirstResponder];
}

-(IBAction)textChangedOnTouch:(id)sender
{
    btnClear.hidden = NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [delegate setOwnerName:tFieldName.text];
    
    [self.navigationController popViewControllerAnimated: YES];
    return YES;
}

@end
