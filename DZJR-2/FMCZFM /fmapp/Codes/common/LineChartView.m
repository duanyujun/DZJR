//
//  LineChartView.m
//  DrawDemo
//
//  Created by 东子 Adam on 12-5-31.
//  Copyright (c) 2012年 热频科技. All rights reserved.
//

#import "LineChartView.h"

#define KBtTag   1000
@interface LineChartView()
{
    CALayer *linesLayer;
    
    
    UIView *popView;
    UILabel *disLabel;
    
    CGFloat scale;
}

@end

@implementation LineChartView

@synthesize array;

@synthesize hInterval,vInterval;

@synthesize hDesc,vDesc;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        scale=KProjectScreenWidth/320.0f;
        hInterval = 10;
        vInterval = 50;
        
        linesLayer = [[CALayer alloc] init];
        linesLayer.masksToBounds = YES;
        linesLayer.contentsGravity = kCAGravityLeft;
        linesLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        
        [self.layer addSublayer:linesLayer];
        
        
        //PopView
        popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        [popView setBackgroundColor:[UIColor clearColor]];
        [popView setAlpha:0.0f];
        
        disLabel = [[UILabel alloc]initWithFrame:popView.frame];
        disLabel.textColor=[UIColor whiteColor];
        [disLabel setTextAlignment:NSTextAlignmentCenter];

        [popView addSubview:disLabel];
        [self addSubview:popView];
    }
    return self;
}

#define ZeroPoint CGPointMake(30,160)

- (void)drawRect:(CGRect)rect
{
    [self setClearsContextBeforeDrawing: YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画背景线条------------------
    CGColorRef backColorRef = [UIColor colorWithRed:24.0f/255.0f green:116.0f/255.0f blue:205.0f/255.0f alpha:0.8f].CGColor;
    CGFloat backLineWidth = 0.4f;
    CGFloat backMiterLimit = 5.0f;
    
    CGContextSetLineWidth(context, backLineWidth);//主线宽度
    CGContextSetMiterLimit(context, backMiterLimit);//投影角度  
    
    CGContextSetShadowWithColor(context, CGSizeMake(3, 5), 8, backColorRef);//设置双条线 
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetLineCap(context, kCGLineCapRound );
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    
    int x = KProjectScreenWidth ;
    int y = 170 ;

    for (int i=0; i<vDesc.count; i++) {
        
        CGPoint bPoint = CGPointMake(30, y);
        CGPoint ePoint = CGPointMake(x-10, y);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [label setCenter:CGPointMake(bPoint.x-10, bPoint.y-35)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:[vDesc objectAtIndex:i]];
        label.font=[UIFont systemFontOfSize:10.0f];
        [self addSubview:label];
        
        CGContextMoveToPoint(context, bPoint.x-20, bPoint.y-30);
        CGContextAddLineToPoint(context, ePoint.x, ePoint.y-30);
        
        y -= 50;
        
    }
    
    for (int i=0; i<array.count-1; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*vInterval*scale+30*scale, 140, 40*scale, 30)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumFontSize = 1.0f;
        label.font=[UIFont systemFontOfSize:10.0f];
        [label setText:[hDesc objectAtIndex:i]];
        
        [self addSubview:label];
    }
    
    CGContextStrokePath(context);
    
//    //画点线条------------------
    CGColorRef pointColorRef = [UIColor colorWithRed:24.0f/255.0f green:116.0f/255.0f blue:205.0f/255.0f alpha:1.0].CGColor;
    CGFloat pointLineWidth = 2.5f;
    CGFloat pointMiterLimit = 5.0f;
    
    CGContextSetLineWidth(context, pointLineWidth);//主线宽度
    CGContextSetMiterLimit(context, pointMiterLimit);//投影角度  
    
    
    CGContextSetShadowWithColor(context, CGSizeMake(3, 5), 8, pointColorRef);//设置双条线 
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetLineCap(context, kCGLineCapRound );
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);

	//绘图
	CGPoint p1 = [[array objectAtIndex:0] CGPointValue];
	int i = 1;
	CGContextMoveToPoint(context, p1.x+30, 140-p1.y);
	for (; i<[array count]; i++)
	{
		p1 = [[array objectAtIndex:i] CGPointValue];
        CGPoint goPoint = CGPointMake(p1.x, 140-p1.y*vInterval/20);
		CGContextAddLineToPoint(context, goPoint.x, goPoint.y);;
        
        //添加触摸点
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [bt setBackgroundColor:[UIColor clearColor]];
        
        [bt setFrame:CGRectMake(0, 0, 20,20)];
        
        [bt setCenter:goPoint];
        
        bt.tag=KBtTag+i;
        
        [bt addTarget:self 
               action:@selector(btAction:) 
     forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:bt];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 4, 4)];
        image.layer.cornerRadius=2.0f;
        image.image=createImageWithColor([UIColor whiteColor]);
        image.clipsToBounds=YES;
        [bt addSubview:image];
	}
	CGContextStrokePath(context);
    
}

- (void)btAction:(id)sender{
//    [disLabel setText:@"100"];
    
    
    UIButton *bt = (UIButton*)sender;
    NSInteger index=bt.tag-KBtTag;
    [disLabel setText:[NSString stringWithFormat:@"%.2f",[self.contentArr[index] floatValue]]];
    
    popView.center = CGPointMake(bt.center.x, bt.center.y - popView.frame.size.height/2);
    [popView setAlpha:1.0f];
}

@end
