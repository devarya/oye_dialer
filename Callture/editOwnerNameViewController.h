//
//  editOwnerNameViewController.h
//  Oye Dialer
//
//  Created by user on 23/07/13.
//
//

#import <UIKit/UIKit.h>

@protocol editControllerDelegate <NSObject>

-(void)setOwnerName:(NSString *)name;

@end
@interface editOwnerNameViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *tFieldName;
    IBOutlet UIButton *btnClear;
     IBOutlet UIView *viewOwnerName;
}

@property(nonatomic, assign) id <editControllerDelegate> delegate;
@property(nonatomic,retain)NSString *strOwnerName;
-(IBAction)btnClearTextClicked:(id)sender;
-(IBAction)textChangedOnTouch:(id)sender;
@end
