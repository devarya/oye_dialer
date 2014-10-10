//
//  CallOptionViewController.h
//  Oye Dialer
//
//  Created by user on 06/03/13.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CallOptionView.h"
@interface CallOptionViewController : UITableViewController<MBProgressHUDDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CallOptionViewDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *arrPickerView;
    CallOptionView *callOptView;
}
@end
