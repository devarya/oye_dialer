//
//  LocationData.h
//  Callture
//
//  Created by user on 24/09/12.
//
//

#import <Foundation/Foundation.h>

@interface LocationData : NSObject
  
{
    
    NSString *country;
    NSString *state;
    NSString *city;
}
@property(nonatomic,retain) NSString *country;
@property(nonatomic,retain) NSString *state;
@property(nonatomic,retain) NSString *city;
@end

 