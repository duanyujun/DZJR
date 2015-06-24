//
//  FMNavigateMenu.h
//  fmapp
//
//  Created by 李 喻辉 on 14-6-12.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMNavigateMenuDelegate <NSObject>
- (void)didItemSelected:(NSInteger)index;
@end

@interface FMNavigateMenu : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,weak) id<FMNavigateMenuDelegate> delegate;


- (id)initWithNav:(UINavigationController* )navi;

//增加菜单项
- (void)addMenuItem:(NSString* )strTitle;

//显示菜单
- (void)showMenu:(CGPoint)ltPos curIndex:(NSInteger)currentIndex;

@end
