//
//  PhoneNumberController.m
//  fmapp
//
//  Created by apple on 15/3/7.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "PhoneNumberController.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "HTTPClient.h"
#import "FontAwesome.h"
#import "CodeController.h"
#import "ShareViewController.h"

@interface PhoneNumberController ()<UITextFieldDelegate>

@property (nonatomic,weak)       UITextField    *phoneField;
@property (nonatomic , assign)   UserPhoneNumOperationStyle          initOperationStyle;
@property (nonatomic,weak)       UIButton       *nextBtn;
@property (nonatomic , assign)   BOOL           agreementBool;

@end

@implementation PhoneNumberController
- (id)initWithUserOperationStyle:(UserPhoneNumOperationStyle)m_OperationStyle
{
    self = [super init];
    if (self) {
        self.initOperationStyle = m_OperationStyle;
        self.enableCustomNavbarBackButton=TRUE;
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
    if (self.initOperationStyle==UserFindPasswordStyle) {
        [self settingNavTitle:@"找回密码"];
    }
    else
    {
    [self settingNavTitle:@"注册"];
    }
    self.agreementBool=YES;
    [self phoneNumberMainView];
}
- (void)phoneNumberMainView
{

    if (self.initOperationStyle==UserRegisterOperationStyle) {
        [self UserRegisterView];
    }
    else
    {
        [self UserfindPasswordView];
    }
}
-(void)UserfindPasswordView
{
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    [self.view addSubview:mainScrollView];
    //手机号/用户名
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 20.0f,self.view.bounds.size.width-20, 47.0f)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.layer.borderWidth = 0.5f;
    backGroundView.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    [mainScrollView addSubview:backGroundView];
    
    ////指示图片
    UIImageView *userNameIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone.png"]];
    [userNameIndicatorImageView setFrame:CGRectMake(20, 12.0f, 17, 23)];
    [backGroundView addSubview:userNameIndicatorImageView];
    ////文本框
    UITextField *userPhoneNumberText = [[UITextField alloc] initWithFrame:CGRectMake(60.0f-8, 1.0f, KProjectScreenWidth-30-60, 45.0f)];
    [userPhoneNumberText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [userPhoneNumberText setReturnKeyType:UIReturnKeyNext];
    [userPhoneNumberText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [userPhoneNumberText setFont:[UIFont systemFontOfSize:18.0f]];
    [userPhoneNumberText setBorderStyle:UITextBorderStyleNone];
    [userPhoneNumberText setPlaceholder:@"手机号"];
    [userPhoneNumberText setDelegate:self];
    [userPhoneNumberText setKeyboardType:UIKeyboardTypePhonePad];
    [userPhoneNumberText becomeFirstResponder];
    self.phoneField=userPhoneNumberText;
    [backGroundView addSubview:userPhoneNumberText];
    
    UILabel *agreeLabel=[[UILabel alloc]init];
    agreeLabel.text=@"输入已绑定的手机号,通过验证后可找回密码";
    agreeLabel.font=[UIFont systemFontOfSize:14.0f];
    CGSize size=[agreeLabel.text sizeWithFont:agreeLabel.font];
    agreeLabel.frame=CGRectMake(13, 78, size.width, 15);
    agreeLabel.textColor=KSubTitleContentTextColor;
    [mainScrollView addSubview:agreeLabel];

    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                          forState:UIControlStateNormal];
    [nextButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                          forState:UIControlStateHighlighted];
    
    [nextButton setTitle:@"下一步"
                forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
    [nextButton setFrame:CGRectMake(20.0f, 130.0f, KProjectScreenWidth-40, 43.0f)];
    [nextButton.layer setBorderWidth:0.5f];
    [nextButton.layer setCornerRadius:5.0f];
    [nextButton.layer setMasksToBounds:YES];
    [nextButton setBackgroundColor:KDefaultOrNightBackGroundColor];
    [nextButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [nextButton addTarget:self action:@selector(userNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn=nextButton;
    [mainScrollView addSubview:nextButton];

    
}
-(void)UserRegisterView
{
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    [self.view addSubview:mainScrollView];
    //手机号/用户名
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 20.0f,self.view.bounds.size.width-20, 47.0f)];
       backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.layer.borderWidth = 0.5f;
    backGroundView.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    [mainScrollView addSubview:backGroundView];
    
    ////指示图片
    UIImageView *userNameIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone.png"]];
    [userNameIndicatorImageView setFrame:CGRectMake(20, 12.0f, 17, 23)];
    [backGroundView addSubview:userNameIndicatorImageView];
    ////文本框
    UITextField *userPhoneNumberText = [[UITextField alloc] initWithFrame:CGRectMake(60.0f-8, 1.0f, KProjectScreenWidth-30-60, 45.0f)];
    [userPhoneNumberText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [userPhoneNumberText setReturnKeyType:UIReturnKeyNext];
    [userPhoneNumberText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [userPhoneNumberText setFont:[UIFont systemFontOfSize:18.0f]];
    [userPhoneNumberText setBorderStyle:UITextBorderStyleNone];
    [userPhoneNumberText setPlaceholder:@"手机号"];
    [userPhoneNumberText setDelegate:self];
    [userPhoneNumberText setKeyboardType:UIKeyboardTypePhonePad];
    [userPhoneNumberText becomeFirstResponder];
    self.phoneField=userPhoneNumberText;
    [backGroundView addSubview:userPhoneNumberText];
    
    
    UIButton *agreeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setFrame:CGRectMake(10, 78, 15, 15)];
    [agreeBtn setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.27 green:0.59 blue:0.26 alpha:1]) forState:UIControlStateNormal];
    [agreeBtn setImage:[FontAwesome imageWithIcon:FMIconSubmitSend iconColor:[UIColor whiteColor] iconSize:10] forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:agreeBtn];
    
    UILabel *agreeLabel=[[UILabel alloc]init];
    agreeLabel.text=@"同意融托金融";
    agreeLabel.font=[UIFont systemFontOfSize:16.0f];
    CGSize size=[agreeLabel.text sizeWithFont:agreeLabel.font];
    agreeLabel.frame=CGRectMake(28, 78, size.width, 15);
    agreeLabel.textColor=KSubTitleContentTextColor;
    [mainScrollView addSubview:agreeLabel];
    
    UIButton *introBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [introBtn setBackgroundImage:createImageWithColor([UIColor clearColor]) forState:UIControlStateNormal];
    [introBtn setFrame:CGRectMake(20+size.width, 78, 140, 15)];
    [introBtn setTitle:@"《用户服务协议》" forState:UIControlStateNormal];
    [introBtn setTitleColor:[UIColor colorWithRed:0.18 green:0.46 blue:0.69 alpha:1] forState:UIControlStateNormal];
    introBtn.titleLabel.font=[UIFont systemFontOfSize:17.0f];
    [introBtn addTarget:self action:@selector(servicesIntroBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:introBtn];
    
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                          forState:UIControlStateNormal];
    [nextButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                          forState:UIControlStateHighlighted];
    
    [nextButton setTitle:@"下一步"
                forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
    [nextButton setFrame:CGRectMake(20.0f, 130.0f, KProjectScreenWidth-40, 43.0f)];
    [nextButton.layer setBorderWidth:0.5f];
    [nextButton.layer setCornerRadius:5.0f];
    [nextButton.layer setMasksToBounds:YES];
    [nextButton setBackgroundColor:KDefaultOrNightBackGroundColor];
    [nextButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [nextButton addTarget:self action:@selector(userNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn=nextButton;
    [mainScrollView addSubview:nextButton];

    
}
-(void)servicesIntroBtnClick
{
    ShareViewController *webView=[[ShareViewController alloc]initWithTitle:@"用户服务协议" AndWithShareUrl:@"http://p2p.rongtuojinrong.com/rongtuoxinsoc/user/xieyi"];
    [self.navigationController pushViewController:webView animated:YES];
}
-(void)agreeBtnClick:(id)sender
{ 
    UIButton *button=(UIButton *)sender;
    if (self.agreementBool) {
    
        [button setBackgroundImage:createImageWithColor(KSubNumbeiTextColor) forState:UIControlStateNormal];
        self.agreementBool=NO;
        [self.nextBtn setHidden:YES];
    }
    else
    {
        [button setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.27 green:0.59 blue:0.26 alpha:1]) forState:UIControlStateNormal];
        self.agreementBool=YES;
        [self.nextBtn setHidden:NO];
    }
}
-(void)userNextBtnClick
{
    if (!IsNormalMobileNum(self.phoneField.text)) {
        ShowImportErrorAlertView(@"手机号格式不符");
        return;
    }
    __weak __typeof(&*self)weakSelf = self;
        [FMHTTPClient getUserRegisterWithUserPersonalPhoneNumber:self.phoneField.text WithType:self.initOperationStyle completion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (response.code==WebAPIResponseCodeSuccess) {
                    
                    Log(@"%@",self.phoneField.text);
                    CodeController *viewController=[[CodeController alloc]initWithUserOperationStyle:(UserPhoneCodeOperationStyle)self.initOperationStyle WithPhoneNumber:self.phoneField.text];
                    [self.navigationController pushViewController:viewController animated:YES];
                    
                }
                else
                {
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                }
            });
        }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self userNextBtnClick];
    return YES;
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
