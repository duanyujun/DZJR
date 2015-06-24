//
//  FMNavigationController.m
//  fmapp
//
//  Created by 李 喻辉 on 14-5-8.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#define kNavBarImageTag 98989

#import "FMNavigationController.h"

@interface FMNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property(nonatomic,weak) UIViewController* currentShowVC;
@end

@implementation FMNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //去掉底部阴影条
    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)]) {// > iOS 6.0
        [self.navigationBar setShadowImage:[UIImage imageNamed:@"TabItem_SelectionIndicatorImage"]];
    }
    
    //设置背景
    [FMThemeManager applySkinToNavigationBar:self.navigationBar];
    
    //支持滑动返回
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0))
    {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
}
- (void)viewDidUnload
{
    if (HUISystemVersionBelow(kHUISystemVersion_6_0))
        [super viewDidUnload];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    
    if (navigationController.viewControllers.count == 1)
        self.currentShowVC = Nil;
    else
        self.currentShowVC = viewController;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //在根视图不响应手势，避免和侧滑产生冲突
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController);
    }
    return YES;
}

@end

#pragma mark - Inline Functions

inline UIButton *FMNavBarBackButtonWithTargetAndAntion(id target, SEL action)
{
    if (target == nil && action == nil)
        return nil;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 55.00, 44.00);
    [backBtn setImage:kImgNavbarBackItem forState:UIControlStateNormal];
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return backBtn;
}



