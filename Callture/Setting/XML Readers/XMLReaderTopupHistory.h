//
//  XMLReaderTopupHistory.h
//  Oye Dialer
//
//  Created by user on 29/11/12.
//
//

#import "BaseXMLReader.h"
#import "MobileTopup.h"
@protocol XMLReaderTopupHistoryDelegate
-(void)addMobileTopup:(MobileTopup *)mt;
@end
@interface XMLReaderTopupHistory : BaseXMLReader
{
    MobileTopup *currentObject;
    NSMutableArray *topupList;
}
@property (nonatomic,assign) id <XMLReaderTopupHistoryDelegate>delegate;
@end
