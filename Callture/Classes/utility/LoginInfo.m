//
//  LoginInfo.m
//  Callture
//
//  Created by Manish on 07/12/11.
//  Copyright 2011 Aryavrat infotech. All rights reserved.
//

#import "LoginInfo.h"

static LoginInfo *loginManager = nil;

@implementation LoginInfo

@synthesize ResultID,ResultStr,UserKey,ClientId,ClientName;
+ (id)LoginManager {
    @synchronized(self) {
        if (loginManager == nil)
            loginManager = [[self alloc] init];
    }
    return loginManager;
}
@end
