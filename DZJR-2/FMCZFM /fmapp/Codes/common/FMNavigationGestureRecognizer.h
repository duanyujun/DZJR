//
//  FMNavigationGestureRecognizer.h
//  fmapp
//
//  Created by 张利广 on 14-6-11.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#define KGestureButtonBaseTag 1870111
#import <UIKit/UIKit.h>

@protocol GestureRecognizerDelegate <NSObject>

/**用户操作控制协议，用于作为数据传出的依据**/
- (void)initWithUserGestureRecognizerOperationButtonEvent:(id)sender;

@end
/** 用户手势滑动 选择加载加载内容
 
 *@See 适用于找到了、都市顺风车、信息网模块的手势操作
 **/
@interface FMNavigationGestureRecognizer : UIView<GestureRecognizerDelegate>


/** 初始化滑动操作界面
 
 *@param (UIViewController *)parentControl 操作控制视图
 *@param (NSArray *)nameArray 按键内容数组
 *@param (id<GestureRecognizerDelegate>)delegate 操作控制协议
 *@return 界面内容
 **/
- (id)initWithFrame:(CGRect)frame
      withViewContr:(UIViewController *)parentControl
   withBtnNameArray:(NSArray *)nameArray
       withDelegate:(id<GestureRecognizerDelegate>)delegate;

/** 用户在外围改变选择器内容
 
 *@param (NSInteger)intIndex 选中的内容
 *@return void
 **/
- (void)initWithChangedWithUserSelectedIndex:(NSInteger)intIndex;

@end
