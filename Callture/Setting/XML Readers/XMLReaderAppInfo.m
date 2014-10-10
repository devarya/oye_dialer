//
//  XMLReaderAppInfo.m
//  Oye
//
//  Created by user on 26/10/12.
//
//
/*
 <XML id='xmlRoot' name='xmlRoot'>
 <AppSettings>
 <ResellerId>11105</ResellerId>
 <AppName>Oye</AppName>
 <AppDescription>Oye Mobile Appp</AppDescription>
 <WebSite>www.oyetoronto.ca</WebSite>
 <CopyRight><![CDATA[&copy; 1998-2012 Oye Communications]]></CopyRight>
 <AboutText><![CDATA[Contents for this page like.... Application Description, Copyright Message, website and customer service and this Message will be returned by an API. The API will be called from at signup/login and will be stored within the app. They shall then be displayed from this page. These contents might incldue some <B>HTML</B> and shall be displayed accordingly.]]></AboutText>
 <CS_Email>techsupport@callture.com</CS_Email>
 <CS_Phone>1 800 958 1960</CS_Phone>
 <FacebookAppId>423445051042838</FacebookAppId>
 <FacebookAppSecret>ce7912a698dbf6e5813e916451ca8366</FacebookAppSecret>
 <TwitterAppKey>y0w2F9TLXGpUcmtduDqw</TwitterAppKey>
 <TwitterAppSecret>ib4PlHo9ovf0gtU87xNIj5ltsn7cwxUm73nI9fw3IBA</TwitterAppSecret>
 </AppSettings>
 <Status>
 <ID>1</ID>
 <Description>Successful</Description>
 </Status>
 
 </XML>
 */

#import "XMLReaderAppInfo.h"
#import "Constants.h"
#import "GlobalData.h"
@implementation XMLReaderAppInfo
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"AppSettings"]) {
        currentObject = [[AppInfo alloc] init];
    }
    
    else if([elementName isEqualToString:@"label"]) {
        
        currentObjectLabels = [[AppInfo alloc] init];
        
        dict = [[NSDictionary alloc] initWithDictionary:attributeDict];
        
    }
    
    self.contentOfCurrentProperty = [[NSMutableString alloc] init];
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (qName) {
        elementName = qName;
    }
    if ([elementName isEqualToString:@"AppSettings"])
    {
        [GlobalData setAppInfo:currentObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APP_INFO object:nil];
    }
    if ([elementName isEqualToString:@"ResellerId"]) {
        currentObject.resellerId = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"AppDescription"]) {
        currentObject.AppDescription = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"CopyRight"]) {
        currentObject.copyright = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"WebSite"]) {
        currentObject.webSite = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"CS_Phone"]) {
        currentObject.CS_Phone = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"CS_Email"]) {
        currentObject.CS_Email = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"AboutText"]) {
        currentObject.aboutText = self.contentOfCurrentProperty;
    }
    
    if ([elementName isEqualToString:@"FacebookAppId"]) {
        currentObject.facebookAppId = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"FacebookAppSecret"]) {
        currentObject.facebookAppSecret = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"FaceBookPage"]) {
        currentObject.facebookPage = self.contentOfCurrentProperty;
    }
    
    if ([elementName isEqualToString:@"TwitterAppKey"]) {
        currentObject.twitterAppKey = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"TwitterAppSecret"]) {
        currentObject.TwitterAppSecret = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"TwitterPage"]) {
        currentObject.TwitterPage = self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"LoginPage"]) {
        currentObject.LoginPage = self.contentOfCurrentProperty;
    }
    
    
    if ([elementName isEqualToString:@"OptionsPage"]) {
        currentObject.urlOptionsPage = self.contentOfCurrentProperty;
        NSLog(@"%@",currentObject.urlOptionsPage);
    }
    if ([elementName isEqualToString:@"TopupPage"]) {
        currentObject.urlTopUpPage = self.contentOfCurrentProperty;
        NSLog(@"%@",currentObject.urlTopUpPage);
    }
    if ([elementName isEqualToString:@"ContactsPage"]) {
        currentObject.urlContactsPage = self.contentOfCurrentProperty;
        NSLog(@"%@",currentObject.urlContactsPage);
    }
    if ([elementName isEqualToString:@"ShowTopUps"]) {
        currentObject.showTopUps =  [self.contentOfCurrentProperty boolValue];
    }
    if ([elementName isEqualToString:@"ShowAddFunds"]) {
        currentObject.showAddFunds =  [self.contentOfCurrentProperty boolValue];
    }
    if ([elementName isEqualToString:@"ShowMessages"]) {
        currentObject.showMessage =  [self.contentOfCurrentProperty boolValue];
    }
    if ([elementName isEqualToString:@"ShowInviteFriends"]) {
        currentObject.showInviteFriends =  [self.contentOfCurrentProperty boolValue];
    }
    if ([elementName isEqualToString:@"MessagesPage"]) {
        currentObject.messagePage =  self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"AddFundsPage"]) {
        currentObject.addFundsPage =  self.contentOfCurrentProperty;
    }
    
    if ([elementName isEqualToString:@"AppImagesPath"]) {
        currentObject.imagePath =  self.contentOfCurrentProperty;
    }
    if ([elementName isEqualToString:@"AppImagesUpdateDate"]) {
        currentObject.imageUpdateDate =  self.contentOfCurrentProperty;
        if (currentObject.imagePath) {
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:IMAGE_UPDATE_DATE]);
            if ([[NSUserDefaults standardUserDefaults] valueForKey:IMAGE_UPDATE_DATE])
            {
                NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
                [dateformatter setTimeZone:[NSTimeZone localTimeZone]];
                [dateformatter setDateFormat:@"MM/dd/yyyy h:mm:ss aaa"];
                NSDate *newUpdatedDate = [dateformatter dateFromString:currentObject.imageUpdateDate];
                NSDate *lastUpdatedDate = [dateformatter dateFromString:[[NSUserDefaults standardUserDefaults] valueForKey:IMAGE_UPDATE_DATE]];
                if ([newUpdatedDate compare:lastUpdatedDate] == NSOrderedDescending)
                {
                    [[NSUserDefaults standardUserDefaults] setValue:currentObject.imageUpdateDate forKey:IMAGE_UPDATE_DATE];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSMutableData *myImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@_40x40.png",docDir,[[GlobalData getApp_Name] stringByReplacingOccurrencesOfString:@" " withString:@"_"]]]];
                    NSMutableString *jpegFilePath = [NSString stringWithFormat:@"%@/%@_40x40.png",docDir,[[GlobalData getApp_Name] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
                    if ([myImage writeToFile:jpegFilePath atomically:YES]) {
                        currentObject.imgTopRightLogo = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    myImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/activate_1x41.png",currentObject.imagePath]]];
                    jpegFilePath = [NSString stringWithFormat:@"%@/activate_1x41.png",docDir];
                    if ([myImage writeToFile:jpegFilePath atomically:YES]) {
                        currentObject.imgSendBtn = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    myImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/log-out-with-txt_65x25.png",currentObject.imagePath]]];
                    jpegFilePath = [NSString stringWithFormat:@"%@/log-out-with-txt_65x25.png",docDir];
                    if ([myImage writeToFile:jpegFilePath atomically:YES]) {
                        currentObject.imgLogout = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    
                    myImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@_151x100.png",docDir,[[GlobalData getApp_Name] stringByReplacingOccurrencesOfString:@" " withString:@"_"]]]];
                    jpegFilePath = [NSString stringWithFormat:@"%@/%@_151x100.png",docDir,[[GlobalData getApp_Name] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
                    if ([myImage writeToFile:jpegFilePath atomically:YES]) {
                        currentObject.imgLogo = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    myImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/btnBg_1x41.png",currentObject.imagePath]]];
                    jpegFilePath = [NSString stringWithFormat:@"%@/btnBg_1x41.png",docDir];
                    if ([myImage writeToFile:jpegFilePath atomically:YES]) {
                        currentObject.imgDropDownBg = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    
                    myImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/dialer_320x411.png",currentObject.imagePath]]];
                    jpegFilePath = [NSString stringWithFormat:@"%@/dialer_320x411.png",docDir];
                    if ([myImage writeToFile:jpegFilePath atomically:YES]) {
                        currentObject.imgDialer4 = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    myImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/dialer_320x500.png",currentObject.imagePath]]];
                    jpegFilePath = [NSString stringWithFormat:@"%@/dialer_320x500.png",docDir];
                    if ([myImage writeToFile:jpegFilePath atomically:YES]) {
                        currentObject.imgDialer5 = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    myImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/contacts_30x30.png",currentObject.imagePath]]];
                    jpegFilePath = [NSString stringWithFormat:@"%@/contacts_30x30.png",docDir];
                    if ([myImage writeToFile:jpegFilePath atomically:YES]) {
                        currentObject.imgContacts = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    myImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/cell-btn_180x40.png",currentObject.imagePath]]];
                    jpegFilePath = [NSString stringWithFormat:@"%@/cell-btn_180x40.png",docDir];
                    if ([myImage writeToFile:jpegFilePath atomically:YES]) {
                        currentObject.imgCellDropDown = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    myImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Cancel_1x41.png",currentObject.imagePath]]];
                    jpegFilePath = [NSString stringWithFormat:@"%@/Cancel_1x41.png",docDir];
                    if ([myImage writeToFile:jpegFilePath atomically:YES]) {
                        currentObject.imgCancelBtn = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                }else
                {
                    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSMutableString *jpegFilePath = [NSString stringWithFormat:@"%@/%@_40x40.png",docDir,[[GlobalData getApp_Name] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:jpegFilePath]) {
                        currentObject.imgTopRightLogo = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    
                    jpegFilePath = [NSString stringWithFormat:@"%@/activate_1x41.png",docDir];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:jpegFilePath]) {
                        currentObject.imgSendBtn = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    
                    jpegFilePath = [NSString stringWithFormat:@"%@/log-out-with-txt_65x25.png",docDir];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:jpegFilePath]) {
                        currentObject.imgLogout = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    
                    
                    jpegFilePath = [NSString stringWithFormat:@"%@/%@_151x100.png",docDir,[[GlobalData getApp_Name] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:jpegFilePath]) {
                        currentObject.imgLogo = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    
                    jpegFilePath = [NSString stringWithFormat:@"%@/btnBg_1x41.png",docDir];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:jpegFilePath]) {
                        currentObject.imgDropDownBg = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    
                    
                    jpegFilePath = [NSString stringWithFormat:@"%@/dialer_320x411.png",docDir];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:jpegFilePath]) {
                        currentObject.imgDialer4 = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    
                    jpegFilePath = [NSString stringWithFormat:@"%@/dialer_320x500.png",docDir];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:jpegFilePath]) {
                        currentObject.imgDialer5 = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    
                    jpegFilePath = [NSString stringWithFormat:@"%@/contacts_30x30.png",docDir];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:jpegFilePath]) {
                        currentObject.imgContacts = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    
                    jpegFilePath = [NSString stringWithFormat:@"%@/cell-btn_180x40.png",docDir];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:jpegFilePath]) {
                        currentObject.imgCellDropDown = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                    
                    
                    jpegFilePath = [NSString stringWithFormat:@"%@/Cancel_1x41.png",docDir];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:jpegFilePath]) {
                        currentObject.imgCancelBtn = [UIImage imageWithData:[NSData dataWithContentsOfFile:jpegFilePath]];
                    }
                }
            }else
            {
                [[NSUserDefaults standardUserDefaults] setValue:currentObject.imageUpdateDate forKey:IMAGE_UPDATE_DATE];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    
    ///// 26 July 2013 ////
    
    if ([elementName isEqualToString:@"PageBgColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
           currentObject.pageBgColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    if ([elementName isEqualToString:@"PageTextColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
            currentObject.pageTextColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    if ([elementName isEqualToString:@"TopBarBgColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
            currentObject.topBarBgColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    if ([elementName isEqualToString:@"TopBarTextColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
            currentObject.topBarTextColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    if ([elementName isEqualToString:@"BottomBarBgColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
            currentObject.bottomBarBgColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    if ([elementName isEqualToString:@"BottomBarTextColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
            currentObject.bottomBarTextColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    if ([elementName isEqualToString:@"BottomBarDimTextColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
            currentObject.bottomBarDimTextColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    if ([elementName isEqualToString:@"DataViewBgColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
            currentObject.dataViewBgColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    if ([elementName isEqualToString:@"DataViewTextColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
            currentObject.dataViewTextColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    if ([elementName isEqualToString:@"DataViewDimTextColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
            currentObject.dataViewDimTextColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    if ([elementName isEqualToString:@"DialerTextColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
            currentObject.colDialerText = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    if ([elementName isEqualToString:@"DialerDialTextColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
            currentObject.colDialerDialText = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    if ([elementName isEqualToString:@"LoginBgColor"]) {
        
        if(self.contentOfCurrentProperty.length > 0)
        {
            float r = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
            float g = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
            float b = [[[self.contentOfCurrentProperty componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
            currentObject.colDialerDialText = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    }
    
    /////////
    if([elementName isEqualToString:@"label"])
    {
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Select Contacts"]) {
            currentObject.selectContacts = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.selectContacts);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"All"]) {
            currentObject.all = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.all);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Refer Friends"]) {
            currentObject.referFriends = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.referFriends);
        }
        
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Enter your 10 digit Mobile Number"]) {
            currentObject.enter10DigitMobileNo = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.enter10DigitMobileNo);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"New Client. Welcome !"]) {
            currentObject.clientWelcome = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.clientWelcome);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Promocode"]) {
            currentObject.promoCode = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.promoCode);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Passcode sent in text"]) {
            currentObject.passcodeSentInText = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.passcodeSentInText);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Didn't get passcode?"]) {
            currentObject.didntgetpasscode = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.didntgetpasscode);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Enter passcode"]) {
            currentObject.enterPasscode = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.enterPasscode);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Call Me"]) {
            currentObject.callMe = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.callMe);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Activate"]) {
            currentObject.activate = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.activate);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"login"]) {
            currentObject.login = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.login);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Mobile Recharge"]) {
            currentObject.mobileRecharge = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.mobileRecharge);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Send recharge to:"]) {
            currentObject.sendRechargeTo = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.sendRechargeTo);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Recipient's Mobile Number"]) {
            currentObject.recipientsMobileNumber = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.recipientsMobileNumber);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Mobile Operator"]) {
            currentObject.mobileOperator = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.mobileOperator);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Please Select Operator"]) {
            currentObject.pleaseSelectOperator = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.pleaseSelectOperator);
        }
        
        
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Mobile Operator:"]) {
            currentObject.mobileOperator = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.mobileOperator);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Amount to send:"]) {
            currentObject.amountToSend = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.amountToSend);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Please Select Amount"]) {
            currentObject.pleaseSelectAmount = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.pleaseSelectAmount);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Recepient will receive:"]) {
            currentObject.recepientWillReceive = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.recepientWillReceive);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Send"]) {
            currentObject.send = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.send);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Recent Transactions"]) {
            currentObject.recentTransactions = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.recentTransactions);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Topup confirmation"]) {
            currentObject.topupConfirmation = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.topupConfirmation);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Number:"]) {
            currentObject.number = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.number);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Country:"]) {
            currentObject.country = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.country);
        }
        
        
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Operator:"]) {
            currentObject.operatorWithColon = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.operatorWithColon);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Cust Service:"]) {
            currentObject.custService = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.custService);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Currency:"]) {
            currentObject.currency = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.currency);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Amount:"]) {
            currentObject.amount = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.amount);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Tax:"]) {
            currentObject.tax = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.tax);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Sent Amount:"]) {
            currentObject.sendAmount = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.sendAmount);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Amount Charged:"]) {
            currentObject.amountCharged = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.amountCharged);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Trans ID:"]) {
            currentObject.transId = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.transId);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Name:"]) {
            currentObject.name = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.name);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"From"]) {
            currentObject.from = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.from);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Confirm Transaction"]) {
            currentObject.confirmTransaction = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.confirmTransaction);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Cancel"]) {
            currentObject.cancel = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.cancel);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Balance:"]) {
            currentObject.Balance = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.Balance);
        }
        
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Follow Us"]) {
            currentObject.followUs = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.followUs);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Rates calculator"]) {
            currentObject.ratesCalculator = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.ratesCalculator);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"By Number"]) {
            currentObject.byNumber = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.byNumber);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"International Number"]) {
            currentObject.internationalNumber = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.internationalNumber);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"By Area"]) {
            currentObject.byArea = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.byArea);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Country"]) {
            currentObject.country = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.country);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Please select"]) {
            currentObject.pleaseSelect = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.pleaseSelect);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Area"]) {
            currentObject.area = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.area);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Your Rates"]) {
            currentObject.yourRates = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.yourRates);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Loading"]) {
            currentObject.loading = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.loading);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Please Enter PhoneNumber"]) {
            currentObject.pleaseEnterPhoneNumber = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.pleaseEnterPhoneNumber);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Please Enter Promocode"]) {
            currentObject.pleaseEnterPromocode = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.pleaseEnterPromocode);
        }
        
        
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Please Enter Passcode"]) {
            currentObject.pleaseEnterPasscode = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.pleaseEnterPasscode);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Login Failed"]) {
            currentObject.loginFailed = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.loginFailed);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Network Not Available"]) {
            currentObject.networkNotAvailable = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.networkNotAvailable);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Please dial a number"]) {
            currentObject.pleaseDialAnumber = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.pleaseDialAnumber);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Please Enter a valid Number"]) {
            currentObject.pleaseEnterAvalidNumber = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.pleaseEnterAvalidNumber);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Amount Selection Or Entering Amount is Required"]) {
            currentObject.amountSelectionOrEnteringAmountIsRequired = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.amountSelectionOrEnteringAmountIsRequired);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Failed to Load Mobile Operators"]) {
            currentObject.failedToLoadMobileOperators = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.failedToLoadMobileOperators);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Failed to Process"]) {
            currentObject.failedToProcess = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.failedToProcess);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Failed to Get Response From Server"]) {
            currentObject.failedToGetResponseFromServer = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.failedToGetResponseFromServer);
        }
        
        
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Please Select Country"]) {
            currentObject.pleaseSelectCountry = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.pleaseSelectCountry);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Failed to Load Country List"]) {
            currentObject.failedToLoadCountryList = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.failedToLoadCountryList);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Failed to Load Area List"]) {
            currentObject.failedToLoadAreaList = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.failedToLoadAreaList);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Failed to Load Rates List"]) {
            currentObject.failedToLoadRatesList = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.failedToLoadRatesList);
        }
        
        
                
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Keypad"]) {
            currentObject.keypad = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.keypad);
        }

        if ([[dict objectForKey:@"eng"] isEqualToString:@"Contacts"]) {
            currentObject.contacts = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.contacts);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Topups"]) {
            currentObject.topUps = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.topUps);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Options"]) {
            currentObject.options = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.options);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Phone no"]) {
            currentObject.phoneNo = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.phoneNo);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Logout"]) {
            currentObject.logOut = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.logOut);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Call Options"]) {
            currentObject.callOptions = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.callOptions);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Get Rates"]) {
            currentObject.getRates = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.getRates);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"About Us"]) {
            currentObject.aboutUs = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.aboutUs);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"More Options"]) {
            currentObject.moreOptions = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.moreOptions);
        }
        
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Top Ups"]) {
            currentObject.topUps = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.topUps);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Messages"]) {
            currentObject.messages = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.messages);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Add Funds"]) {
            currentObject.addFunds = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.addFunds);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Call Rates"]) {
            currentObject.callRates = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.callRates);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Invite Friends"]) {
            currentObject.inviteFriends = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.inviteFriends);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Invite"]) {
            currentObject.invite = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.invite);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Call Type"]) {
            currentObject.callType = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.callType);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Use Wifi when available"]) {
            currentObject.useWifiWhenAvailable = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.useWifiWhenAvailable);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Announce Minutes"]) {
            currentObject.announceMinutes = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.announceMinutes);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Announce Balance"]) {
            currentObject.announceBalance = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.announceBalance);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Close"]) {
            currentObject.close = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.close);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Pull up to refresh..."]) {
            currentObject.pullUpToRefresh = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.pullUpToRefresh);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Release to refresh..."]) {
            currentObject.releaseToRefresh = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.releaseToRefresh);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Customer Service"]) {
            currentObject.customerService = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.customerService);
        }
        
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Customer Service"]) {
            currentObject.customerService = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.customerService);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"version"]) {
            currentObject.version = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.version);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Street Address"]) {
            currentObject.streetAddress = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.streetAddress);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Address Line2"]) {
            currentObject.AddressLine2 = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.AddressLine2);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"City"]) {
            currentObject.city = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.city);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Province / State"]) {
            currentObject.province = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.province);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Name on Credit Card"]) {
            currentObject.nameOnCreditCard = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.nameOnCreditCard);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Credit Card No"]) {
            currentObject.creditCardNo = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.creditCardNo);
        }
        
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Security Code (CVV)"]) {
            currentObject.securityCode = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.securityCode);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Exp Month"]) {
            currentObject.expMonth = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.expMonth);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Exp Year"]) {
            currentObject.expYear = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.expYear);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Card Information"]) {
            currentObject.cardInformation = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.cardInformation);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Billing Address"]) {
            currentObject.billingAddress = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.billingAddress);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"State/Postal Code"]) {
            currentObject.statePostalCode = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.statePostalCode);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Save Billing Info"]) {
            currentObject.saveBillingInfo = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.saveBillingInfo);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Select Amount"]) {
            currentObject.selectAmount = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.selectAmount);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Next"]) {
            currentObject.next = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.next);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Charge my Credit Card"]) {
            currentObject.chargeMyCreditCard = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.chargeMyCreditCard);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Select All"]) {
            currentObject.strSelectAll = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.strSelectAll);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Contacts"]) {
            currentObject.selectFriends = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.selectFriends);
        }
        //vishnu
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Close"]) {
            currentObject.strClose = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.strClose);
        }if ([[dict objectForKey:@"eng"] isEqualToString:@"View"]) {
            currentObject.strView = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.strView);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"WantToViewTopUp"]) {
            currentObject.strView = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.strWantToGoTopUp);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"WantToViewMessage"]) {
            currentObject.strView = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.strWantToGoMsg);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"Message"]) {
            currentObject.strView = self.contentOfCurrentProperty;
            NSLog(@"%@",currentObject.strMessage);
        }
        
        
        if ([[dict objectForKey:@"eng"] isEqualToString:@"ImgDialer4"]) {
            currentObject.imgDialer4 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.contentOfCurrentProperty]]] ;
            NSLog(@"%@",currentObject.imgDialer4);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"ImgDialer5"]) {
            currentObject.imgDialer5 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.contentOfCurrentProperty]]] ;
            NSLog(@"%@",currentObject.imgDialer5);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"ImgBlueBtn"]) {
            currentObject.imgSendBtn = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.contentOfCurrentProperty]]] ;
            NSLog(@"%@",currentObject.imgSendBtn);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"ImgCancelBtn"]) {
            currentObject.imgCancelBtn = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.contentOfCurrentProperty]]] ;
            NSLog(@"%@",currentObject.imgCancelBtn);
        }
        if ([[dict objectForKey:@"eng"] isEqualToString:@"ImgDropDownBg"]) {
            currentObject.imgDropDownBg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.contentOfCurrentProperty]]] ;
            NSLog(@"%@",currentObject.imgDropDownBg);
        }
        
    }
    self.contentOfCurrentProperty = nil;
}
@end
