//
//  ExploreViewController.m
//  fmapp
//
//  Created by 李 喻辉 on 14-5-11.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "ExploreViewController.h"
#import "SelfButton.h"
#import "SafetySetController.h"
#import "AboutViewController.h"
#import "UMFeedback.h"
#import "GesturerViewController.h"
#import "StationLettersController.h"
#import "ShareViewController.h"
#import "CurrentUserInformation.h"
#import "LoginController.h"
#import "UMSocial.h"
#import "BorrowViewController.h"
#import "FeedbackViewController.h"
#import "LocalDataManagement.h"
#import "MobClick.h"

#define KLeftWidth      0
#define KBtnHeight      47
#define KBtnTag         10000

@interface ExploreViewController ()<UIScrollViewDelegate,UMSocialUIDelegate,UIActionSheetDelegate>
@property (nonatomic,weak)UIButton  *loginOrLoginOutBtn;

@end

@implementation ExploreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //初始化主题模式
    }
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        self.enableCustomNavbarBackButton=TRUE;
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
    
    [self settingNavTitle:@"更多"];

    [self settingContentView];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(leftloginNotification:)
                                                 name: FMUserLoginNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(leftloginOutNotification:)
                                                 name: FMUserLogoutNotification
                                               object: nil];
   	
}
-(void)settingContentView
{
    //滚动视图
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+260);
    if(KProjectScreenHeight>568)
    {
        mainScrollView.contentSize = CGSizeMake(KProjectScreenWidth, mainScrollView.frame.size.height+50);
    }
    [self.view addSubview:mainScrollView];
    
    //我要借款
    SelfButton *loanbtn=[[SelfButton alloc]initWithImageStr:@"more_01.png" AndWithTitle:@"我要借款" AndWithBtnTag:KBtnTag];
    [loanbtn setFrame:CGRectMake(KLeftWidth, 10, KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
    [loanbtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:loanbtn];
    
    //手势密码
    SelfButton *gesturebtn=[[SelfButton alloc]initWithImageStr:@"more_02.png" AndWithTitle:@"手势密码" AndWithBtnTag:KBtnTag+1];
    [gesturebtn setFrame:CGRectMake(KLeftWidth,loanbtn.frame.origin.y+KBtnHeight+10, KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
    [gesturebtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:gesturebtn];
    
    //安全设置
    SelfButton *safeSetBtn=[[SelfButton alloc]initWithImageStr:@"more_03.png" AndWithTitle:@"安全设置" AndWithBtnTag:KBtnTag+2];
    [safeSetBtn setFrame:CGRectMake(KLeftWidth,gesturebtn.frame.origin.y+KBtnHeight+0.5f, KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
    [safeSetBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:safeSetBtn];
    
    //第三部分
    NSArray *thirdImageArr=[[NSArray alloc]initWithObjects:@"more_04.png",@"more_05.png",@"more_06.png",@"more_07.png", nil];
    NSArray *thirdtitleArr=[[NSArray alloc]initWithObjects:@"站内信",@"关于我们",@"帮助中心",@"客服电话", nil];
    for(int i=0;i<4;i++)
    {
        SelfButton *thirdBtn=[[SelfButton alloc]initWithImageStr:thirdImageArr[i] AndWithTitle:thirdtitleArr[i] AndWithBtnTag:KBtnTag+3+i];
        [thirdBtn setFrame:CGRectMake(KLeftWidth,safeSetBtn.frame.origin.y+KBtnHeight+10+(KBtnHeight+0.5f)*i, KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
        [thirdBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [mainScrollView addSubview:thirdBtn];
 
    }

    //第三部分
    NSArray *forthImageArr=[[NSArray alloc]initWithObjects:@"more_08.png",@"more_09.png",@"more_10.png", nil];
    NSArray *forthTitleArr=[[NSArray alloc]initWithObjects:@"意见反馈",@"推荐给好友", nil];
    for(int i=0;i<2;i++)
    {
        SelfButton *thirdBtn=[[SelfButton alloc]initWithImageStr:forthImageArr[i] AndWithTitle:forthTitleArr[i] AndWithBtnTag:KBtnTag+7+i];
        [thirdBtn setFrame:CGRectMake(KLeftWidth,safeSetBtn.frame.origin.y+KBtnHeight+20+(KBtnHeight+0.5f)*(4+i), KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
        [thirdBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [mainScrollView addSubview:thirdBtn];
        
    }
    UIButton *personalLogoOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    personalLogoOutButton.tag = KBtnTag+10;
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                                     forState:UIControlStateNormal];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                                     forState:UIControlStateHighlighted];
    [personalLogoOutButton addTarget:self
                              action:@selector(userLoginOut:)
                    forControlEvents:UIControlEventTouchUpInside];
    personalLogoOutButton.titleLabel.font=[UIFont boldSystemFontOfSize:16.0];
    if ([[CurrentUserInformation sharedCurrentUserInfo] userLoginState] == 0) {//未登录
        [personalLogoOutButton setTitle:@"登  录"
                               forState:UIControlStateNormal];
        
    }
    else
    {
    [personalLogoOutButton setTitle:@"退出登录"
                               forState:UIControlStateNormal];
    }
    [personalLogoOutButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    [personalLogoOutButton setFrame:CGRectMake(20.0f, 540.0f, KProjectScreenWidth-40, 43.0f)];
    [personalLogoOutButton.layer setBorderWidth:0.5f];
    [personalLogoOutButton.layer setCornerRadius:5.0f];
    [personalLogoOutButton.layer setMasksToBounds:YES];
    [personalLogoOutButton setBackgroundColor:KDefaultOrNightBackGroundColor];
    [personalLogoOutButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    self.loginOrLoginOutBtn=personalLogoOutButton;
    [mainScrollView addSubview:personalLogoOutButton];

    
}
- (void)userLoginOut:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"退出登录"]) {
        
        UIActionSheet *loginOutActionSheet = [[UIActionSheet alloc] initWithTitle:@"你确定退出本次登录吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
        [loginOutActionSheet showInView:self.view.window];

    }
    else
    {
        //注册控制器
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentModalViewController:navController animated:YES];
        
        return;
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        
        [[CurrentUserInformation sharedCurrentUserInfo] setUserLoginState:0];//设置用户为未登录状态
        //移除本地文件
        LocalDataManagement *dataManagement=[[LocalDataManagement alloc] init];
        ////移除用户登录文件
        NSString *userLoginInfoPathString=[dataManagement getUserFilePathWithUserFileType:CYHUserLoginInfoFile];;
        [[NSFileManager defaultManager] removeItemAtPath:userLoginInfoPathString error:nil];
        ////移除用户详情文件
        NSString *userDetailInfoPathString = [dataManagement getUserFilePathWithUserFileType:CYHUserDetailInfoFile];
        [[NSFileManager defaultManager] removeItemAtPath:userDetailInfoPathString error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:FMUserLogoutNotification object:nil];//触发退出登录通知
    }
}
- (void) leftloginNotification:(NSNotification *) notification{
    
    [self.loginOrLoginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    
}
- (void) leftloginOutNotification:(NSNotification *) notification{
    
    [self.loginOrLoginOutBtn setTitle:@"登  录" forState:UIControlStateNormal];
    
}

#pragma mark -
#pragma mark - 初始化按钮点击时事件
- (void)buttonClicked:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentModalViewController:navController animated:YES];
        return;
    }

    if (button.tag==KBtnTag) {
        BorrowViewController *viewController=[[BorrowViewController alloc]init];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (button.tag==KBtnTag+1)
    {
        GesturerViewController *viewController=[[GesturerViewController alloc]init];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (button.tag==KBtnTag+2)
    {
        SafetySetController *viewController=[[SafetySetController alloc]initWithButtonStyle:SafetySetupStyle];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (button.tag==KBtnTag+3)
    {
        
        if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState == 0) {
            //登陆控制器
            LoginController *loginController = [[LoginController alloc] init];
            FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:loginController];
            [self presentModalViewController:navController animated:YES];
            return;
        }

        StationLettersController *viewController=[[StationLettersController alloc]init];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (button.tag==KBtnTag+4)
    {
        AboutViewController *viewController=[[AboutViewController alloc]init];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }

    else if (button.tag==KBtnTag+5)
    {
        
        ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"帮助中心" AndWithShareUrl:[NSString stringWithFormat:@"%@%@",kBaseAPIURL,@"Helpzhongxin/indexweb"]];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (button.tag==KBtnTag+6)
    {
        NSString *telNum=@"telprompt://400-878-8686";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum]];

    }
    else if (button.tag==KBtnTag+7)
    {
//        [self presentModalViewController:[UMFeedback feedbackModalViewController]
//                                animated:YES];
        FeedbackViewController *viewController=[[FeedbackViewController alloc]init];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];


    }
    else if (button.tag==KBtnTag+8)
    {
        
        NSString *shareUrl=@"http://ww.rongtuojinrong.com/login/appindex";
        [UMSocialData defaultData].extConfig.wechatSessionData.url =shareUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url =shareUrl;
        [UMSocialData defaultData].extConfig.qqData.url =shareUrl;
        [UMSocialData defaultData].extConfig.qzoneData.url =shareUrl;
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:kUmengKey
                                          shareText:@"融汇天下资本,托起财富梦想!"
                                         shareImage:[UIImage imageNamed:@"icon.png"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToTencent,UMShareToSina,UMShareToEmail,UMShareToDouban,nil]
                                           delegate:self];

        
    }
    else if (button.tag==KBtnTag+9)
    {
        [MobClick checkUpdate];//检查更新
        
    }

}
@end