//
//  getRatesViewController.m
//  Callture
//
//  Created by user on 16/10/12.
//
//

#import "getRatesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalData.h"
#import "RESTInteraction.h"
#import "Constants.h"
@interface getRatesViewController ()

@end
@implementation getRatesViewController
@synthesize delegate,areaList,countryList;
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
    [self.view setBackgroundColor:[GlobalData getAppInfo].pageBgColor];
    [viewTitleByArea setBackgroundColor:[GlobalData getAppInfo].topBarBgColor];
    [viewTitleByNumber setBackgroundColor:[GlobalData getAppInfo].topBarBgColor];
    [btnArea setBackgroundImage:[GlobalData getAppInfo].imgDropDownBg forState:UIControlStateNormal];
    [btnCountry setBackgroundImage:[GlobalData getAppInfo].imgDropDownBg forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedNo:) name:NOTIFICATION_CONTACT_SELECTED_ON_RATES object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contrylistUpdated) name:NOTIFICATION_COUNTRYLIST_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(arealistUpdated) name:NOTIFICATION_AREALIST_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ratesForPhoneUpdated) name:NOTIFICATION_RATES_FOR_PHONE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedNoFailed) name:NOTIFICATION_CONTACT_SELECTED_ON_RATES_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contrylistFailed) name:NOTIFICATION_COUNTRYLIST_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(arealistFailed) name:NOTIFICATION_AREALIST_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ratesForPhoneFailed) name:NOTIFICATION_RATES_FOR_PHONE_FAILED object:nil];
    [txtRate setText:[NSString stringWithFormat:@"%@                                         ",[GlobalData getAppInfo].yourRates]];
    lblInternationalNumber.text = [GlobalData getAppInfo].internationalNumber;
    lblInternationalNumber.textColor = [GlobalData getAppInfo].dataViewTextColor;
    lblArea.text = [GlobalData getAppInfo].area;
    lblArea.textColor = [GlobalData getAppInfo].dataViewTextColor;
    lblByArea.text = [GlobalData getAppInfo].byArea;
    lblByArea.textColor = [GlobalData getAppInfo].topBarTextColor;
    lblByNumber.text = [GlobalData getAppInfo].byNumber;
    lblByArea.textColor = [GlobalData getAppInfo].topBarTextColor;
    lblCountry.text = [GlobalData getAppInfo].country;
    lblCountry.textColor = [GlobalData getAppInfo].dataViewTextColor;
    if (![GlobalData getCountryList] || [GlobalData getCountryList].count==0)
    {
        [self showLoader];
        [self performSelectorInBackground:@selector(loadCountryList) withObject:nil];
    }else
    {
        countryList = [GlobalData getCountryList];
    }
    
    
    btnCountry.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    btnCountry.layer.borderWidth = 0.5;
    btnCountry.layer.cornerRadius = 10;
    [btnCountry setTitleColor:[GlobalData getAppInfo].dataViewTextColor forState:UIControlStateNormal];
    btnArea.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    btnArea.layer.borderWidth = 0.5;
    btnArea.layer.cornerRadius = 10;
    [btnArea setTitleColor:[GlobalData getAppInfo].dataViewTextColor forState:UIControlStateNormal];
    
    //countryList = [[NSMutableArray alloc] initWithObjects:@"Canada", @"Jamaica", @"Pakistan",@"United States of America", nil];
    areaList = [[NSMutableArray alloc] initWithObjects:@"Area 1", @"Area 2", @"Area 3", nil];
    selectedCountry = nil;
    selectedArea = nil;
    [btnCountry setTitle:[GlobalData getAppInfo].pleaseSelect forState:UIControlStateNormal];
    [btnArea setTitle:[GlobalData getAppInfo].pleaseSelect forState:UIControlStateNormal];
    
   // self.title = [GlobalData getAppInfo].ratesCalculator;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setMinimumFontSize:12.0];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor = [GlobalData getAppInfo].topBarTextColor;
    self.navigationItem.titleView = label;
    label.text = [GlobalData getAppInfo].ratesCalculator;
    
    //// Add Image on navigation bar right side
    UIButton *btnImage =[[UIButton alloc] init];
    [btnImage setBackgroundImage:[GlobalData getAppInfo].imgTopRightLogo forState:UIControlStateNormal];
    btnImage.userInteractionEnabled = NO;
    btnImage.frame = CGRectMake(100, 100, 40, 40);
    UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithCustomView:btnImage];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    container1.layer.cornerRadius = 10;
    container1.layer.borderWidth = 1.0f;
    container1.layer.borderColor = [UIColor grayColor].CGColor;
    container1.backgroundColor = [GlobalData getAppInfo].dataViewBgColor;
    container2.layer.cornerRadius = 10;
    container2.layer.borderWidth = 1.0f;
    container2.layer.borderColor = [UIColor grayColor].CGColor;
    container2.backgroundColor = [GlobalData getAppInfo].dataViewBgColor;
    btnContact.layer.cornerRadius = 5.0f;
    [btnContact setBackgroundImage:[GlobalData getAppInfo].imgContacts forState:UIControlStateNormal];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    txtInternationalNo.inputAccessoryView = numberToolbar;
    
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        //vishnu
        isCallRatesScreen =  NO;
        //vishnu
        NSLog(@"Back Pressed");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CONTACT_SELECTED_ON_RATES object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_COUNTRYLIST_UPDATED object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_AREALIST_UPDATED object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_RATES_FOR_PHONE object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CONTACT_SELECTED_ON_RATES_FAILED object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_COUNTRYLIST_FAILED object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_AREALIST_FAILED object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_RATES_FOR_PHONE_FAILED object:nil];
    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    


    if (optView) {
        [optView removeFromSuperview];
        optView = nil;
    }
}

-(void)getSelectedNoFailed
{
    
}

-(void)contrylistFailed
{
    [loader removeFromSuperview];
    [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].failedToLoadCountryList delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

-(void)arealistFailed
{
    [loader removeFromSuperview];
    [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].failedToLoadAreaList delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

-(void)ratesForPhoneFailed
{
    [loader removeFromSuperview];
    [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].failedToLoadRatesList delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

-(void)ratesForPhoneUpdated
{
    [btnCountry setTitle:[GlobalData getAppInfo].pleaseSelect forState:UIControlStateNormal];
    [btnArea setTitle:[GlobalData getAppInfo].pleaseSelect forState:UIControlStateNormal];
    [txtRate setText:[NSString stringWithFormat:@"%@                                         ",[GlobalData getAppInfo].yourRates]];
    countryDataForPhone = [GlobalData getCountryForPhone];
    if (countryDataForPhone) {
        Country *phoneCountry = [self findCountryInList:countryDataForPhone.countryName];
        if (phoneCountry) {
            selectedCountry = phoneCountry;
            [GlobalData setSelectedCountry:selectedCountry];
            [btnCountry setTitle:selectedCountry.countryName forState:UIControlStateNormal];
            if (selectedCountry.areaList.count>0)
            {
                areaList = selectedCountry.areaList;
                Area *phoneArea = [self findAreaInList:countryDataForPhone.selectedArea];
                if (phoneArea) {
                    selectedArea = phoneArea;
                    [btnArea setTitle:selectedArea.areaName forState:UIControlStateNormal];
                    [self setTextRate:selectedArea.rate];
                    countryDataForPhone = nil;
                }
            }else
            {
                [self showLoader];
                [self performSelectorInBackground:@selector(loadArea) withObject:nil];
            }
        }
    }
}

-(Area *)findAreaInList:(NSString *)areaName
{
    for (Area *area in selectedCountry.areaList) {
        if ([area.areaName isEqualToString:areaName]) {
            return area;
        }
    }
    return nil;
}

-(Country *)findCountryInList:(NSString *)countryName
{
    for (Country *country in [GlobalData getCountryList]) {
        if ([country.countryName isEqualToString:countryName]) {
            return country;
        }
    }
    return nil;
}

-(void)loadCountryList
{
        [[RESTInteraction restInteractionManager] GetCountryList];
}

-(void)contrylistUpdated
{
    countryList = [GlobalData getCountryList];
    [loader removeFromSuperview];
}

-(void)arealistUpdated
{
    areaList = [GlobalData getSelectedCountry].areaList;
    if (countryDataForPhone) {
        Area *phoneArea = [self findAreaInList:countryDataForPhone.selectedArea];
        if (phoneArea) {
            selectedArea = phoneArea;
            [btnArea setTitle:selectedArea.areaName forState:UIControlStateNormal];
            [self setTextRate:selectedArea.rate];
        }
        countryDataForPhone = nil;
    }
    [loader removeFromSuperview];
}

-(void)showLoader
{
    loader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    [loader setBackgroundColor:[UIColor blackColor]];
    [loader setAlpha:0.5];
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.frame = CGRectMake(135, 160, 50, 50);
    [aiv startAnimating];
    [loader addSubview:aiv];
    [self.view addSubview:loader];
}

-(void)doneWithNumberPad
{
    [txtInternationalNo resignFirstResponder];
}

-(void)getSelectedNo:(NSNotification *)notification
{
    NSString *selectedNo = (NSString *)notification.object;
    txtInternationalNo.text = [GlobalData filterDialString:selectedNo];
    if (txtInternationalNo.text.length>=10) {
        [self performSelector:@selector(callGetAreaForPhone) withObject:nil afterDelay:0.0];
    }
}

-(IBAction)gotoContacts:(id)sender
{
//    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
//    picker.peoplePickerDelegate = self;
//    // Display only a person's phone, email, and birthdate
//    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
//                               [NSNumber numberWithInt:kABPersonEmailProperty],
//                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
//    
//    
//    picker.displayedProperties = displayedItems;
//    picker.tabBarItem.image = [UIImage imageNamed:@"user"];
//    picker.title = @"Contacts";
    [delegate gotoContact:[GlobalData getAppInfo].getRates];
}

-(IBAction)tapOnCountry:(id)sender
{
    if (!optView) {
        if (((44*countryList.count)+20)>self.view.bounds.size.height)
        {
            optView = [[CallOptionView alloc]initWithFrame:self.view.bounds tableFram:CGRectMake(15, 30, 290, self.view.bounds.size.height-100)];
            optView.table.bounces = NO;
            optView.table.scrollEnabled = YES;
        }
        else
        {
            optView = [[CallOptionView alloc]initWithFrame:self.view.bounds tableFram:CGRectMake(15, 30, 290, (44*countryList.count)+20)];
            optView.table.bounces = NO;
            optView.table.scrollEnabled = NO;
        }
    }
    else
    {
        if (((44*countryList.count)+20)>self.view.bounds.size.height) {
            optView.table.frame = CGRectMake(15, 30, 290, self.view.bounds.size.height-100);
            optView.table.bounces = YES;
            optView.table.scrollEnabled = YES;
        }else
        {
            optView.table.frame = CGRectMake(15, 30, 290, (44*countryList.count)+20);
            optView.table.bounces = NO;
            optView.table.scrollEnabled = NO;
        }
    }
    optView.section = @"COUNTRY";
    // optView.center = self.view.center;
    optView.dataList = countryList;
    optView.selectedData = selectedCountry;
    optView.delegate = self;
    [optView.table reloadData];
    if (![self.view.subviews containsObject:optView]) {
        [optView setAlpha:0.0];
        [self.view addSubview:optView];
        [UIView beginAnimations:nil context:nil];
        [optView setAlpha:1.0];
        [UIView commitAnimations];
    }
}

-(void)updateData:(NSObject *)data section:(NSString *)section
{
    txtInternationalNo.text = @"";
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3f];
//    optView.alpha = 0;
//    [UIView commitAnimations];

    [UIView animateWithDuration:0.2
                     animations:^{optView.alpha = 0.0;}
                     completion:^(BOOL finished){[optView removeFromSuperview];}];
    optView = nil;
    if (data) {
        if ([section isEqualToString:@"COUNTRY"]) {
            selectedCountry = (Country *)data;
            [GlobalData setSelectedCountry:selectedCountry];
            [btnCountry setTitle:selectedCountry.countryName forState:UIControlStateNormal];
            [btnArea setTitle:[GlobalData getAppInfo].pleaseSelect forState:UIControlStateNormal];
            [txtRate setText:[NSString stringWithFormat:@"%@                                         ",[GlobalData getAppInfo].yourRates]];
            selectedArea = nil;
            areaList = nil;
            if (![GlobalData isNetworkAvailable]) {
                
                [[[UIAlertView alloc]initWithTitle:@"Message" message:[GlobalData getAppInfo].networkNotAvailable delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }else
            {
                [self showLoader];
                [self performSelectorInBackground:@selector(loadArea) withObject:nil];
            }
        }else if ([section isEqualToString:@"AREA"]) {
            selectedArea = (Area *)data;
            [btnArea setTitle:selectedArea.areaName forState:UIControlStateNormal];
            [self setTextRate:selectedArea.rate];
        }
    }
    
}

-(void)setTextRate:(NSString *)rate
{
    float callRate = [rate floatValue];
    txtRate.text = [NSString stringWithFormat:@"%@:             $ %.4f/minute",[GlobalData getAppInfo].yourRates,callRate];
}

-(void)loadArea
{
    [[RESTInteraction restInteractionManager] GetAreaList:selectedCountry.countryName];
}

-(IBAction)tapOnArea:(id)sender
{
    if (selectedCountry) {
        if (!optView) {
            if (((44*areaList.count)+20)>self.view.bounds.size.height) {
                optView = [[CallOptionView alloc]initWithFrame:self.view.bounds tableFram:CGRectMake(15, 30, 290, self.view.bounds.size.height-100)];
                optView.table.bounces = YES;
                optView.table.scrollEnabled = YES;
            }else
            {
                optView = [[CallOptionView alloc]initWithFrame:self.view.bounds tableFram:CGRectMake(15, 30, 290, (44*areaList.count))];
                optView.table.bounces = NO;
                optView.table.scrollEnabled = NO;
            }
        }else
        {
            if (((44*areaList.count)+20)>self.view.bounds.size.height) {
                optView.table.frame = CGRectMake(15, 30, 290, self.view.bounds.size.height-100);
                optView.table.bounces = YES;
                optView.table.scrollEnabled = YES;
            }else
            {
                optView.table.frame = CGRectMake(15, 30, 290, (44*areaList.count));
                optView.table.bounces = NO;
                optView.table.scrollEnabled = NO;
            }
        }
        optView.section = @"AREA";
        // optView.center = self.view.center;
        optView.dataList = areaList;
        optView.selectedData = selectedArea;
        optView.delegate = self;
        [optView.table reloadData];
        if (![self.view.subviews containsObject:optView]) {
            [optView setAlpha:0.0];
            [self.view addSubview:optView];
            [UIView beginAnimations:nil context:nil];
            [optView setAlpha:1.0];
            [UIView commitAnimations];
        }
        
    }else
    {
        [[[UIAlertView alloc] initWithTitle:@"Message" message:[GlobalData getAppInfo].pleaseSelectCountry delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(callGetAreaForPhone) object:nil];
    if (textField.text.length>9)
    {
        [self performSelector:@selector(callGetAreaForPhone) withObject:nil afterDelay:1.1];
    }else if(textField.text.length==9 && string.length==1)
    {
        [self performSelector:@selector(callGetAreaForPhone) withObject:nil afterDelay:1.1];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [btnContact setTitle:[GlobalData getAppInfo].pleaseSelect forState:UIControlStateNormal];
    [btnArea setTitle:[GlobalData getAppInfo].pleaseSelect forState:UIControlStateNormal];
    [txtRate setText:[NSString stringWithFormat:@"%@                                         ",[GlobalData getAppInfo].yourRates]];
    return YES;
}

-(void)callGetAreaForPhone
{
    if (txtInternationalNo.text.length>=10) {
        [[RESTInteraction restInteractionManager] GetAreaForPhone:txtInternationalNo.text];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
