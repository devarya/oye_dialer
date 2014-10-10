//
//  CallOptionViewController.m
//  Oye Dialer
//
//  Created by user on 06/03/13.
//
//

#import "CallOptionViewController.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "RESTInteraction.h"

@interface CallOptionViewController ()

@end

@implementation CallOptionViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setMinimumFontSize:12.0];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor = [GlobalData getAppInfo].topBarTextColor;
    self.navigationItem.titleView = label;
    label.text = [GlobalData getAppInfo].callOptions;
    
    [self.view setBackgroundColor:[GlobalData getAppInfo].pageBgColor];
    //// Add Image on navigation bar right side
    UIButton *btnImage =[[UIButton alloc] init];
    [btnImage setBackgroundImage:[GlobalData getAppInfo].imgTopRightLogo forState:UIControlStateNormal];
    btnImage.userInteractionEnabled = NO;
    btnImage.frame = CGRectMake(100, 100, 40, 40);
    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithCustomView:btnImage];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lineInfoUpdated) name:NOTIFICATION_LINE_INFO_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lineInfoUpdateFailed) name:NOTIFICATION_LINE_INFO_FAIL object:nil];
    arrPickerView = [[NSMutableArray alloc]initWithObjects:LOCAL_ACCESS,CALL_BACK,SIP_VOIP, nil];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        //vishnu
        isCallOptionScreen = NO;
        //vishnu
        NSLog(@"Back Pressed");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LINE_INFO_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LINE_INFO_FAIL object:nil];
        
    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
}

-(void)lineInfoUpdated
{
    
}

-(void)lineInfoUpdateFailed
{
    [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Failed to save Announcements" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

-(void)CallRestForEnableSip
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:USE_WIFI_IFAVAILABLE] isEqualToString:@"YES"])
    {
            [[RESTInteraction restInteractionManager] EnableSipCalling:YES];
    }else
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:CALLOPTION1] isEqualToString:SIP_VOIP])
        {
                [[RESTInteraction restInteractionManager] EnableSipCalling:YES];
        }else
        {
                [[RESTInteraction restInteractionManager] EnableSipCalling:NO];
        }
    }
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self setBackButtonVisible];
}

-(void)CallRestForEnableSipAndSaveWiFi
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:USE_WIFI_IFAVAILABLE] isEqualToString:@"YES"])
    {
            [[RESTInteraction restInteractionManager] EnableSipCalling:YES];
    }else
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:CALLOPTION1] isEqualToString:SIP_VOIP])
        {
                [[RESTInteraction restInteractionManager] EnableSipCalling:YES];
        }else
        {
                [[RESTInteraction restInteractionManager] EnableSipCalling:NO];
        }
    }
    [self savingAnnounce];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(setBackButtonVisible) withObject:nil waitUntilDone:NO];
}

-(void)setBackButtonVisible
{
    [self.navigationItem setHidesBackButton:NO animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [arrPickerView count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [arrPickerView objectAtIndex:row];
    //return [operatorList objectAtIndex:row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        return 2;
    }else
    {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier1 = @"Cell1";
    UITableViewCell *cell;
    if (indexPath.section==0)
    {
        if (indexPath.row==0) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        }
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    }
    if (cell == nil)
    {
        if (indexPath.section==1)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            UISwitch *switchView = [[UISwitch alloc]init];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            switchView.tag = indexPath.row+1;
            switch (indexPath.row)
            {
                case 0:
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:ANNOUNCE_MINUTES] isEqualToString:@"True"]) {
                        [switchView setOn:YES];
                        cell.accessoryView = switchView;
                    }else
                    {
                        [switchView setOn:NO];
                        cell.accessoryView = switchView;
                    }
                    break;
                case 1:
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:ANNOUNCE_BALANCE] isEqualToString:@"True"]) {
                        [switchView setOn:YES];
                        cell.accessoryView = switchView;
                    }else
                    {
                        [switchView setOn:NO];
                        cell.accessoryView = switchView;
                    }
                    break;
                default:
                    break;
            }
        }else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            if (indexPath.row==0) {
                UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [downloadButton setBackgroundImage:[GlobalData getAppInfo].imgCellDropDown forState:UIControlStateNormal];
                [downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                downloadButton.tag = indexPath.row;
                [downloadButton setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:CALLOPTION1] forState:UIControlStateNormal];
                [downloadButton setFrame:CGRectMake(0, 0, 180, 40)];
                [downloadButton addTarget:self action:@selector(btnTapEvent:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = downloadButton;
            }else
            {
                UISwitch *switchView = [[UISwitch alloc]init];
                [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                switchView.tag = 0;
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:USE_WIFI_IFAVAILABLE] isEqualToString:@"YES"]) {
                    [switchView setOn:YES];
                    cell.accessoryView = switchView;
                }else
                {
                    [switchView setOn:NO];
                    cell.accessoryView = switchView;
                }
                cell.accessoryView = switchView;
            }
        }
    }else
    {
        if (indexPath.section==0)
        {
            if (indexPath.row==0) {
                UIButton *btn = (UIButton *)cell.accessoryView;
                [btn setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:CALLOPTION1] forState:UIControlStateNormal];
            }else
            {
                UISwitch *switchView = (UISwitch *)cell.accessoryView;
                switchView.tag = 0;
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:USE_WIFI_IFAVAILABLE] isEqualToString:@"YES"]) {
                    [switchView setOn:YES];
                    cell.accessoryView = switchView;
                }else
                {
                    [switchView setOn:NO];
                    cell.accessoryView = switchView;
                }
            }
            
        }else if (indexPath.section==1)
        {
            UISwitch *switchView = (UISwitch *)cell.accessoryView;
            switchView.tag = indexPath.row+1;
            switch (indexPath.row)
            {
                case 0:
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:ANNOUNCE_MINUTES] isEqualToString:@"True"]) {
                        [switchView setOn:YES];
                        cell.accessoryView = switchView;
                    }else
                    {
                        [switchView setOn:NO];
                        cell.accessoryView = switchView;
                    }
                    break;
                case 1:
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:ANNOUNCE_BALANCE] isEqualToString:@"True"]) {
                        [switchView setOn:YES];
                        cell.accessoryView = switchView;
                    }else
                    {
                        [switchView setOn:NO];
                        cell.accessoryView = switchView;
                    }
                    break;
                default:
                    break;
            }
        }
    }
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    cell.backgroundColor = [GlobalData getAppInfo].dataViewBgColor;
    cell.textLabel.textColor = [GlobalData getAppInfo].dataViewTextColor;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.clipsToBounds = YES;
    cell.accessoryView.backgroundColor = [GlobalData getAppInfo].dataViewBgColor;
    cell.contentView.layer.cornerRadius = 5.0;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"%@:",[GlobalData getAppInfo].callType];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"%@:",[GlobalData getAppInfo].useWifiWhenAvailable];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"%@:",[GlobalData getAppInfo].announceMinutes];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"%@:",[GlobalData getAppInfo].announceBalance];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:15]];
}


-(void)switchChanged:(UISwitch *)switchview
{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    switch (switchview.tag) {
        case 0:
            if (switchview.isOn) {
                [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:USE_WIFI_IFAVAILABLE];
                HUD=[[MBProgressHUD alloc] initWithView:self.view];
                HUD.delegate=self;
                [self.view addSubview:HUD];
                [HUD showWhileExecuting:@selector(CallRestForEnableSipAndSaveWiFi) onTarget:self withObject:nil animated:TRUE];
            }else
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:USE_WIFI_IFAVAILABLE];
                HUD=[[MBProgressHUD alloc] initWithView:self.view];
                HUD.delegate=self;
                [self.view addSubview:HUD];
                [HUD showWhileExecuting:@selector(CallRestForEnableSipAndSaveWiFi) onTarget:self withObject:nil animated:TRUE];
            }
            break;
        case 1:
            if (switchview.isOn) {
                [[NSUserDefaults standardUserDefaults] setValue:@"True" forKey:ANNOUNCE_MINUTES];
            }else
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"False" forKey:ANNOUNCE_MINUTES];
            }
            HUD=[[MBProgressHUD alloc] initWithView:self.view];
            HUD.delegate=self;
            [self.view addSubview:HUD];
            [HUD showWhileExecuting:@selector(savingAnnounce) onTarget:self withObject:nil animated:TRUE];
            break;
        case 2:
            if (switchview.isOn) {
                [[NSUserDefaults standardUserDefaults] setValue:@"True" forKey:ANNOUNCE_BALANCE];
            }else
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"False" forKey:ANNOUNCE_BALANCE];
            }
            HUD=[[MBProgressHUD alloc] initWithView:self.view];
            HUD.delegate=self;
            [self.view addSubview:HUD];
            [HUD showWhileExecuting:@selector(savingAnnounce) onTarget:self withObject:nil animated:TRUE];
            break;
        default:
            break;
    }
}


-(void)savingAnnounce
{
    [[RESTInteraction restInteractionManager] announcement];
    [self performSelectorOnMainThread:@selector(setBackButtonVisible) withObject:nil waitUntilDone:NO];
}



-(void)btnTapEvent:(UIButton *)btn
{ 
    callOptView = [[CallOptionView alloc]initWithFrame:self.view.bounds tableFram:CGRectMake(15,80, 290, (44*arrPickerView.count))];
    
    callOptView.section = SECTION_OPTION;
   // callOptView.center = self.view.center;
    callOptView.dataList = arrPickerView;
    //callOptView.selectedData = profileData.profile_calltype;
    callOptView.delegate = self;
    [self.view addSubview:callOptView];
}

-(void)updateData:(NSObject *)data section:(NSString *)section
{
    [callOptView removeFromSuperview];
    //[self.navigationItem setHidesBackButton:YES animated:YES];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:CALLOPTION1];
        HUD=[[MBProgressHUD alloc] initWithView:self.view];
        HUD.delegate=self;
        [self.view addSubview:HUD];
        [HUD showWhileExecuting:@selector(CallRestForEnableSip) onTarget:self withObject:nil animated:TRUE];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return nil;
    }else
    {
        return [GlobalData getAppInfo].announcements;
    }

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
