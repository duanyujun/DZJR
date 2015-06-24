//
//  AppDelegate.m
//  fmapp
//
//  Created by 李 喻辉 on 14-5-5.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#define KAdBgImageViewTag 198011        ///广告背景图
#define APP_KEY @"3Qon0WQ5Wz1RSmX2wpjR17Zt"

#import "AppDelegate.h"
#import "OpenUDID.h"
#import "HTTPClient.h"
#import "MeViewController.h"
#import "FMTabBarController.h"
#import "LocalDataManagement.h"
#import "CurrentUserInformation.h"
#import "InteractionViewController.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "ExploreViewController.h"
#import "UMFeedback.h"
#import "UMOpus.h"
#import "FMSettings.h"
#import "FMImageView.h"
#import "FontAwesome.h"
#import "LoginController.h"
#import "GesturerViewController.h"

#import "MobClick.h"
#import "AttributedStringHelper.h"
#import <AudioToolbox/AudioToolbox.h>
#import "RoadMainViewController.h"
#import "JSONKit.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"

#import "APService.h"


#define SUPPORT_IOS8 1


@interface AppDelegate () <UITabBarControllerDelegate>

@property (nonatomic,assign) NSInteger              lastTabIndex;
@property (nonatomic,weak)  FMTabBarController      *tabBar;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    self.gestureBool=YES;
    
    FMShareSetting.tabbarSelectIndex=0;
    
    [MobClick startWithAppkey:kUmengKey];//AppStore
    [UMFeedback setAppkey:kUmengKey];
    [UMOpus setAudioEnable:YES];
//        [MobClick startWithAppkey:kUmengKey reportPolicy:REALTIME channelId:@"91AppsStore"]; //91手机助手
    [MobClick checkUpdate];//检查更新
    [MobClick setLogEnabled:NO];//是否打印Log
    
    [UMSocialData setAppKey:kUmengKey];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:kWeiXinKey appSecret:KWeiXinAPPSecretKey url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"1103554971" appKey:@"qFCyaFUHqVPTa8Fu" url:@"http://www.umeng.com/social"];

    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_8_0)){
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }  else {
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        }
    }
    else{
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }

    //判是不是断程序由推送服务完成的
    if (launchOptions) {
        NSDictionary *pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
//            NSDictionary *pushDic = [[NSDictionary alloc]initWithDictionary: [pushNotificationKey objectForKey:@"aps"]];
            [self dealAppNotification:pushNotificationKey];
        }
    }
    ////根据用户名和密码进行自动登录
    [self initWithUserAutoLogin];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    
//    [self setTabRootControl];
    
//    if (FMShareSetting.openGuideView) {
//    
//        [self createGuideScrollView];
//    }
//    else
//    {
        [self setTabRootControl];
//    }
    
//    [FMThemeManager applySkin:[FMThemeManager createSkinById:FMShareSetting.appProgramPersonalityThemeIndexInteger]];
    
    if (HUISystemVersionBelow(kHUISystemVersion_7_0)) {
        self.window.backgroundColor = [UIColor whiteColor];
    }else{
        self.window.backgroundColor = [UIColor clearColor];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(leftloginOutNotification:)
                                                 name: FMUserLogoutNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(manageGestureNotification:)
                                                 name: FMManageGestureNotification
                                               object: nil];

    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)createGuideScrollView
{
    
    
    CGRect rect=[[UIScreen mainScreen] bounds];
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:rect];
    scroll.backgroundColor=[UIColor clearColor];
    scroll.contentSize=CGSizeMake(rect.size.width*4, rect.size.height);
    scroll.pagingEnabled=YES;
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.showsVerticalScrollIndicator=NO;
    [self.window addSubview:scroll];
    
    
    NSArray *arr=[[NSArray alloc]initWithObjects:@"guide1.jpg",@"guide2.jpg",@"guide3.jpg",@"guide4.jpg", nil];
    for(int i=0;i<4;i++)
    {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(rect.size.width*i, 0, rect.size.width, rect.size.height)];
        image.image=[UIImage imageNamed:arr[i]];
        image.userInteractionEnabled=YES;
        [scroll addSubview:image];
        
        if (i==3) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(38, KProjectScreenHeight-240, KProjectScreenWidth-76, 60)];
            if(KProjectScreenHeight<=480)
            {
                [btn setFrame:CGRectMake(38, KProjectScreenHeight-180, KProjectScreenWidth-76, 60)];
            }
            btn.backgroundColor=[UIColor colorWithRed:0.91 green:0.32 blue:0.12 alpha:1];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:@"马上开启财富之旅" forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont boldSystemFontOfSize:25.0f];
            [btn addTarget:self action:@selector(setTabRootControl) forControlEvents:UIControlEventTouchUpInside];
            [image addSubview:btn];
        }

    }

}


- (void) leftloginOutNotification:(NSNotification *) notification{

    LoginController *registerController = [[LoginController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:registerController];
    [self.window.rootViewController presentModalViewController:navController animated:NO];
    return;
  
}
- (void)manageGestureNotification:(NSNotification *)notification
{
    GesturerViewController *registerController = [[GesturerViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:registerController];
    registerController.enterStyleForPush=NO;
    [self.window.rootViewController presentModalViewController:navController animated:NO];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (void)initWithUserAutoLogin{

    LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
    if ([dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]) {//用户登录文件存在
        //用户登录字典
        NSDictionary *userLoginDic = [[NSDictionary alloc] initWithDictionary:[dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]];
        NSString *userName = [NSString stringWithFormat:@"%@",[userLoginDic objectForKey:@"UserName"]];//用户名
        NSString *password = [NSString stringWithFormat:@"%@",[userLoginDic objectForKey:@"Password"]];//密码
        
        [FMHTTPClient getUserLoginInforWithUser:userName withUserPassword:password completion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(response.code == WebAPIResponseCodeSuccess){
                    //初始化登录信息
                    [CurrentUserInformation initializaionUserInformation:[response.responseObject objectForKey:@"data"]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:FMUserLoginNotification
                                                                        object:nil];//触发登录通知
                    
                    [self showLockView];
                    
                }
            });
        }];
        
    }
}
#pragma mark - 弹出手势解锁密码输入框
- (void)showLLLockViewController:(LLLockViewType)type
{
    if(self.window.rootViewController.presentingViewController == nil){
        
        LLLog(@"root = %@", self.window.rootViewController.class);
        LLLog(@"lockVc isBeingPresented = %d", [self.lockVc isBeingPresented]);
        
        self.lockVc = [[LLLockViewController alloc] init];
        self.lockVc.nLockViewType = type;
        
        self.lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self.window.rootViewController presentViewController:self.lockVc animated:NO completion:^{
        }];
        LLLog(@"创建了一个pop=%@", self.lockVc);
    }
}

-(void)dealAppNotification:(NSDictionary* )apsDic
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    NSString    *documentString = [NSString stringWithFormat:@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
//    ///所有图片地址内容
//    NSString *carImagesDirectory = [[NSString alloc] initWithFormat:@"%@/Images",documentString];
//    BOOL clearCarImagesSize = [[NSFileManager defaultManager] removeItemAtPath :carImagesDirectory error:nil] ;
    
}

- (void)showLockView
{
    if (FMShareSetting.agreeGestures) {
        // 手势解锁相关
        NSString* pswd = [LLLockPassword loadLockPassword];
        if (pswd) {
            [self showLLLockViewController:LLLockViewTypeCheck];
        } else {
            [self showLLLockViewController:LLLockViewTypeCreate];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //设置状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:[FMThemeManager.skin statusbarStyle]];
    
    [self initWithUserAutoLogin];
    [[NSNotificationCenter defaultCenter] postNotificationName:FMEnterForegroundNotificationn object:nil];
    
    
//    [self BackgroundAutoLogin];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

 - (void)setTabRootControl
 {
     
     FMShareSetting.openGuideView=NO;
     NSMutableArray *controllersArray = [[NSMutableArray alloc] init];//控制器数组
     //路况
     RoadMainViewController *roadConditionController = [[RoadMainViewController alloc] init];
     roadConditionController.tabbarIndex=0;
     UINavigationController *roadConditionNavController = [[FMNavigationController alloc] initWithRootViewController:roadConditionController];
     [controllersArray addObject:roadConditionNavController];
     
     //互动
     InteractionViewController *interactionController = [[InteractionViewController alloc] init];
     interactionController.tabbarIndex=1;
     UINavigationController *interactionNavController = [[FMNavigationController alloc] initWithRootViewController:interactionController];
     interactionNavController.navigationBar.translucent = NO;
     [controllersArray addObject:interactionNavController];
     
     //我
     MeViewController *meController = [[MeViewController alloc] init];
     meController.tabbarIndex=2;
     UINavigationController *meNavController = [[FMNavigationController alloc] initWithRootViewController:meController];
     meNavController.navigationBar.translucent = NO;
     [controllersArray addObject:meNavController];

     
//     //探索
//     ExploreViewController *exploreController = [[ExploreViewController alloc] init];
//     UINavigationController *exploreNavController = [[FMNavigationController alloc] initWithRootViewController:exploreController];
//     exploreNavController.navigationBar.translucent = NO;
//     [controllersArray addObject:exploreNavController];


  
 //选项卡控制器
 FMTabBarController *tabBarController = [[FMTabBarController alloc] init];
// self.tabBar=tabBarController;
 [tabBarController setViewControllers:controllersArray];
     

 tabBarController.delegate = self;
 self.window.rootViewController = tabBarController;
 [self setTabRootControlItem];
 self.lastTabIndex = tabBarController.selectedIndex;
 }
#pragma mark -选项卡栏
- (void)setTabRootControlItem
{
    FMTabBarController *tabBarController = (FMTabBarController* )self.window.rootViewController;
    if ([tabBarController.viewControllers count] < 3) {
        return;
    }
    FMNavigationController *roadConditionController = [tabBarController.viewControllers objectAtIndex:0];
    roadConditionController.tabBarItem = [FMTabBarController addButtonWithNormalImage:[FontAwesome imageWithIcon:FMIconBusiness
                                                                                                       iconColor:[FMThemeManager.skin tabBarTitleColor]
                                                                                                        iconSize:kTableBarItemSize]
                                                                        selectedImage:[FontAwesome imageWithIcon:FMIconBusiness
                                                                                                       iconColor:[FMThemeManager.skin tabBarSelectColor]
                                                                                                        iconSize:kTableBarItemSize]
                                                                                title:@"今日"];
    FMNavigationController *interactionController = [tabBarController.viewControllers objectAtIndex:1];
    interactionController.tabBarItem = [FMTabBarController addButtonWithNormalImage:[FontAwesome imageWithIcon:FMIconProject
                                                                                                     iconColor:[FMThemeManager.skin tabBarTitleColor]
                                                                                                      iconSize:kTableBarItemSize]
                                                                      selectedImage:[FontAwesome imageWithIcon:FMIconProject
                                                                                                     iconColor:[FMThemeManager.skin tabBarSelectColor]
                                                                                                      iconSize:kTableBarItemSize]
                                                                              title:@"发现"];
    FMNavigationController *exploreController  =  [tabBarController.viewControllers objectAtIndex:2];
    exploreController.tabBarItem = [FMTabBarController addButtonWithNormalImage:[FontAwesome imageWithIcon:FMIconMe
                                                                                                 iconColor:[FMThemeManager.skin tabBarTitleColor]
                                                                                                  iconSize:kTableBarItemSize]
                                                                  selectedImage:[FontAwesome imageWithIcon:FMIconMe
                                                                                                 iconColor:[FMThemeManager.skin tabBarSelectColor]
                                                                                                  iconSize:kTableBarItemSize]
                                                                          title:@"资产"];
//    FMNavigationController *meNavController  =  [tabBarController.viewControllers objectAtIndex:3];
//    meNavController.tabBarItem = [FMTabBarController addButtonWithNormalImage:[FontAwesome imageWithIcon:FMIconMore
//                                                                                               iconColor:[FMThemeManager.skin tabBarTitleColor]
//                                                                                                iconSize:kTableBarItemSize]
//                                                                selectedImage:[FontAwesome imageWithIcon:FMIconMore
//                                                                                               iconColor:[FMThemeManager.skin tabBarSelectColor]
//                                                                                                iconSize:kTableBarItemSize]
//                                                                        title:@"更多"];
}

 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
 {
     NSInteger selectIndex=tabBarController.selectedIndex;
     FMShareSetting.tabbarSelectIndex=selectIndex;

     if (selectIndex==2) {
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     }
     else
     {
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
     }

 self.lastTabIndex = tabBarController.selectedIndex;
 }
 

#if SUPPORT_IOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif

#pragma mark -注册通知
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
     [APService registerDeviceToken:deviceToken];

}

//获取到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  [APService handleRemoteNotification:userInfo];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
    
    NSDictionary *pushDic = [[NSDictionary alloc] initWithDictionary:[userInfo objectForKey:@"aps"]];
    [self dealAppNotification:pushDic];

}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
@end
