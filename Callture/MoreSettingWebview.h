//
//  MoreSettingWebview.h
//  Oye Dialer
//
//  Created by user on 04/03/13.
//
//

#import <UIKit/UIKit.h>

@protocol CustomWebViewDelegate <NSObject>

-(void)didFinishHidingAnimation;
@end


@interface MoreSettingWebview : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIActivityIndicatorView *activity;
    
}
@property(nonatomic,assign)id <CustomWebViewDelegate> delegate;
@property(nonatomic,retain) IBOutlet UIWebView *moreSetting;
//vishnu
@property(nonatomic,retain) NSURLRequest *request;
//vishnu
@end
