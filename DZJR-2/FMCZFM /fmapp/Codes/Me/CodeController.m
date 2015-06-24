//
//  CodeController.m
//  fmapp
//
//  Created by apple on 15/3/7.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "CodeController.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "HTTPClient.h"
#import "RegisterController.h"
#import "FindPassWordViewController.h"

@interface CodeController ()<UITextFieldDelegate>
@property (nonatomic,assign)UserPhoneCodeOperationStyle    codeStyle;
@property (nonatomic,weak)    UITextField    *phoneCodeField;
@property (nonatomic,strong)  NSTimer        *timer;
@property (nonatomic,weak)    UIButton       *getCodeBtn;
@property (nonatomic,assign)  int            currentSeconds;
@property (nonatomic,strong)  NSString       *phoneNumber;
@end

@implementation CodeController
- (id)initWithUserOperationStyle:(UserPhoneCodeOperationStyle)m_OperationStyle WithPhoneNumber:(NSString *)phoneNumber
{
    self=[super init];
    if (self) {
     
        self.codeStyle=m_OperationStyle;
        self.phoneNumber=[NSString stringWithFormat:@"%@",phoneNumber];
        
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
    
    if (self.codeStyle==UserRegisterCodeOperationStyle) {
        
        [self settingNavTitle:@"注册"];
    }
    else
    {
        [self settingNavTitle:@"找回密码"];
    }
    [self phoneCodeMainView];
}
- (void)phoneCodeMainView
{
    self.currentSeconds=60;
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    [self.view addSubview:mainScrollView];
    
    UILabel *topLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, KProjectScreenWidth-40, 15)];
    topLabel.backgroundColor=[UIColor clearColor];
    topLabel.text=@"验证码已下发，请注意查收短信";
    topLabel.textColor=KContentTextColor;
    topLabel.font=[UIFont systemFontOfSize:15.0f];
    [mainScrollView addSubview:topLabel];
    
    //手机号/用户名
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 50.0f,self.view.bounds.size.width-20, 47.0f)];
    if (ThemeCategory==5) {
        backGroundView.alpha=0.6;
    }
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.layer.borderWidth = 0.5f;
    backGroundView.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    [mainScrollView addSubview:backGroundView];
    
    ////指示图片
    UIImageView *userNameIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"code.png"]];
    [userNameIndicatorImageView setFrame:CGRectMake(20, 14.0f, 23, 19)];
    [backGroundView addSubview:userNameIndicatorImageView];
    ////文本框
    UITextField *userPhoneCodeText = [[UITextField alloc] initWithFrame:CGRectMake(60.0f-8, 1.0f, KProjectScreenWidth-30-60, 45.0f)];
    [userPhoneCodeText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [userPhoneCodeText setReturnKeyType:UIReturnKeyNext];
    [userPhoneCodeText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [userPhoneCodeText setFont:[UIFont systemFontOfSize:18.0f]];
    [userPhoneCodeText setBorderStyle:UITextBorderStyleNone];
    [userPhoneCodeText setPlaceholder:@"验证码"];
    [userPhoneCodeText setDelegate:self];
    [userPhoneCodeText setKeyboardType:UIKeyboardTypePhonePad];
    [userPhoneCodeText becomeFirstResponder];
    self.phoneCodeField=userPhoneCodeText;
    [backGroundView addSubview:userPhoneCodeText];
    
    UIButton *getCodeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [getCodeBtn setFrame:CGRectMake(KProjectScreenWidth-10-150, 114, 150, 20)];
    getCodeBtn.backgroundColor=[UIColor clearColor];
    [getCodeBtn setTitleColor:KContentTextCanEditColor forState:UIControlStateNormal];
    [getCodeBtn setTitle:@"重新获取验证码(60s)" forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [getCodeBtn addTarget:self action:@selector(getCodeForSecond) forControlEvents:UIControlEventTouchUpInside];
    self.getCodeBtn=getCodeBtn;
    [mainScrollView addSubview:getCodeBtn];
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                          forState:UIControlStateNormal];
    [nextButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                          forState:UIControlStateHighlighted];
    [nextButton setTitle:@"下一步"
                forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
    [nextButton setFrame:CGRectMake(20.0f, 150.0f, KProjectScreenWidth-40, 43.0f)];
    [nextButton.layer setBorderWidth:0.5f];
    [nextButton.layer setCornerRadius:5.0f];
    [nextButton.layer setMasksToBounds:YES];
    [nextButton setBackgroundColor:KDefaultOrNightBackGroundColor];
    [nextButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [nextButton addTarget:self action:@selector(userNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:nextButton];

}
-(void)userNextBtnClick
{
    if (IsStringEmptyOrNull(self.phoneCodeField.text)) {
        ShowImportErrorAlertView(@"验证码不能为空");
        return;
    }
    __weak __typeof(&*self)weakSelf = self;
    
[FMHTTPClient getUserRegisterWithUserPersonalPhoneNumber:self.phoneNumber WithCode:self.phoneCodeField.text WithType:self.codeStyle completion:^(WebAPIResponse *response) {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (response.code==WebAPIResponseCodeSuccess) {
            Log(@"%@",response.responseObject);
            if (self.codeStyle==UserRegisterCodeOperationStyle) {
                RegisterController *viewController=[[RegisterController alloc]initWithTel:self.phoneNumber];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else
            {
                FindPassWordViewController *viewController=[[FindPassWordViewController alloc]init];
                viewController.telStr=self.phoneNumber;
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
        else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
        }
        
    });
}];
}

- (void)getCodeForSecond
{
    if (self.currentSeconds==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)timerChange
{
    if (self.currentSeconds==0) {
        [self.getCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
    }
    else
    {
        self.currentSeconds--;
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新获取验证码(%ds)",self.currentSeconds] forState:UIControlStateNormal];
 
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
