//
//  XMLReaderTopupCharge.h
//  Oye
//
//  Created by user on 25/10/12.
//
//

#import "BaseXMLReader.h"
#import "TopupInfo.h"
@interface XMLReaderTopupCharge : BaseXMLReader
{
    TopupInfo *currentObject;
    NSString *callingFrom;
}
@property (nonatomic, retain) NSString *callingFrom;
@end
