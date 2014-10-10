//
//  CallSetUp.m
//  Callture
//
//  Created by php1 on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CallSetUp.h"
static CallSetUp *SetUpManager = nil;
@implementation CallSetUp
@synthesize phoneNumber,promoCode,pinCode,ResultId,ResultStr,clientid,username,password,OwnerName;
+ (id)CallSetupManager {
    @synchronized(self) {
        if (SetUpManager == nil)
            SetUpManager = [[self alloc] init];
    }
    return SetUpManager;
}

@end
