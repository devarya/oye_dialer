//
//  XMLReaderPhoneArea.h
//  Callture
//
//  Created by user on 17/10/12.
//
//

#import "BaseXMLReader.h"
#import "Country.h"
@interface XMLReaderPhoneArea : BaseXMLReader
{
    Country *currentObject;
    int count;
}
@property(nonatomic,retain) Country *currentObject;
@end
