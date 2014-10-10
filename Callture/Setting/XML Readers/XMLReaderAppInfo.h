//
//  XMLReaderAppInfo.h
//  Oye
//
//  Created by user on 26/10/12.
//
//

#import "BaseXMLReader.h"
#import "AppInfo.h"
@interface XMLReaderAppInfo : BaseXMLReader
{
    AppInfo *currentObject;
    AppInfo *currentObjectLabels;
    NSDictionary *dict;
}
@end
