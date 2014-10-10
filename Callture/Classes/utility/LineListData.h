//
//  LineListData.h
//  Callture
//
//  Created by Manish on 16/12/11.
//  Copyright (c) 2011 Aryavrat infotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineListData : NSObject
@property (nonatomic,strong)NSString *LineNo;
@property (nonatomic,strong)NSString *CallbackNo;
@property (nonatomic,strong)NSString *Balance;
@property (nonatomic,strong)NSString *Description;
@property (nonatomic,strong)NSString *PublicPIN;
@property (nonatomic,strong)NSString *Deactivated;
@property (nonatomic,strong)NSString *VirtualDID;
@property (nonatomic,strong)NSString *CallerID;
@property (nonatomic,strong)NSString *DialOutString;
@end
