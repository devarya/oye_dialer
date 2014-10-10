//
//  callAppDelegate.m
//  Callture
//
//  Created by Manish on 07/12/11.
//  Copyright (c) 2011 Aryavrat Infotech Pvt. All rights reserved.
//

#import "callAppDelegate.h"
#import "Constants.h"
#import "GlobalData.h"
#import "RESTInteraction.h"


@interface UIApplication ()

- (BOOL)launchApplicationWithIdentifier:(NSString *)identifier suspended:(BOOL)suspended;
- (void)addStatusBarImageNamed:(NSString *)imageName removeOnExit:(BOOL)remove;
- (void)addStatusBarImageNamed:(NSString *)imageName;
- (void)removeStatusBarImageNamed:(NSString *)imageName;

@end


@implementation callAppDelegate
@synthesize navigationController;
@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize uiviewController = _uiviewController;
@synthesize callViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    viewControllerLogon = [[callLogonViewController alloc] initWithNibName:@"callLogonViewController" bundle:nil];
    viewControllerLogon.delegate = self;
    if ([GlobalData isNetworkAvailable]) {
        [[RESTInteraction restInteractionManager] GetAboutUsDetail];
    }else
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:[NSString stringWithFormat:@"Could not connect to internet, Internet connection is required for %@ to work properly. Please connect to the network and try again.", [GlobalData getApp_Name]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    
    self.window.rootViewController = viewControllerLogon;
    
    //sip
    callViewController = [[CallViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
//    NSDictionary *pushDict = [NSDictionary dictionaryWithObject:@"Call" forKey:@"Action"];
    NSDictionary *pushDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(pushDict)
    {
        [self application:application didReceiveRemoteNotification:pushDict];
    }
    
    return YES;
}



- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *strDeviceToken  = [NSString stringWithFormat:@"%@",deviceToken];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    //[[[[UIAlertView alloc]initWithTitle:@"Message" message:strDeviceToken delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease]show];
    [GlobalData SetDiviceToken:strDeviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"Error %@",err);
    [[[UIAlertView alloc]initWithTitle:@"Message" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}






////////////////////////////////vishnu/////////////////////////
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    @try {
        NSString *strAction = [[userInfo valueForKey:@"Action"] lowercaseString];
        if ([strAction isEqualToString:REMOTE_NOTIFICATION_CALL]) {
            
            
            if ([self isUserLoggedIn]) {
                
                [viewControllerLogon enableSip:nil];
            }
            
            
        }else if ([strAction isEqualToString:REMOTE_NOTIFICATION_CALLEND] || [strAction isEqualToString:REMOTE_NOTIFICATION_DEFAULT]) {
            
            if ([self isUserLoggedIn]) {
                
                viewControllerLogon.tabBarController.selectedIndex = 0;
            }
        }else if ([strAction isEqualToString:REMOTE_NOTIFICATION_TOP_UP]) {
            
            NSString *isShowPopUp = [userInfo valueForKey:@"Popup"];
            
            NSDictionary *apsInfo = [userInfo valueForKey:@"aps"];
            NSString *popMessage = [apsInfo valueForKey:@"alert"];
            NSString *lblRightBtn = [userInfo valueForKey:@"btnLabel"];
            NSString *popTitle = [userInfo valueForKey:@"PopupTitle"];
            NSString *soundName = [apsInfo valueForKey:@"sound"];
            if ([isShowPopUp isEqualToString:@"0"]) {
                
                if ([self isUserLoggedIn]) {
                    
                    viewControllerLogon.tabBarController.selectedIndex = 2;
                }
                
            }else{
                
                if (isAppInBackGround) {
                    
                    if ([self isUserLoggedIn]) {
                        
                        viewControllerLogon.tabBarController.selectedIndex = 2;
                    }
                }else{
                    [self showPopup_Title:popTitle message:popMessage titleViewBtn:lblRightBtn tag:1 soundName:soundName];
                    
                }
            }
            
        }else if ([strAction isEqualToString:REMOTE_NOTIFICATION_ADD_FUNDS]) {
            
            NSString *isShowPopUp = [userInfo valueForKey:@"Popup"];
            NSDictionary *apsInfo = [userInfo valueForKey:@"aps"];
            NSString *popMessage = [apsInfo valueForKey:@"alert"];
            NSString *lblRightBtn = [userInfo valueForKey:@"btnLabel"];
            NSString *popTitle = [userInfo valueForKey:@"PopupTitle"];
            NSString *soundName = [apsInfo valueForKey:@"sound"];
            if ([isShowPopUp isEqualToString:@"0"]) {
                
                [self gotoAddFundScreen];
                
            }else{
                if (isAppInBackGround) {
                    
                    [self gotoAddFundScreen];
                    
                }else{
                    [self playPopupSound:soundName];
                    [self showPopup_Title:popTitle message:popMessage titleViewBtn:lblRightBtn tag:2 soundName:soundName];
                    
                }
            }
            
            
            
        }else if ([strAction isEqualToString:REMOTE_NOTIFICATION_CALL_OPTION]) {
            
            NSString *isShowPopUp = [userInfo valueForKey:@"Popup"];
            NSDictionary *apsInfo = [userInfo valueForKey:@"aps"];
            NSString *popMessage = [apsInfo valueForKey:@"alert"];
            NSString *lblRightBtn = [userInfo valueForKey:@"btnLabel"];
            NSString *popTitle = [userInfo valueForKey:@"PopupTitle"];
            NSString *soundName = [apsInfo valueForKey:@"sound"];
            if ([isShowPopUp isEqualToString:@"0"]) {
                
                [self gotoCallOptionScreen];
                
            }else{
                if (isAppInBackGround) {
                    
                    [self gotoCallOptionScreen];
                    
                }else{
                    [self showPopup_Title:popTitle message:popMessage titleViewBtn:lblRightBtn tag:3 soundName:soundName];
                    
                }
            }
        }else if ([strAction isEqualToString:REMOTE_NOTIFICATION_MESSAGE]) {
            NSString *popTitle = [userInfo valueForKey:@"PopupTitle"];
            NSString *isShowPopUp = [userInfo valueForKey:@"Popup"];
            NSDictionary *apsInfo = [userInfo valueForKey:@"aps"];
            NSString *popMessage = [apsInfo valueForKey:@"alert"];
            NSString *lblRightBtn = [userInfo valueForKey:@"btnLabel"];
            NSString *soundName = [apsInfo valueForKey:@"sound"];
            
            if ([isShowPopUp isEqualToString:@"0"]) {
                
                [self gotoMessageScreen];
                
            }else{
                if (isAppInBackGround) {
                    
                    [self gotoMessageScreen];
                }else{
                    [self showPopup_Title:popTitle message:popMessage titleViewBtn:lblRightBtn tag:4 soundName:soundName];
                    
                }
            }
        }else if ([strAction isEqualToString:REMOTE_NOTIFICATION_CALL_RATES]) {
            NSString *popTitle = [userInfo valueForKey:@"PopupTitle"];
            NSString *isShowPopUp = [userInfo valueForKey:@"Popup"];
            NSDictionary *apsInfo = [userInfo valueForKey:@"aps"];
            NSString *popMessage = [apsInfo valueForKey:@"alert"];
            NSString *lblRightBtn = [userInfo valueForKey:@"btnLabel"];
            NSString *soundName = [apsInfo valueForKey:@"sound"];
            
            if ([isShowPopUp isEqualToString:@"0"]) {
                
                [self gotoCallRatesScreen];
                
            }else{
                if (isAppInBackGround) {
                    
                    [self gotoCallRatesScreen];
                    
                }else{
                    [self showPopup_Title:popTitle message:popMessage titleViewBtn:lblRightBtn tag:5 soundName:soundName];
                    
                }
            }
        }else if ([strAction isEqualToString:REMOTE_NOTIFICATION_INVITE_FRIENDS]) {
            NSString *popTitle = [userInfo valueForKey:@"PopupTitle"];
            NSString *isShowPopUp = [userInfo valueForKey:@"Popup"];
            NSDictionary *apsInfo = [userInfo valueForKey:@"aps"];
            NSString *popMessage = [apsInfo valueForKey:@"alert"];
            NSString *lblRightBtn = [userInfo valueForKey:@"btnLabel"];
            NSString *soundName = [apsInfo valueForKey:@"sound"];
            
            if ([isShowPopUp isEqualToString:@"0"]) {
                
                [self gotoInviteFriendsScreen];
                
            }else{
                if (isAppInBackGround) {
                    
                    [self gotoInviteFriendsScreen];
                }else{
                    [self showPopup_Title:popTitle message:popMessage titleViewBtn:lblRightBtn tag:6 soundName:soundName];
                    
                }
            }
        }else if ([strAction isEqualToString:REMOTE_NOTIFICATION_MORE_OPTIONS]) {
            NSString *popTitle = [userInfo valueForKey:@"PopupTitle"];
            NSString *isShowPopUp = [userInfo valueForKey:@"Popup"];
            NSDictionary *apsInfo = [userInfo valueForKey:@"aps"];
            NSString *popMessage = [apsInfo valueForKey:@"alert"];
            NSString *lblRightBtn = [userInfo valueForKey:@"btnLabel"];
            NSString *soundName = [apsInfo valueForKey:@"sound"];
            
            if ([isShowPopUp isEqualToString:@"0"]) {
                
                [self gotoMoreOptionsScreen];
                
            }else{
                if (isAppInBackGround) {
                    
                    [self gotoMoreOptionsScreen];
                }else{
                    [self showPopup_Title:popTitle message:popMessage titleViewBtn:lblRightBtn tag:7 soundName:soundName];
                    
                }
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        
        if (buttonIndex==1) {
            if ([self isUserLoggedIn]) {
                
                viewControllerLogon.tabBarController.selectedIndex = 2;
            }
        }
        
    }else if (alertView.tag==2){
        
        if (buttonIndex==1) {
            
            [self gotoAddFundScreen];
        }
    }else if (alertView.tag==3){
        
        if (buttonIndex==1) {
            
           [self gotoCallOptionScreen];
        }
    }else if (alertView.tag==4){
        
        if (buttonIndex==1) {
            
            [self gotoMessageScreen];
        }
    }else if (alertView.tag==5){
        
        if (buttonIndex==1) {
            
            [self gotoCallRatesScreen];
        }
    }else if (alertView.tag==6){
        
        if (buttonIndex==1) {
            
            [self gotoInviteFriendsScreen];
        }
    }else if (alertView.tag==7){
        
        if (buttonIndex==1) {
            
            [self gotoMoreOptionsScreen];
        }
    }else{
        exit(0);
    }
    
}
////////////////////////////////vishnu/////////////////////////








-(void)ShowNativeContacts:(NSString *)onPage
{
    strContactOnPage = onPage;
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    // Display only a person's phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
    
    
    picker.displayedProperties = displayedItems;
    [self.window setRootViewController:picker];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	return YES;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, property);
    CFStringRef phonenumberselected = ABMultiValueCopyValueAtIndex(multi, ABMultiValueGetIndexForIdentifier(multi, identifier));
    if (phonenumberselected) {
        NSString *selectedNo = (__bridge NSString *)phonenumberselected;
        selectedNo = [GlobalData filterDialString:selectedNo];
        if ([strContactOnPage isEqualToString:[GlobalData getAppInfo].topUps]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONTACT_SELECTED_ON_TOPUP object:selectedNo];
        }else if ([strContactOnPage isEqualToString:[GlobalData getAppInfo].getRates]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONTACT_SELECTED_ON_RATES object:selectedNo];
        }else if ([strContactOnPage isEqualToString:TOPUPWEB]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONTACT_SELECTED_ON_TOPUP_WEB object:selectedNo];
        }
        
        [self.window setRootViewController:viewControllerLogon];
    }
	return NO;
}

// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self.window setRootViewController:viewControllerLogon];
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
     isAppInBackGround = YES;
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    isAppInBackGround = NO;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    //    [_hostReach stopNotifier];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                                    name:kReachabilityChangedNotification
    //                                                  object:nil];
    //    [self sipCleanup];
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    UIAlertView *memoryAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Your Phone memory is not allow to perform anything!!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [memoryAlert show];
    
    NSLog(@"Memory warning issue ");
}








//vishnu///////////////

-(void)showPopup_Title:(NSString*)popTitle message:(NSString*)popMessage titleViewBtn:(NSString*)lblRightBtn tag:(NSInteger)tag soundName:(NSString*)soundName{
    
    
    [self playPopupSound:soundName];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:popTitle message:popMessage delegate:self cancelButtonTitle:[GlobalData getAppInfo].strClose otherButtonTitles:lblRightBtn, nil];
    alert.tag = tag;
    alert.delegate = self;
    [alert show];
}

-(void)playPopupSound:(NSString*)soundName{
    
    @try {
        
        NSString *fileName = [soundName stringByDeletingPathExtension];
        SystemSoundID audioEffect;
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"];
        if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
            NSURL *pathURL = [NSURL fileURLWithPath: path];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
            AudioServicesPlaySystemSound(audioEffect); 
        }
        else {
            NSLog(@"error, file not found: %@", path);
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    //[soundPath release];
}
-(BOOL)isUserLoggedIn{
    NSUserDefaults *userLoginpref   = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userLoginpref valueForKey:@"userid"];
    NSString *password = [userLoginpref valueForKey:@"password"];
    NSString *phoneNumber = [userLoginpref valueForKey:@"phonenumber"];
    if (userId&&password&&phoneNumber) {
        return YES;
    }
    return NO;
    
}

-(void)gotoAddFundScreen{
    
    if ([self isUserLoggedIn]) {
        
        viewControllerLogon.tabBarController.selectedIndex = 3;
        UINavigationController *navProfileViewController = (UINavigationController*)[viewControllerLogon.tabBarController.viewControllers objectAtIndex:3];
        addProfileViewController *profileViewController = [navProfileViewController.viewControllers objectAtIndex:0];
        
        if (isAddFundScreen) {
            isAddFundScreen = NO;
            [navProfileViewController popViewControllerAnimated:NO];
        }
        [profileViewController gotoAddFundScreen];
        
    }
}
-(void)gotoCallOptionScreen{
    
    if ([self isUserLoggedIn]) {
        
        viewControllerLogon.tabBarController.selectedIndex = 3;
        UINavigationController *navProfileViewController = (UINavigationController*)[viewControllerLogon.tabBarController.viewControllers objectAtIndex:3];
        addProfileViewController *profileViewController = [navProfileViewController.viewControllers objectAtIndex:0];
        
        if (isCallOptionScreen) {
            isCallOptionScreen = NO;
            [navProfileViewController popViewControllerAnimated:NO];
        }
        [profileViewController gotoCallOptionScreen];
        
    }
}
-(void)gotoMessageScreen{
    
    if ([self isUserLoggedIn]) {
        
        viewControllerLogon.tabBarController.selectedIndex = 3;
        UINavigationController *navProfileViewController = (UINavigationController*)[viewControllerLogon.tabBarController.viewControllers objectAtIndex:3];
        addProfileViewController *profileViewController = [navProfileViewController.viewControllers objectAtIndex:0];
        
        if (isMessageScreen) {
            isMessageScreen = NO;
            [navProfileViewController popViewControllerAnimated:NO];
        }
        [profileViewController gotoMessageScreen];
        
    }
}
-(void)gotoCallRatesScreen{
    
    if ([self isUserLoggedIn]) {
        
        viewControllerLogon.tabBarController.selectedIndex = 3;
        UINavigationController *navProfileViewController = (UINavigationController*)[viewControllerLogon.tabBarController.viewControllers objectAtIndex:3];
        addProfileViewController *profileViewController = [navProfileViewController.viewControllers objectAtIndex:0];
        
        if (isCallRatesScreen) {
            isCallRatesScreen = NO;
            [navProfileViewController popViewControllerAnimated:NO];
        }
        [profileViewController gotoCallRatesScreen];
        
    }
}
-(void)gotoInviteFriendsScreen{
    if ([self isUserLoggedIn]) {
        
        viewControllerLogon.tabBarController.selectedIndex = 3;
        UINavigationController *navProfileViewController = (UINavigationController*)[viewControllerLogon.tabBarController.viewControllers objectAtIndex:3];
        addProfileViewController *profileViewController = [navProfileViewController.viewControllers objectAtIndex:0];
        
        if (isInviteFriendsScreen) {
            isInviteFriendsScreen = NO;
            [navProfileViewController popViewControllerAnimated:NO];
        }
        [profileViewController gotoInviteFriendsScreen];
        
    }
}
-(void)gotoMoreOptionsScreen{
    
    if ([self isUserLoggedIn]) {
        
        viewControllerLogon.tabBarController.selectedIndex = 3;
        UINavigationController *navProfileViewController = (UINavigationController*)[viewControllerLogon.tabBarController.viewControllers objectAtIndex:3];
        addProfileViewController *profileViewController = [navProfileViewController.viewControllers objectAtIndex:0];
        
        if (isMoreOptionsScreen) {
            isMoreOptionsScreen = NO;
            [navProfileViewController popViewControllerAnimated:NO];
        }
        [profileViewController gotoMoreOptionsScreen];
        
    }
}
//vishnu///////////////
@end
