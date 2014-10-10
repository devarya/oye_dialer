//
//  SipManager.h
//  Oye Dialer
//
//  Created by user on 16/05/13.
//
//

#import <Foundation/Foundation.h>
#import "callAppDelegate.h"
#import "call.h"
#define UIAppDelegate (callAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface SipManager : NSObject
{
    app_config_t _app_config;
    pjsua_acc_id  _sip_acc_id;
    BOOL isConnected;
    NSString *selectedNum;
    NSString *strDialedNumber;
}
@property (strong,nonatomic) NSString *selectedNum;
@property (nonatomic) BOOL isConnected;
- (app_config_t *)pjsipConfig;

+ (SipManager *)voipManager;

//sip
-(void)displayError:(NSString *)error withTitle:(NSString *)title;
-(void)displayParameterError:(NSString *)error;
- (void)callDisconnecting;
-(void)disconnected:(id)fp8;
-(void)sip_Connect;
-(void)sip_DisConnect;
-(void)callFromCallOption:(NSString *)callOption destNo:(NSString *)destNo;
-(void)doCall:(NSString *)destNo;
-(void) dialup:(NSString *)phoneNumber number:(BOOL)isNumber;
-(void)sip_Cleanup;
@end
