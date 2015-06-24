//
//  ZhongChouCell.m
//  fmapp
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ZhongChouCell.h"

#define KBackWidth    KProjectScreenWidth-20
#define KBackHeight   KProjectScreenWidth/320.0f*200

#define KContentLabelTag   10000
#define KTitleLabelTag     20000

@interface ZhongChouCell ()

@property (nonatomic,weak)  UIImageView      *topImageView;

@end

@implementation ZhongChouCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
  
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(10, 15, KBackWidth, KBackHeight)];
        backView.backgroundColor=[UIColor whiteColor];
        [self addSubview:backView];
        
        UIImageView *topImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KBackWidth, KBackHeight-60.0f)];
        topImageView.image=createImageWithColor(KSubNumbeiTextColor);
        self.topImageView=topImageView;
        [backView addSubview:topImageView];
      
        CGFloat width=(KProjectScreenWidth-20)/3.0f;
        
        NSArray *titleArr=[[NSArray alloc]initWithObjects:@"已达到",@"已筹集",@"剩余时间", nil];
        
        for(int i=0;i<3;i++)
        {
            UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i,KBackHeight-60+10, width, 20)];
            contentLabel.font=[UIFont boldSystemFontOfSize:20.0f];
            contentLabel.textAlignment=NSTextAlignmentCenter;
            contentLabel.backgroundColor=[UIColor clearColor];
            contentLabel.textColor=KContentTextColor;
            contentLabel.tag=KContentLabelTag+i;
            [backView addSubview:contentLabel];
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i, contentLabel.frame.origin.y+20+5, width, 16)];
            titleLabel.font=[UIFont systemFontOfSize:13.0f];
            titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.backgroundColor=[UIColor clearColor];
            titleLabel.text=titleArr[i];
            titleLabel.textColor=KSubTitleContentTextColor;
            titleLabel.tag=KTitleLabelTag+i;
            [backView addSubview:titleLabel];

        }
    }
    return self;
}
- (void) displayQuestion:(ProjectModel* )model
{
    NSString *imageUrl=[NSString stringWithFormat:@"%@%@",kBaseAPIURL,model.tupian];
    [self.topImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:createImageWithColor(KSubNumbeiTextColor)];
    
    model.lilv=@"100";
    NSArray *contentArr=[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",model.lilv],[NSString stringWithFormat:@"%@",model.lilv],[NSString stringWithFormat:@"%@",model.lilv], nil];
    
    for(int i=0;i<3;i++)
    {
        UILabel *contentLabel=(UILabel *)[self viewWithTag:KContentLabelTag+i];
        contentLabel.text=contentArr[i];
        
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
