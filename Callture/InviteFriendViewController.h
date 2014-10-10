//
//  InviteFriendViewController.h
//  Oye Dialer
//
//  Created by user on 06/06/13.
//
//

#import <UIKit/UIKit.h>
#import "editOwnerNameViewController.h"

@interface InviteFriendViewController : UIViewController<editControllerDelegate>
{
    NSMutableArray *contacts;
    IBOutlet UITableView *tblContacts;
    IBOutlet UIView *contactView;
    IBOutlet UIButton *btnSubmit;
    IBOutlet UILabel *lblSelectFriends;
    IBOutlet UIImageView *imgCheckBox;
    IBOutlet UILabel *lblSelectAll;
    
    IBOutlet UILabel *lblOwnerName;
    IBOutlet UILabel *lblFrom;
    editOwnerNameViewController *editController;
    IBOutlet UIView *viewContactsTitle;
    IBOutlet UIView *viewOwnerName;
}

-(IBAction)btnEditNameClicked:(id)sender;
-(IBAction)inviteFriends:(id)sender;
-(IBAction)selectAll:(UIButton *)btn;
@end
