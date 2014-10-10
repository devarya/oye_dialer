//
//  webViewPopup.h
//  Oye
//
//  Created by user on 08/11/12.
//
//

#import <UIKit/UIKit.h>

@interface webViewPopup : UIView <UIWebViewDelegate>
{
    NSString * _serverURL;
    UIWebView* _webView;
    UIActivityIndicatorView* _spinner;
    UIButton* _closeButton;
    UIInterfaceOrientation _orientation;
    BOOL _showingKeyboard;
    BOOL _isViewInvisible;
    UIView* _modalBackgroundView;
}
- (id)initWithURL: (NSString *) serverURL
           params: (NSMutableDictionary *) params
  isViewInvisible: (BOOL)isViewInvisible;
- (void)show;
@end
