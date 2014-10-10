//
//  Country.h
//  Callture
//
//  Created by user on 17/10/12.
//
//

#import <Foundation/Foundation.h>

@interface Country : NSObject
{
    NSString *countryName;
    NSString *countryCode;
    NSMutableArray *areaList;
    NSString *selectedArea;
}
@property (nonatomic,retain) NSString *countryName;
@property (nonatomic,retain) NSString *countryCode;
@property (nonatomic, retain) NSString *selectedArea;
@property (nonatomic,retain) NSMutableArray *areaList;
@end
