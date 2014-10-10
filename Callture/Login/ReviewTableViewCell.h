//
//  ReviewTableViewCell.h
//  MovieGuru
//
//  Created by user on 23/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

 
@interface ReviewTableViewCell : UITableViewCell<UITextFieldDelegate>
{
    UITextField *txtBoxName;
    UILabel *lblName;
    NSString *txtPlaceHolderName;
    NSString *txtString;
    NSString *lblString;
}
 
@property(nonatomic,retain)UITextField *txtBoxName;
@property(nonatomic,retain)UILabel *lblName;
@property(nonatomic,retain) NSString *txtPlaceHolderName;
@property(nonatomic,retain) NSString *txtString;
@property(nonatomic,retain) NSString *lblString;
@end
