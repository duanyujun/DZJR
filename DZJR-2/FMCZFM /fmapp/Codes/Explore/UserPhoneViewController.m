//
//  UserPhoneViewController.m
//  fmapp
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "UserPhoneViewController.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "CurrentUserInformation.h"
#import "HTTPClient+UserLoginOrRegister.h"

#define KPhoneTextFiledTag                10001
#define KCodeTextFiledTag                 10002

@interface UserPhoneViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic , assign)   UserPhoneSetStyle          initOperationStyle;
@property (nonatomic,weak)       UITextField                *phoneTextFiled;
@property (nonatomic,weak)       UITextField                *codeTextFiled;
@property (nonatomic,strong)  NSTimer        *timer;
@property (nonatomic,weak)    UIButton       *getCodeBtn;
@property (nonatomic,assign)  int            currentSeconds;

@end

@implementation UserPhoneViewController
- (id)initWithUserOperationStyle:(UserPhoneSetStyle)m_OperationStyle
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
    
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    mainScrollView.delegate=self;
    [self.view addSubview:mainScrollView];
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 20.0f,self.view.bounds.size.width-20, 94.5f)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.layer.borderWidth = 0.5f;
    backGroundView.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    [mainScrollView addSubview:backGroundView];
    
    ////文本框
    UITextField *userPhoneNumberText = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 1.0f, KProjectScreenWidth-20-60, 45.0f)];
    [userPhoneNumberText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [userPhoneNumberText setReturnKeyType:UIReturnKeyNext];
    [userPhoneNumberText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [userPhoneNumberText setFont:[UIFont systemFontOfSize:18.0f]];
    [userPhoneNumberText setBorderStyle:UITextBorderStyleNone];
    
    if (self.initOperationStyle==UserBindingPhoneStyle) {
        [userPhoneNumberText setPlaceholder:@"新手机号码"];
        [self settingNavTitle:@"绑定新手机"];
        
    }
    else if (self.initOperationStyle==UserJiechuPhoneStyle)
    {
        [userPhoneNumberText setPlaceholder:@"注册时使用的手机号码"];
        [self settingNavTitle:@"验证原手机"];
    }
    else
    {
        [userPhoneNumberText setPlaceholder:@"新手机号码"];
        [self settingNavTitle:@"绑定新手机"];
    }
    
    
    [userPhoneNumberText setDelegate:self];
    userPhoneNumberText.tag=KPhoneTextFiledTag;
    [userPhoneNumberText setKeyboardType:UIKeyboardTypePhonePad];
    [userPhoneNumberText becomeFirstResponder];
    self.phoneTextFiled=userPhoneNumberText;
    [backGroundView addSubview:userPhoneNumberText];
    
    UIImageView *seperatorView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 47, KProjectScreenWidth-20, 0.5f)];
    seperatorView.backgroundColor=KSepLineColorSetup;
    [backGroundView addSubview:seperatorView];
    
    UITextField *userCodeNumberText = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 48.5f, KProjectScreenWidth-20-90, 45.0f)];
    [userCodeNumberText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [userCodeNumberText setReturnKeyType:UIReturnKeyNext];
    [userCodeNumberText setFont:[UIFont systemFontOfSize:18.0f]];
    [userCodeNumberText setBorderStyle:UITextBorderStyleNone];
    [userCodeNumberText setPlaceholder:@"验证码"];
    [userCodeNumberText setDelegate:self];
    userCodeNumberText.tag=KCodeTextFiledTag;
    [userCodeNumberText setKeyboardType:UIKeyboardTypePhonePad];
    self.codeTextFiled=userCodeNumberText;
    [backGroundView addSubview:userCodeNumberText];

    UIButton *getCodeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [getCodeBtn setFrame:CGRectMake(KProjectScreenWidth-20-130, 47.5f+13.5f, 120, 20)];
    getCodeBtn.backgroundColor=[UIColor clearColor];
    [getCodeBtn setTitleColor:KContentTextCanEditColor forState:UIControlStateNormal];
    [getCodeBtn setTitle:@"      获取验证码" forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    [getCodeBtn addTarget:self action:@selector(getCodeForSecond:) forControlEvents:UIControlEventTouchUpInside];
    self.getCodeBtn=getCodeBtn;
    [backGroundView addSubview:getCodeBtn];
    
    UIButton *personalLogoOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                                     forState:UIControlStateNormal];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                                     forState:UIControlStateHighlighted];
    
    if (self.initOperationStyle==UserBindingPhoneStyle) {
        [personalLogoOutButton setTitle:@"绑定"
                               forState:UIControlStateNormal];
    }
    else if (self.initOperationStyle==UserJiechuPhoneStyle)
    {
        [personalLogoOutButton setTitle:@"解除绑定"
                               forState:UIControlStateNormal];
    }
    else
    {
        [personalLogoOutButton setTitle:@"绑定"
                               forState:UIControlStateNormal];
    }

    
    [personalLogoOutButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    [personalLogoOutButton setFrame:CGRectMake(20.0f, 145.0f, KProjectScreenWidth-40, 43.0f)];
    [personalLogoOutButton.layer setBorderWidth:0.5f];
    [personalLogoOutButton.layer setCornerRadius:5.0f];
    [personalLogoOutButton.layer setMasksToBounds:YES];
    [personalLogoOutButton setBackgroundColor:KDefaultOrNightBackGroundColor];
    [personalLogoOutButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [personalLogoOutButton addTarget:self action:@selector(initWithUserButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:personalLogoOutButton];
    
    
    CGFloat heighScale=(CGFloat)KProjectScreenHeight/568;
    if (heighScale<1) {
        heighScale=1;
    }

    //英文名称
    UILabel *companyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (416 + (HUIIsIPhone5() ? 88 : 0) - 50)*heighScale, KProjectScreenWidth, 20)];
    companyNameLabel.text = @"如果您绑定的手机无法接收验证短信";
    companyNameLabel.textColor=[UIColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1.0];
    companyNameLabel.font=[UIFont systemFontOfSize:14.0f];
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    companyNameLabel.backgroundColor=[UIColor clearColor];
    [mainScrollView addSubview:companyNameLabel];
    
    //版权
    UIButton *connectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [connectBtn setFrame:CGRectMake((KProjectScreenWidth-145)/2.0f, companyNameLabel.frame.origin.y+companyNameLabel.frame.size.height+5, 145, 20)];
    connectBtn.backgroundColor=[UIColor clearColor];
    [connectBtn addTarget:self action:@selector(telBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:connectBtn];
    
    UILabel *telLabel=[[UILabel alloc]initWithFrame:connectBtn.bounds];
    telLabel.backgroundColor=[UIColor clearColor];
    telLabel.textAlignment=NSTextAlignmentCenter;
    telLabel.font=[UIFont systemFontOfSize:14.0f];
    telLabel.textColor=[UIColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1.0];
    [connectBtn addSubview:telLabel];

    NSString *content=@"请拨打400-878-8686";
    NSRange range=[content rangeOfString:@"400-878-8686"];
    NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
    [attriContent addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.21 green:0.56 blue:0.88 alpha:1] range:range];
    telLabel.attributedText=attriContent;



}
-(void)telBtnClick
{
    NSString *telNum=@"telprompt://400-878-8686";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)initWithUserButtonClicked
{
    if (self.initOperationStyle==UserBindingPhoneStyle) {
        
        
    }
    else if (self.initOperationStyle==UserJiechuPhoneStyle)
    {
        if (!IsNormalMobileNum(self.phoneTextFiled.text)) {
            ShowImportErrorAlertView(@"请输入正确格式的手机号");
            return;
        }
        
        if (IsStringEmptyOrNull(self.codeTextFiled.text)) {
            ShowImportErrorAlertView(@"验证码不能为空");
            return;
        }
        
        [FMHTTPClient confirmCodeWithUserPersonalPhoneNumber:self.phoneTextFiled.text WithCode:self.codeTextFiled.text WithUserId:[CurrentUserInformation sharedCurrentUserInfo].userId completion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                if (response.code==WebAPIResponseCodeSuccess) {
                    
                    UserPhoneViewController *viewController=[[UserPhoneViewController alloc]initWithUserOperationStyle:UserXiugaiPhoneStyle];
                    [self.navigationController pushViewController:viewController animated:YES];
                    
                }
                else
                {
                    ShowImportErrorAlertView(StringForKeyInUnserializedJSONDic(response.responseObject, @"msg"));
                }
                
            });
        }];
    }
    else
    {
        if (!IsNormalMobileNum(self.phoneTextFiled.text)) {
            ShowImportErrorAlertView(@"请输入正确格式的手机号");
            return;
        }
        
        if (IsStringEmptyOrNull(self.codeTextFiled.text)) {
            ShowImportErrorAlertView(@"验证码不能为空");
            return;
        }
        [FMHTTPClient changeTelWithUserPersonalPhoneNumber:self.phoneTextFiled.text WithCode:self.codeTextFiled.text completion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                if (response.code==WebAPIResponseCodeSuccess) {
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
                else
                {
                    ShowImportErrorAlertView(StringForKeyInUnserializedJSONDic(response.responseObject, @"msg"));
                }
                
            });
        }];
 
        
    }
}


- (void)getCodeForSecond:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"      获取验证码"]) {
        
        if (!IsNormalMobileNum(self.phoneTextFiled.text)) {
            ShowImportErrorAlertView(@"请输入正确格式的手机号");
            return;
        }
        
        NSInteger type=0;
        if (self.initOperationStyle==UserBindingPhoneStyle) {
            
            
        }
        else if (self.initOperationStyle==UserJiechuPhoneStyle)
        {
            type=3;
        }
        else
        {
            type=3;
        }
        
        [FMHTTPClient sendCodeWithUserPersonalPhoneNumber:self.phoneTextFiled.text type:type completion:^(WebAPIResponse *response) {
              dispatch_async(dispatch_get_main_queue(), ^(void){
                
                if (response.code==WebAPIResponseCodeSuccess) {
                    
                    self.currentSeconds=60;
                    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
                }
                else
                {
                    ShowImportErrorAlertView(StringForKeyInUnserializedJSONDic(response.responseObject, @"msg"));
                }
                
            });
        }];
        
        
    }


}
- (void)timerChange
{
    if (self.currentSeconds==0) {
        [self.getCodeBtn setTitle:@"      获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
    }
    else
    {
        self.currentSeconds--;
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码(%ds)",self.currentSeconds] forState:UIControlStateNormal];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==KPhoneTextFiledTag) {
        [self.codeTextFiled becomeFirstResponder];
    }
    else
    {
        
    }
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
