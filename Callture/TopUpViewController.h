//
//  TopUpViewController.h
//  Callture
//
//  Created by user on 10/10/12.
//
//

#import <UIKit/UIKit.h>
#import "CallOptionView.h"
#import "MobileOperator.h"
#import "RESTInteraction.h"
#import "TopUpConfirmationViewController.h"
#import "PhoneCallDelegate.h"
@interface TopUpViewController : UIViewController<RESTInteractionDelegate,CallOptionViewDelegate,TopUpConfirmationViewControllerDelegate,UIWebViewDelegate,PhoneCallDelegate,MBProgressHUDDelegate>
{
    IBOutlet UITextField *txtAmtToSend;
    
    IBOutlet UITextField *txtRecepientAmt;
    
    IBOutlet UIButton *btnContact;
    IBOutlet UITableView *tableTopupHistory;
    IBOutlet UIView *historyView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIView *viewRecentTransTitle;
    
    IBOutlet UIView *loaderBg;
    NSDateFormatter *objDateFormatter;
    NSMutableArray *operatorList;
    NSMutableArray *mobileTopupList;
    NSMutableArray *amountList;
    CallOptionView *optView;
    UIView *popupView;
    MobileOperator *selectedMo;
    NSString *selectedAmount;
    UIView *loader;
    BOOL isMobileNoChanged;
    BOOL isgetNoFromContacts;
    float amountToSend;
    
    BOOL isViewLoaded;
    BOOL isWebViewLoaded;
    BOOL keyboardVisible;
    
    CGPoint offset;
	UITextField *activeField;
    IBOutlet UIScrollView *scrollview;
    
    NSString *lastTransactionId;
    
    //refreshon pull
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    BOOL isLogout;
    
    //////////// outlet language ///////////
    IBOutlet UILabel *lblMobileNo;
    IBOutlet UITextField *txtMobileNo;
    IBOutlet UILabel *lblMobileOperator;
    IBOutlet UIButton *btnOperatorList;
    IBOutlet UILabel *lblAmtToSend;
    IBOutlet UIButton *btnAmtToSend;
    IBOutlet UILabel *lblRecepientAmt;
    IBOutlet UIButton *btnSend;
    IBOutlet UILabel *lblRecentTranscations;
    
    IBOutlet UIWebView *webViewTopUpPage;
    
    id<PhoneCallDelegate> phoneCallDelegate;
    MBProgressHUD *HUD;
    
    NSMutableArray *arrContactsData;
}

-(void)getAllAddressBookData2;

-(void)getAllAddressBookData;
-(void)setAllAddressBookListData;
-(void)getContactsById:(NSString *)idNo;
-(void)getContactsByName:(NSString *)name;
-(void)getContactsByNumber:(NSString *)phoneNo;

//pull to refresh
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, retain)   id<PhoneCallDelegate> phoneCallDelegate;


-(IBAction)proceedNo:(id)sender;
-(IBAction)selectOperator:(id)sender;
-(IBAction)selectAmount:(id)sender;
-(IBAction)mobileNoChanged:(id)sender;
-(IBAction)amountToSendChanged:(id)sender;
-(IBAction)tapOnSend:(id)sender;
-(IBAction)gotoContacts:(id)sender;
@end
