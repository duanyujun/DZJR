//
//  ThemeManager.h
//  FM_CZFW
////
//  Created by liyuhui on 14-4-1.
//  Copyright (c) 2013年 ETelecom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ThemeSize.h"
#import "ThemeColor.h"
#import "ThemeImage.h"
#import "FMDefaultSkin.h"

#define FMThemeManager [ThemeManager sharedThemeManager]

@interface ThemeManager : NSObject

@property (nonatomic, strong) FMDefaultSkin *skin;

+ (ThemeManager *)sharedThemeManager;

- (id)init;
- (FMDefaultSkin* )createSkinById:(NSInteger)skinId;

//更换皮肤
- (void)applySkin:(FMDefaultSkin* )skin;
- (void)applySkinToTabBar:(UITabBar *)tabBarOrAppearance;
- (void)applySkinToNavigationBar:(UINavigationBar *)navigationBarOrAppearance;
- (void)applySkinToTableView:(UITableView *)tableView;

@end
