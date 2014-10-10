//
//  callDialerViewController.h
//  Callture
//
//  Created by Manish on 17/02/12.
//  Copyright (c) 2012 Aryavrat Infotech Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CopyLabel.h"
#import <AVFoundation/AVFoundation.h>
#import "callLogListViewController.h"
#import "PhoneCallDelegate.h"
#import "LineListData.h"
#import "addProfileViewController.h"
@class callLogonViewController;
@interface callDialerViewController : UIViewController<CopyLabelDelegate,AVAudioPlayerDelegate,PhoneCallDelegate,MBProgressHUDDelegate>
{
    IBOutlet CopyLabel *lblDialNumber;
    NSString *dialString;
    UIView *loader;
    UIView *popup;
    IBOutlet UIButton *btnCall;
    NSString *dialStr;
    NSTimer *callingTimer;
    callLogListViewController *logViewController;
    id<PhoneCallDelegate> phoneCallDelegate;
    NSTimer *timer;
    NSString *_lastNumber;
    IBOutlet UILabel *balancekeyboard;
    IBOutlet UILabel *calloptions;
    
    addProfileViewController *addprofile;
    //////// outlet languages /////
    IBOutlet UILabel *lblBalance;
    MBProgressHUD *HUD;
    IBOutlet UIImageView *imgDialer;
}
@property(nonatomic,retain) NSString *dialString;
@property(nonatomic,retain) NSTimer *callingTimer;
+ (callDialerViewController*)currentView;
+ (void)setCurrentView:(callDialerViewController*)newView;
-(IBAction)btnTouchUpInside:(id)sender;
-(IBAction)btnBackTouchUpInside:(id)sender;
-(IBAction)btnBackTouchUpOutside:(id)sender;
-(IBAction)btnBackTouchDown:(id)sender;

-(void)callFromCallButton;
-(void)updateCallBackStatus:(NSString *)msg;
-(void)gotoContact;
-(void)tapOnDialer;
//added by par
@property(nonatomic,retain) NSString *dialStr;
@property (nonatomic, retain)   id<PhoneCallDelegate> phoneCallDelegate;
@end
