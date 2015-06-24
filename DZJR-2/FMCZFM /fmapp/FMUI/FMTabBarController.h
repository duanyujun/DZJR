//
//  FMTabBarController.h
//  fmapp
//
//  Created by 李 喻辉 on 14-5-8.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTableButtonBaseTag    100


@interface FMTabBarController : UITabBarController

@property (nonatomic, strong) UIImage *tabBarBackgroundImage;   //Image's height is the custom tabbar's height

@property (nonatomic, copy) void(^tableClickBlock)(UIButton* oldButton,UIButton* newButton);

//add custom button image
- (void)addButtonWithNormalImage:(UIImage *)normalImage
                   selectedImage:(UIImage*)selectedImage
        forViewControllerAtIndex:(NSInteger)index;

+ (UITabBarItem* )addButtonWithNormalImage:(UIImage *)normalImage
                             selectedImage:(UIImage*)selectedImage
                                     title:(NSString* )title;

//显示或关闭table button小红点提示
- (void)showHintPoint:(NSInteger)buttonIndex showOrHide:(BOOL)bShow;

@end
