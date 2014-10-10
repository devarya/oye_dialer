//
//  getRatesViewController.h
//  Callture
//
//  Created by user on 16/10/12.
//
//

#import <UIKit/UIKit.h>
#import "CallOptionView.h"
#import "Country.h"
#import "Area.h"
@protocol getRatesViewControllerDelegate <NSObject>
-(void)gotoContact:(NSString *)onPage;
@end
@interface getRatesViewController : UIViewController<CallOptionViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIView *container1;
    IBOutlet UIView *container2;
    IBOutlet UIButton *btnContact;
    IBOutlet UITextField *txtInternationalNo;
    
    CallOptionView *optView;
    Country *selectedCountry;
    Area *selectedArea;
    UIView *loader;
    
    Country *countryDataForPhone;
    
    //////////// outlet language///////////
    IBOutlet UILabel *lblByNumber;
    IBOutlet UILabel *lblInternationalNumber;
    IBOutlet UILabel *lblByArea;
    IBOutlet UIButton *btnCountry;
    IBOutlet UIButton *btnArea;
    IBOutlet UILabel *lblCountry;
    IBOutlet UILabel *lblArea;
    IBOutlet UITextField *txtRate;
    IBOutlet UIView *viewTitleByNumber;
    IBOutlet UIView *viewTitleByArea;
}

@property(nonatomic, retain) NSMutableArray *countryList;
@property(nonatomic, retain) NSMutableArray *areaList;
@property(nonatomic,assign) id <getRatesViewControllerDelegate> delegate;
-(IBAction)gotoContacts:(id)sender;
-(IBAction)tapOnCountry:(id)sender;
-(IBAction)tapOnArea:(id)sender;
-(void)showLoader;
@end
