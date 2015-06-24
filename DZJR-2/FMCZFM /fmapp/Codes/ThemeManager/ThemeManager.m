//
//  ThemeManager.m
//  FM_CZFW
//
//  Created by liyuhui on 14-4-1.
//  Copyright (c) 2013年 ETelecom. All rights reserved.
//

#import "ThemeManager.h"
#import "FMNightSkin.h"
#import "AppDelegate.h"
#import "FMSolidSkin.h"


@implementation ThemeManager


+ (ThemeManager *)sharedThemeManager
{
    static ThemeManager *_themeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _themeManager = [[ThemeManager alloc] init];
    });
    
    return _themeManager;
}

- (id)init
{
    self = [super init];
    if (self){
        self.skin = [[FMDefaultSkin alloc] init];
    }
    return self;
}
- (FMDefaultSkin* )createSkinById:(NSInteger)skinId
{
    skinId=4;

    //更换主题
    switch (skinId) {
            
        case 2:
            return [[FMSolidSkin alloc] initWithColor:[UIColor colorWithRed:252.0/255.0
                                                                     green:111.0/255.0
                                                                      blue:160.0/255.0
                                                                     alpha:1.0]];
            break;
        case 3:
            return [[FMSolidSkin alloc] initWithColor:[UIColor colorWithRed:0/255.0f
                                                                       green:213/255.0f
                                                                        blue:161/255.0f
                                                                       alpha:1.0]];
            break;
        case 4:
            return [[FMSolidSkin alloc] initWithColor:[UIColor colorWithRed:0.2 green:0.68 blue:0.92 alpha:1]];
        case 5:
            return [[FMNightSkin alloc] init];
            
        default:
            break;
    }
    return  [[FMDefaultSkin alloc] init];
}
- (void)applySkin:(FMDefaultSkin* )skin
{
    self.skin = skin;
    UIViewController *rootViewController = ShareAppDelegate.window.rootViewController;
    
//    [ShareAppDelegate setTabRootControlItem];

    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){
        //设置状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:[skin statusbarStyle]];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
    ShareAppDelegate.window.rootViewController = nil;
    
    //
    [self applySkinToTabBar:nil];
    [self applySkinToNavigationBar:nil];
    [self applySkinToTableView:nil];
    
    ShareAppDelegate.window.rootViewController = rootViewController;
    
    
    
}
- (void)applySkinToTabBar:(UITabBar *)tabBarOrAppearance {
    if (!tabBarOrAppearance) {
        tabBarOrAppearance = [UITabBar appearance];
    }
    
    //设置背景
    UIImage* img = createImageWithColor([UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1]);
    if(img){
        [tabBarOrAppearance setBackgroundImage:img];
        
    }else{
        UIColor* color = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        if (color) {
            
            if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
                tabBarOrAppearance.tintColor = color;
            }else{
                
                tabBarOrAppearance.barTintColor = color;
            }
        }
    }
    
    //title颜色
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{ UITextAttributeFont: kTableBarFontSize,
        UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
        UITextAttributeTextColor: [self.skin tabBarTitleColor]}
                                             forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:
            @{ UITextAttributeFont: kTableBarFontSize,
               UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
               UITextAttributeTextColor: [self.skin tabBarSelectColor]}
                    forState:UIControlStateSelected];
    
    //title位置
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -2.0)];
}

- (void)applySkinToNavigationBar:(UINavigationBar *)navigationBarOrAppearance {
    if (!navigationBarOrAppearance) {
        navigationBarOrAppearance = [UINavigationBar appearance];
    }
    
    //设置背景
    UIImage* img = createImageWithColor([UIColor colorWithRed:0.18 green:0.56 blue:0.89 alpha:1]);
    if(img){
        if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
            [navigationBarOrAppearance setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        }else{
            [navigationBarOrAppearance setBackgroundImage:img
                                           forBarPosition:UIBarPositionTopAttached
                                               barMetrics:UIBarMetricsDefault];

        }
    }else{
        UIColor* color = [UIColor colorWithRed:0.18 green:0.56 blue:0.89 alpha:1];
        if (color) {
            if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
                navigationBarOrAppearance.tintColor = color;
            }else{                
                navigationBarOrAppearance.barTintColor = color;
            }
            
        }
    }
    //设置返回按钮颜色
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){
        [navigationBarOrAppearance setTintColor:[self.skin navigationTextColor]];
    }

}

- (void)applySkinToTableView:(UITableView *)tableView {

    UIColor *backgroundColor = [self.skin backgroundColor];
    if (backgroundColor) {
        [tableView setBackgroundColor:backgroundColor];
        [tableView setBackgroundView:[[UIView alloc] initWithFrame:tableView.backgroundView.frame]];
    }
}

@end
