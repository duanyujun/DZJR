//
//  FlatGroupedStyleCell.h
//
//  fmapp
//
//  Created by lyh on 14-5-5.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlatGroupedStyleCell : UITableViewCell {

    UIView *_headView;              //头部视图
    UIView *_cellAccessoryView;     //尾部视图
}
//分割线起点
@property (nonatomic,assign)NSInteger     sepLineLeft;

- (void)setHeadView:(UIView *)view;  
- (void)setCellAccessoryView:(UIView *)view;
- (void)setLastCell:(BOOL)boolValue;
- (void)setFirstCell:(BOOL)boolValue;

@end
