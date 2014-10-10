//
//  SipManager.m
//  Oye Dialer
//
//  Created by user on 16/05/13.
//
//

#import "SipManager.h"
#import "Constants.h"
#include <unistd.h>
#import "GlobalData.h"
#import "RESTInteraction.h"
#define kDelayToCall 10.0
static SipManager *sipmanager = nil;
@implementation SipManager
@synthesize selectedNum,isConnected;
+ (SipManager *)voipManager {
    @synchronized(self) {
        if (sipmanager == nil)
            sipmanager = [[self alloc] init];
        
    }
    return sipmanager;
}

-(void)callFromCallOption:(NSString *)callOption destNo:(NSString *)destNo
{
    strDialedNumber = destNo;
    if([callOption isEqualToString:CALL_BACK])
    {
        [self callRestForCallBack:destNo];
    }if([callOption isEqualToString:LOCAL_ACCESS])
    {
        
        NSString *dialStr = [[NSUserDefaults standardUserDefaults] stringForKey:destNo];
        if(dialStr.length > 0)
        {
            if ([[[UIDevice currentDevice] model] rangeOfString:@"Phone"].location != NSNotFound &&
                [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location == NSNotFound ) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",dialStr]]];
            }
        }else {
            [[RESTInteraction restInteractionManager]sendRequestForDialSetup:destNo :@"other"];
        }
    }else
        if([callOption isEqualToString:SIP_VOIP])
        {
            [self performSelectorOnMainThread:@selector(callOnMainThread) withObject:nil waitUntilDone:NO];
        }
}

-(void)callRestForCallBack:(NSString *)destNo
{
    NSString *no = [[NSUserDefaults standardUserDefaults] valueForKey:LINE_NO];
    [[RESTInteraction restInteractionManager] callMeBack:destNo :nil];
}


-(void)doCall:(NSString *)destNo
{
    [[NSUserDefaults standardUserDefaults] setValue:destNo forKey:LAST_DIALED_NUMBER];
    strDialedNumber = destNo;
    if ([GlobalData isNetworkAvailable])
    {
        BOOL useWiFi = [[[NSUserDefaults standardUserDefaults] valueForKey:USE_WIFI_IFAVAILABLE] isEqualToString:@"YES"];
        if (useWiFi && [GlobalData isReachableViaWiFi])
        {
            [self performSelectorOnMainThread:@selector(callOnMainThread) withObject:nil waitUntilDone:NO];
            
        }else
        {
            [self callFromCallOption:[[NSUserDefaults standardUserDefaults] valueForKey:CALLOPTION1] destNo:destNo];
        }
    }else
    {
        [[[UIAlertView alloc] initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

-(void)callOnMainThread
{
    [self dialup:strDialedNumber number:NO];
}

- (app_config_t *)pjsipConfig
{
    return &_app_config;
}

/***** SIP ********/
/* */
- (BOOL)sipStartup
{
    if (_app_config.pool)
        return YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (sip_startup(&_app_config) != PJ_SUCCESS)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return NO;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    /** Call management **/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(processCallState:)
                                                 name: kSIPCallState object:nil];
    
    /** Registration management */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(processRegState:)
                                                 name: kSIPRegState object:nil];
    
    return YES;
}

/* */
- (void)sipCleanup
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: kSIPRegState
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kSIPCallState
                                                  object:nil];
    [self sipDisconnect];
    
    if (_app_config.pool != NULL)
    {
        sip_cleanup(&_app_config);
    }
}

/* */
- (BOOL)sipConnect
{
    pj_status_t status;
    
    if (![self sipStartup])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SIP_CONNECT_FAILED object:nil];
        return FALSE;
    }
    
    if (_sip_acc_id == PJSUA_INVALID_ID)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        if ((status = sip_connect(_app_config.pool, &_sip_acc_id)) != PJ_SUCCESS)
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SIP_CONNECT_FAILED object:nil];
            return FALSE;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SIP_CONNECTED object:nil];
    return TRUE;
}

/* */
- (BOOL)sipDisconnect
{
    if ((_sip_acc_id != PJSUA_INVALID_ID) &&
        (sip_disconnect(&_sip_acc_id) != PJ_SUCCESS))
    {
        return FALSE;
    }
    
    _sip_acc_id = PJSUA_INVALID_ID;
    
    isConnected = FALSE;
    
    return TRUE;
}

/** FIXME plutôt à mettre dans l'objet qui gère les appels **/
-(void) dialup:(NSString *)phoneNumber number:(BOOL)isNumber
{
    pjsua_call_id call_id;
    pj_status_t status;
    NSString *number;
    
    UInt32 hasMicro, size;
    
    // Verify if microphone is available (perhaps we should verify in another place ?)
    size = sizeof(hasMicro);
    AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable,
                            &size, &hasMicro);
    if (!hasMicro)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Microphone Available", @"SiphonApp")
                                                        message:NSLocalizedString(@"Connect a microphone to phone", @"SiphonApp")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"SiphonApp")
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (isNumber)
        number = [self normalizePhoneNumber:phoneNumber];
    else
        number = phoneNumber;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"removeIntlPrefix"])
    {
        number = [number stringByReplacingOccurrencesOfString:@"+"
                                                   withString:@""
                                                      options:0
                                                        range:NSMakeRange(0,1)];
    }
    else
    {
        NSString *prefix = [[NSUserDefaults standardUserDefaults] stringForKey:
                            @"intlPrefix"];
        if ([prefix length] > 0)
        {
            number = [number stringByReplacingOccurrencesOfString:@"+"
                                                       withString:prefix
                                                          options:0
                                                            range:NSMakeRange(0,1)];
        }
    }
    
    // Manage pause symbol
    NSArray * array = [number componentsSeparatedByString:@","];
    [[UIAppDelegate callViewController] setDtmfCmd:@""];
    if ([array count] > 1)
    {
        number = [array objectAtIndex:0];
        [[UIAppDelegate callViewController] setDtmfCmd:[array objectAtIndex:1]];
    }
    
    if (!isConnected)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                             message:NSLocalizedString(@"Failed to enable sip account.",@"SiphonApp")
                                                            delegate:nil
                                                   cancelButtonTitle:NSLocalizedString(@"OK",@"SiphonApp")
                                                   otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([self sipConnect])
    {
        NSRange range = [number rangeOfString:@"@"];
        if (range.location != NSNotFound)
        {
            status = sip_dial_with_uri(_sip_acc_id, [[NSString stringWithFormat:@"sip:%@", number] UTF8String], &call_id);
        }
        else
            status = sip_dial(_sip_acc_id, [number UTF8String], &call_id);
        if (status != PJ_SUCCESS)
        {
            // FIXME
            //[self displayStatus:status withTitle:nil];
            const pj_str_t *str = pjsip_get_status_text(status);
            NSString *msg = [[NSString alloc]
                             initWithBytes:str->ptr
                             length:str->slen
                             encoding:[NSString defaultCStringEncoding]];
            [self displayError:msg withTitle:@"registration error"];
        }
    }
}
/** Fin du FIXME */


- (void)processCallState:(NSNotification *)notification
{
#if 0
    NSNumber *value = [[ notification userInfo ] objectForKey: @"CallID"];
    pjsua_call_id callId = [value intValue];
#endif
    int state = [[[ notification userInfo ] objectForKey: @"State"] intValue];
    
    switch(state)
    {
        case PJSIP_INV_STATE_NULL: // Before INVITE is sent or received.
            return;
        case PJSIP_INV_STATE_CALLING: // After INVITE is sent.
#ifdef __IPHONE_3_0
            [UIDevice currentDevice].proximityMonitoringEnabled = YES;
#else
            self.proximitySensingEnabled = YES;
#endif
        case PJSIP_INV_STATE_INCOMING: // After INVITE is received.
            [UIApplication sharedApplication].idleTimerDisabled = YES;
           // [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
            if (pjsua_call_get_count() == 1)
            {
                callAppDelegate *appdelegate = (callAppDelegate *)[UIApplication sharedApplication].delegate;
                [appdelegate.window addSubview:[appdelegate callViewController].view];
                //[callViewController showDialPad:NO];
                [UIAppDelegate callViewController];
                //        [tabBarController presentModalViewController:callViewController animated:YES];
            }
        case PJSIP_INV_STATE_EARLY: // After response with To tag.
        case PJSIP_INV_STATE_CONNECTING: // After 2xx is sent/received.
            break;
        case PJSIP_INV_STATE_CONFIRMED: // After ACK is sent/received.
#ifdef __IPHONE_3_0
            [UIDevice currentDevice].proximityMonitoringEnabled = YES;
#else
            self.proximitySensingEnabled = YES;
#endif
            break;
        case PJSIP_INV_STATE_DISCONNECTED:
#if 0
            self.idleTimerDisabled = NO;
#ifdef __IPHONE_3_0
            [UIDevice currentDevice].proximityMonitoringEnabled = NO;
#else
            self.proximitySensingEnabled = NO;
#endif
            if (pjsua_call_get_count() <= 1)
                [self performSelector:@selector(disconnected:)
                           withObject:nil afterDelay:1.0];
#endif
            break;
    }
    [[UIAppDelegate callViewController] processCall: [ notification userInfo ]];
}

- (void)callDisconnecting
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
#ifdef __IPHONE_3_0
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
#else
    self.proximitySensingEnabled = NO;
#endif
    if (pjsua_call_get_count() <= 1)
        [self performSelector:@selector(disconnected:)
                   withObject:nil afterDelay:1.0];
}

- (void) disconnected:(id)fp8
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[tabBarController dismissModalViewControllerAnimated: YES];
    callAppDelegate *appdelegate = (callAppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    if ([appdelegate.window.subviews containsObject:[[appdelegate callViewController] view]]) {
        [[[UIAppDelegate callViewController] view] removeFromSuperview];
        [UIAppDelegate callViewController];
    }
    
}

- (void)processRegState:(NSNotification *)notification
{
    //  const pj_str_t *str;
    //NSNumber *value = [[ notification userInfo ] objectForKey: @"AccountID"];
    //pjsua_acc_id accId = [value intValue];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    int status = [[[ notification userInfo ] objectForKey: @"Status"] intValue];
    
    switch(status)
    {
        case 200: // OK
            isConnected = TRUE;
        {
            pjsua_call_id call_id;
            NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"dateOfCall"];
            NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"callURL"];
            if (date && [date timeIntervalSinceNow] < kDelayToCall)
            {
                sip_dial_with_uri(_sip_acc_id, [url UTF8String], &call_id);
            }
        }
            break;
        case 403: // registration failed
        case 404: // not found
            //sprintf(TheGlobalConfig.accountError, "SIP-AUTH-FAILED");
            //break;
        case 503:
        case PJSIP_ENOCREDENTIAL:
            // This error is caused by the realm specified in the credential doesn't match the realm challenged by the server
            //sprintf(TheGlobalConfig.accountError, "SIP-REGISTER-FAILED");
            //break;
        default:
            isConnected = FALSE;
            //      [self sipDisconnect];
    }
}

-(void)sip_Connect
{
    _sip_acc_id = PJSUA_INVALID_ID;
    isConnected = FALSE;
    [self initUserDefaults];
    NSString *server = [[NSUserDefaults standardUserDefaults] valueForKey:SIP_PROXY];
    NSRange range = [server rangeOfString:@":"
                                  options:NSCaseInsensitiveSearch|NSBackwardsSearch];
    if (range.length > 0)
    {
        server = [server substringToIndex:range.location];
    }
    [self performSelector:@selector(sipConnect) withObject:nil afterDelay:0.2];
}

-(void)sip_DisConnect{
    [self sipDisconnect];
}

-(void)sip_Cleanup
{
    [self sipCleanup];
}

/***** MESSAGE *****/
-(void)displayParameterError:(NSString *)msg
{
    NSString *message = NSLocalizedString(msg, msg);
    NSString *error = [message stringByAppendingString:NSLocalizedString(
                                                                         @"\nTo correct this parameter, select \"Settings\" from your Home screen, "
                                                                         "and then tap the \"Oye Dialer\" entry.", @"Oye Dialer")];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:error
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:@"Ok", nil ];
    [alert show];
}

-(void)displayError:(NSString *)error withTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:error
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
}

-(void)displayStatus:(pj_status_t)status withTitle:(NSString *)title
{
    char msg[80];
    pj_str_t pj_msg = pj_strerror(status, msg, 80);
    PJ_UNUSED_ARG(pj_msg);
    
    NSString *message = [NSString stringWithUTF8String:msg];
    
    [self displayError:message withTitle:nil];
}



- (void)initUserDefaults:(NSMutableDictionary *)dict fromSettings:(NSString *)settings
{
    NSDictionary *prefItem;
    
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:settings];
    NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
    
    for (prefItem in prefSpecifierArray)
    {
        NSString *keyValueStr = [prefItem objectForKey:@"Key"];
        if (keyValueStr)
        {
            id defaultValue = [prefItem objectForKey:@"DefaultValue"];
            if (defaultValue)
            {
                [dict setObject:defaultValue forKey: keyValueStr];
            }
        }
    }
}

- (void)initUserDefaults
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity: 10];
    [self initUserDefaults:dict fromSettings:@"Phone.plist"];
    [self initUserDefaults:dict fromSettings:@"Codec.plist"];
    
    [userDef registerDefaults:dict];
    [userDef synchronize];
    
}

- (NSString *)normalizePhoneNumber:(NSString *)number
{
    const char *phoneDigits = "22233344455566677778889999",
    *nb = [[number uppercaseString] UTF8String];
    int i, len = [number length];
    char *u, *c, *utf8String = (char *)calloc(sizeof(char), len+1);
    c = (char *)nb; u = utf8String;
    for (i = 0; i < len; ++c, ++i)
    {
        if (*c == ' ' || *c == '(' || *c == ')' || *c == '/' || *c == '-' || *c == '.')
            continue;
        /*    if (*c >= '0' && *c <= '9')
         {
         *u = *c;
         u++;
         }
         else*/ if (*c >= 'A' && *c <= 'Z')
         {
             *u = phoneDigits[*c - 'A'];
         }
         else
             *u = *c;
        u++;
    }
    NSString * norm = [[NSString alloc] initWithUTF8String:utf8String];
    free(utf8String);
    return norm;
}
@end
