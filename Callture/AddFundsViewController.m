//
//  AddFundsViewController.m
//  Oye Dialer
//
//  Created by user on 07/06/13.
//
//

#import "AddFundsViewController.h"
#import "GlobalData.h"
#import "YIInnerShadowView.h"
#import "RESTInteraction.h"
#import "Constants.h"
#import "ClientInfo.h"
#import "CreditCardValidation.h"
#import "ChargeViewController.h"
@interface AddFundsViewController ()

@end

@implementation AddFundsViewController
@synthesize wView,request;
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
    selectedAmountIndex = -1;
    [activity stopAnimating];
    [super viewDidLoad];
    tblAddFunds.backgroundColor = [GlobalData getAppInfo].pageBgColor;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [GlobalData getAppInfo].pageBgColor;
    tblAddFunds.backgroundView = backView;
    [self.view setBackgroundColor:[GlobalData getAppInfo].pageBgColor];
    //// Add Image on navigation bar right side
    UIButton *btnImage =[[UIButton alloc] init];
    [btnImage setBackgroundImage:[GlobalData getAppInfo].imgTopRightLogo forState:UIControlStateNormal];
    btnImage.userInteractionEnabled = NO;
    btnImage.frame = CGRectMake(100, 100, 40, 40);
    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithCustomView:btnImage];
    self.navigationItem.rightBarButtonItem = btnItem;
    if ([GlobalData getAppInfo].addFundsPage)
    {
        wView.hidden = NO;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clientInfoGetSucceed:) name:NOTIFICATION_CLIENTINFO_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clientInfoSavedSucceed:) name:NOTIFICATION_SAVE_BILLING_INFO_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChargedSucceed:) name:NOTIFICATION_ACCOUNT_CHARGED_SUCCESS object:nil];
        
        
        
        wView.hidden = YES;
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:nil
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        
        CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
        
        pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        pickerView.showsSelectionIndicator = YES;
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [actionSheet addSubview:pickerView];
        
        UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
        closeButton.momentary = YES;
        closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
        closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
        closeButton.tintColor = [UIColor blackColor];
        [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
        [actionSheet addSubview:closeButton];
        
        UISegmentedControl *previousButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Previous"]];
        previousButton.momentary = YES;
        previousButton.frame = CGRectMake(5, 7.0f, 70.0f, 30.0f);
        previousButton.segmentedControlStyle = UISegmentedControlStyleBar;
        previousButton.tintColor = [UIColor blackColor];
        [previousButton addTarget:self action:@selector(previous:) forControlEvents:UIControlEventValueChanged];
        [actionSheet addSubview:previousButton];
        
        UISegmentedControl *nextButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Next"]];
        nextButton.momentary = YES;
        nextButton.frame = CGRectMake(80, 7.0f, 70.0f, 30.0f);
        nextButton.segmentedControlStyle = UISegmentedControlStyleBar;
        nextButton.tintColor = [UIColor blackColor];
        [nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventValueChanged];
        [actionSheet addSubview:nextButton];
        hud = [[MBProgressHUD alloc]initWithView:self.view];
        hud.delegate=self;
        [self.view addSubview:hud];
        [hud showWhileExecuting:@selector(requestForClientInfo) onTarget:self withObject:nil animated:TRUE];
        
//        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
//        [actionSheet setBounds:CGRectMake(0, 0, 320, 480)];
    }
    expandedRowIndex = -1;
    data = [NSMutableArray new];
    [data addObject:[GlobalData getAppInfo].cardInformation];
    [data addObject:[GlobalData getAppInfo].billingAddress];
    [data addObject:[GlobalData getAppInfo].selectAmount];
    
   // self.title = [GlobalData getAppInfo].addFunds;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setMinimumFontSize:12.0];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor = [GlobalData getAppInfo].topBarTextColor;
    self.navigationItem.titleView = label;
    label.text = [GlobalData getAppInfo].addFunds;
    
    //vishnu
    [wView loadRequest:request];
    //vishnu
}

-(void)accountChargedSucceed:(NSNotification *)notification
{
    NSMutableDictionary *dict = (NSMutableDictionary *)notification.object;
    [[[UIAlertView alloc]initWithTitle:@"Message" message:[dict valueForKey:@"ResultStr"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setTextFields
{
    textCraditCard = [[UITextField alloc]initWithFrame:CGRectMake(5, 3, tblAddFunds.frame.size.width-50, 30)];
    textCraditCard.returnKeyType = UIReturnKeyDone;
    [textCraditCard addTarget:self action:@selector(textEditDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    textCraditCard.delegate = self;
    [textCraditCard setBorderStyle:UITextBorderStyleNone];
    [textCraditCard setPlaceholder:[GlobalData getAppInfo].nameOnCreditCard];
    if (ci.ccName) {
        textCraditCard.text = ci.ccName;
    }
    textCraditCardNo = [[UITextField alloc]initWithFrame:CGRectMake(5, 3, tblAddFunds.frame.size.width-50, 30)];
    textCraditCardNo.delegate = self;
    textCraditCardNo.returnKeyType = UIReturnKeyDone;
    [textCraditCardNo addTarget:self action:@selector(textEditDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textCraditCardNo setBorderStyle:UITextBorderStyleNone];
    [textCraditCardNo setPlaceholder:[GlobalData getAppInfo].creditCardNo];
    if (ci.ccNumber) {
        textCraditCardNo.text = ci.ccNumber;
    }
    textSecurityCode = [[UITextField alloc]initWithFrame:CGRectMake(5, 3, tblAddFunds.frame.size.width-50, 30)];
    textSecurityCode.delegate = self;
    textSecurityCode.returnKeyType = UIReturnKeyDone;
    [textSecurityCode addTarget:self action:@selector(textEditDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textSecurityCode setSecureTextEntry:YES];
    [textSecurityCode setBorderStyle:UITextBorderStyleNone];
    [textSecurityCode setPlaceholder:[GlobalData getAppInfo].securityCode];
    if (ci.ccCvv) {
        textSecurityCode.text = ci.ccCvv;
    }
    textStreetAddress = [[UITextField alloc]initWithFrame:CGRectMake(5, 3, tblAddFunds.frame.size.width-50, 30)];
    textStreetAddress.delegate = self;
    textStreetAddress.returnKeyType = UIReturnKeyDone;
    [textStreetAddress addTarget:self action:@selector(textEditDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textStreetAddress setBorderStyle:UITextBorderStyleNone];
    [textStreetAddress setPlaceholder:[GlobalData getAppInfo].streetAddress];
    if (ci.bAddress1) {
        textStreetAddress.text = ci.bAddress1;
    }
    textAdd2 = [[UITextField alloc]initWithFrame:CGRectMake(5, 3, tblAddFunds.frame.size.width-50, 30)];
    textAdd2.delegate = self;
    textAdd2.returnKeyType = UIReturnKeyDone;
    [textAdd2 addTarget:self action:@selector(textEditDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textAdd2 setBorderStyle:UITextBorderStyleNone];
    [textAdd2 setPlaceholder:[GlobalData getAppInfo].AddressLine2];
    if (ci.bAddress2) {
        textAdd2.text = ci.bAddress2;
    }
    textCity = [[UITextField alloc]initWithFrame:CGRectMake(5, 3, tblAddFunds.frame.size.width-50, 30)];
    textCity.delegate = self;
    textCity.returnKeyType = UIReturnKeyDone;
    [textCity addTarget:self action:@selector(textEditDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textCity setBorderStyle:UITextBorderStyleNone];
    [textCity setPlaceholder:[GlobalData getAppInfo].city];
    if (ci.city) {
        textCity.text = ci.bCity;
    }
    textState = [[UITextField alloc]initWithFrame:CGRectMake(5, 3, tblAddFunds.frame.size.width-50, 30)];
    textState.delegate = self;
    textState.returnKeyType = UIReturnKeyDone;
    [textState addTarget:self action:@selector(textEditDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textState setBorderStyle:UITextBorderStyleNone];
    [textState setPlaceholder:[GlobalData getAppInfo].province];
    if (ci.bProvince) {
        textState.text = ci.bProvince;
    }
    
    textPostal = [[UITextField alloc]initWithFrame:CGRectMake(5, 3, tblAddFunds.frame.size.width-50, 30)];
    textPostal.delegate = self;
    textPostal.returnKeyType = UIReturnKeyDone;
    [textPostal addTarget:self action:@selector(textEditDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textPostal setBorderStyle:UITextBorderStyleNone];
    [textPostal setPlaceholder:[GlobalData getAppInfo].statePostalCode];
    if (ci.bPostalCode) {
        textPostal.text = ci.bPostalCode;
    }
}

-(void)requestForClientInfo
{
    [[RESTInteraction restInteractionManager] getBillingInfo];
}

-(void)clientInfoGetSucceed:(NSNotification *)notification
{
     ci = (ClientInfo *)notification.object;
    if (ci.ccNumber.length>0) {
        needToSendCCNo = NO;
    }
    else
    {
        needToSendCCNo = YES;
    }
    [self setTextFields];
    if (expandedRowIndex!=0) {
        [self openSection:0];
    }
    [tblAddFunds reloadData];
    
//    [tblAddFunds beginUpdates];
//    [tblAddFunds insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//    [tblAddFunds endUpdates];
}
//
-(void)clientInfoSavedSucceed:(NSNotification *)notification
{
    NSMutableDictionary *dict = (NSMutableDictionary *)notification.object;
    if ([[dict valueForKey:@"ResultId"] integerValue] == 1)
    {
        //[self.navigationController pushViewController:[ChargeViewController new] animated:YES];
        if (selectedAmountIndex>=0) {
            [[RESTInteraction restInteractionManager] chargeAccount:[ci.ccAllowAmounts objectAtIndex:selectedAmountIndex]];
            
        }else
        {
            [[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please select an amount" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }else
    {
        [[[UIAlertView alloc]initWithTitle:@"Message" message:[dict valueForKey:@"ResultStr"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}


-(void)previous:(id)sender{
    [pickerView selectRow:[arrPickerData indexOfObject:selectedButton.titleLabel.text]-1 inComponent:0 animated:YES];
    [selectedButton setTitle:[arrPickerData objectAtIndex:[arrPickerData indexOfObject:selectedButton.titleLabel.text]-1] forState:UIControlStateNormal];
}

-(void)next:(id)sender{
    [pickerView selectRow:[arrPickerData indexOfObject:selectedButton.titleLabel.text]+1 inComponent:0 animated:YES];
    [selectedButton setTitle:[arrPickerData objectAtIndex:[arrPickerData indexOfObject:selectedButton.titleLabel.text]+1] forState:UIControlStateNormal];
}

-(NSMutableArray *)getExpYearys
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger yearString = [[formatter stringFromDate:[NSDate date]] integerValue];
    NSInteger count = 0;
    [arr addObject:[GlobalData getAppInfo].expYear];
    for (int i=0; i<10; i++) {
        [arr addObject:[NSString stringWithFormat:@"%d",(int)(yearString+count)]];
        count++;
    }
    return arr;
}

-(NSMutableArray *)getExpMonths
{
    return [[NSMutableArray alloc]initWithObjects:[GlobalData getAppInfo].expMonth,@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
}

-(void)dismissActionSheet:(id)sender{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)selectExpMonth:(UIButton *)btn
{
    selectedButton = btn;
    arrPickerData = [self getExpMonths];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 480)];
    [pickerView reloadAllComponents];
    [pickerView selectRow:[arrPickerData indexOfObject:btn.titleLabel.text] inComponent:0 animated:NO];
}

-(void)selectExpYear:(UIButton *)btn
{
    [btn setBackgroundColor:[UIColor whiteColor]];
    selectedButton = btn;
    arrPickerData = [self getExpYearys];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 480)];
    [pickerView reloadAllComponents];
    [pickerView selectRow:[arrPickerData indexOfObject:btn.titleLabel.text] inComponent:0 animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    scrollview.contentSize = scrollview.bounds.size;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request1 navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request1.URL scheme] isEqual:@"myapp"])
    {
        //vishnu
        isAddFundScreen = NO;
        //vishnu
        [self.navigationController popViewControllerAnimated:YES];
        return NO; // Tells the webView not to load the URL
    }
    else
    {
        return YES; // Tells the webView to go ahead and load the URL
    }
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([GlobalData getAppInfo].addFundsPage)
    {
        NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
        BOOL isEmpty = string==nil || [string length]==0;
        if (isEmpty) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
        [activity startAnimating];
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([GlobalData getAppInfo].addFundsPage)
    {
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
    BOOL isEmpty = string==nil || [string length]==0;
    if (isEmpty) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [activity stopAnimating];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([GlobalData getAppInfo].addFundsPage)
    {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [activity stopAnimating];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count] + (expandedRowIndex != -1 ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger dataIndex = [self dataIndexForRowIndex:row];
    NSString *dataObject = [data objectAtIndex:dataIndex];
    
    BOOL expandedCell = expandedRowIndex != -1 && expandedRowIndex + 1 == row;
    
    if (!expandedCell)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"data"];
        //cell.backgroundColor = [UIColor colorWithPatternImage:[GlobalData getAppInfo].imgSendBtn];
        cell.backgroundColor = [GlobalData getAppInfo].topBarBgColor;
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        cell.textLabel.text = dataObject;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        if (row==1)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardinfo"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cardinfo"];
                YIInnerShadowView *viewCreditCard = [[YIInnerShadowView alloc]initWithFrame:CGRectMake(20, 10, tableView.frame.size.width-40, 30)];
                viewCreditCard.shadowRadius = 1;
                viewCreditCard.cornerRadius = 5;
                viewCreditCard.shadowMask = YIInnerShadowMaskAll;
                [viewCreditCard addSubview:textCraditCard];
                [cell addSubview:viewCreditCard];
                
                YIInnerShadowView *viewCreditCardNo = [[YIInnerShadowView alloc]initWithFrame:CGRectMake(20, 50, tableView.frame.size.width-40, 30)];
                viewCreditCardNo.shadowRadius = 1;
                viewCreditCardNo.cornerRadius = 5;
                viewCreditCardNo.shadowMask = YIInnerShadowMaskAll;
                
                [viewCreditCardNo addSubview:textCraditCardNo];
                [cell addSubview:viewCreditCardNo];
                
                YIInnerShadowView *viewExp = [[YIInnerShadowView alloc]initWithFrame:CGRectMake(20, 90, tableView.frame.size.width-80, 30)];
                viewExp.shadowRadius = 1;
                viewExp.cornerRadius = 5;
                viewExp.shadowMask = YIInnerShadowMaskAll;
                btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, viewExp.bounds.size.width/2, 30)];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
                btn1.layer.borderWidth = 0.5;
                [btn1 addTarget:self action:@selector(selectExpMonth:) forControlEvents:UIControlEventTouchUpInside];
                if (ci.ccExp.length>0) {
                    [btn1 setTitle:[ci.ccExp substringToIndex:2] forState:UIControlStateNormal];
                }else
                {
                    [btn1 setTitle:[GlobalData getAppInfo].expMonth forState:UIControlStateNormal];
                }
                [viewExp addSubview:btn1];
                btn2 = [[UIButton alloc]initWithFrame:CGRectMake(viewExp.bounds.size.width/2, 0, viewExp.bounds.size.width/2, 30)];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
                btn2.layer.borderWidth = 0.5;
                if (ci.ccExp.length>0) {
                    [btn2 setTitle:[NSString stringWithFormat:@"20%@",[ci.ccExp substringFromIndex:2]] forState:UIControlStateNormal];
                }else
                {
                    [btn2 setTitle:[GlobalData getAppInfo].expYear forState:UIControlStateNormal];
                }
                [btn2 addTarget:self action:@selector(selectExpYear:) forControlEvents:UIControlEventTouchUpInside];
                [viewExp addSubview:btn2];
                [cell addSubview:viewExp];
                
                YIInnerShadowView *viewSecurityCode = [[YIInnerShadowView alloc]initWithFrame:CGRectMake(20, 130, tableView.frame.size.width-40, 30)];
                viewSecurityCode.shadowRadius = 1;
                viewSecurityCode.cornerRadius = 5;
                viewSecurityCode.shadowMask = YIInnerShadowMaskAll;
                
                [viewSecurityCode addSubview:textSecurityCode];
                
                [cell addSubview:viewSecurityCode];
                
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView setBackgroundColor:[GlobalData getAppInfo].dataViewBgColor];
            return cell;
        }else if (row==2)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"billinginfo"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"billinginfo"];
                YIInnerShadowView *viewStreetAddress = [[YIInnerShadowView alloc]initWithFrame:CGRectMake(20, 10, tableView.frame.size.width-40, 30)];
                viewStreetAddress.shadowRadius = 1;
                viewStreetAddress.cornerRadius = 5;
                viewStreetAddress.shadowMask = YIInnerShadowMaskAll;
                
                
                [viewStreetAddress addSubview:textStreetAddress];
                [cell addSubview:viewStreetAddress];
                
                YIInnerShadowView *viewAdd2 = [[YIInnerShadowView alloc]initWithFrame:CGRectMake(20, 50, tableView.frame.size.width-40, 30)];
                viewAdd2.shadowRadius = 1;
                viewAdd2.cornerRadius = 5;
                viewAdd2.shadowMask = YIInnerShadowMaskAll;
                
                [viewAdd2 addSubview:textAdd2];
                [cell addSubview:viewAdd2];
                
                YIInnerShadowView *viewCity = [[YIInnerShadowView alloc]initWithFrame:CGRectMake(20, 90, tableView.frame.size.width-40, 30)];
                viewCity.shadowRadius = 1;
                viewCity.cornerRadius = 5;
                viewCity.shadowMask = YIInnerShadowMaskAll;
                
                [viewCity addSubview:textCity];
                [cell addSubview:viewCity];
                
                YIInnerShadowView *viewState = [[YIInnerShadowView alloc]initWithFrame:CGRectMake(20, 130, tableView.frame.size.width-40, 30)];
                viewState.shadowRadius = 1;
                viewState.cornerRadius = 5;
                viewState.shadowMask = YIInnerShadowMaskAll;
                
                [viewState addSubview:textState];
                [cell addSubview:viewState];
                
                YIInnerShadowView *viewPostal = [[YIInnerShadowView alloc]initWithFrame:CGRectMake(20, 170, tableView.frame.size.width-40, 30)];
                viewPostal.shadowRadius = 1;
                viewPostal.cornerRadius = 5;
                viewPostal.shadowMask = YIInnerShadowMaskAll;
                
                [viewPostal addSubview:textPostal];
                [cell addSubview:viewPostal];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView setBackgroundColor:[GlobalData getAppInfo].dataViewBgColor];
            return cell;
        }
        else if (row==3)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectamount"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"selectamount"];
                CGFloat yPos = 10;
                for (int i=0; i<ci.ccAllowAmounts.count; i++)
                {
                    UIButton *btnAmount = [UIButton buttonWithType:UIButtonTypeCustom];
                    btnAmount.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    btnAmount.layer.borderWidth = .5;
                    btnAmount.layer.cornerRadius = 2.0;
                    btnAmount.clipsToBounds = YES;
                    btnAmount.tag = i+1;
                    [btnAmount addTarget:self action:@selector(amountSelected:) forControlEvents:UIControlEventTouchUpInside];
                    [btnAmount setFrame:CGRectMake(20, yPos+(i*40), tableView.frame.size.width-40, 30)] ;
                    [btnAmount setTitle:[ci.ccAllowAmounts objectAtIndex:i] forState:UIControlStateNormal];
                    [btnAmount setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    if (selectedAmountIndex==i) {
                        btnAmount.selected = YES;
                        //[btnAmount setBackgroundColor:[GlobalData getAppInfo].topBarBgColor];
                        [btnAmount setBackgroundImage:[GlobalData getAppInfo].imgSendBtn forState:UIControlStateNormal];
                    }else
                    {
                        btnAmount.selected = NO;
                        //[btnAmount setBackgroundColor:[GlobalData getAppInfo].topBarBgColor];
                    [btnAmount setBackgroundImage:[GlobalData getAppInfo].imgDropDownBg forState:UIControlStateNormal];
                    }
                    [cell addSubview:btnAmount];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView setBackgroundColor:[GlobalData getAppInfo].dataViewBgColor];
            return cell;
        }
    }
}

-(void)amountSelected:(UIButton *)btn
{
    UITableViewCell *cell = [tblAddFunds cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    for (int i=0; i<ci.ccAllowAmounts.count; i++) {
        UIButton *btnCell = (UIButton *)[cell viewWithTag:i+1];
        if (btn!=btnCell) {
            if (btnCell.selected) {
                btnCell.selected = NO;
                [btnCell setBackgroundImage:[UIImage imageNamed:@"Bg-Option.png"] forState:UIControlStateNormal];
            }
        }
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        selectedAmountIndex = btn.tag-1;
        //[btn setBackgroundColor:[GlobalData getAppInfo].topBarBgColor];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg_send.png"] forState:UIControlStateNormal];
    }else
    {
        selectedAmountIndex = -1;
        //[btn setBackgroundColor:[GlobalData getAppInfo].topBarBgColor];
        [btn setBackgroundImage:[UIImage imageNamed:@"Bg-Option.png"] forState:UIControlStateNormal];
    }

}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        NSLog(@"Back Pressed");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CLIENTINFO_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SAVE_BILLING_INFO_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ACCOUNT_CHARGED_SUCCESS object:nil];

    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    
}

-(IBAction)textEditDone:(id)sender
{
    [sender resignFirstResponder];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    BOOL preventReopen = NO;
    
    if (row == expandedRowIndex + 1 && expandedRowIndex != -1)
        return nil;
    
    [tableView beginUpdates];
    
    if (expandedRowIndex != -1)
    {
        NSInteger rowToRemove = expandedRowIndex + 1;
        preventReopen = row == expandedRowIndex;
        if (row > expandedRowIndex)
            row--;
        expandedRowIndex = -1;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToRemove inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    NSInteger rowToAdd = -1;
    if (!preventReopen)
    {
        rowToAdd = row + 1;
        expandedRowIndex = row;
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToAdd inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        
    }
    [tableView endUpdates];
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (expandedRowIndex != -1 && row == expandedRowIndex + 1)
    {
        if (expandedRowIndex==0)
        {
            return 170;
        }else if (expandedRowIndex==1)
        {
            return 212;
        }
        else if (expandedRowIndex==2)
        {
            return ci.ccAllowAmounts.count*42.5;
        }
    }
    return 30;
}

- (NSInteger)dataIndexForRowIndex:(NSInteger)row
{
    if (expandedRowIndex != -1 && expandedRowIndex <= row)
    {
        if (expandedRowIndex == row)
            return row;
        else
            return row - 1;
    }
    else
        return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 20, tableView.frame.size.width-20, 31);
    [btn setBackgroundImage:[GlobalData getAppInfo].imgSendBtn forState:UIControlStateNormal];
    if (expandedRowIndex==2) {
        [btn setTitle:[GlobalData getAppInfo].chargeMyCreditCard forState:UIControlStateNormal];
    }else
    {
    [btn setTitle:[GlobalData getAppInfo].next forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.center = view.center;
    [btn addTarget:self action:@selector(saveBillingInfo:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = [[UIColor colorWithRed:22.0/255.0 green:46.0/255.0 blue:81.0/255.0 alpha:1.0] CGColor];
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 10;
    btn.clipsToBounds = YES;
    [view addSubview:btn];
    return view;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrPickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrPickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [selectedButton setTitle:[arrPickerData objectAtIndex:row] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveBillingInfo:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:[GlobalData getAppInfo].next])
    {
        if ([self validateForm])
        {
            if (expandedRowIndex!=2) {
                [self openSection:3];
                [btn setTitle:[GlobalData getAppInfo].chargeMyCreditCard forState:UIControlStateNormal];
            }else
            {
                [btn setTitle:[GlobalData getAppInfo].chargeMyCreditCard forState:UIControlStateNormal];
            }
        }
    }else if ([btn.titleLabel.text isEqualToString:[GlobalData getAppInfo].chargeMyCreditCard])
    {
        if ([self validateForm])
        {
            if (selectedAmountIndex>=0) {
                hud = [[MBProgressHUD alloc]initWithView:self.view];
                hud.delegate=self;
                [self.view addSubview:hud];
                [hud showWhileExecuting:@selector(requestForSaveBillingInfo) onTarget:self withObject:nil animated:TRUE];
            }else
            {
                [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].pleaseSelectAmount delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
            
        }
    }
}

-(void)requestForSaveBillingInfo
{
    [[RESTInteraction restInteractionManager]  saveBillingInfo:ci isCcNo:needToSendCCNo];
}

-(void)openSection:(NSInteger)row
{
    BOOL preventReopen = NO;
    
    if (row == expandedRowIndex + 1 && expandedRowIndex != -1)
        return;
    
    [tblAddFunds beginUpdates];
    
    if (expandedRowIndex != -1)
    {
        NSInteger rowToRemove = expandedRowIndex + 1;
        preventReopen = row == expandedRowIndex;
        if (row > expandedRowIndex)
            row--;
        expandedRowIndex = -1;
        [tblAddFunds deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToRemove inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    NSInteger rowToAdd = -1;
    if (!preventReopen)
    {
        rowToAdd = row + 1;
        expandedRowIndex = row;
        [tblAddFunds insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToAdd inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        
    }
    [tblAddFunds endUpdates];
}

-(BOOL)validateForm
{
    BOOL isValid = YES;
    BOOL needToOpenSecond = YES;
    if ([textCraditCard.text stringByReplacingOccurrencesOfString:@" " withString:@""].length>0)
    {
        ci.ccName = textCraditCard.text;
    }
    else
    {
        isValid = NO;
        [textCraditCard setBackgroundColor:[UIColor colorWithRed:178.0/255.0 green:0.0 blue:0.0 alpha:0.2]];
        needToOpenSecond = NO;
        if (expandedRowIndex!=0) {
            [self openSection:0];
        }
    
    }
    if (![ci.ccNumber isEqualToString:textCraditCardNo.text] && textCraditCardNo.text.length>0)
    {
        CreditCardValidation *cc = [[CreditCardValidation alloc]init];
        if ([cc validateCard:textCraditCardNo.text])
        {
            ci.ccNumber = textCraditCardNo.text;
            needToSendCCNo = YES;
        }else
        {
            isValid = NO;
            [textCraditCardNo setBackgroundColor:[UIColor colorWithRed:178.0/255.0 green:0.0 blue:0.0 alpha:0.2]];
            needToOpenSecond = NO;
            if (expandedRowIndex!=0) {
                [self openSection:0];
            }
        }
    }else
    {
        needToSendCCNo = NO;
    }
    
    
    if ([textSecurityCode.text stringByReplacingOccurrencesOfString:@" " withString:@""].length>0)
    {
        ci.ccCvv = textSecurityCode.text;
    }
    else
    {
        isValid = NO;
        [textSecurityCode setBackgroundColor:[UIColor colorWithRed:178.0/255.0 green:0.0 blue:0.0 alpha:0.2]];
        needToOpenSecond = NO;
        if (expandedRowIndex!=0) {
            [self openSection:0];
        }
    }
    
    if ([textCity.text stringByReplacingOccurrencesOfString:@" " withString:@""].length>0)
    {
        ci.bCity = textCity.text;
    }
    else
    {
        isValid = NO;
        [textCity setBackgroundColor:[UIColor colorWithRed:178.0/255.0 green:0.0 blue:0.0 alpha:0.2]];
        if (expandedRowIndex!=1 && needToOpenSecond) {
            [self openSection:2];
        }
    }
    
    
    
    if ([textState.text stringByReplacingOccurrencesOfString:@" " withString:@""].length>0)
    {
        ci.bProvince = textState.text;
    }
    else
    {
        isValid = NO;
        [textState setBackgroundColor:[UIColor colorWithRed:178.0/255.0 green:0.0 blue:0.0 alpha:0.2]];
        if (expandedRowIndex!=1 && needToOpenSecond) {
            [self openSection:2];
        }
    }
    
    if ([textStreetAddress.text stringByReplacingOccurrencesOfString:@" " withString:@""].length>0)
    {
        ci.bAddress1 = textStreetAddress.text;
    }
    else
    {
        isValid = NO;
        [textStreetAddress setBackgroundColor:[UIColor colorWithRed:178.0/255.0 green:0.0 blue:0.0 alpha:0.2]];
        if (expandedRowIndex!=1 && needToOpenSecond) {
            [self openSection:2];
        }
    }
    
    if ([btn1.titleLabel.text isEqualToString:[GlobalData getAppInfo].expMonth])
    {
        isValid = NO;
        btn1.backgroundColor = [UIColor colorWithRed:178.0/255.0 green:0.0 blue:0.0 alpha:0.2];
        if (expandedRowIndex!=1 && needToOpenSecond) {
            [self openSection:2];
        }
    }else
    {
        
    }
    
    if ([btn2.titleLabel.text isEqualToString:[GlobalData getAppInfo].expYear])
    {
        isValid = NO;
        btn2.backgroundColor = [UIColor colorWithRed:178.0/255.0 green:0.0 blue:0.0 alpha:0.2];
        if (expandedRowIndex!=1) {
            [self openSection:2];
        }
    }else
    {
        if (isValid) {
            ci.ccExp = [NSString stringWithFormat:@"%@%@",btn1.titleLabel.text,[btn2.titleLabel.text substringFromIndex:2]];
        }
    }
    return isValid;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setBackgroundColor:[UIColor clearColor]];
    return YES;
}


@end
