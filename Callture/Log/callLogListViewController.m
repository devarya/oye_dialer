//
//  callLogListViewController.m
//  Callture
//
//  Created by Manish on 09/12/11.
//  Copyright 2011 Aryavrat Infotech Pvt. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "callLogListViewController.h"
#import "CallLogData.h"
#import "RESTInteraction.h"
#import "GlobalData.h"
#import "CallLogData.h"
#import "StaticData.h"
#import <QuartzCore/QuartzCore.h>
#import "ABContactsHelper.h"
#import "Constants.h"
#import "SipManager.h"
#define REFRESH_HEADER_HEIGHT 52.0f

@implementation callLogListViewController
@synthesize myLogList,tableLog,filteredListContent,bgView,searchBar,searchCOmbinations,dialStr;
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;
@synthesize callingTimer,phoneCallDelegate;

static callLogListViewController *curViewController;
static bool isLoading = FALSE;

+(void)SetIsLoading:(BOOL)isloading
{
    isLoading = isloading; 
}

+ (callLogListViewController*)currentView
{
	return curViewController;
}
+ (void)setCurrentView:(callLogListViewController*)newView
{	
	if(curViewController != newView)
	{
		curViewController = newView;
	}
}

-(NSString *)getDateInFormat:(NSDate *)dt
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    dateString = [formatter stringFromDate:dt];
    return dateString;
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    selectedRow = -1;
    [callLogListViewController setCurrentView:self];
    //[self loadData];
    if (!isLoading) {
        isLoading = YES;
    [self performSelectorInBackground:@selector(callRestForGetLog) withObject:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (![GlobalData isNetworkAvailable]) {
        
        [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

-(void)callRestForGetLog
{
    if(myLogList == nil || [myLogList count]==0)
    {
        [[RESTInteraction restInteractionManager] getCallLogData:@"30":nil:[GlobalData ClientID]];
    }else
    {
        NSString *lastcdrd = [GlobalData GetLastCDRD];
     //   NSLog(@"%@",lastcdrd);
        [[RESTInteraction restInteractionManager] getCallLogData:@"30" :lastcdrd :[GlobalData ClientID]];
     //   NSLog(@"%@ %@",lastcdrd,[GlobalData ClientID]);
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.filteredListContent = [[NSMutableArray alloc]init];
    if (myLogList==nil || myLogList.count==0) {
        [self showLoader];
    }
    isCallFromBtn = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:NOTIFICATION_LOGOUT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    count=0;
    searchBar.backgroundColor = [UIColor clearColor];   
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [[searchBar.subviews objectAtIndex:0] removeFromSuperview];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sarch-heading-bg.png"]];
    for (id aSubview in searchBar.subviews) {
        if([aSubview isKindOfClass:NSClassFromString(@"UITextField")])
        {
            [aSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
            
        }
    }
    
    [self setupStrings];
    [self addPullToRefreshHeader];
}

-(void)logout
{
    [myLogList removeAllObjects];
    [tableLog reloadData];
}

-(void)showLoader
{
    loader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [loader setBackgroundColor:[UIColor blackColor]];
    [loader setAlpha:0.5];
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.frame = CGRectMake(135, 205, 50, 50);
    [aiv startAnimating];
    [loader addSubview:aiv];
    [self.view addSubview:loader];
}


-(IBAction)keyboardWillShow:(id)sender
{
    btnBg = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBg.frame = self.view.bounds;
    [btnBg addTarget:self action:@selector(hideSearchKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBg];
}

-(IBAction)hideSearchKeyBoard:(id)sender
{
    [searchBar resignFirstResponder];
}

-(IBAction)keyboardDidHide:(id)sender
{
    [btnBg removeFromSuperview];
}


-(void)updateLogList:(NSMutableArray *)logList
{
    if(logList!=nil && [logList count]>0)
    {
       CallLogData *firstLog = (CallLogData *)[logList objectAtIndex:0];
        [GlobalData SetLastCDRD:firstLog.CDRID];
        if(myLogList==nil || [myLogList count]==0)
        {
            myLogList = logList;
        }else
        {
            if([logList count]>=50)
            {
                myLogList = logList;
            }else
            {
                if([myLogList count]+[logList count]>50)
                {
                    int delCount = [myLogList count]+[logList count]-50;
                    int previousItemLength = [myLogList count]-delCount;
                    while ([myLogList count]>previousItemLength) {
                        [myLogList removeLastObject];
                    }
                }
                    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0, logList.count)];
                
                    [myLogList insertObjects:logList atIndexes:indexSet];
            }
        }
    }else
    {
        for (CallLogData *cld in myLogList) {
            if(cld.callType == 0)
            {
                NSString *displayNum = [[[ABContactsHelper contactsMatchingPhone:cld.CallerID] objectAtIndex:0]contactName];
                if(displayNum == nil || displayNum.length==0)
                {
                    NSRange firstCharRange = NSMakeRange(0,1);
                    NSString* firstCharacter = [cld.CallerID substringWithRange:firstCharRange];
                    if ([firstCharacter isEqualToString:@"1"])
                    {
                        NSRange range = NSMakeRange(1,cld.CallerID.length-1);
                        NSString* subStr = [cld.CallerID substringWithRange:range];
                        displayNum = [[[ABContactsHelper contactsMatchingPhone:subStr]objectAtIndex:0]contactName];
                        if(displayNum == nil || displayNum.length==0)
                            cld.CallerName = cld.CallerID;
                        else
                            cld.CallerName = displayNum;
                    }else
                        cld.CallerName = cld.CallerID;
                }
                else
                    cld.CallerName = displayNum;
            }else
            {
                NSString *displayNum = [[[ABContactsHelper contactsMatchingPhone:cld.CalledNo] objectAtIndex:0]contactName];
                if(displayNum == nil || displayNum.length==0)
                {
                    NSRange firstCharRange = NSMakeRange(0,1);
                    NSString* firstCharacter = [cld.CalledNo substringWithRange:firstCharRange];
                    if ([firstCharacter isEqualToString:@"1"])
                    {
                        NSRange range = NSMakeRange(1,cld.CalledNo.length-1);
                        NSString* subStr = [cld.CalledNo substringWithRange:range];
                        displayNum = [[[ABContactsHelper contactsMatchingPhone:subStr]objectAtIndex:0]contactName];
                        if(displayNum == nil || displayNum.length==0)
                            cld.CallerName = cld.CalledNo;
                        else
                            cld.CallerName = displayNum;
                    }else
                        cld.CallerName = cld.CalledNo;
                }
                else
                    cld.CallerName = displayNum;
            }
        }
    }
    [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:NO];
}

-(void)refreshView
{
    [self performSelector:@selector(stopLoading)];
    [loader removeFromSuperview];
    if (searchBar.text.length>0) {
    }else
    {
        [tableLog reloadData];
    }
    isLoading = FALSE;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Memory Warning in callLogListViewController" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
	//return [myLogList count];
    selectedRow = -1;
    if([searchBar.text length]>0)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [self.myLogList count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"cellID";
    UILabel *topLabel;
	UILabel *bottomLabel;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];	
    const CGFloat LABEL_HEIGHT = 20;
    UIImage *image = [UIImage imageNamed:@"call-icon1.png"];
    topLabel = [[UILabel alloc]
      initWithFrame:
      CGRectMake(
                 image.size.width + 2.0 * cell.indentationWidth,
                 0.5 * (tableLog.rowHeight - 2 * LABEL_HEIGHT),
                 tableLog.bounds.size.width -
                 image.size.width - 4.0 * cell.indentationWidth,
                 LABEL_HEIGHT)];
    [cell.contentView addSubview:topLabel];

    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textColor = [UIColor blackColor];
    topLabel.highlightedTextColor = [UIColor blackColor];
    topLabel.font = [UIFont boldSystemFontOfSize:18];

    bottomLabel =
    [[UILabel alloc]
      initWithFrame:
      CGRectMake(
                 image.size.width + 2.0 * cell.indentationWidth,
                 0.5 * (tableLog.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT,
                 tableLog.bounds.size.width -
                 image.size.width - 4.0 * cell.indentationWidth,
                 LABEL_HEIGHT)];
    [cell.contentView addSubview:bottomLabel];
    
    bottomLabel.backgroundColor = [UIColor clearColor];
    bottomLabel.textColor = [UIColor grayColor];
    bottomLabel.highlightedTextColor = [UIColor grayColor];
    bottomLabel.font = [UIFont systemFontOfSize:12];        
    cell.selectedBackgroundView =
    [[UIImageView alloc] init];   
    
    UIView *viewSelected = [[UIView alloc] init];
    viewSelected.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"head-bg.png"]];
    cell.selectedBackgroundView = viewSelected;
    
    CallLogData *product = nil;
    if([searchBar.text length]>0)
    {
        if (filteredListContent.count>0) {
            product = [self.filteredListContent objectAtIndex:indexPath.row];
        }
    }else
    {
        if([self.title isEqualToString:TITLE_RECENT_CALLS_LOG])
        {
            product = [self.myLogList objectAtIndex:indexPath.row];
        }else
        {             
            product = [[ABContactsHelper contacts] objectAtIndex:indexPath.row];
        }       
    }	       
    topLabel.text = product.CallerName;
    NSString *strDisc = product.StartTime;
    strDisc = [[strDisc componentsSeparatedByString:@"T"] objectAtIndex:1];
    NSArray *timeArr = [strDisc componentsSeparatedByString:@":"];
    NSInteger hour = [[timeArr objectAtIndex:0] integerValue];
    NSInteger minute = [[timeArr objectAtIndex:1] integerValue];
    NSString *strAMPM;
    if (hour>12) {
        hour = hour-12;
        strAMPM = @"PM";
    }else
    {
        strAMPM = @"AM";
    }
    
    bottomLabel.text = [NSString stringWithFormat:@"%02d:%02d %@    %@",hour,minute,strAMPM,product.FormattedDate];
//    [strDisc release];
//    [timeArr release];
//    [strAMPM release];
    
    if([product.ConnectStatus isEqualToString:@"Answered"])
    {
        if(product.callType == 0)
            cell.imageView.image = [UIImage imageNamed:@"call-icon3.png"];
        else
            cell.imageView.image = [UIImage imageNamed:@"call-icon1.png"];
    }
    else if([product.ConnectStatus isEqualToString:@"Voice Mail"])
        cell.imageView.image = [UIImage imageNamed:@"voicemail.png"];
    else if([product.ConnectStatus isEqualToString:@"Dial Out"])
        cell.imageView.image = [UIImage imageNamed:@"call-icon4.png"];
    else if([product.ConnectStatus isEqualToString:@"Missed Call"])
        cell.imageView.image = [UIImage imageNamed:@"call-icon2.png"];        
    return cell;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[searchBar resignFirstResponder];
    selectedRow = indexPath.row;
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate=self;
    [self.view addSubview:HUD];
    [HUD showWhileExecuting:@selector(startCalling) onTarget:self withObject:nil animated:TRUE];
}

-(void)startCalling
{
    NSString *destNo;
    CallLogData *cld;
    if([searchBar.text length]>0)
    {
        if (filteredListContent.count>0) {
            cld = [self.filteredListContent objectAtIndex:selectedRow];
        }
    }else
    {
        cld = [self.myLogList objectAtIndex:selectedRow];
    }
    if(cld.callType==0)
        destNo = cld.CallerID;
    else
        destNo = cld.CalledNo;
    if(destNo!=nil)
    {
        destNo = [GlobalData filterDialString:destNo];
        [[SipManager voipManager] doCall:destNo];
    }
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 44;
}

- (void)filterContentForSearchText:(NSString*)searchText
{	
    @try {
        [self.filteredListContent removeAllObjects]; 
        if (searchText.length>0) 
        {
            if (searchList==nil) {
                searchList = [[NSMutableArray alloc]init];
            }
            if ([searchList count]>searchText.length)
            {
                [searchList removeLastObject];
                //NSLog(@"1 arr length is %d",[[searchList objectAtIndex:(searchText.length-1)] count]);
                self.filteredListContent = [[searchList objectAtIndex:(searchList.count-1)] mutableCopy];
            }else
            {
                char value = [searchText characterAtIndex:(searchText.length-1)];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:[StaticData GetKeyValues:value]];
                if (searchList.count>0) {
                    // NSLog(@"2 arr length is %d",searchText.length);
                    [self searchInFilteredList:[searchList objectAtIndex:(searchText.length-2)] combArray:arr index:(searchText.length-1)];
                }else
                {
                    [self searchInFilteredList:myLogList combArray:arr index:(searchText.length-1)];
                }
            }
            NSArray *tempArr = [self callsMatchingPhone:searchText];
            if (tempArr.count>0) {
                for (CallLogData *callData in tempArr) {
                    if(![self.filteredListContent containsObject:callData])
                        [self.filteredListContent addObject:callData]; 
                }
            }
        }else
        {
            [searchList removeAllObjects];
        }
        [tableLog reloadData];
    }
    @catch (NSException *exception) {
        [self.filteredListContent removeAllObjects];
        [searchList removeAllObjects];
        [tableLog reloadData];
    }
    @finally {
    }
	
}

- (NSArray *) callsMatchingPhone: (NSString *) number
{
	NSPredicate *pred;
	pred = [NSPredicate predicateWithFormat:@"CallerName contains[cd] %@", number];
    if([[myLogList filteredArrayUsingPredicate:pred] count]>0)
        return [myLogList filteredArrayUsingPredicate:pred];
    else
        return nil;
}

-(void)searchInFilteredList:(NSMutableArray *)arr combArray:(NSMutableArray *)combArr index:(int)ind
{
    for(NSString *str in combArr)
    {
        for (CallLogData *product in arr)
        {		
            NSComparisonResult result = [product.CallerName compare:str options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(ind, 1)];
            if (result == NSOrderedSame)
            {
            
                    [self.filteredListContent addObject:product];
                               
            }	        
        }
    }
  //  NSLog(@"Here are issue when the object is falt");
    
    if ([self.filteredListContent mutableCopy] != nil ) {
    //    NSLog(@"object is not null");
        [searchList insertObject:[self.filteredListContent mutableCopy] atIndex:ind];
    }
    
}

-(NSMutableArray *)generateComb:(NSMutableArray *)arr1 :(NSMutableArray *)arr2
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(int i=0;i<[arr1 count];i++)
    {
        NSString *str1 = [arr1 objectAtIndex:i];
        for(int j=0;j<[arr2 count];j++)
        {
            NSString *str2 = [arr2 objectAtIndex:j];
            NSString *str = [str1 stringByAppendingString:str2];
            [arr addObject:str];
        }
    }
    return arr;
}


-(BOOL)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{    
    [self filterContentForSearchText:searchText];
    return YES;
}

-(void)updateCallBackStatus:(NSString *)msg
{
    [loader removeFromSuperview];
    if(msg!=nil)
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}


//refresh on pull
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            tableLog.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            tableLog.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = self.textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = self.textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        tableLog.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        tableLog.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    
    [self performSelectorInBackground:@selector(callRestForGetLog) withObject:nil];
    
}
- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:[GlobalData getAppInfo].pullUpToRefresh];
    textRelease = [[NSString alloc] initWithString:[GlobalData getAppInfo].releaseToRefresh];
    textLoading = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@...",[GlobalData getAppInfo].loading]];
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowCallHistory.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [tableLog addSubview:refreshHeaderView];
}


@end
