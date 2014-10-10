//
//  CallLogData.h
//  Callture
//
//  Created by Manish on 09/12/11.
//  Copyright 2011 Aryavrat infotech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CallLogData : NSObject {		
	NSString *CDRID;
	NSString *LineNo;
	NSString *CallerID;
	NSString *StartTime;
	NSString *CallDuration;
	NSString *CalledNo;
	NSString *ConnectStatus;
	NSString *CallerName;
	NSString *ClientName;
	NSString *ProfileName;
    NSString *FormattedDate;
    int callType;
}
@property (nonatomic) int callType;
@property (nonatomic,retain) NSString *CDRID;
@property (nonatomic,retain)NSString *LineNo;
@property (nonatomic,retain)NSString *CallerID;
@property (nonatomic,retain)NSString *StartTime;
@property (nonatomic,retain)NSString *CallDuration;
@property (nonatomic,retain)NSString *CalledNo;
@property (nonatomic,retain)NSString *ConnectStatus;
@property (nonatomic,retain)NSString *CallerName;
@property (nonatomic,retain)NSString *ClientName;
@property (nonatomic,retain)NSString *ProfileName;
@property (nonatomic,retain)NSString *FormattedDate;

@end
