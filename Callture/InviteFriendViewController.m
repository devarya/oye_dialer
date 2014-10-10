//
//  InviteFriendViewController.m
//  Oye Dialer
//
//  Created by user on 06/06/13.
//
//
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "InviteFriendViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalData.h"
#import "JSON.h"
#import "RESTInteraction.h"
#import "Constants.h"

#import "CallSetUp.h"

@interface InviteFriendViewController ()

@end

@implementation InviteFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inviteFriendsSuccess:) name:NOTIFICATION_INVITE_FRIENDS_SUCCESS object:nil];
    viewOwnerName.layer.cornerRadius = 5.0;
    viewOwnerName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    viewOwnerName.layer.borderWidth = 0.5;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [GlobalData getAppInfo].dataViewBgColor;
    tblContacts.backgroundView = backView;
    
    [viewContactsTitle setBackgroundColor:[GlobalData getAppInfo].topBarBgColor];
    [self.view setBackgroundColor:[GlobalData getAppInfo].pageBgColor];
    //// Add Image on navigation bar right side
    UIButton *btnImage =[[UIButton alloc] init];
    [btnImage setBackgroundImage:[GlobalData getAppInfo].imgTopRightLogo forState:UIControlStateNormal];
    btnImage.userInteractionEnabled = NO;
    btnImage.frame = CGRectMake(100, 100, 40, 40);
    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithCustomView:btnImage];
    self.navigationItem.rightBarButtonItem = btnItem;
    
   // self.title = [GlobalData getAppInfo].inviteFriends;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setMinimumFontSize:12.0];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor = [GlobalData getAppInfo].topBarTextColor;
    self.navigationItem.titleView = label;
    label.text = [GlobalData getAppInfo].referFriends;
    
    
    lblSelectFriends.text = [GlobalData getAppInfo].selectContacts;
    lblSelectAll.textColor = [GlobalData getAppInfo].topBarTextColor;
    lblSelectAll.text = [GlobalData getAppInfo].all;
   // lblSelectAll.text = [GlobalData getAppInfo].strSelectAll;
    [btnSubmit setTitle:[GlobalData getAppInfo].invite forState:UIControlStateNormal];
    
    lblFrom.text = [GlobalData getAppInfo].from;
    lblOwnerName.text = [GlobalData GetOwnerName];
    lblSelectFriends.textColor = [GlobalData getAppInfo].topBarTextColor;
    NSString *strVersion =[[UIDevice currentDevice] systemVersion];
    BOOL isIos7=[strVersion floatValue]>=7.0;
    if (isIos7)
    {
        self.navigationController.navigationBar.barTintColor = [GlobalData getAppInfo].topBarBgColor;
      //  self.navigationController.navigationBar.translucent = NO;
    }
    else
    {
        self.navigationController.navigationBar.tintColor = [GlobalData getAppInfo].topBarBgColor;
    }
    
    //self.navigationController.navigationBar.tintColor = [GlobalData getAppInfo].topBarBgColor;
    contactView.layer.cornerRadius = 10.0;
    contactView.layer.borderWidth = 1.0;
    contactView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    btnSubmit.layer.borderColor = [[UIColor colorWithRed:22.0/255.0 green:46.0/255.0 blue:81.0/255.0 alpha:1.0] CGColor];
    btnSubmit.layer.borderWidth = 0.5;
    btnSubmit.layer.cornerRadius = 10;
    [self getAllAddressBookData];
    [tblContacts reloadData];
    
    editController = [[editOwnerNameViewController alloc]init];
    editController.delegate = self;
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        //vishnu
        isInviteFriendsScreen = NO;
        //vishnu
        NSLog(@"Back Pressed");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_INVITE_FRIENDS_SUCCESS object:nil];
    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    
}


-(void)inviteFriendsSuccess:(NSNotification *)notification
{
    NSMutableDictionary *dict = (NSMutableDictionary *)notification.object;
    [[[UIAlertView alloc]initWithTitle:@"Message" message:[dict valueForKey:@"ResultStr"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnEditNameClicked:(id)sender
{
   // editOwnerNameViewController *editController = [[editOwnerNameViewController alloc]init];
    
    editController.strOwnerName = lblOwnerName.text;
     [self.navigationController pushViewController:editController animated:YES];
}

-(void)setOwnerName:(NSString *)name
{
    [GlobalData SetOwnerName:name];
    lblOwnerName.text = name;
}

-(void)getAllAddressBookData
{
    @try {
        ABAddressBookRef addressBook = ABAddressBookCreate();
        contacts = [[NSMutableArray alloc]init];
        
        if (addressBook != nil)
        {
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex nPeople= ABAddressBookGetPersonCount(addressBook);
            NSUInteger peopleCounter = 0;
            
            for (peopleCounter = 0;peopleCounter < nPeople; peopleCounter++)
            {
                ABRecordRef thisPerson = CFArrayGetValueAtIndex(allPeople,peopleCounter);
                NSMutableDictionary *dictContact = [[NSMutableDictionary alloc]init];
                
                NSString *strId = [NSString stringWithFormat:@"%d",peopleCounter];
                [dictContact setValue:strId forKey:@"id"];
                [dictContact setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
                //////// Name
                NSString *strFirstName = (__bridge NSString *)(ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty));
                
                strFirstName = [strFirstName stringByReplacingOccurrencesOfString:@"(" withString:@""];
                strFirstName = [strFirstName stringByReplacingOccurrencesOfString:@")" withString:@""];
                strFirstName = [strFirstName stringByReplacingOccurrencesOfString:@"&" withString:@""];
                strFirstName = [strFirstName stringByReplacingOccurrencesOfString:@"<" withString:@""];
                strFirstName = [strFirstName stringByReplacingOccurrencesOfString:@">" withString:@""];
                
                if(!strFirstName.length == 0)
                {
                    [dictContact setValue:strFirstName forKey:@"firstname"];
                }
                
                NSString *strLastName  = (__bridge NSString *)(ABRecordCopyValue(thisPerson, kABPersonLastNameProperty));
                strLastName = [strLastName stringByReplacingOccurrencesOfString:@"(" withString:@""];
                strLastName = [strLastName stringByReplacingOccurrencesOfString:@")" withString:@""];
                strLastName = [strLastName stringByReplacingOccurrencesOfString:@"&" withString:@""];
                strLastName = [strLastName stringByReplacingOccurrencesOfString:@"<" withString:@""];
                strLastName = [strLastName stringByReplacingOccurrencesOfString:@">" withString:@""];
                
                if(!strLastName.length == 0)
                {
                    [dictContact setValue:strLastName forKey:@"lastname"];
                }
                
                if(strFirstName.length == 0 && !strLastName.length == 0)
                {
                    [dictContact setValue:strLastName forKey:@"firstname"];
                    [dictContact setValue:@"" forKey:@"lastname"];
                }
                
                if(!strFirstName.length == 0 && strLastName.length == 0)
                {
                    [dictContact setValue:strFirstName forKey:@"firstname"];
                    [dictContact setValue:@"" forKey:@"lastname"];
                }
                
                if(strFirstName.length == 0 && strLastName.length == 0)
                {
                    [dictContact setValue:@"No Name" forKey:@"firstname"];
                    [dictContact setValue:@"" forKey:@"lastname"];
                }
                
                //                [dictContact setValue:(strLastName.length>0)?strLastName:@"" forKey:@"lastname"];
                
                
                NSMutableArray *arrPhone = [[NSMutableArray alloc]init];
                ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(thisPerson, kABPersonPhoneProperty));
                for(CFIndex i = 0; i <ABMultiValueGetCount(phones); i++)
                {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
                    CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, i);
                    NSString *phoneLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
                    NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
                    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
                    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
                    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"&" withString:@""];
                    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"<" withString:@""];
                    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@">" withString:@""];
                    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [arrPhone addObject:[NSString stringWithFormat:@"%@: %@", phoneLabel, phoneNumber]];
                }
                
                [dictContact setObject:arrPhone forKey:@"phoneno"];
                
                ///////// Email Id
                ABMultiValueRef multiValue = ABRecordCopyValue(thisPerson, kABPersonEmailProperty);
                if (ABMultiValueGetCount(multiValue)>0) {
                    NSString *strEmailId = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multiValue, 0);
                    if(strEmailId == nil)
                    {
                        strEmailId = @"";
                    }
                    [dictContact setValue:[NSString stringWithFormat:@"%@", strEmailId] forKey:@"email"];
                }else
                {
                    [dictContact setValue:@"" forKey:@"email"];
                }
                
                
                
                [contacts addObject:dictContact];
                
            }
            
            NSSortDescriptor * firstNameDescriptor = [[NSSortDescriptor alloc]
                                                      initWithKey:@"firstname" ascending:YES selector:@selector(localizedStandardCompare:)];
            NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc]
                                                    initWithKey:@"lastname" ascending:YES selector:@selector(localizedStandardCompare:)];
            
            NSArray *sortDescriptors = @[firstNameDescriptor, lastNameDescriptor];
            NSArray *sortedArray = [contacts sortedArrayUsingDescriptors:sortDescriptors];
         //   NSLog(@"%@",sortedArray);
            
            contacts = [[NSMutableArray arrayWithArray: sortedArray] mutableCopy];
          //  NSLog(@"%@",contacts);
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}


-(IBAction)selectAll:(UIButton *)btn
{
    if (btn.tag==0) {
        btn.tag = 1;
        [imgCheckBox setImage:[UIImage imageNamed:@"Radio-Checkbox-selected.jpeg"]];
    }else
    {
        btn.tag = 0;
        [imgCheckBox setImage:[UIImage imageNamed:@"Radio-Checkbox-deselected.jpeg"]];
    }
    for (int i=0; i<contacts.count; i++)
    {
        NSMutableDictionary *dict = [contacts objectAtIndex:i];
        [dict setValue:[NSNumber numberWithBool:btn.tag] forKey:@"selected"];
    }
    [tblContacts reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.textColor = [GlobalData getAppInfo].dataViewTextColor;
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSMutableDictionary *dict = [contacts objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"firstname"],[dict valueForKey:@"lastname"]]];
    if([[dict valueForKey:@"selected"] boolValue])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        
    // Configure the cell...
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

-(IBAction)valueChanged:(UISwitch *)switchview
{
    NSDictionary *dict = [contacts objectAtIndex:switchview.tag-1];
    [dict setValue:[NSNumber numberWithBool:switchview.isOn] forKey:@"selected"];
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
    NSDictionary *dict = [contacts objectAtIndex:indexPath.row];
    [dict setValue:[NSNumber numberWithBool:![[dict valueForKey:@"selected"] boolValue]] forKey:@"selected"];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([[dict valueForKey:@"selected"] boolValue])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([self checkIsAllSelected]) {
        [imgCheckBox setImage:[UIImage imageNamed:@"Radio-Checkbox-selected.jpeg"]];
    }else
    {
        [imgCheckBox setImage:[UIImage imageNamed:@"Radio-Checkbox-deselected.jpeg"]];
    }
}

-(BOOL)checkIsAllSelected
{
    for (int i=0; i<contacts.count; i++) {
        NSDictionary *dict = [contacts objectAtIndex:i];
        if (![[dict valueForKey:@"selected"] boolValue]) {
            return NO;
        }
    }
    return YES;
}

-(NSMutableArray *)getSelectedContacts
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=0; i<contacts.count; i++) {
        NSMutableDictionary *dict = [contacts objectAtIndex:i];
        if ([[dict valueForKey:@"selected"] boolValue]) {
            [arr addObject:dict];
        }
    }
    return arr;
}

-(IBAction)inviteFriends:(id)sender
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self getSelectedContacts] options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[RESTInteraction restInteractionManager] sendInviteFriends:jsonString ownerName:lblOwnerName.text];
}

@end
