//
//  ChargeViewController.h
//  Oye Dialer
//
//  Created by user on 24/06/13.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ChargeViewController : UIViewController<UIAlertViewDelegate,MBProgressHUDDelegate>
{
    IBOutlet UIButton *btnSend;
    IBOutlet UITextField *textAmount;
    MBProgressHUD *hud;
}
-(IBAction)recharge:(id)sender;
@end
