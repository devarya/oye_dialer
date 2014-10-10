//
//  ContactsViewController.m
//  Oye Dialer
//
//  Created by dev on 28/05/13.
//
//

#import "ContactsViewController.h"
#import "GlobalData.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController
@synthesize contactsWebView;

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
    self.navigationController.navigationBar.hidden = YES;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    
    if(screenHeight <= 480)
    {
        self.view.frame = CGRectMake(0, 0, 320, 480);
    }
    else
    {
        self.view.frame = CGRectMake(0, 0, 320, 568);
    }

    contactsWebView.frame = self.view.bounds;
    
    NSString *urlAddress = [GlobalData getAppInfo].urlContactsPage;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [contactsWebView loadRequest:requestObj];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
