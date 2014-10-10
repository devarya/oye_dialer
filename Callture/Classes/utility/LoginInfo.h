//
//  LoginInfo.h
//  Callture
//
//  Created by Manish on 07/12/11.
//  Copyright 2011 Aryavrat infotech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginInfo : NSObject {
	NSString *ResultID;
	NSString *ResultStr;
	NSString *UserKey;
	NSString *ClientId;
	NSString *ClientName;
}
+ (id)LoginManager;
@property (nonatomic,strong)NSString *ResultID;
@property (nonatomic,strong)NSString *ResultStr;
@property (nonatomic,strong)NSString *UserKey;
@property (nonatomic,strong)NSString *ClientId;
@property (nonatomic,strong)NSString *ClientName;

@end
