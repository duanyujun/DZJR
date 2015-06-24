//
//  LoadProgressView.m
//  ArtAuthority
//
//  Created by Ma Yiming on 13-7-16.
//  Copyright (c) 2013年 Ma Yiming. All rights reserved.
//

#import "LoadProgressView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadProgressView
@synthesize progressPercentValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置视图的边框 圆角 背景色
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 6.0f;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    //得到当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置画笔的粗细
    CGContextSetLineWidth(context, 10);
    //设置画笔的颜色
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    //开始准备绘制
    CGContextBeginPath(context);
    
    //从哪一点开始
    CGContextMoveToPoint(context,0,5);
    //到哪一点结束
    CGContextAddLineToPoint(context, progressPercentValue * 100,5);
    
    //绘制
    CGContextStrokePath(context);
}

@end
