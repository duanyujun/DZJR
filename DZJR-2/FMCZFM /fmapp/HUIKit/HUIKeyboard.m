//
//  HUIKeybord.m
//  fmapp
//
//  Created by 李 喻辉 on 14/11/7.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUIKeyboard.h"


UIView* GetKeyBoardView()
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIView *keyboardView = nil;
    for(UIView *window in windows){
        NSArray *viewsArray = [window subviews];
        
        for(UIView *view in viewsArray){
            if([[NSString stringWithUTF8String:object_getClassName(view)]
                isEqualToString:HUISystemVersionAboveOrIs(kHUISystemVersion_8_0) ?
                @"UIInputSetContainerView":@"UIPeripheralHostView"])
            {
                //是键盘视图
                keyboardView = view;
                break;
            }
        }
    }
    return keyboardView;
}