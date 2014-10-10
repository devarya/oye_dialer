//
//  AddFundsViewController.h
//  Oye Dialer
//
//  Created by user on 07/06/13.
//
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "ClientInfo.h"
#import "MBProgressHUD.h"
@protocol CustomWebViewDelegate <NSObject>

-(void)didFinishHidingAnimation;
@end
@interface AddFundsViewController : UIViewController<UIAlertViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    IBOutlet UITableView *tblAddFunds;
    IBOutlet UIActivityIndicatorView *activity;
    UITextField *textCraditCard;
    UITextField *textCraditCardNo;
    UIButton *btn1;
    UIButton *btn2;
    UITextField *textSecurityCode;
    UITextField *textStreetAddress;
    UITextField *textAdd2;
    UITextField *textCity;
    UITextField *textState;
    UITextField *textPostal;
    NSMutableArray *data;
    NSInteger expandedRowIndex;
    IBOutlet TPKeyboardAvoidingScrollView *scrollview;
    UIPickerView *pickerView;
    UIActionSheet *actionSheet;
    NSMutableArray *arrPickerData;
    UIButton *selectedButton;
    ClientInfo *ci;
    MBProgressHUD *hud;
    NSInteger selectedAmountIndex;
    BOOL needToSendCCNo;
    
}
@property(nonatomic,assign)id <CustomWebViewDelegate> delegate;
@property(nonatomic,retain) IBOutlet UIWebView *wView;

//vishnu
@property(nonatomic,retain) NSURLRequest *request;
//vishnu
@end
