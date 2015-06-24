//
//  SetUpPasswordController.m
//  fmapp
//
//  Created by 张利广 on 14-5-19.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "SetUpPasswordController.h"
#import "HTTPClient+MeModulesSetup.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "CurrentUserInformation.h"
#import "LocalDataManagement.h"
#import "HTTPClient.h"
#import "OpenUDID.h"
#import "FBEncryptorAES.h"

#define KUserFormerPwdTextTag 171001        ///原密码
#define KUserFreshPwdTextTag 171002         ///新密码
#define KUserVerifyPwdTextTag 171003        ///确认密码



@interface SetUpPasswordController ()
///用户原密码
@property (nonatomic , weak)    UITextField             *userPersonalFormerPassWord;
///用户新密码
@property (nonatomic , weak)    UITextField             *userPersonalFreshPassWord;
///用户确认密码
@property (nonatomic , weak)    UITextField             *userPersonalVerifyPassWord;
@property (nonatomic , strong)  AFHTTPRequestOperation  *requestSetupPassword;




/** 在该控制器中初始化界面控件框架内容
 
 *@return void
 **/
- (void) initWithControlFrameAtThisViewController;

/** 用户保存个人新的密码并提交到服务器
 
 *@return void
 **/
- (void) userSaveUserPersonalFreshPassWordAndSubmit;


/** 初始化用户自动登录信息内容
 
 *@return void
 **/
- (void) initWithUserAutoLoginWithNewPassword;
@end

@implementation SetUpPasswordController


- (id) init{
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
    [self settingNavTitle:@"修改密码"];
    //在该控制器中初始化界面控/Users/zhangliguang/Pictures/iPhoto 图库件框架内容
    [self initWithControlFrameAtThisViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - 在该控制器中初始化界面控件框架内容
- (void) initWithControlFrameAtThisViewController{
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    [self.view addSubview:mainScrollView];

    ///第一组：原密码背景图设置
    UIView  *formerPassWordBackGrondView = [[UIView alloc]initWithFrame:CGRectMake(10.0f, 10.0f,
                                                                                   KProjectScreenWidth-20, 47*3+1)];
    [formerPassWordBackGrondView setBackgroundColor:KDefaultOrNightBackGroundColor];
    [formerPassWordBackGrondView.layer setBorderWidth:0.5f];
    [formerPassWordBackGrondView.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [mainScrollView addSubview:formerPassWordBackGrondView];

    ///原密码头部Label
    UILabel *formerPassWordHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 12, 60, 23)];
    [formerPassWordHeaderLabel setText:@"原密码"];
    [formerPassWordHeaderLabel setTextColor:KDefaultOrNightTextColor];
    [formerPassWordHeaderLabel setBackgroundColor:[UIColor clearColor]];
    [formerPassWordHeaderLabel setFont:KContentLeftTitleFontOfSize];
    formerPassWordHeaderLabel.textAlignment=NSTextAlignmentLeft;
    [formerPassWordBackGrondView addSubview:formerPassWordHeaderLabel];
    
    ///原密码输入框
    UITextField *formerPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(65.0f, 1, KProjectScreenWidth-30-65, 45.0f)];
    [formerPasswordTextField setDelegate:self];
    [formerPasswordTextField becomeFirstResponder];
    [formerPasswordTextField setTag:KUserFormerPwdTextTag];
    [formerPasswordTextField setSecureTextEntry:YES];
    [formerPasswordTextField setPlaceholder:@"(6-16位数字或字母)"];
    [formerPasswordTextField setTextColor:KDefaultOrNightTextColor];
    [formerPasswordTextField setReturnKeyType:UIReturnKeyNext];
    [formerPasswordTextField setBackgroundColor:[UIColor clearColor]];
    [formerPasswordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [formerPasswordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [formerPasswordTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    self.userPersonalFormerPassWord = formerPasswordTextField;
    [formerPassWordBackGrondView addSubview:self.userPersonalFormerPassWord];
    
    UIView *seperatorView=[[UIView alloc]initWithFrame:CGRectMake(0, 47, KProjectScreenWidth-20, 0.5f)];
    seperatorView.backgroundColor=KSepLineColorSetup;
    [formerPassWordBackGrondView addSubview:seperatorView];
    
    
    ///新密码头部Label
    UILabel *freshPassWordHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7,59.5,60,23)];
    [freshPassWordHeaderLabel setText:@"新密码"];
    [freshPassWordHeaderLabel setTextColor:KDefaultOrNightTextColor];
    [freshPassWordHeaderLabel setBackgroundColor:[UIColor clearColor]];
    [freshPassWordHeaderLabel setFont:KContentLeftTitleFontOfSize];
    [formerPassWordBackGrondView addSubview:freshPassWordHeaderLabel];
    
    ///新密码输入框
    UITextField *freshPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(65.0f, 48.5, KProjectScreenWidth-30-65, 45.0f)];
    [freshPasswordTextField setDelegate:self];
    [freshPasswordTextField setSecureTextEntry:YES];
    [freshPasswordTextField setPlaceholder:@"(6-16位数字或字母)"];
    [freshPasswordTextField setTextColor:KDefaultOrNightTextColor];
    [freshPasswordTextField setTag:KUserFreshPwdTextTag];
    [freshPasswordTextField setReturnKeyType:UIReturnKeyNext];
    [freshPasswordTextField setBackgroundColor:[UIColor clearColor]];
    [freshPasswordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [freshPasswordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [freshPasswordTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    self.userPersonalFreshPassWord = freshPasswordTextField;
    [formerPassWordBackGrondView addSubview:self.userPersonalFreshPassWord];
    
    ///新密码底部横线
    UIImageView *freshPasswordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f,
                                                                                       94.5f,
                                                                                       KProjectScreenWidth-20,
                                                                                       0.5f)];
    [freshPasswordImageView setBackgroundColor:KSepLineColorSetup];
    [freshPasswordImageView setUserInteractionEnabled:YES];
    [formerPassWordBackGrondView addSubview:freshPasswordImageView];
    
    ///确认密码头部Label
    UILabel *verifyPassWordHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7,106,80,23)];
    [verifyPassWordHeaderLabel setText:@"确认密码"];
    [verifyPassWordHeaderLabel setTextColor:KDefaultOrNightTextColor];
    [verifyPassWordHeaderLabel setBackgroundColor:[UIColor clearColor]];
    [verifyPassWordHeaderLabel setFont:KContentLeftTitleFontOfSize];
    [formerPassWordBackGrondView addSubview:verifyPassWordHeaderLabel];
    
    ///确认码输入框
    UITextField *verifyPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(80.0f,
                                                                                        95.0f,
                                                                                        KProjectScreenWidth-20-100,
                                                                                        47.5)];
    [verifyPasswordTextField setDelegate:self];
    [verifyPasswordTextField setSecureTextEntry:YES];
    [verifyPasswordTextField setPlaceholder:@"(6-16位数字或字母)"];
    [verifyPasswordTextField setTextColor:KDefaultOrNightTextColor];
    [verifyPasswordTextField setTag:KUserVerifyPwdTextTag];
    [verifyPasswordTextField setReturnKeyType:UIReturnKeySend];
    [verifyPasswordTextField setBackgroundColor:[UIColor clearColor]];
    [verifyPasswordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [verifyPasswordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [verifyPasswordTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    self.userPersonalVerifyPassWord = verifyPasswordTextField;
    [formerPassWordBackGrondView addSubview:self.userPersonalVerifyPassWord];
    
    
    
//    [self.view addSubview:freshPassWordBackGrondView];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                            forState:UIControlStateNormal];
    [finishButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                            forState:UIControlStateHighlighted];
    
    [finishButton setTitle:@"确定"
                  forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [finishButton setFrame:CGRectMake(20.0f, 220.0f, KProjectScreenWidth-40, 43.0f)];
    [finishButton.layer setBorderWidth:0.5f];
    [finishButton.layer setCornerRadius:5.0f];
    [finishButton.layer setMasksToBounds:YES];
    [finishButton setBackgroundColor:KDefaultOrNightBackGroundColor];
    [finishButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [finishButton addTarget:self action:@selector(userSaveUserPersonalFreshPassWordAndSubmit) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:finishButton];
    
    
}


#pragma mark -
#pragma mark - 用户保存个人新的密码并提交到服务器
- (void)userSaveUserPersonalFreshPassWordAndSubmit{
    
    ///原密码为空
    if (IsStringEmptyOrNull(self.userPersonalFormerPassWord.text)) {
        ShowImportErrorAlertView(@"输入你的原密码");
        return;
    }else if (IsStringEmptyOrNull(self.userPersonalFreshPassWord.text)){
        ShowImportErrorAlertView(@"输入你的新密码");
        return;
    }
    //新密码不可过短或过长
    else if ([self.userPersonalFreshPassWord.text length] >= 16 &&
             [self.userPersonalFreshPassWord.text length] <= 6) {
        ShowImportErrorAlertView(@"你的密码过短或者过长，请重新输入");
        [self.userPersonalFreshPassWord becomeFirstResponder];
        return;
    }
    //输入你的密码
    else if(IsStringEmptyOrNull(self.userPersonalVerifyPassWord.text)){
        ShowImportErrorAlertView(@"输入你的确认密码");
        return;
    }
    //新密码和确认密码不一致
    else if (![self.userPersonalVerifyPassWord.text isEqualToString:self.userPersonalFreshPassWord.text]){
        ShowImportErrorAlertView(@"两次输入的密码不一致，请重新输入");
        [self.userPersonalVerifyPassWord setText:@""];
        [self.userPersonalFreshPassWord setText:@""];
        return;
    }
    
    [self.view endEditing:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    [self.userPersonalFreshPassWord setEnabled:NO];
    [self.userPersonalVerifyPassWord setEnabled:NO];
    [self.userPersonalFormerPassWord setEnabled:NO];
    
    WaittingMBProgressHUD(HUIKeyWindow, @"修改中...");
    
     [FMHTTPClient getUserSetupPersonalPasswordWithUserId:[CurrentUserInformation sharedCurrentUserInfo].userId withPassword:self.userPersonalFormerPassWord.text withnewPwd:self.userPersonalVerifyPassWord.text withConfirmPassword:self.userPersonalFreshPassWord.text completion:^(WebAPIResponse *response) {
                                                                                               dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                                               
                                                                                                   Log(@"infor is %@",response.responseObject);
                                                                                                   if (response.code == WebAPIResponseCodeSuccess) {
                                                                                                       
                                                                                                       FinishMBProgressHUD(HUIKeyWindow);
                                                                                                      //保存登录信息 用户名 密码
                                                                                                       LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
                                                                                                       NSDictionary *userLoginDic = nil;
                                                                                                           userLoginDic = [[NSDictionary alloc] initWithObjectsAndKeys:[CurrentUserInformation sharedCurrentUserInfo].userName,@"UserName",self.userPersonalFreshPassWord.text,@"Password",nil];
                                                                
                                                                                                       [dataManagement writeUserDataToFileWithDictionary:userLoginDic andUserDataType:CYHUserLoginInfoFile];
                                                                                                    
                                                                 [self initWithUserAutoLoginWithNewPassword];                                  }
                                                                                                   else if (response.code == WebAPIResponseCodeFailed){
                                                                     
                                                                                                       FailedMBProgressHUD(HUIKeyWindow, StringForKeyInUnserializedJSONDic(response.responseObject, @"msg"));
                                                                                                       [self.navigationItem.rightBarButtonItem setEnabled:YES];
                                                                                                       [self.userPersonalFreshPassWord setEnabled:YES];
                                                                                                       [self.userPersonalVerifyPassWord setEnabled:YES];
                                                                                                       [self.userPersonalFormerPassWord setEnabled:YES];
                                                                                                   }else{
                                                                                                       [self.navigationItem.rightBarButtonItem setEnabled:YES];
                                                                                                       
                                                                                                       [self.userPersonalFreshPassWord setEnabled:YES];
                                                                                                       [self.userPersonalVerifyPassWord setEnabled:YES];
                                                                                                       [self.userPersonalFormerPassWord setEnabled:YES];
                                                                                                   }
                                                                                               });
                                                                                           }];
     
    
}

- (void)initWithUserAutoLoginWithNewPassword{
    
    
    LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
    if ([dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]) {//用户登录文件存在
        //用户登录字典
        
        [FMHTTPClient getUserLoginInforWithUser:[CurrentUserInformation sharedCurrentUserInfo].userName withUserPassword:self.userPersonalFreshPassWord.text completion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(response.code == WebAPIResponseCodeSuccess){
                    //初始化登录信息
                    [CurrentUserInformation initializaionUserInformation:[response.responseObject objectForKey:@"data"]];
                    
                [self.navigationController popViewControllerAnimated:YES];
                    
                }
            });
        }];
        
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    ///原密码
    if (textField.tag == KUserFormerPwdTextTag) {
        [self.userPersonalFreshPassWord becomeFirstResponder];
    }
    ///新密码
    else if (textField.tag == KUserFreshPwdTextTag){
        [self.userPersonalVerifyPassWord becomeFirstResponder];
    }
    ///确认密码
    else if (textField.tag == KUserVerifyPwdTextTag){
        [self userSaveUserPersonalFreshPassWordAndSubmit];
    }
   return YES;
}

@end
