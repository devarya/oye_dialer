//
//  TopupHistory.h
//  Oye Dialer
//
//  Created by user on 29/11/12.
//
//

#import <Foundation/Foundation.h>

@interface MobileTopup : NSObject
{
    /*
     <MobilePaymentID>875536</MobilePaymentID>
     <RequestDate>2012-11-24T02:25:12.533000000</RequestDate>
     <LineNo>1972422</LineNo>
     <MobileTelNo>923014231423</MobileTelNo>
     <Amount>5.75</Amount>
     <PostedCurrencyCode/>
     <PostedAmount>0</PostedAmount>
     <Status>
     Balance is not enough in pin. Current Balance is 0.44 Required Balance is 5.75
     </Status>
     <RecepientsName/>
     <ProcessStatusID>10</ProcessStatusID>
    */
    
    NSString *mobilePaymentID;
    NSString *requestDate;
    NSString *lineNo;
    NSString *mobileTelNo;
    NSString *amount;
    NSString *postedCurrencyCode;
    NSString *postedAmount;
    NSString *status;
    NSString *recepientsName;
    NSString *processStatusID;
}

@property (nonatomic,retain) NSString *mobilePaymentID;
@property (nonatomic,retain) NSString *requestDate;
@property (nonatomic,retain) NSString *lineNo;
@property (nonatomic,retain) NSString *mobileTelNo;
@property (nonatomic,retain) NSString *amount;
@property (nonatomic,retain) NSString *postedCurrencyCode;
@property (nonatomic,retain) NSString *postedAmount;
@property (nonatomic,retain) NSString *status;
@property (nonatomic,retain) NSString *recepientsName;
@property (nonatomic,retain) NSString *processStatusID;
@end
