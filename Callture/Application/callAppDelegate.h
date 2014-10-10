//
//  callAppDelegate.h
//  Callture
//
//  Created by Manish on 07/12/11.
//  Copyright (c) 2011 Aryavrat Infotech Pvt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "callLogonViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CallViewController.h"
#import "MBProgressHUD.h"

#define REACHABILITY_2_0 1
@interface callAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,callLogonViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate,AVAudioSessionDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    callLogonViewController *viewControllerLogon;
    NSString *strContactOnPage;
    BOOL isappLaunched;
    MBProgressHUD *HUD;
    //vishnu
    AVAudioPlayer *audioPlayerObj;
    //vishnu
    //sip
    CallViewController *callViewController;
    BOOL isAppInBackGround;
}
@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) UIViewController *uiviewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) CallViewController *callViewController;

//////vishnu
-(BOOL)isUserLoggedIn;
-(void)gotoAddFundScreen;
-(void)gotoCallOptionScreen;
-(void)gotoMessageScreen;
-(void)gotoCallRatesScreen;
-(void)gotoInviteFriendsScreen;
-(void)gotoMoreOptionsScreen;
-(void)playPopupSound:(NSString*)soundName;
-(void)showPopup_Title:(NSString*)popTitle message:(NSString*)popMessage titleViewBtn:(NSString*)lblRightBtn tag:(NSInteger)tag soundName:(NSString*)soundName;
//////vishnu
@end
