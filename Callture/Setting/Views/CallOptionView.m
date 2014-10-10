//
//  CallOptionView.m
//  Callture
//
//  Created by user on 12/10/12.
//
//

#import "CallOptionView.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalData.h"
#import "Country.h"
#import "Area.h"
#import "MobileOperator.h"
#import "Constants.h"

@implementation CallOptionView
@synthesize delegate,dataList,selectedData,section,table;
- (id)initWithFrame:(CGRect)frame tableFram:(CGRect)tblFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        btn.titleLabel.text = @"";
        [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        table = [[UITableView alloc]initWithFrame:tblFrame];
        table.scrollEnabled = NO;
        //table.center = self.center;
        table.delegate = self;
        table.dataSource = self;
        [self addSubview:table];
        table.backgroundView = nil;
        table.layer.borderColor = [UIColor clearColor].CGColor;
        table.layer.cornerRadius = 5.0F;
        table.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        table.layer.shadowOffset = CGSizeMake(0, 0);
        table.layer.shadowOpacity = 1.0f;
        table.layer.shadowRadius = 5.0f;
        table.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)close
{
    [delegate updateData:nil section:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@",dataList);
    return dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.imageView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
     
    if ([section isEqualToString:SECTION_OPTION]) {
        NSString *data = (NSString *)[dataList objectAtIndex:indexPath.row];
        cell.textLabel.text = data;
        if (selectedData) {
            if ([data isEqualToString:(NSString *)selectedData]) {
                cell.imageView.image = [UIImage imageNamed:@"selected_radio.png"];
            }else
            {
                cell.imageView.image = [UIImage imageNamed:@"radio_button.png"];
            }
        }else
        {
            cell.imageView.image = [UIImage imageNamed:@"radio_button.png"];
        }
        
    }else if ([section isEqualToString:SECTION_COUNTRY]) {
        Country *data = (Country *)[dataList objectAtIndex:indexPath.row];
        cell.textLabel.text = data.countryName;
        if (selectedData) {
            if ([data.countryName isEqualToString:((Country *)selectedData).countryName]) {
                cell.imageView.image = [UIImage imageNamed:@"selected_radio.png"];
            }else
            {
                cell.imageView.image = [UIImage imageNamed:@"radio_button.png"];
            }
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"radio_button.png"];
        }
    }
    else if ([section isEqualToString:SECTION_AREA]) {
        Area *data = (Area *)[dataList objectAtIndex:indexPath.row];
        cell.textLabel.text = data.areaName;
        if(selectedData)
        {
            if ([data.areaName isEqualToString:((Area *)selectedData).areaName]) {
                cell.imageView.image = [UIImage imageNamed:@"selected_radio.png"];
            }else
            {
                cell.imageView.image = [UIImage imageNamed:@"radio_button.png"];
            }
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"radio_button.png"];
        }
    }else if ([section isEqualToString:OPERATOR]) {
        MobileOperator *data = (MobileOperator *)[dataList objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",data.country,data.operatorName];
        if(selectedData)
        {
            if ([data.operatorName isEqualToString:((MobileOperator *)selectedData).operatorName]) {
                cell.imageView.image = [UIImage imageNamed:@"selected_radio.png"];
            }else
            {
                cell.imageView.image = [UIImage imageNamed:@"radio_button.png"];
            }
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"radio_button.png"];
        }
    }
    else if ([section isEqualToString:AMOUNT]) {
        NSString *data = (NSString *)[dataList objectAtIndex:indexPath.row];
        NSLog(@"%@",data);
        cell.textLabel.text = [NSString stringWithFormat:@"$ %@",data];
        if(selectedData)
        {
            if ([data isEqualToString:(NSString *)selectedData]) {
                cell.imageView.image = [UIImage imageNamed:@"selected_radio.png"];
            }else
            {
                cell.imageView.image = [UIImage imageNamed:@"radio_button.png"];
            }
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"radio_button.png"];
        }
    }else if ([section isEqualToString:[GlobalData getAppInfo].followUs])
    {
        NSString *data = (NSString *)[dataList objectAtIndex:indexPath.row];
        if (indexPath.row==0) {
            cell.imageView.image = [UIImage imageNamed:@"facebook_icon.png"];
            cell.textLabel.text = data;
        }else if (indexPath.row==1) {
            cell.imageView.image = [UIImage imageNamed:@"twitter_icon.png"];
            cell.textLabel.text = data;
        }
        
    }
    return cell;
}

-(void)setCallOption:(NSString *)option
{
    selectedCallOption = option;
    [table reloadData]; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([section isEqualToString:SECTION_OPTION]) {
        NSString *data = (NSString *)[dataList objectAtIndex:indexPath.row];
        [delegate updateData:data section:section];
        selectedData = data;
    }else if ([section isEqualToString:SECTION_COUNTRY]) {
        Country *data = (Country *)[dataList objectAtIndex:indexPath.row];
        [delegate updateData:data section:section];
        selectedData = data;
    }
    else if ([section isEqualToString:SECTION_AREA]) {
        Area *data = (Area *)[dataList objectAtIndex:indexPath.row];
        [delegate updateData:data section:section];
        selectedData = data;
    }
    else if ([section isEqualToString:OPERATOR]) {
        MobileOperator *data = (MobileOperator *)[dataList objectAtIndex:indexPath.row];
        [delegate updateData:data section:section];
        selectedData = data;
    }
    else if ([section isEqualToString:AMOUNT]) {
        NSString *data = (NSString *)[dataList objectAtIndex:indexPath.row];
        [delegate updateData:data section:section];
        selectedData = data;
    }
    else if ([section isEqualToString:[GlobalData getAppInfo].followUs]) {
        NSString *data = (NSString *)[dataList objectAtIndex:indexPath.row];
        [delegate updateData:data section:section];
        selectedData = data;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
