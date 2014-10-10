//
//  CallOptionView.h
//  Callture
//
//  Created by user on 12/10/12.
//
//

#import <UIKit/UIKit.h>
@protocol CallOptionViewDelegate <NSObject>
-(void)updateData:(NSObject *)data section:(NSString *)section;
@end
@interface CallOptionView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSString *selectedCallOption;
}
@property (nonatomic,retain) UITableView *table;
@property(nonatomic,retain) NSMutableArray *dataList;
@property(nonatomic,retain) NSObject *selectedData;
@property(nonatomic,retain) NSString *section;
@property(nonatomic,assign) id<CallOptionViewDelegate> delegate;
-(void)setCallOption:(NSString *)option;
- (id)initWithFrame:(CGRect)frame tableFram:(CGRect)tblFrame;
@end
