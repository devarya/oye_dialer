//
//  XMLReaderAreaList.h
//  Callture
//
//  Created by user on 17/10/12.
//
//

#import "BaseXMLReader.h"
#import "Area.h"
@interface XMLReaderAreaList : BaseXMLReader
{
    Area *currentObject;
    NSMutableArray *arealist;
    int count;
}
@property(nonatomic,retain) Area *currentObject;
@end
