//
//  AccessNumbers.h
//  Callture
//
//  Created by php1 on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessNumbers : NSObject
{
    NSString *accessNumber;
    NSString *destnumber;
    NSString *speeddialnumber;
    NSString *action;
    NSString *telenumber;
    NSString *country;
    NSString *province;
    NSString *city;
}
@property(nonatomic,retain) NSString *accessNumber;
@property(nonatomic,retain) NSString *destnumber;
@property(nonatomic,retain) NSString *speeddialnumber;
@property(nonatomic,retain) NSString *action;
@property(nonatomic,retain) NSString *telenumber;
@property(nonatomic,retain) NSString *country;
@property(nonatomic,retain) NSString *province;
@property(nonatomic,retain) NSString *city;
@end
