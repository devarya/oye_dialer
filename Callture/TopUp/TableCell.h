//
//  TableCell.h
//  Oye Dialer
//
//  Created by user on 30/11/12.
//
//

#import <UIKit/UIKit.h>
#import "MobileTopup.h"
@interface TableCell : UITableViewCell
{
    UILabel *lblAmount;
}
@property (nonatomic, retain) UILabel *lblAmount;
-(void)setTopupData:(MobileTopup *)mt;
@end
