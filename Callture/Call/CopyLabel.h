//
//  CopyLabel.h
//  Callture
//
//  Created by Manish on 28/03/12.
//  Copyright (c) 2011 __Aryavrat Infotech Pvt. Ltd.__. All rights reserved.
//

@class CopyLabel;
@protocol CopyLabelDelegate <NSObject>
@required
-(void)pasteData:(NSString *)str;
@end
@interface CopyLabel : UILabel
{
    UIPasteboard *pasteboard;
}
@property (nonatomic, assign, readwrite) id <CopyLabelDelegate> delegate;

@end
