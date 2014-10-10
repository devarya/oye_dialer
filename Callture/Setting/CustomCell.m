//
//  CustomCell.m
//  Callture
//
//  Created by Manish on 24/02/12.
//  Copyright (c) 2012 Aryavrat Infotech Pvt. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize imgIsDefault,lblText;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        imgIsDefault = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 16, 15)];
        [self addSubview:imgIsDefault];
        lblText = [[UILabel alloc]initWithFrame:CGRectMake(26, 0, (self.frame.size.width-60), self.frame.size.height)];
        lblText.backgroundColor = [UIColor clearColor];
        lblText.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:lblText];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
