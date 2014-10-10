//
//  Area.h
//  Callture
//
//  Created by user on 17/10/12.
//
//

#import <Foundation/Foundation.h>

@interface Area : NSObject
{
    NSString *areaName;
    NSString *areaCode;
    NSString *rate;
    NSString *rateCode;
}
@property (nonatomic, retain) NSString *areaName;
@property (nonatomic, retain) NSString *areaCode;
@property (nonatomic, retain) NSString *rate;
@property (nonatomic, retain) NSString *rateCode;
@end
