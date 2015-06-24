//
//  PeopleConfirmController.m
//  fmapp
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "PeopleConfirmController.h"
#import "HTTPClient+ExploreModules.h"
#import "HTTPClient.h"
#import "CurrentUserInformation.h"

@interface PeopleConfirmController ()<UITextFieldDelegate>

@property (nonatomic , weak)UITextField                 *userNameTextField;
/*!
 *@breif 用户个人密码
 */
@property (nonatomic , weak)UITextField                 *userPasswordTextField;

@end

@implementation PeopleConfirmController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingNavTitle:@"实名认证"];
    
    
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
    [userNameText setPlaceholder:@"姓名"];
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
    [passwordText setPlaceholder:@"身份证号"];
    [passwordText setDelegate:self];
    [passwordText setFont:KContentLeftTitleFontOfSize];
    [passwordText setKeyboardType:UIKeyboardTypePhonePad];
    [passwordText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [passwordText setBorderStyle:UITextBorderStyleNone];
    self.userPasswordTextField=passwordText;
    [backGroundView addSubview:passwordText];
    
    [mainScrollView addSubview:backGroundView];
    
    
    ///退出登录
    UIButton *personalLogoOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                                     forState:UIControlStateNormal];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                                     forState:UIControlStateHighlighted];
    
    [personalLogoOutButton setTitle:@"保存"
                           forState:UIControlStateNormal];

    [personalLogoOutButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    [personalLogoOutButton setFrame:CGRectMake(20.0f, 145.0f, KProjectScreenWidth-40, 43.0f)];
    [personalLogoOutButton.layer setBorderWidth:0.5f];
    [personalLogoOutButton.layer setCornerRadius:5.0f];
    [personalLogoOutButton.layer setMasksToBounds:YES];
    [personalLogoOutButton setBackgroundColor:KDefaultOrNightBackGroundColor];
    [personalLogoOutButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [personalLogoOutButton addTarget:self action:@selector(initWithUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:personalLogoOutButton];
    
    
    [self.view addSubview:mainScrollView];

    [self getUserInformation];
}

- (void)getUserInformation
{
    [FMHTTPClient getAuthenticateWithUserId:[CurrentUserInformation sharedCurrentUserInfo].userId completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
        Log(@"%@",response.responseObject);
            if (response.code==WebAPIResponseCodeSuccess) {
                
                self.userNameTextField.text=StringForKeyInUnserializedJSONDic(response.responseObject, @"zhenshixingming");
                
                self.userPasswordTextField.text=StringForKeyInUnserializedJSONDic(response.responseObject, @"shenfenzhenghao");
            }
            
        });
    }];
}

- (void)initWithUserButtonClicked:(id)sender{

    if (IsStringEmptyOrNull(self.userNameTextField.text)) {
        
        ShowImportErrorAlertView(@"请输入你的姓名");
        
        return;
    }
    if (!IsNormalIdCard(self.userPasswordTextField.text)) {
        
        ShowImportErrorAlertView(@"身份证号格式不正确");
        
        return;
    }
    
    WaittingMBProgressHUD(HUIKeyWindow, @"认证中...");
    [FMHTTPClient AuthenticateWithUserId:[CurrentUserInformation sharedCurrentUserInfo].userId withUserName:self.userNameTextField.text WithUserIdCard:self.userPasswordTextField.text completion:^(WebAPIResponse *response) {
        Log(@"%@",response.responseObject);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if(response.code==WebAPIResponseCodeSuccess)
            {
                SuccessMBProgressHUD(HUIKeyWindow, @"认证成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                FailedMBProgressHUD(HUIKeyWindow, @"认证失败");
            }
            
        });
    }];
    
    
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
