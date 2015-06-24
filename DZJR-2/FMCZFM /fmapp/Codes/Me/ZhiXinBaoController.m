//
//  ZhiXinBaoController.m
//  fmapp
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ZhiXinBaoController.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "HTTPClient+MeModulesSetup.h"
#import "HTTPClient.h"
#import "LineChartView.h"
#import "HTTPClient+ExploreModules.h"
#import "CurrentUserInformation.h"
#import "ShareViewController.h"
#import "LoginController.h"

@interface ZhiXinBaoController ()
@property (nonatomic,weak) UIScrollView    *mainScrollView;
@property (nonatomic,weak) UIView          *midView;

@end

@implementation ZhiXinBaoController

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrNightScrollViewColor;
}

- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingNavTitle:@"智信宝"];
    [self createMainScroView];
}
- (void)createMainScroView
{
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +260.0f);
    if(KProjectScreenHeight>568)
    {
        mainScrollView.contentSize = CGSizeMake(KProjectScreenWidth, mainScrollView.frame.size.height+80);
    }
    self.mainScrollView=mainScrollView;
    [self.view addSubview:mainScrollView];
        
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 290)];
    backView.backgroundColor=[UIColor colorWithRed:0.99 green:0.37 blue:0.34 alpha:1];
    [mainScrollView addSubview:backView];
    
    UILabel *zichanLabel=[[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth-100)/2, 35, 100, 15)];
    zichanLabel.textColor=[UIColor whiteColor];
    zichanLabel.text=@"昨日收益（元）";
    zichanLabel.font=[UIFont systemFontOfSize:12.0f];
    zichanLabel.textAlignment=NSTextAlignmentCenter;
    [backView addSubview:zichanLabel];
    
    UILabel *zichanContentLabel=[[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth-150)/2.0f, zichanLabel.frame.origin.y+zichanLabel.frame.size.height+20, 150, 100)];
    zichanContentLabel.textColor=[UIColor whiteColor];
    zichanContentLabel.text=[CurrentUserInformation sharedCurrentUserInfo].zongzichan;
    zichanContentLabel.font=[UIFont systemFontOfSize:60.0f];
    zichanContentLabel.textAlignment=NSTextAlignmentCenter;
    [backView addSubview:zichanContentLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 290-100-0.5f, KProjectScreenWidth, 0.5f)];
    lineView.backgroundColor=[UIColor whiteColor];
    [backView addSubview:lineView];
    
    NSArray *infoTitleArr=[[NSArray alloc]initWithObjects:@"今日最新收益（元）",@"累计收益（元）", nil];
    NSArray *infoValueArr=[[NSArray alloc]initWithObjects:[CurrentUserInformation sharedCurrentUserInfo].zongzichan,[CurrentUserInformation sharedCurrentUserInfo].zongzichan, nil];
    
    CGFloat orgY=290-100;
    CGFloat width=KProjectScreenWidth/2.0f;
    
    for(int i=0;i<2;i++)
    {
        UILabel *infoTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i, orgY+25, width, 15)];
        infoTitleLabel.textColor=[UIColor whiteColor];
        infoTitleLabel.text=infoTitleArr[i];
        infoTitleLabel.font=[UIFont systemFontOfSize:12.0f];
        infoTitleLabel.textAlignment=NSTextAlignmentCenter;
        [backView addSubview:infoTitleLabel];
        
        UILabel *infoValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i, orgY+45, width, 40)];
        infoValueLabel.textColor=[UIColor whiteColor];
        infoValueLabel.text=infoValueArr[i];
        infoValueLabel.font=[UIFont systemFontOfSize:30.0f];
        infoValueLabel.textAlignment=NSTextAlignmentCenter;
        [backView addSubview:infoValueLabel];
        
        
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
