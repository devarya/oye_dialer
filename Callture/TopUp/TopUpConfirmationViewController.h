//
//  TopUpConfirmationViewController.h
//  Oye
//
//  Created by user on 25/10/12.
//
//

#import <UIKit/UIKit.h>
#import "TopupInfo.h"
@protocol TopUpConfirmationViewControllerDelegate <NSObject>
-(void)updateRecentsTransaction;
@end
@interface TopUpConfirmationViewController : UIViewController
{
    IBOutlet UILabel *lblNumber;
    IBOutlet UILabel *lblCountry;
    IBOutlet UILabel *lblOperator;
    IBOutlet UILabel *lblCustService;
    IBOutlet UILabel *lblCurrency;
    IBOutlet UILabel *lblAmount;
    IBOutlet UILabel *lblSentAmt;
    IBOutlet UILabel *lblAmtCharged;
    IBOutlet UILabel *lblTransId;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblTax;
    IBOutlet UILabel *lblMessage;
    
    TopupInfo *topupInfo;
    NSString *operatorId;
    NSString *amtCharged;
    UIView *loader;
    float amountToSend;
    
    //////// outlet languages //////////
    IBOutlet UILabel *labelNumber;
    IBOutlet UILabel *labelCountry;
    IBOutlet UILabel *labelOperator;
    IBOutlet UILabel *labelCustService;
    IBOutlet UILabel *labelCurrency;
    IBOutlet UILabel *labelAmount;
    IBOutlet UILabel *labelSentAmt;
    IBOutlet UILabel *labelAmtCharged;
    IBOutlet UILabel *labelTransId;
    IBOutlet UILabel *labelName;
    IBOutlet UILabel *labelTax;
    IBOutlet UIButton *btnConfirm;
    IBOutlet UIButton *btnCancel;
    
 
}
@property (nonatomic, retain)   id<TopUpConfirmationViewControllerDelegate> delegate;
@property (nonatomic,retain) TopupInfo *topupInfo;
@property (nonatomic, retain) NSString *operatorId;
@property (nonatomic, retain) NSString *amtCharged;
@property (nonatomic) float amountToSend;
-(IBAction)tapOnConfirm:(id)sender;
-(IBAction)tapOnCancel:(id)sender;
@end
