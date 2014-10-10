//
//  callLogListViewController.h
//  Callture
//
//  Created by Manish on 09/12/11.
//  Copyright 2011 Aryavrat Infotech Pvt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneCallDelegate.h"
#import "MBProgressHUD.h"
@interface callLogListViewController : UIViewController<MBProgressHUDDelegate> {
    NSMutableArray *myLogList;
    IBOutlet UITableView *tableLog;
    NSMutableArray	*filteredListContent;    
    IBOutlet UIView *bgView;
    UIView *searchBgView;
    IBOutlet UISearchBar *searchBar;
    NSInteger selectedRow;
    UIView *popup;
    int count;
    NSArray *searchCOmbinations;
    UIView *loader;
    UIButton *btnBg;
    BOOL isCallFromBtn;
    NSMutableArray *searchList;
    NSTimer *callingTimer;
    NSString *dialStr;
    
    //refreshon pull
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    id<PhoneCallDelegate> phoneCallDelegate;
    MBProgressHUD *HUD;
}

//pull to refresh
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;


@property (nonatomic,retain) NSTimer *callingTimer;
@property (nonatomic,retain)NSMutableArray *myLogList;
@property (nonatomic,retain)UITableView *tableLog;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic,retain) UIView *bgView;
@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,retain) NSArray *searchCOmbinations;
@property (nonatomic, retain)   id<PhoneCallDelegate> phoneCallDelegate;
+ (callLogListViewController*)currentView;
+ (void)setCurrentView:(callLogListViewController*)newView;
+(void)SetIsLoading:(BOOL)isloading;
-(void)updateLogList:(NSMutableArray *)logList;
-(NSString *)getDateInFormat:(NSDate *)dt;
-(NSMutableArray *)generateComb:(NSMutableArray *)arr1 :(NSMutableArray *)arr2;
-(void)callRestForGetLog;
-(void)callRestForCallBack;
-(void)updateCallBackStatus:(NSString *)msg;
-(void)callFromCallButton;
-(void)searchInFilteredList:(NSMutableArray *)arr combArray:(NSMutableArray *)combArr index:(int)ind;
- (NSArray *) callsMatchingPhone: (NSString *) number;
- (void)filterContentForSearchText:(NSString*)searchText;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;

//added by par
@property(nonatomic,retain) NSString *dialStr;
@end
