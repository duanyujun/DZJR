//
//  ZhengQuanCell.m
//  fmapp
//
//  Created by apple on 15/5/8.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ZhengQuanCell.h"

#define KContentLabelTag           10001
#define KTitleLabelTag             20001

@interface ZhengQuanCell()

@property (nonatomic,weak) UILabel  *titleLabl;
@property (nonatomic,weak) UILabel  *companyLabl;
@property (nonatomic,weak) UIView   *bottomLineView;
@property (nonatomic,weak) UIView   *dateView;

@end

@implementation ZhengQuanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, KProjectScreenWidth-10-80, 16)];
        titleLable.font = [UIFont systemFontOfSize:16.0f];
        [titleLable setTextColor:KContentTextColor];
        [titleLable setBackgroundColor:[UIColor clearColor]];
        self.titleLabl = titleLable;
        [self addSubview:titleLable];
        
        UILabel *companyLable = [[UILabel alloc]init];
        companyLable.font = [UIFont systemFontOfSize:11.0f];
        [companyLable setTextColor:[UIColor whiteColor]];
        [companyLable setBackgroundColor:[UIColor colorWithRed:96.0/255.0 green:201.0/255.0 blue:255.0/255.0 alpha:1]];
        self.companyLabl = companyLable;
        [self addSubview:companyLable];
        
        CGFloat width=KProjectScreenWidth/2.0f;

        for(int i=0;i<2;i++)
        {
            
            UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 48, width, 30)];
            contentlabel.tag=KContentLabelTag+i;
            contentlabel.textColor=[UIColor colorWithRed:0.93 green:0.29 blue:0.17 alpha:1];
            if (i==0) {
                contentlabel.textColor=[UIColor blackColor];
            }
            contentlabel.textAlignment=NSTextAlignmentCenter;
            contentlabel.backgroundColor=[UIColor clearColor];
            contentlabel.font=[UIFont boldSystemFontOfSize:25];
            [self addSubview:contentlabel];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 83, width, 15)];
            //            label.text=titleArr[i];
            label.textColor=[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1];
            label.textAlignment=NSTextAlignmentCenter;
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:12];
            label.tag=KTitleLabelTag+i;
            [self addSubview:label];

            
            if(i>0)
            {
                UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(width*i, 55, 0.5f, 50)];
                lineView.backgroundColor=KSepLineColorSetup;
                [self addSubview:lineView];
            }
            
        }
        
        UIView *dateView=[[UIView alloc]initWithFrame:CGRectMake(0, 165-50, KProjectScreenWidth, 35)];
        dateView.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        self.dateView=dateView;
        [self addSubview:dateView];

        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 165-15, KProjectScreenWidth, 15)];
        self.bottomLineView=bottomView;
        self.bottomLineView.backgroundColor=[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [self addSubview:bottomView];


        
    }
    return  self;
}

- (void) displayQuestion:(ProjectModel* )model
{
    self.titleLabl.text=model.biaoti;
    
    NSString *companyStr=[NSString stringWithFormat:@" %@ ",model.chenggong];
    CGSize comSize=[companyStr sizeWithFont:self.companyLabl.font];
    self.companyLabl.frame=CGRectMake(KProjectScreenWidth-15-comSize.width, 13, comSize.width, 15);
    self.companyLabl.text=companyStr;

    NSArray *titleArr=[[NSArray alloc]initWithObjects:@"成本价(元)",@"最新价(元)", nil];
    
    for(int i=0;i<2;i++)
    {
        NSArray *cArr=[[NSArray alloc]initWithObjects:model.lilv,model.zjine, nil];
        
        UILabel *titleLabel=(UILabel *)[self viewWithTag:KTitleLabelTag+i];
        titleLabel.text=titleArr[i];
        
        UILabel *contentLabel=(UILabel *)[self viewWithTag:KContentLabelTag+i];
        contentLabel.text=cArr[i];
        
    }

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
