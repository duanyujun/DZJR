//
//  SelfButton.m
//  fmapp
//
//  Created by apple on 15/2/26.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "SelfButton.h"

@implementation SelfButton

-(id)initWithImageStr:(NSString *)imageStr AndWithTitle:(NSString *)title AndWithBtnTag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        self.tag=tag;

        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 25, 25)];
        image.backgroundColor=[UIColor clearColor];
        image.image=[UIImage imageNamed:imageStr];
        [self addSubview:image];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(40, 8.5, 200, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=title;
        label.textColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
        label.font=[UIFont systemFontOfSize:16.0f];
        [self addSubview:label];
        
        if([title isEqualToString:@"客服电话"])
        {
            UILabel *tellabel=[[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-160-8, 8.5, 150, 30)];
            tellabel.backgroundColor=[UIColor clearColor];
            tellabel.textAlignment=NSTextAlignmentRight;
            tellabel.text=@"400-878-8686";
            tellabel.textColor=[UIColor colorWithRed:0 green:0.42 blue:0.77 alpha:1];
            tellabel.font=[UIFont systemFontOfSize:15.0f];
            [self addSubview:tellabel];
        }
       else if([title isEqualToString:@"检查更新"])
        {
            UILabel *tellabel=[[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-160-8, 8.5, 150, 30)];
            tellabel.backgroundColor=[UIColor clearColor];
            tellabel.textAlignment=NSTextAlignmentRight;
            tellabel.text=@"V1.0";
            tellabel.textColor=[UIColor colorWithRed:0 green:0.42 blue:0.77 alpha:1];
            tellabel.font=[UIFont systemFontOfSize:15.0f];
            [self addSubview:tellabel];
        }
        else
        {
            UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-25, 16.5, 10, 14)];
            arrowImage.image=[UIImage imageNamed:@"More_CellArrow.png"];
            [self addSubview:arrowImage];
        }

        
    }
    
    return self;
}
-(id)initWithTitle:(NSString *)title AndWithBtnTag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.tag=tag;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,8.5f , 200, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=title;
        label.textColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
        label.font=[UIFont systemFontOfSize:17.0f];
        [self addSubview:label];
        
        if (![title isEqualToString:@"实名认证"]) {
            
            UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-40, 16.5, 10, 14)];
            arrowImage.image=[UIImage imageNamed:@"More_CellArrow.png"];
            [self addSubview:arrowImage];

        }

    }
    return self;

}
-(id)initWithHelpCenterTitle:(NSString *)title AndWithBtnTag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.tag=tag;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,8.5f , 200, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=title;
        label.textColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
        label.font=[UIFont systemFontOfSize:17.0f];
        [self addSubview:label];
        
        UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-40, 16.5, 10, 14)];
        arrowImage.image=[UIImage imageNamed:@"More_CellArrow.png"];
        [self addSubview:arrowImage];
        
    }
    return self;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
