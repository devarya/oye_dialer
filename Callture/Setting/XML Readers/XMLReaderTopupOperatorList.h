//
//  XMLReaderTopupOperatorList.h
//  Oye
//
//  Created by user on 23/10/12.
//
//

#import "BaseXMLReader.h"
#import "MobileOperator.h"
@protocol XMLReaderTopupOperatorListDelegate
-(void)addOperator:(MobileOperator *)mo;
@end
@interface XMLReaderTopupOperatorList : BaseXMLReader
{
    MobileOperator *currentObject;
}
@property (nonatomic,assign) id <XMLReaderTopupOperatorListDelegate>delegate;
@end
