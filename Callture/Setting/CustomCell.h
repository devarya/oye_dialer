//
//  CustomCell.h
//  Callture
//
//  Created by Manish on 24/02/12.
//  Copyright (c) 2012 Aryavrat Infotech Pvt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
{
    UIImageView *imgIsDefault;
    UILabel *lblText;
}
@property (nonatomic,retain)UIImageView *imgIsDefault;
@property (nonatomic,retain)UILabel *lblText;
@end
