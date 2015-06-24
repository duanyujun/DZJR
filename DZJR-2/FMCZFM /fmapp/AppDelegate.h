//
//  AppDelegate.h
//  fmapp
//
//  Created by lyh on 14-5-5.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLLockViewController.h"

#define  ShareAppDelegate ((AppDelegate* )[[UIApplication sharedApplication] delegate])



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign)  BOOL      gestureBool;

// 手势解锁相关
@property (strong, nonatomic) LLLockViewController* lockVc; // 添加解锁界面
- (void)showLLLockViewController:(LLLockViewType)type;

- (void)showLockView;


@end
