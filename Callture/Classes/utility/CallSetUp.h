//
//  CallSetUp.h
//  Callture
//
//  Created by php1 on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallSetUp : NSObject
{
    NSString *phoneNumber;
    NSString *promoCode;
    NSString *pinCode;
    NSString *Resultid;
    NSString *ResultStr;
    NSString *clientid;
    NSString *username;
    NSString *password;
    NSString *OwnerName;
 
}
+ (id)CallSetupManager;

@property(nonatomic,retain) NSString *OwnerName;
@property(nonatomic,retain) NSString *phoneNumber;
@property(nonatomic,retain) NSString *promoCode;
@property(nonatomic,retain) NSString *pinCode;
@property(nonatomic,retain) NSString *ResultId;
@property(nonatomic,retain) NSString *ResultStr;
@property(nonatomic,retain) NSString *clientid;
@property(nonatomic,retain) NSString *username;
@property(nonatomic,retain) NSString *password;
@end
