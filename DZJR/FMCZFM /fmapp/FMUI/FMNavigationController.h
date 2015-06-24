//
//  FMNavigationController.h
//  fmapp
//
//  Created by 李 喻辉 on 14-5-8.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

#if defined __cplusplus
extern "C" {
#endif

    //自定义的返回按钮
    extern inline UIButton *FMNavBarBackButtonWithTargetAndAntion(id target, SEL action);
    
#if defined __cplusplus
};
#endif


@interface FMNavigationController : UINavigationController


@end


