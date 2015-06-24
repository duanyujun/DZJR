//
//  AboutController.m
//  fmapp
//
//  Created by 张利广 on 14-5-14.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "AboutController.h"
#define kScrollViewTag 10000
#define kHotlineButtonTag 10001
#define kCooperationButtonTag 10002

@interface AboutController ()

@end

@implementation AboutController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrNightScrollViewColor;
    
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    [self settingNavTitle:@"关于"];
    
    CGFloat heighScale=(CGFloat)KProjectScreenHeight/568;
    if (heighScale<1) {
        heighScale=1;
    }
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mainScrollView.tag = kScrollViewTag;
    mainScrollView.showsVerticalScrollIndicator = NO;
    [mainScrollView setBackgroundColor:KDefaultOrNightScrollViewColor];
    [mainScrollView setContentSize:CGSizeMake(KProjectScreenWidth, self.view.bounds.size.height + 20.0f)];
    
    //项目图片
    UIImageView *projectImage = [[UIImageView alloc]initWithFrame:CGRectMake((KProjectScreenWidth-110*heighScale)/2, 85.0f, 110.0f*heighScale,110.0f*heighScale)];
    if (ThemeCategory==5) {
        projectImage.alpha=0.7;
    }
    
    [projectImage setImage:[UIImage imageNamed:@"about_icon.png"]];
    [projectImage setImage:createImageWithColor(KUIImageViewDefaultColor)];
    projectImage.layer.cornerRadius = 10.0f;
    projectImage.layer.masksToBounds = YES;
    [mainScrollView addSubview:projectImage];
    
    
    //
    UILabel *companyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, projectImage.frame.origin.y+projectImage.frame.size.height+20, KProjectScreenWidth, 20)];
    companyNameLabel.text = @"大众金融";
    companyNameLabel.textColor=KContentTextColor;
    companyNameLabel.font=[UIFont boldSystemFontOfSize:18.0f];
    companyNameLabel.textAlignment = UITextAlignmentCenter;
    companyNameLabel.backgroundColor=[UIColor clearColor];
    [mainScrollView addSubview:companyNameLabel];
    
    UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, companyNameLabel.frame.origin.y+companyNameLabel.frame.size.height+5, KProjectScreenWidth, 20)];
    introLabel.text = @"微投行领导者";
    introLabel.textColor=KSubNumbeiTextColor;
    introLabel.font=[UIFont systemFontOfSize:14.0f];
    introLabel.textAlignment = UITextAlignmentCenter;
    introLabel.backgroundColor=[UIColor clearColor];
    [mainScrollView addSubview:introLabel];
    
    //版权
    UILabel *copyRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (416  + (HUIIsIPhone5() ? 88 : 0)- 20)*heighScale, KProjectScreenWidth, 20)];
    copyRightLabel.text = @"Copyright ©2014-2015 大众智信 版权所有";
    copyRightLabel.textColor = [UIColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1.0];
    copyRightLabel.textAlignment = UITextAlignmentCenter;
    copyRightLabel.font = [UIFont systemFontOfSize:11];
    copyRightLabel.backgroundColor = [UIColor clearColor];
    [mainScrollView addSubview:copyRightLabel];
    
    [self.view addSubview:mainScrollView];

    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
