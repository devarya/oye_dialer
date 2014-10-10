//
//  addProfileViewController.h
//  Callture
//
//  Created by Manish on 14/12/11.
//  Copyright (c) 2011 Aryavrat Infotech Pvt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallOptionView.h"
#import "getRatesViewController.h"
#import "webViewPopup.h"
#import "CallOptionViewController.h"
@protocol optionsDelegate <NSObject>
-(void)logout;
-(void)gotoNativeContacts:(NSString *)onPage;
@end


@interface addProfileViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate,CallOptionViewDelegate,getRatesViewControllerDelegate,MBProgressHUDDelegate,UIWebViewDelegate>
{
    BOOL keyboardVisible;        
    NSArray *callerIDList;
    NSArray *billingACList;
    NSArray *callOptionList;    
    IBOutlet UITableView *mytable;
    UIView *loader;
    BOOL isAdd;
    BOOL isUpdate;
    NSString *popupMsg;
    UIButton *btnBg;
    BOOL isModified;
    BOOL canshow;
    IBOutlet UIView *tblHeaderView;
    CallOptionView *callOptView;
    UILabel *lblPhoneNoValue;
    UILabel *lblBalanceValue;
    BOOL isLoaded;
    BOOL isLineListDataLoading;
    webViewPopup *facebookPopup;
    CallOptionViewController *covc;
    MBProgressHUD *HUD;
    
    IBOutlet UIWebView *webViewOptionsPage;
}
@property(nonatomic, assign) id <optionsDelegate> delegate;
@property (nonatomic,strong) UITableView *mytable;
@property (nonatomic) BOOL isADDBtn;
@property(nonatomic) BOOL canshow;
+ (addProfileViewController*)currentView;
+ (void)setCurrentView:(addProfileViewController*)newView;
-(void)showLoader;
-(void)getLineListData;
@property(nonatomic,retain) UIButton *btnBg;
//vishnu
-(void)gotoAddFundScreen;
-(void)gotoCallOptionScreen;
-(void)gotoMessageScreen;
-(void)gotoCallRatesScreen;
-(void)gotoInviteFriendsScreen;
-(void)gotoMoreOptionsScreen;
//vishnu
@end
