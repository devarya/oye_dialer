//
//  OptionTableCell.m
//  Callture
//
//  Created by user on 09/10/12.
//
//

#import "OptionTableCell.h"

@implementation OptionTableCell
@synthesize lblValue;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        lblValue = [[UILabel alloc]initWithFrame:CGRectMake(145, 5, 120, self.bounds.size.height-10)];
        [lblValue setFont:[UIFont systemFontOfSize:16]];
        lblValue.textColor = [UIColor colorWithRed:55.0/255.0 green:116.0/255.0 blue:177.0/255.0 alpha:1];
        [lblValue setBackgroundColor:[UIColor clearColor]];
        [lblValue setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:lblValue];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
