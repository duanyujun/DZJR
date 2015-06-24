//
//  UIScreen+HUIAddtion.m
//  HUIKit
//
//  Created by lyh on 14-5-7.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import "UIScreen+HUIAddtion.h"

@implementation UIScreen (HUIAddtion)

- (BOOL)isRetinaDisplay 
{
    static BOOL _isRetina;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _isRetina = ([self respondsToSelector:@selector(scale)] && [self scale] == 2.0);
    });
    return _isRetina;
}

- (BOOL)isIPhone5
{
    static BOOL _isIPhone5 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _isIPhone5 = self.bounds.size.height >= 568.00;
    });
    return _isIPhone5;
}

@end
