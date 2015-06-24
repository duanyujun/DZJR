//
//  LoginController.m
//  fmapp
//
//  Created by 张利广 on 14-5-14.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "LoginController.h"
#import "OpenUDID.h"
#import "HTTPClient.h"
#import "HUILoadMoreCell.h"
#import "LocalDataManagement.h"
#import "CurrentUserInformation.h"
#import "RegisterController.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "JSONKit.h"
#import "PhoneNumberController.h"
#import "AppDelegate.h"
#import "FMSettings.h"

#define kLoginButtonTag 1630114                 //登录操作按键
#define KForgetPasswordButtonTag 1630115        //找回密码操作按键
#define KUserGotoRegisterButtonTag 1630119      //注册信息新用户按键
#define KUserPersonalNameTextTag 1630116        //用户名输入框
#define KUserPersonalPWdTextTag 1630117         //用户密码输入框


@interface LoginController ()

/*!
 *@breif 数据通信设置
 */
@property (nonatomic, weak) AFHTTPRequestOperation      *requestDataOperation;
/*!
 *@breif 用户个人昵称
 */
@property (nonatomic , weak)UITextField                 *userNameTextField;
/*!
 *@breif 用户个人密码
 */
@property (nonatomic , weak)UITextField                 *userPasswordTextField;

@end

@implementation LoginController

- (id)init{
    self = [super init];
    if (self) {
        self.enableCustomNavbarBackButton = FALSE;
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
    [self settingNavTitle:@"登录"];
    [self initWithLoginControllerFrame];
    
    NSString *string = [OpenUDID value];
    Log(@"string is %@ ",string);
    
    [self setLeftNavButtonFA:FMIconLeftArrow
                   withFrame:kNavButtonRect
                actionTarget:self
                      action:@selector(navigationBarCancelItemClicked:)];
}
- (void)navigationBarCancelItemClicked:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化登录界面框架内容
- (void)initWithLoginControllerFrame{
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    
    //手机号/用户名
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 20.0f,self.view.bounds.size.width-20, 94.5f)];
    if (ThemeCategory==5) {
        backGroundView.alpha=0.6;
    }
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.layer.borderWidth = 0.5f;
    backGroundView.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    ////指示图片
    UIImageView *userNameIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login.png"]];
    [userNameIndicatorImageView setFrame:CGRectMake(20, 12.0f, 23, 23)];
    [backGroundView addSubview:userNameIndicatorImageView];
    ////文本框
    UITextField *userNameText = [[UITextField alloc] initWithFrame:CGRectMake(60.0f, 1.0f, KProjectScreenWidth-30-60, 45.0f)];
    [userNameText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [userNameText setReturnKeyType:UIReturnKeyNext];
    [userNameText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [userNameText setFont:[UIFont systemFontOfSize:18.0f]];
    [userNameText setBorderStyle:UITextBorderStyleNone];
    [userNameText setPlaceholder:@"用户名"];
    userNameText.tag=KUserPersonalNameTextTag;
    [userNameText setDelegate:self];
    [userNameText becomeFirstResponder];
    self.userNameTextField=userNameText;
    [backGroundView addSubview:userNameText];
    
    ////分割线
    UIView *sectionSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(20, 47.5, self.view.bounds.size.width-20.0f, 0.5f)];
    sectionSeperatorView.backgroundColor = KDefaultOrNightSepratorColor;
    [backGroundView addSubview:sectionSeperatorView];
    //密码
    ////指示图片
    UIImageView *passwordIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secret.png"]];
    [passwordIndicatorImageView setFrame:CGRectMake(20, 59.5, 18, 23)];
    [backGroundView addSubview:passwordIndicatorImageView];
    ////文本框
    UITextField *passwordText= [[UITextField alloc] initWithFrame:CGRectMake(60.0f, 48.5, KProjectScreenWidth-30-60, 45.0f)];
    [passwordText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [passwordText setReturnKeyType:UIReturnKeyGo];
    [passwordText setPlaceholder:@"密码"];
    passwordText.tag=KUserPersonalPWdTextTag;
    [passwordText setDelegate:self];
    [passwordText setFont:KContentLeftTitleFontOfSize];
    [passwordText setKeyboardType:UIKeyboardTypeAlphabet];
    [passwordText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [passwordText setBorderStyle:UITextBorderStyleNone];
    [passwordText setSecureTextEntry:YES];
    self.userPasswordTextField=passwordText;
    [backGroundView addSubview:passwordText];
    
    [mainScrollView addSubview:backGroundView];
    
    
    ///退出登录
    UIButton *personalLogoOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                                     forState:UIControlStateNormal];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                                     forState:UIControlStateHighlighted];
    
//    if ([[CurrentUserInformation sharedCurrentUserInfo] userLoginState] == 0) {//未登录
        [personalLogoOutButton setTitle:@"登  录"
                               forState:UIControlStateNormal];
        
//    }
//    else
//    {
//        [personalLogoOutButton setTitle:@"退出登录"
//                               forState:UIControlStateNormal];
//    }
    [personalLogoOutButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    [personalLogoOutButton setFrame:CGRectMake(20.0f, 145.0f, KProjectScreenWidth-40, 43.0f)];
    [personalLogoOutButton.layer setBorderWidth:0.5f];
    [personalLogoOutButton.layer setCornerRadius:5.0f];
    [personalLogoOutButton.layer setMasksToBounds:YES];
    personalLogoOutButton.tag=kLoginButtonTag;
    [personalLogoOutButton setBackgroundColor:KDefaultOrNightBackGroundColor];
    [personalLogoOutButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [personalLogoOutButton addTarget:self action:@selector(initWithUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:personalLogoOutButton];

    
    [self.view addSubview:mainScrollView];
    
    //忘记密码
    UIButton *forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPasswordButton.tag = KForgetPasswordButtonTag;
    //    [forgetPasswordButton setFrame:CGRectMake(79.75*widthScale, 150.0f+ (HUIIsIPhone5() ?+80.0f:0.0f), 70, 20.0f)];
    [forgetPasswordButton setFrame:CGRectMake((KProjectScreenWidth-160)/2, 230, 70, 20.0f)];
    
    [forgetPasswordButton setBackgroundColor:[UIColor clearColor]];
    [forgetPasswordButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [forgetPasswordButton setTitleColor:KSubTitleContentTextColor forState:UIControlStateNormal];
    forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [forgetPasswordButton setBackgroundImage:createImageWithColor([UIColor lightGrayColor]) forState:UIControlStateHighlighted];
    [forgetPasswordButton addTarget:self action:@selector(initWithUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:forgetPasswordButton];
    //忘记密码按钮下划线
    UIView *forgetPasswordButtonUnderLineView = [[UIView alloc] initWithFrame:CGRectMake(22, 188, 66, 1)];
    forgetPasswordButtonUnderLineView.hidden = YES;
    forgetPasswordButtonUnderLineView.backgroundColor = [UIColor blueColor];
    [mainScrollView addSubview:forgetPasswordButtonUnderLineView];
    
    UIView          *sectionView =[[UIView alloc]initWithFrame:CGRectMake(forgetPasswordButton.frame.origin.x+80, 225, 0.5, 30.0f)];
    [sectionView setBackgroundColor:[UIColor grayColor]];
    [mainScrollView addSubview:sectionView];
    
    
    //登录按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.tag = KUserGotoRegisterButtonTag;
    [loginButton setFrame:CGRectMake(forgetPasswordButton.frame.origin.x+90, 230, 70, 20.0f)];
    [loginButton setBackgroundColor:[UIColor clearColor]];
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f,70.0f, 20.0f)];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    loginLabel.font = [UIFont systemFontOfSize:16.0f];
    [loginLabel setBackgroundColor:[UIColor clearColor]];
    [loginLabel setTextColor:KContentTextCanEditColor];
    [loginLabel setText:@"会员注册"];
    [loginButton addSubview:loginLabel];
    [loginButton setBackgroundImage:createImageWithColor([UIColor clearColor])
                           forState:UIControlStateNormal];
    [loginButton setBackgroundImage:createImageWithColor([UIColor lightGrayColor])
                           forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(initWithUserButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:loginButton];
    
    [self.view addSubview:mainScrollView];

    
    
    LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
    if ([dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]) {//用户登录文件存在
        //用户登录字典
        NSDictionary *userLoginDic = [[NSDictionary alloc] initWithDictionary:[dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]];
        NSString *userName = [NSString stringWithFormat:@"%@",[userLoginDic objectForKey:@"UserName"]];//用户名
        NSString *password = [NSString stringWithFormat:@"%@",[userLoginDic objectForKey:@"Password"]];//密码
        
        
        if (!IsStringEmptyOrNull(userName)) {
            [self.userNameTextField setText:userName];
        }
        
        if (!IsStringEmptyOrNull(password)) {
            [self.userPasswordTextField setText:password];
        }
        
    }
}
#pragma mark - 初始化用户按键事件
- (void)initWithUserButtonClicked:(id)sender{
    UIButton    *button = (UIButton *)sender;

    if (button.tag == kLoginButtonTag) {
        ///初始化用户登录请求
        [self initWithRequestUserLogoInformation];
    }
    
    ///用户忘记密码处理
    else if (button.tag == KForgetPasswordButtonTag){
        PhoneNumberController *viewController = [[PhoneNumberController alloc]initWithUserOperationStyle:UserFindPasswordStyle];

        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    ///用户进行新用户注册
    else if (button.tag == KUserGotoRegisterButtonTag){
        
        PhoneNumberController *viewController = [[PhoneNumberController alloc]initWithUserOperationStyle:UserRegisterOperationStyle];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
#pragma mark - 初始化用户登录请求
- (void)initWithRequestUserLogoInformation{
    
    ///判断用户名是否已编辑
    if (IsStringEmptyOrNull(self.userNameTextField.text)) {
        ShowImportErrorAlertView(@"请输入用户名");
        return;
    }
    ///判断密码是否已编辑
    if (IsStringEmptyOrNull(self.userPasswordTextField.text)) {
        ShowImportErrorAlertView(@"请输入密码");
        return;
    }
    WaittingMBProgressHUD(HUIKeyWindow, @"登录中...");
    __weak __typeof(&*self)weakSelf = self;
    self.requestDataOperation=[FMHTTPClient getUserLoginInforWithUser:self.userNameTextField.text withUserPassword:self.userPasswordTextField.text completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            Log(@"%@",response.responseObject);
            if (response.code==WebAPIResponseCodeSuccess) {
                
                SuccessMBProgressHUD(HUIKeyWindow, @"登录成功");
               [CurrentUserInformation initializaionUserInformation:[response.responseObject objectForKey:@"data"]];
                NSDictionary *userLoginDic = nil;
                userLoginDic = [[NSDictionary alloc] initWithObjectsAndKeys:weakSelf.userNameTextField.text,@"UserName",weakSelf.userPasswordTextField.text,@"Password",nil];
                LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
                [dataManagement writeUserDataToFileWithDictionary:userLoginDic andUserDataType:CYHUserLoginInfoFile];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:FMUserLoginNotification
                                                                    object:nil];//触发登录通知
                [self.navigationController dismissModalViewControllerAnimated:NO];
                
                [LLLockPassword saveLockPassword:nil];
                FMShareSetting.agreeGestures=YES;
                [ShareAppDelegate showLockView];
                
            }
            else
            {
                FailedMBProgressHUD(HUIKeyWindow, @"登录失败");
                ShowImportErrorAlertView(StringForKeyInUnserializedJSONDic(response.responseObject, @"msg"));
            }
        });
    }];
    
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    ///若点击的是用户名的下一步，则输入密码
    if (textField.tag == KUserPersonalNameTextTag) {
        [self.userPasswordTextField becomeFirstResponder];
    }
    else if (textField.tag == KUserPersonalPWdTextTag){
        //初始化用户登录请求
        [self initWithRequestUserLogoInformation];
        
    }
    return YES;
}

@end
