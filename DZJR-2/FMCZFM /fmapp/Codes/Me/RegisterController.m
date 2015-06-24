//
//  RegisterController.m
//  fmapp
//
//  Created by 张利广 on 14-5-14.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "RegisterController.h"
#import "OpenUDID.h"
#import "HTTPClient.h"
#import "LoginController.h"
#import "LocalDataManagement.h"
#import "CurrentUserInformation.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "CommonShareController.h"

@interface RegisterController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,weak)  UITextField    *nameField;
@property (nonatomic,weak)  UITextField    *passwordField;
@property (nonatomic,weak)  UITextField    *sPasswordField;
@property (nonatomic,weak)  UITextField    *phoneField;

@property (nonatomic,copy)  NSString       *telStr;
@end

@implementation RegisterController

- (id)initWithTel:(NSString *)tel
{
    self = [super init];
    if (self) {
        
        self.telStr=tel;
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
- (void)viewDidLoad
{
    [self settingNavTitle:@"快速注册"];
    
    ///初始化注册界面框架内容
    [self initWithRegisterControllerFrame];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}


#pragma mark -
#pragma mark - 初始化注册界面框架内容
- (void)initWithRegisterControllerFrame{
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.delegate=self;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    
    //用户名
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 20.0f,self.view.bounds.size.width-20, 189.5f)];
    if (ThemeCategory==5) {
        backGroundView.alpha=0.6;
    }
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.layer.borderWidth = 0.5f;
    backGroundView.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    ////指示图片
    UIImageView *userNameIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login.png"]];
    [userNameIndicatorImageView setFrame:CGRectMake(20, 12.0f, 20, 23)];
    [backGroundView addSubview:userNameIndicatorImageView];
    ////文本框
    UITextField *userNameText = [[UITextField alloc] initWithFrame:CGRectMake(60.0f, 1.0f, KProjectScreenWidth-30-60, 45.0f)];
    [userNameText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [userNameText setReturnKeyType:UIReturnKeyNext];
    [userNameText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [userNameText setFont:[UIFont systemFontOfSize:18.0f]];
    [userNameText setBorderStyle:UITextBorderStyleNone];
    [userNameText setPlaceholder:@"用户名(6-16位数字或字母)"];
    [userNameText setDelegate:self];
    [userNameText setKeyboardType:UIKeyboardTypeAlphabet];
    [userNameText becomeFirstResponder];
    self.nameField=userNameText;
    [backGroundView addSubview:userNameText];
    
    ////分割线
    UIView *sectionSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(20, 47.5, self.view.bounds.size.width-20.0f, 0.5f)];
    sectionSeperatorView.backgroundColor = KDefaultOrNightSepratorColor;
    [backGroundView addSubview:sectionSeperatorView];
    //密码
    ////指示图片
    UIImageView *passwordIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password.png"]];
    [passwordIndicatorImageView setFrame:CGRectMake(20, 59.5, 20, 23)];
    [backGroundView addSubview:passwordIndicatorImageView];
    ////文本框
    UITextField *passwordText= [[UITextField alloc] initWithFrame:CGRectMake(60.0f, 48.5, KProjectScreenWidth-30-60, 45.0f)];
    [passwordText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [passwordText setReturnKeyType:UIReturnKeyGo];
    [passwordText setPlaceholder:@"密码(6-16位数字或字母)"];
    [passwordText setDelegate:self];
    [passwordText setFont:KContentLeftTitleFontOfSize];
    [passwordText setKeyboardType:UIKeyboardTypeAlphabet];
    [passwordText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [passwordText setBorderStyle:UITextBorderStyleNone];
    [passwordText setSecureTextEntry:YES];
    self.passwordField=passwordText;
    [backGroundView addSubview:passwordText];
    
    ////分割线
    UIView *secondSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(20, 94.5, self.view.bounds.size.width-20.0f, 0.5f)];
    secondSeperatorView.backgroundColor = KDefaultOrNightSepratorColor;
    [backGroundView addSubview:secondSeperatorView];

        ////指示图片
    UIImageView *spasswordIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spassword.png"]];
    [spasswordIndicatorImageView setFrame:CGRectMake(20, 107, 20, 23)];
    [backGroundView addSubview:spasswordIndicatorImageView];
    ////文本框
    UITextField *spasswordText= [[UITextField alloc] initWithFrame:CGRectMake(60.0f, 96, KProjectScreenWidth-30-60, 45.0f)];
    [spasswordText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [spasswordText setReturnKeyType:UIReturnKeyGo];
    [spasswordText setPlaceholder:@"确认密码"];
    [spasswordText setDelegate:self];
    [spasswordText setFont:KContentLeftTitleFontOfSize];
    [spasswordText setKeyboardType:UIKeyboardTypeAlphabet];
    [spasswordText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [spasswordText setBorderStyle:UITextBorderStyleNone];
    [spasswordText setSecureTextEntry:YES];
    self.sPasswordField=spasswordText;
    [backGroundView addSubview:spasswordText];
    
    ////分割线
    UIView *thirdSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(20,142, self.view.bounds.size.width-20.0f, 0.5f)];
    thirdSeperatorView.backgroundColor = KDefaultOrNightSepratorColor;
    [backGroundView addSubview:thirdSeperatorView];

    ////指示图片
    UIImageView *phoneIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone.png"]];
    [phoneIndicatorImageView setFrame:CGRectMake(20, 154.5, 20, 23)];
    [backGroundView addSubview:phoneIndicatorImageView];
    ////文本框
    UITextField *phoneText= [[UITextField alloc] initWithFrame:CGRectMake(60.0f, 143.5, KProjectScreenWidth-30-60, 45.0f)];
    [phoneText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [phoneText setReturnKeyType:UIReturnKeyGo];
    [phoneText setPlaceholder:@"推荐人手机号"];
    [phoneText setDelegate:self];
    [phoneText setFont:KContentLeftTitleFontOfSize];
    [phoneText setKeyboardType:UIKeyboardTypePhonePad];
    [phoneText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [phoneText setBorderStyle:UITextBorderStyleNone];
    [phoneText setSecureTextEntry:YES];
    self.phoneField=phoneText;
    [backGroundView addSubview:phoneText];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                                     forState:UIControlStateNormal];
    [finishButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                                     forState:UIControlStateHighlighted];
    
    [finishButton setTitle:@"完 成"
                           forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    [finishButton setFrame:CGRectMake(20.0f, 240.0f, KProjectScreenWidth-40, 43.0f)];
    [finishButton.layer setBorderWidth:0.5f];
    [finishButton.layer setCornerRadius:5.0f];
    [finishButton.layer setMasksToBounds:YES];
    [finishButton setBackgroundColor:KDefaultOrNightBackGroundColor];
    [finishButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [finishButton addTarget:self action:@selector(userRegisterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:finishButton];

    
    [mainScrollView addSubview:backGroundView];
    [self.view addSubview:mainScrollView];
}

-(void)userRegisterBtnClick
{
    if (IsStringEmptyOrNull(self.nameField.text)) {
        ShowImportErrorAlertView(@"用户名不能为空");
        return;
    }
    if ([self.nameField.text length]<6||[self.nameField.text length]>16) {
        ShowImportErrorAlertView(@"用户名长度不符");
        return;
    }
    if (IsStringEmptyOrNull(self.passwordField.text)) {
        ShowImportErrorAlertView(@"密码不能为空");
        return;
    }
    if ([self.passwordField.text length]<6||[self.passwordField.text length]>16) {
        ShowImportErrorAlertView(@"密码长度不符");
        return;
    }
    if (IsStringEmptyOrNull(self.sPasswordField.text)) {
        ShowImportErrorAlertView(@"验证密码不能为空");
        return;
    }
    if (![self.sPasswordField.text isEqualToString:self.passwordField.text]) {
        ShowImportErrorAlertView(@"密码和验证密码不一致");
        return;
    }
//    if (!IsNormalMobileNum(self.phoneField.text)) {
//        ShowImportErrorAlertView(@"推荐人手机格式不正确");
//        return;
//    }
    __weak __typeof(&*self)weakSelf = self;
    WaittingMBProgressHUD(HUIKeyWindow, @"注册中...");
     [FMHTTPClient getUserRegisterWithUserWithUserName:self.nameField.text WithPassword:self.passwordField.text WithSecondPassword:self.sPasswordField.text PersonalPhoneNumber:self.telStr withRecommendPeople:self.phoneField.text completion:^(WebAPIResponse *response) {
             dispatch_async(dispatch_get_main_queue(), ^(void){
            Log(@"%@",response.responseObject);
            if (response.code==WebAPIResponseCodeSuccess) {
            
                SuccessMBProgressHUD(HUIKeyWindow, @"注册成功");
//                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
              
                NSDictionary *dic=ObjForKeyInUnserializedJSONDic(response.responseObject, @"data");
                NSString *userId=StringForKeyInUnserializedJSONDic(dic, @"user_id");
                
                NSString *url=[NSString stringWithFormat:@"http://p2p.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/kaihu?user_id=%@",userId];
                CommonShareController *viewController=[[CommonShareController alloc]initWithTitle:@"实名认证" AndWithShareUrl:url];
                viewController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:viewController animated:YES];

            }
            else
            {
                FailedMBProgressHUD(HUIKeyWindow, StringForKeyInUnserializedJSONDic(response.responseObject, @"msg"));
                

            }
        });
        
        
    }];

    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end