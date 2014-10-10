//
//  AboutUsViewController.h
//  Oye
//
//  Created by user on 26/10/12.
//
//

#import <UIKit/UIKit.h>
#import "UnderlineButton.h"
@interface AboutUsViewController : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UnderlineButton *btnWebsite;
    IBOutlet UIWebView *webview;
    
    /////// Outlet language ///////
    IBOutlet UILabel *lblAppDescription;
    IBOutlet UILabel *lblAppVersion;
    IBOutlet UILabel *lblCopyRight;
    IBOutlet UILabel *lblCS_Phone;
    IBOutlet UIImageView *imgLogo;
}
-(IBAction)gotoWebSite:(id)sender;
@end
