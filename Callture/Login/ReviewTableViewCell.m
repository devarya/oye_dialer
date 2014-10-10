//
//  ReviewTableViewCell.m
//  MovieGuru
//
//  Created by user on 23/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ReviewTableViewCell

@synthesize txtBoxName,lblName,txtPlaceHolderName ,lblString,txtString;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *customBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, 270, 95)];
    [customBackGroundView setBackgroundColor:[UIColor whiteColor]];
//    customBackGroundView.layer.borderColor = [[UIColor blackColor]CGColor];
//    customBackGroundView.layer.borderWidth = 1.0f;
    
    [customBackGroundView.layer setCornerRadius:10];
    [self addSubview:customBackGroundView];
      
    lblName = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, 250, 21)];
    [self.lblName setBackgroundColor:[UIColor clearColor]];
    [self.lblName setTextAlignment:UITextAlignmentCenter];
    [self.lblName setTextColor:[UIColor blackColor]];
    [self.lblName setFont:[UIFont boldSystemFontOfSize:14]];
    [self addSubview:lblName];
    
    txtBoxName = [[UITextField alloc]initWithFrame:CGRectMake(47, 35, 200, 31)];   
    [self.txtBoxName setTextColor:[UIColor blackColor]];
    [self.txtBoxName setFont:[UIFont systemFontOfSize:14]];         
    [self.txtBoxName setBorderStyle:UITextBorderStyleRoundedRect];
     self.txtBoxName.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.txtBoxName setTextAlignment:UITextAlignmentCenter];
    
//self.txtBoxName.layer.borderWidth=1.0f;
   // self.txtBoxName.layer.cornerRadius=8.0f;
    ///self.txtBoxName setBackgroundColor:[UIColor colorWithRed:195/255 green:190/255 blue:190/255 alpha:0.0]];
     
    
   // [[self.txtBoxName.layer.borderColor:[UIColor colorWithRed:195 green:190 blue:190 alpha:0.3]]CGColor];
     
    [self.txtBoxName setTextAlignment:UITextAlignmentCenter];
    [self addSubview:txtBoxName];
    return self;
}
 
@end
