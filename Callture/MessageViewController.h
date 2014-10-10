//
//  MessageViewController.h
//  Oye Dialer
//
//  Created by user on 10/06/13.
//
//

#import <UIKit/UIKit.h>
#import "YIInnerShadowView.h"
#import "ODTextView.h"
#import "TPKeyboardAvoidingScrollView.h"
@protocol CustomWebViewDelegate <NSObject>

-(void)didFinishHidingAnimation;
@end
@interface MessageViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet YIInnerShadowView *viewPhoneNumber;
    IBOutlet YIInnerShadowView *viewMessage;
    IBOutlet ODTextView *textview;
    IBOutlet UIButton *btnSend;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet TPKeyboardAvoidingScrollView *scrollview;
}
@property(nonatomic,assign)id <CustomWebViewDelegate> delegate;
@property(nonatomic,retain) IBOutlet UIWebView *wView;
//vishnu
@property(nonatomic,retain)NSURLRequest *urlRequest;
//vishnu
@end
