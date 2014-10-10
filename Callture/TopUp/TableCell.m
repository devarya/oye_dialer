//
//  TableCell.m
//  Oye Dialer
//
//  Created by user on 30/11/12.
//
//

#import "TableCell.h"
@implementation TableCell
@synthesize lblAmount;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        CGRect rect = self.detailTextLabel.frame;
//        rect.origin.x = 120;
//        rect.size.width = 130;
        lblAmount = [[UILabel alloc]initWithFrame:CGRectMake(120, 23, 130, 20)];
        [lblAmount setBackgroundColor:[UIColor clearColor]];
        lblAmount.textColor = [UIColor grayColor];
        lblAmount.font = [UIFont systemFontOfSize:13];
        lblAmount.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:lblAmount];
    }
    return self;
}

-(void)setTopupData:(MobileTopup *)mt
{// 2012-11-29T10:59:46.290000000
    NSDateFormatter *objDateFormatter = [[NSDateFormatter alloc] init];
    [objDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *reqDate = [objDateFormatter dateFromString:mt.requestDate];
    [objDateFormatter setDateFormat:@"dd-MMM HH:mm TT"];
    self.detailTextLabel.text = [objDateFormatter stringFromDate:reqDate];
    
    self.textLabel.text = mt.mobileTelNo;
    self.lblAmount.text = [NSString stringWithFormat:@"$%@ > %@ %@",mt.amount,mt.postedCurrencyCode,mt.postedAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
