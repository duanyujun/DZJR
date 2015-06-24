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
#import "AboutController.h"
#import "CurrentUserInformation.h"
#import "UserPhoneViewController.h"

#define KLeftWidth      0
#define KBtnHeight      47
#define KBtnTag         10000
#define KUserCameraButtonTag 111020                                 //用户头像操作按键
#define KUserAddPhototActionSheetTag 111032                         ///用户上传头像选择设置

@interface ExploreViewController ()<UIScrollViewDelegate,UMSocialUIDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,weak)UIButton  *loginOrLoginOutBtn;
@property (nonatomic , weak)        UIImageView                     *cameraButtonImageView;

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
    
    
    //一、用户基本信息视图
    UIView *userBasicInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, 60)];
    userBasicInfoView.layer.borderWidth = 0.5f;
    [userBasicInfoView setBackgroundColor:[UIColor whiteColor]];
    userBasicInfoView.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    
    ///头像内容
    UILabel *headerPiclabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 25.0f, 40.0f, 20.0f)];
    [headerPiclabel setText:@"头像"];
    [headerPiclabel setTextColor:KDefaultOrNightTextColor];
    [headerPiclabel setTextAlignment:NSTextAlignmentLeft];
    [headerPiclabel setBackgroundColor:[UIColor clearColor]];
    [headerPiclabel setFont:[UIFont systemFontOfSize:16.0f]];
    [userBasicInfoView addSubview:headerPiclabel];
    
    UIButton    *cameraButton = [[UIButton alloc]init];
    [cameraButton setFrame:CGRectMake(KProjectScreenWidth-30-46, 10.0f, 46.0f, 46.0f)];
    [cameraButton setTag:KUserCameraButtonTag];
    
    UIImageView *cameraButtonImage = [[UIImageView alloc]init];
    [cameraButtonImage setFrame:CGRectMake(0.0f,0.0f, 46.0f, 46.0f)];
    [cameraButtonImage setImage:kImgDefaultCar];
    self.cameraButtonImageView = cameraButtonImage;
    [cameraButton addSubview:self.cameraButtonImageView];
    [cameraButton addTarget:self action:@selector(initWIthUserOperationButtonEvent:)
           forControlEvents:UIControlEventTouchUpInside];
    [userBasicInfoView addSubview:cameraButton];
    
    ////分割线
    //    UIView *firstSectionSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(20, 70.0f, KProjectScreenWidth-20, 0.5f)];
    //    firstSectionSeperatorView.backgroundColor = KDefaultOrNightSepratorColor;
    //    [userBasicInfoView addSubview:firstSectionSeperatorView];
    [mainScrollView addSubview:userBasicInfoView];
 
    
    //实名认证
    SelfButton *loanbtn=[[SelfButton alloc]initWithTitle:@"实名认证" AndWithBtnTag:KBtnTag];
    [loanbtn setFrame:CGRectMake(KLeftWidth, 80, KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
    [loanbtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:loanbtn];
    
    if ([CurrentUserInformation sharedCurrentUserInfo].shiming==1) {
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-160-8, 8.5, 140, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=NSTextAlignmentRight;
        label.text=@"已认证";
        label.textColor=KSubTitleContentTextColor;
        label.font=[UIFont systemFontOfSize:15.0f];
        [loanbtn addSubview:label];
    }
    else
    {
        UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-25, 16.5, 10, 14)];
        arrowImage.image=[UIImage imageNamed:@"More_CellArrow.png"];
        [loanbtn addSubview:arrowImage];
    }

    
    //绑定手机
    SelfButton *gesturebtn=[[SelfButton alloc]initWithTitle:@"绑定手机" AndWithBtnTag:KBtnTag+1];
    [gesturebtn setFrame:CGRectMake(KLeftWidth,loanbtn.frame.origin.y+KBtnHeight+0.5f,KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
    [gesturebtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:gesturebtn];
    
    //支付密码
    SelfButton *safeSetBtn=[[SelfButton alloc]initWithTitle:@"支付密码" AndWithBtnTag:KBtnTag+2];
    [safeSetBtn setFrame:CGRectMake(KLeftWidth,gesturebtn.frame.origin.y+KBtnHeight+0.5f, KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
    [safeSetBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:safeSetBtn];
    
    //手势密码
    SelfButton *shoushiSetBtn=[[SelfButton alloc]initWithTitle:@"修改手势密码" AndWithBtnTag:KBtnTag+3];
    [shoushiSetBtn setFrame:CGRectMake(KLeftWidth,safeSetBtn.frame.origin.y+KBtnHeight+0.5f, KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
    [shoushiSetBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:shoushiSetBtn];

    
    //第三部分
    NSArray *forthTitleArr=[[NSArray alloc]initWithObjects:@"客服电话",@"推荐给好友",@"关于", nil];
    for(int i=0;i<3;i++)
    {
        SelfButton *thirdBtn=[[SelfButton alloc]initWithTitle:forthTitleArr[i] AndWithBtnTag:KBtnTag+4+i];
        [thirdBtn setFrame:CGRectMake(KLeftWidth,shoushiSetBtn.frame.origin.y+KBtnHeight+20+(KBtnHeight+0.5f)*i, KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
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

    
    if (actionSheet.tag == KUserAddPhototActionSheetTag) {
        
        ///若不是取消
        if (buttonIndex != 2) {
            //选择照片
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            [imagePickerController.view setTag:KUserCameraButtonTag];
            if(buttonIndex == 0){//拍照
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = YES;
                imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            }else if(buttonIndex == 1){//相册
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.allowsEditing = YES;
            }
            
            [self presentModalViewController:imagePickerController animated:YES];
        }
    }
   else
   {
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
}

#pragma mark -
#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    @autoreleasepool {
        UIImage *imageinfo = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        CGSize imageSize = imageinfo.size;
        
        CGFloat imageHeight = imageSize.height * 640 /imageSize.width;
        imageSize.width = 640;
        imageSize.height = imageHeight;
        
        UIGraphicsBeginImageContext(imageSize);
        [imageinfo drawInRect: CGRectMake(0, 0, imageSize.width,imageSize.height)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.cameraButtonImageView setImage:smallImage];
        
        [[UIApplication sharedApplication] setStatusBarStyle:[FMThemeManager.skin statusbarStyle]];
        [picker dismissModalViewControllerAnimated:YES];
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;//保存按钮可用
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
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
        
        if ([CurrentUserInformation sharedCurrentUserInfo].shiming==1) {
            
            ShowImportErrorAlertView(@"您已通过实名认证");
        }
        else
        {
            ///
            NSString *url=[NSString stringWithFormat:@"%@Usercenter/kaihu?user_id=%@",kBaseAPIURL,[CurrentUserInformation sharedCurrentUserInfo].userId];
            ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"实名认证" AndWithShareUrl:url];
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
  
    }
    else if (button.tag==KBtnTag+1)
    {
        UserPhoneViewController *viewController=[[UserPhoneViewController alloc]init];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];

    }
    else if (button.tag==KBtnTag+2)
    {
    }
    else if (button.tag==KBtnTag+3)
    {
        
        GesturerViewController *viewController=[[GesturerViewController alloc]init];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (button.tag==KBtnTag+4)
    {
        NSString *telNum=@"telprompt://400-878-8686";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum]];

    }

    else if (button.tag==KBtnTag+5)
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
    else if (button.tag==KBtnTag+6)
    {
        AboutController *viewController=[[AboutController alloc]init];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }

}
#pragma mark -
#pragma mark - 初始化用户个人信息界面操作按键事件
- (void)initWIthUserOperationButtonEvent:(id)sender{

    UIButton *button = (UIButton *)sender;

    if (button.tag == KUserCameraButtonTag) {
        
        UIActionSheet   *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self
                                                         cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [actionSheet setTag:KUserAddPhototActionSheetTag];
        [actionSheet showInView:self.view];
        
        
    }
    
}
@end