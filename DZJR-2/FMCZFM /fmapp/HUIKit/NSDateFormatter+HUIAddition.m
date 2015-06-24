//
//  NSDateFormatter+HUIAddition.m
//  HUIKit
//
//  Created by lyh on 14-5-7.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import "NSDateFormatter+HUIAddition.h"

@implementation NSDateFormatter (HUIAddition)

+ (NSDateFormatter *)localShortStyleFormatter
{
    NSDateFormatter *dateFormatter = dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    dateFormatter.locale = [NSLocale currentLocale];
    return dateFormatter;
}
@end
