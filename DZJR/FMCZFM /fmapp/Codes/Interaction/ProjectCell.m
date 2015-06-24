//
//  ProjectCell.m
//  fmapp
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ProjectCell.h"
#define KCircleOuterRadius          75.0f
#define KCircleBorderWidth          12.0f
#define KCircleInsideRadius         (75.0f - KCircleBorderWidth*2)

#define KCircleOuterImageColor      [UIColor colorWithRed:226.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0f]
#define KCornerRadiusBorderColor    [UIColor colorWithRed:20.0f/255.0f green:153.0f/255.0f blue:240.0f/255.0f alpha:1.0f]

#define KContentLabelTag           10001
#define KTitleLabelTag             20001

@interface ProjectCell()

@property (nonatomic,weak) UILabel  *titleLabl;
@property (nonatomic,weak) UILabel  *companyLabl;
@property (nonatomic,weak) UIImageView *corImageView;
@property (nonatomic,weak) UILabel  *progressLabel;
@property (nonatomic,weak) UILabel  *repayLabel;
@property (nonatomic,weak) UIView   *bottomLineView;
@property (nonatomic,weak) UIView   *dateView;
@property (nonatomic,weak) UIImageView *danImageView;
@property (nonatomic,weak) UILabel  *dateContentLabel;

@end

@implementation ProjectCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *danImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 16, 16)];
        danImage.image=[UIImage imageNamed:@"firsr_2.png"];
        self.danImageView=danImage;
//        [self addSubview:danImage];
        
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

        UIImageView *outerCircleImage = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-10-75, 40.0f, KCircleOuterRadius, KCircleOuterRadius)];
        [outerCircleImage setBackgroundColor:KCircleOuterImageColor];
        
        [outerCircleImage.layer setMasksToBounds:YES];
        [outerCircleImage.layer setCornerRadius:KCircleOuterRadius/2];
        self.corImageView=outerCircleImage;
        [self addSubview:outerCircleImage];
        
        UIImageView *coverImage = [[UIImageView alloc]init];
        [coverImage setBackgroundColor:KDefaultOrNightBackGroundColor];
        [coverImage setFrame:CGRectMake(KCircleBorderWidth, KCircleBorderWidth,
                                        KCircleInsideRadius,
                                        KCircleInsideRadius)];
        [coverImage.layer setMasksToBounds:YES];
        [coverImage.layer setCornerRadius:KCircleInsideRadius/2];
        [outerCircleImage addSubview:coverImage];
        
        UILabel *progressLabel=[[UILabel alloc]initWithFrame:coverImage.bounds];
        progressLabel.textAlignment=NSTextAlignmentCenter;
        progressLabel.backgroundColor=[UIColor clearColor];
        self.progressLabel=progressLabel;
        [coverImage addSubview:progressLabel];
        
        CGFloat width=(KProjectScreenWidth-30-65)/3;

        for(int i=0;i<3;i++)
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 48, width, 15)];
//            label.text=titleArr[i];
            label.textColor=[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1];
            label.textAlignment=NSTextAlignmentCenter;
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:12];
            label.tag=KTitleLabelTag+i;
            [self addSubview:label];

            UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 73, width, 15)];
            contentlabel.tag=KContentLabelTag+i;
            contentlabel.textColor=KContentTextColor;

            if (i==0) {
                contentlabel.textColor=[UIColor colorWithRed:0.93 green:0.29 blue:0.17 alpha:1];
            }
            contentlabel.textAlignment=NSTextAlignmentCenter;
            contentlabel.backgroundColor=[UIColor clearColor];
            contentlabel.font=[UIFont boldSystemFontOfSize:12];
            [self addSubview:contentlabel];
            
            if(i>0)
            {
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(width*i, 55, 0.5f, 50)];
            lineView.backgroundColor=KSepLineColorSetup;
            [self addSubview:lineView];
            }
            
        }
        
        UIImageView *repayImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 105, 15, 15)];
        repayImage.image=[UIImage imageNamed:@"project.png"];
        [self addSubview:repayImage];
        
        UILabel *repayLabel=[[UILabel alloc]initWithFrame:CGRectMake(27, 105, KProjectScreenWidth-10-27, 15)];
        repayLabel.backgroundColor=[UIColor clearColor];
        repayLabel.font=[UIFont systemFontOfSize:12.0f];
        repayLabel.textColor=[UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1];
        self.repayLabel=repayLabel;
        [self addSubview:repayLabel];
        
        UIView *dateView=[[UIView alloc]init];
        dateView.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        self.dateView=dateView;
        dateView.hidden=YES;
        [self addSubview:dateView];
        
        UIImageView *dateImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 15, 15)];
        dateImage.image=[UIImage imageNamed:@"date.png"];
        [dateView addSubview:dateImage];
        
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 7.5, 80, 15)];
        dateLabel.backgroundColor=[UIColor clearColor];
        dateLabel.text=@"过期时间:";
        dateLabel.textColor=KContentTextColor;
        dateLabel.font=[UIFont systemFontOfSize:13.0f];
        [dateView addSubview:dateLabel];
        
        UILabel *dateContentLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 7.5, 200, 15)];
        dateContentLabel.backgroundColor=[UIColor clearColor];
//        dateContentLabel.text=@"02天07小时40分钟23秒";
        dateContentLabel.textColor=[UIColor redColor];
        dateContentLabel.font=[UIFont systemFontOfSize:13.0f];
        self.dateContentLabel=dateContentLabel;
        [dateView addSubview:dateContentLabel];
        
        UIView *bottomView=[[UIView alloc]init];
        self.bottomLineView=bottomView;
        self.bottomLineView.backgroundColor=[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [self addSubview:bottomView];
        
    }
    return self;
}

- (void) displayQuestion:(ProjectModel* )model
{
    

    self.titleLabl.text=model.biaoti;
    
    NSString *companyStr=[NSString stringWithFormat:@" %@ ",model.jginfo];
    CGSize comSize=[companyStr sizeWithFont:self.companyLabl.font];
    self.companyLabl.frame=CGRectMake(KProjectScreenWidth-15-comSize.width, 13, comSize.width, 15);
    self.companyLabl.text=companyStr;
        self.progressLabel.font=[UIFont systemFontOfSize:12.0f];
        self.progressLabel.textColor=[UIColor colorWithRed:0.93 green:0.29 blue:0.17 alpha:1];
        NSString *content=[NSString stringWithFormat:@"%@%%",model.jindu];
        NSRange range=[content rangeOfString:[NSString stringWithFormat:@"%@",model.jindu]];
        NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
        [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:range];
        self.progressLabel.attributedText=attriContent;
        
        CAShapeLayer *progressLayer;//进度Layer
        UIBezierPath *path = [UIBezierPath bezierPath];
    
         CGFloat jindut=[model.jindu floatValue]/100;
        [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                        radius:(KCircleOuterRadius-KCircleBorderWidth)/2
                    startAngle:-M_PI/2
                      endAngle:2*M_PI*(1-0.68)-M_PI/2
                     clockwise:NO];
        progressLayer = [CAShapeLayer layer];
        progressLayer.path = path.CGPath;//46,169,230
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.strokeColor = [UIColor redColor].CGColor;
        progressLayer.lineWidth = KCircleBorderWidth;
        progressLayer.frame = CGRectMake(KCircleBorderWidth/2, KCircleBorderWidth/2,(KCircleOuterRadius-KCircleBorderWidth), (KCircleOuterRadius-KCircleBorderWidth));
        [self.corImageView.layer addSublayer:progressLayer];

    
    NSArray *titleArr=[[NSArray alloc]initWithObjects:@"年化收益",@"融资金额",@"融资期限", nil];

    for(int i=0;i<3;i++)
    {
        NSArray *contentArr=[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@%%",model.lilv],[NSString stringWithFormat:@"%@",model.zjine],[NSString stringWithFormat:@"%@个月",model.qixian],nil];
        NSArray *cArr=[[NSArray alloc]initWithObjects:model.lilv,model.zjine,model.qixian, nil];

        UILabel *titleLabel=(UILabel *)[self viewWithTag:KTitleLabelTag+i];
        titleLabel.text=titleArr[i];

        UILabel *contentLabel=(UILabel *)[self viewWithTag:KContentLabelTag+i];
        NSString *content=contentArr[i];
        NSRange range=[content rangeOfString:cArr[i]];
        NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
        if (i==1) {
            [attriContent addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.0f] range:range];
        }
        else
        {
        [attriContent addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0f] range:range];
        }
        contentLabel.attributedText=attriContent;

    }

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.end_time integerValue]];
    NSString *timeStr=[formatter stringFromDate:date];
    
    self.repayLabel.text=[NSString stringWithFormat:@"截止%@",timeStr];
    self.bottomLineView.frame=CGRectMake(0, 130.0f, KProjectScreenWidth, 10.0f);
   
   

}
- (void)layoutSubviews
{

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
