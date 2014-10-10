//
//  XMLReaderCountryList.h
//  Callture
//
//  Created by user on 17/10/12.
//
//

#import "BaseXMLReader.h"
#import "Country.h"
@interface XMLReaderCountryList : BaseXMLReader
{
    Country *currentObject;
    NSMutableArray *countrylist;
}
@property(nonatomic,retain) Country *currentObject;
@end
