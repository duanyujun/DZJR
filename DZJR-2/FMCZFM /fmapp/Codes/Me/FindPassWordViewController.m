//
//  FindPassWordViewController.m
//  fmapp
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "FindPassWordViewController.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "CurrentUserInformation.h"

@interface FindPassWordViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,weak)  UITextField    *passwordField;
@property (nonatomic,weak)  UITextField    *sPasswordField;

@end

@implementation FindPassWordViewController

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
    
    [self settingNavTitle:@"找回密码"];
    
    [self initWithRegisterControllerFrame];

}
- (void)initWithRegisterControllerFrame{
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.delegate=self;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 20.0f,self.view.bounds.size.width-20, 95.5f)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.layer.borderWidth = 0.5f;
    backGroundView.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    //密码
    ////指示图片
    UIImageView *passwordIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password.png"]];
    [passwordIndicatorImageView setFrame:CGRectMake(20, 12, 20, 23)];
    [backGroundView addSubview:passwordIndicatorImageView];
    ////文本框
    UITextField *passwordText= [[UITextField alloc] initWithFrame:CGRectMake(60.0f, 0, KProjectScreenWidth-30-60, 45.0f)];
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
    UIView *secondSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(20, 47, self.view.bounds.size.width-20.0f, 0.5f)];
    secondSeperatorView.backgroundColor = KDefaultOrNightSepratorColor;
    [backGroundView addSubview:secondSeperatorView];
    
    ////指示图片
    UIImageView *spasswordIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spassword.png"]];
    [spasswordIndicatorImageView setFrame:CGRectMake(20, 59.5f, 20, 23)];
    [backGroundView addSubview:spasswordIndicatorImageView];
    ////文本框
    UITextField *spasswordText= [[UITextField alloc] initWithFrame:CGRectMake(60.0f, 48.5f, KProjectScreenWidth-30-60, 45.0f)];
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
    
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                            forState:UIControlStateNormal];
    [finishButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                            forState:UIControlStateHighlighted];
    
    [finishButton setTitle:@"完 成"
                  forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [finishButton setFrame:CGRectMake(20.0f, 180.0f, KProjectScreenWidth-40, 43.0f)];
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
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];

    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&tel=%@&shijian=%d",self.telStr,timestamp]);
    
    AddObjectForKeyIntoDictionary(self.telStr, @"tel", parameters);
    AddObjectForKeyIntoDictionary(self.passwordField.text, @"mima", parameters);
    AddObjectForKeyIntoDictionary(@"huiyuan", @"appid", parameters);
    AddObjectForKeyIntoDictionary([NSString stringWithFormat:@"%d",timestamp], @"shijian", parameters);
    AddObjectForKeyIntoDictionary([token lowercaseString], @"token", parameters);

    __weak __typeof(&*self)weakSelf = self;
    WaittingMBProgressHUD(HUIKeyWindow, @"找回中...");
    [FMHTTPClient getUserFindPasswordWithUserWithDic:parameters completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            Log(@"%@",response.responseObject);
            if (response.code==WebAPIResponseCodeSuccess) {
                
                SuccessMBProgressHUD(HUIKeyWindow, @"找回成功");
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                
            }
            else
            {
                FailedMBProgressHUD(HUIKeyWindow, @"找回失败");
                ShowImportErrorAlertView(StringForKeyInUnserializedJSONDic(response.responseObject, @"msg"));
            }
        });
        
        
    }];
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
