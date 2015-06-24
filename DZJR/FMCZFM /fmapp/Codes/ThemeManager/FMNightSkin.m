//
//  FMNightSkin.m
//  fmapp
//
//  Created by 李 喻辉 on 14-8-14.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "FMNightSkin.h"

@implementation FMNightSkin

- (id)init
{
    self = [super init];
    if (self){
        self.nightMode = FALSE;
    }
    return self;
}

- (UIStatusBarStyle)statusbarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIColor *)backgroundColor
{
    return [UIColor colorWithRed:34/255.0f
                           green:41/255.0f
                            blue:44/255.0f
                           alpha:1.0];
    
}
- (UIColor *)scrollViewBackgroudColor
{
    return [UIColor colorWithRed:54/255.0f
                           green:61/255.0f
                            blue:64/255.0f
                           alpha:1.0];
    
}

- (UIColor *)buttonHighlightColor
{
    return [UIColor colorWithRed:54/255.0f
                           green:61/255.0f
                            blue:64/255.0f
                           alpha:1.0];
}

- (UIColor *)baseTintColor
{
    return [UIColor colorWithRed:0.18 green:0.56 blue:0.89 alpha:1];
}
- (UIColor *)cellSelectedColor
{
    return [self backgroundColor];
}
- (UIColor *)textColor
{
    return [UIColor colorWithRed:128/255.0f
                           green:128/255.0f
                            blue:128/255.0f
                           alpha:1.0];
//    return KDefaultOrNightTextColor;
}
- (UIColor *)sepratorColor
{
    //return [self textColor];
    return [UIColor colorWithRed:128/255.0f
                           green:128/255.0f
                            blue:128/255.0f
                           alpha:0.7];

}
- (UIColor *)navigationTextColor
{
    return [UIColor colorWithRed:192/255.0f
                           green:192/255.0f
                            blue:192/255.0f
                           alpha:1.0];
}

- (UIColor *)navigationBarTintColor
{
//    return [self backgroundColor];
    
    return [UIColor colorWithRed:0.02 green:0.02 blue:0.02 alpha:1];
}
- (UIImage *)navigationBarBackgroundImage
{
    
    if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
        //return [UIImage imageNamed:@"NavigationBar.png"];
        return createImageWithColor([self navigationBarTintColor]);
    }

    return nil;
}

- (UIColor *)tabBarTintColor
{
//    return [self backgroundColor];
    
    return [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
}

- (UIImage *)tabBarBackgroundImage
{
    
    if(HUISystemVersionBelow(kHUISystemVersion_8_0)){
        //return [UIImage imageNamed:@"TabBar.png"];
         return createImageWithColor([self tabBarTintColor]);
    }
     
    return nil;
}
- (UIColor *)tabBarTitleColor
{
//    return  [self textColor];
    
    return [UIColor colorWithRed:128/255.0f
                           green:128/255.0f
                            blue:128/255.0f
                           alpha:1.0];
}
- (UIColor *)tabBarSelectColor
{
    return  [UIColor colorWithRed:0.99 green:0.37 blue:0.34 alpha:1];
}
@end
