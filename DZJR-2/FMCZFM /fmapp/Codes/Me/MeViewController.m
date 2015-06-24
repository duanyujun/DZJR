//
//  MeViewController.m
//  fmapp
//
//  Created by 李 喻辉 on 14-5-11.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "MeViewController.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "HTTPClient+MeModulesSetup.h"
#import "HTTPClient.h"
#import "LineChartView.h"
#import "HTTPClient+ExploreModules.h"
#import "CurrentUserInformation.h"
#import "ShareViewController.h"
#import "LoginController.h"
#import "ExploreViewController.h"
#import "ZhiXinBaoController.h"

#define KBtnTag            10000

@interface MeViewController ()
@property (nonatomic,weak)NSArray          *titleArr;
@property (nonatomic,strong)NSMutableArray *lineContentArr;
@property (nonatomic,strong)NSDictionary   *userDic;
@property (nonatomic,weak) UIScrollView    *mainScrollView;
@property (nonatomic,copy)NSString   *monthStr;

@property (nonatomic,weak) UIView    *midView;
@end

@implementation MeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.enableCustomNavbarBackButton = FALSE;
    }
    return self;
}
- (id)init{
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
}
- (void)viewDidLoad
{
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(leftloginNotification:)
                                                 name: FMUserLoginNotification
                                               object: nil];
    
    if (IsStringEmptyOrNull([CurrentUserInformation sharedCurrentUserInfo].userName)) {
        
        [self settingNavTitle:@"资产"];
    }
    else
    {
    [self settingNavTitle:[CurrentUserInformation sharedCurrentUserInfo].userName];
    }
    
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        registerController.tabbarIndex=FMShareSetting.tabbarSelectIndex;
        [self presentModalViewController:navController animated:YES];
        return;
    }
    
    [self createMainScroView];
    
    
}

- (void) leftloginNotification:(NSNotification *) notification{
    
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
    
    [self createNav];
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 290)];
    backView.backgroundColor=[UIColor colorWithRed:0.99 green:0.37 blue:0.34 alpha:1];
    [mainScrollView addSubview:backView];
    
    UILabel *zichanLabel=[[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth-100)/2, 35, 100, 15)];
    zichanLabel.textColor=[UIColor whiteColor];
    zichanLabel.text=@"总资产（元）";
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
    
    NSArray *infoTitleArr=[[NSArray alloc]initWithObjects:@"今日最新收益（元）",@"总收益（元）", nil];
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
    
    NSArray *btnTitleArr=[NSArray arrayWithObjects:@"智信宝",@"我的理财",@"我的关系赢",@"我的众筹",@"我的信用金银行",@"我的交易单", nil];
    NSArray *btnImageArr=[NSArray arrayWithObjects:@"me_01.png",@"me_02.png",@"me_03.png",@"me_04.png",@"me_05.png",@"me_06.png", nil];
    
    
    for(int i=0;i<6;i++)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 290+10+47*i, KProjectScreenWidth, 47)];
        [btn setBackgroundImage:createImageWithColor([UIColor whiteColor]) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=KBtnTag+i;
        [self.mainScrollView addSubview:btn];
        
        UIImageView *btnImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 25, 25)];
        btnImage.image=[UIImage imageNamed:btnImageArr[i]];
        [btn addSubview:btnImage];
        
        UILabel *btnTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 11, KProjectScreenWidth-60, 25)];
        btnTitleLable.font = [UIFont systemFontOfSize:16.0f];
        [btnTitleLable setTextColor:KContentTextColor];
        [btnTitleLable setBackgroundColor:[UIColor clearColor]];
        btnTitleLable.text=btnTitleArr[i];
        [btn addSubview:btnTitleLable];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(40, 46.5f, KProjectScreenWidth-40, 0.5f)];
        lineView.backgroundColor=KSepLineColorSetup;
        [btn addSubview:lineView];
        
        UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-25, 16.5, 10, 14)];
        arrowImage.image=[UIImage imageNamed:@"More_CellArrow.png"];
        [btn addSubview:arrowImage];
        
    }

}


- (void)createNav
{
    [self initWithHeaderNavigationLeftButton];
    [self initWithHeaderNavigationRightButton];
}
#pragma mark -
#pragma mark - 初始化左侧可编辑按键
- (void)initWithHeaderNavigationLeftButton{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 30, 30)];
    [btn setBackgroundImage:createImageWithColor([UIColor whiteColor]) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barItem;
}

#pragma mark -
#pragma mark - 初始化右侧可编辑按键
- (void)initWithHeaderNavigationRightButton{
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 30, 30)];
        [btn setBackgroundImage:createImageWithColor([UIColor whiteColor]) forState:UIControlStateNormal];
        UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
        [self.navigationItem setRightBarButtonItem:barItem];
}
- (void)leftNavBtnClick
{
    ExploreViewController *viewController=[[ExploreViewController alloc]init];
    viewController.tabbarIndex=FMShareSetting.tabbarSelectIndex;
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)rightNavBtnClick
{
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentModalViewController:navController animated:YES];
        return;
    }
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *url=[NSString stringWithFormat:@"http://p2p.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/chongzhiweb?user_id=%@&appid=jiekuan&shijian=%d&token=%@",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"提现" AndWithShareUrl:url];
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}

- (void)btnClick:(UIButton *)btn
{
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentModalViewController:navController animated:YES];
        return;
    }
    
    NSInteger index=btn.tag-KBtnTag;
    
    if (index==0) {
        
        ZhiXinBaoController *viewController=[[ZhiXinBaoController alloc]init];
        viewController.tabbarIndex=FMShareSetting.tabbarSelectIndex;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    
    else if (index==1){
        
    }
    else if (index==2){
        
    }
    else if (index==3){
        
    }
    else if (index==4){
        
    }
    else if (index==5){
        
    }
}

@end
