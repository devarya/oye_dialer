//
//  callDialerViewController.m
//  Callture
//
//  Created by Manish on 17/02/12.
//  Copyright (c) 2012 Aryavrat Infotech Pvt. Ltd. All rights reserved.
//

#import "callDialerViewController.h"
#import "GlobalData.h"
#import "RESTInteraction.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "callLogonViewController.h"
#import "Constants.h"
#import "addProfileViewController.h"
#import "SipManager.h"
static callDialerViewController *curViewController;
@implementation callDialerViewController
@synthesize dialStr,callingTimer;
@synthesize dialString;
@synthesize phoneCallDelegate;
+ (callDialerViewController*)currentView
{
	return curViewController;
}

+ (void)setCurrentView:(callDialerViewController*)newView
{
    if (curViewController) {
        if(curViewController != newView)
        {
            curViewController = nil;
            [curViewController release];
            curViewController = newView;
        }
    }else
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
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

    if ([SipManager voipManager].selectedNum && [SipManager voipManager].selectedNum.length>0) {
        dialString = [[SipManager voipManager].selectedNum mutableCopy];
        lblDialNumber.text = dialString;
        [SipManager voipManager].selectedNum = @"";
    }
    if (timer != nil)
        [timer invalidate];
    timer = nil;
    if (logViewController) {
        CGRect rect = self.view.bounds;
        rect.origin.y -= self.view.frame.size.height;
        [logViewController.view setFrame:rect];
    }
    [callDialerViewController setCurrentView:self];
    
    /////balance
    LineListData *lld = [[GlobalData GetCallBackLineList] objectAtIndex:0];
    float balance = [[lld Balance] floatValue];
    [balancekeyboard setText:[NSString stringWithFormat:@"$ %.02f",balance]];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:USE_WIFI_IFAVAILABLE] isEqualToString:@"YES"] && [GlobalData isReachableViaWiFi]) {
        calloptions.text=SIP_VOIP;
    }else
    {
        calloptions.text=[[NSUserDefaults standardUserDefaults] valueForKey:CALLOPTION1];
    }
    [addprofile getLineListData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblDialNumber.textColor = [GlobalData getAppInfo].colDialerDialText;
    
    if (IS_IPHONE_5) {
        [imgDialer setImage:[GlobalData getAppInfo].imgDialer5];
    }else
    {
        [imgDialer setImage:[GlobalData getAppInfo].imgDialer4];
    }
    lblBalance.text = [GlobalData getAppInfo].Balance;
    
    lblBalance.textColor = [GlobalData getAppInfo].colDialerText;
    balancekeyboard.textColor = [GlobalData getAppInfo].colDialerText;
    calloptions.textColor = [GlobalData getAppInfo].colDialerText;
    
    lblDialNumber.delegate = self;
    NSString *lastDialedString = [[NSUserDefaults standardUserDefaults] valueForKey:LAST_DIALED_NUMBER];
    if (lastDialedString && lastDialedString.length>0) {
        dialString = @"";
    }else
    {
        dialString = @"";
        [[NSUserDefaults standardUserDefaults] setValue:dialString forKey:LAST_DIALED_NUMBER];
    }
    
}

-(void)pasteData:(NSString *)str
{
    if(str != nil){
        dialString = [[NSString stringWithString:str] retain];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateCallBackStatus:(NSString *)msg
{
    [loader removeFromSuperview];
    [loader release];
    if(msg!=nil)
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    [[NSUserDefaults standardUserDefaults] setValue:dialString forKey:LAST_DIALED_NUMBER];
    dialString=@"";
    lblDialNumber.text = dialString;
}
-(void)playSound:(NSString *)file{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"wav"];
    if (path) {
        AVAudioPlayer *sound =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
        sound.delegate=self;
        sound.volume = 0.1;
        [sound play] ;
    }else
    {
        path = [[NSBundle mainBundle] pathForResource:file ofType:@"WAV"];
        AVAudioPlayer *sound =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
        sound.delegate=self;
        sound.volume = 0.1;
        [sound play] ;
    }
}


-(IBAction)btnBackTouchUpInside:(id)sender
{
    if (timer != nil)
        [timer invalidate];
    timer = nil;
}

-(IBAction)btnBackTouchUpOutside:(id)sender
{
    if (timer != nil)
        [timer invalidate];
    timer = nil;
}

-(IBAction)btnBackTouchDown:(id)sender
{
    if (self.dialString.length>0) {
        self.dialString = [self.dialString substringToIndex:[self.dialString length] - 1];
        lblDialNumber.text = self.dialString;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(pressOnBackSpace:) userInfo:nil repeats:YES];
}

-(void)pressOnBackSpace:(id)sender
{
    if (self.dialString.length>0) {
        self.dialString = [self.dialString substringToIndex:[self.dialString length] - 1];
        lblDialNumber.text = self.dialString;
    }
}

-(IBAction)btnTouchUpInside:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 12) {
        [self gotoContact];
    }
    else if (btn.tag == 13) {
        HUD=[[MBProgressHUD alloc] initWithView:self.view];
        HUD.delegate=self;
        [self.view addSubview:HUD];
        [HUD showWhileExecuting:@selector(callFromCallButton) onTarget:self withObject:nil animated:TRUE];
        //[self callFromCallButton];
    }
    else if (btn.tag == 14) {
        if (self.dialString.length>0) {
            self.dialString = [self.dialString substringToIndex:[self.dialString length] - 1];
            lblDialNumber.text = self.dialString;
        }
    }else if (self.dialString.length<20) {
        switch (btn.tag) {
            case 0:
                self.dialString = [self.dialString stringByAppendingString:@"0"];
                lblDialNumber.text = self.dialString;
                [self playSound:@"0"];
                break;
            case 1:
                self.dialString = [self.dialString stringByAppendingString:@"1"];
                lblDialNumber.text = self.dialString;
                [self playSound:@"1"];
                
                break;
            case 2:
                self.dialString = [self.dialString stringByAppendingString:@"2"];
                lblDialNumber.text = self.dialString;
                [self playSound:@"2"];
                
                break;
            case 3:
                self.dialString = [self.dialString stringByAppendingString:@"3"];
                lblDialNumber.text = self.dialString;
                [self playSound:@"3"];
                
                break;
            case 4:
                self.dialString = [self.dialString stringByAppendingString:@"4"];
                lblDialNumber.text = self.dialString;
                [self playSound:@"4"];
                
                break;
            case 5:
                self.dialString = [self.dialString stringByAppendingString:@"5"];
                lblDialNumber.text = self.dialString;
                [self playSound:@"5"];
                
                break;
            case 6:
                self.dialString = [self.dialString stringByAppendingString:@"6"];
                lblDialNumber.text = self.dialString; [self playSound:@"6"];
                
                break;
            case 7:
                self.dialString = [self.dialString stringByAppendingString:@"7"];
                lblDialNumber.text = self.dialString; [self playSound:@"7"];
                
                break;
            case 8:
                self.dialString = [self.dialString stringByAppendingString:@"8"];
                lblDialNumber.text = self.dialString; [self playSound:@"8"];
                
                break;
            case 9:
                self.dialString = [self.dialString stringByAppendingString:@"9"];
                lblDialNumber.text = self.dialString; [self playSound:@"9"];
                
                break;
            case 10:
                self.dialString = [self.dialString stringByAppendingString:@"*"];
                lblDialNumber.text = self.dialString; [self playSound:@"Star"];
                
                break;
            case 11:
                self.dialString = [self.dialString stringByAppendingString:@"#"];
                lblDialNumber.text = self.dialString; [self playSound:@"#"];
                
                break;
            case 12:
                [self gotoContact];
                break;
            case 13:
                HUD=[[MBProgressHUD alloc] initWithView:self.view];
                HUD.delegate=self;
                [self.view addSubview:HUD];
                [HUD showWhileExecuting:@selector(callFromCallButton) onTarget:self withObject:nil animated:TRUE];
                break;
            case 14:
                if (self.dialString.length>0) {
                    self.dialString = [self.dialString substringToIndex:[self.dialString length] - 1];
                    lblDialNumber.text = self.dialString;
                }
                
                break;
            default:
                break;
        }
    }
}

-(void)gotoContact
{
    //[[callLogonViewController logOnManager] tabBarController].selectedIndex = 2;
    if(!logViewController)
    {
        logViewController = [[callLogListViewController alloc] init];
        logViewController.phoneCallDelegate = self;
        [callLogListViewController setCurrentView:logViewController];
        logViewController.title = TITLE_RECENT_CALLS_LOG;
    }
    if (![self.view.subviews containsObject:logViewController.view]) {
        [self.view addSubview:logViewController.view];
    }
    CGRect rect = self.view.bounds;
    rect.origin.y -= self.view.frame.size.height;
    [logViewController.view setFrame:rect]; //notice this is OFF screen!
    rect.origin.y += self.view.frame.size.height;
    [UIView animateWithDuration:.4
                     animations:^{
                         [logViewController.view setFrame:rect];
                     }];
}

-(void)tapOnDialer
{
    if ([self.view.subviews containsObject:logViewController.view])
    {
        CGRect rect = self.view.bounds;
        rect.origin.y -= self.view.frame.size.height;
        [UIView animateWithDuration:.4
                         animations:^{
                             [logViewController.view setFrame:rect];
                         }];
    }
    [self performSelector:@selector(removeLogPage) withObject:nil afterDelay:0.4];
}


-(void)removeLogPage
{
    [logViewController.view removeFromSuperview];
}

-(void)callFromCallButton
{
    if([dialString length]>0)
    {
        [[SipManager voipManager] doCall:dialString];
        _lastNumber = [[NSString alloc] initWithString: dialString];
        [lblDialNumber setText:dialString];
        [[NSUserDefaults standardUserDefaults] setValue:dialString forKey:LAST_DIALED_NUMBER];
        dialString =@"";
        lblDialNumber.text = dialString;
    }
    else
    {
        NSString *lastdialedNumber = [[NSUserDefaults standardUserDefaults] valueForKey:LAST_DIALED_NUMBER];
        if (lastdialedNumber && lastdialedNumber.length>0)
        {
            dialString = [[[NSUserDefaults standardUserDefaults] valueForKey:LAST_DIALED_NUMBER] mutableCopy];
            lblDialNumber.text = dialString;
        }else
        {
            [[[[UIAlertView alloc]initWithTitle:nil message:@"Please dial a number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease]show];
        }
    }
}

-(void)dealloc
{
    [super dealloc];
    [dialString release];
    [lblDialNumber release];
}

@end
