//
//  FeedbackViewController.m
//  fmapp
//
//  Created by apple on 15/3/20.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "FeedbackViewController.h"
#import "CurrentUserInformation.h"
#import "HTTPClient+ExploreModules.h"

@interface FeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic , weak)        UITextView        *feedContentTextView;
@property (nonatomic ,weak)         UILabel           *feedLabel;
@property (nonatomic,weak)    UITextField *userPhoneNumberText;
@end

@implementation FeedbackViewController

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
    
    [self settingNavTitle:@"意见反馈"];
    [self createMainView];
    
}
- (void)createMainView
{
    ///滚动视图
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.showsVerticalScrollIndicator = NO;
    [mainScrollView setDelegate:self];
    mainScrollView.contentSize = CGSizeMake(KProjectScreenWidth,self.view.frame.size.height+20);
    [self.view addSubview:mainScrollView];
    
    UITextView *textView = [[UITextView alloc] init];
    if ([textView respondsToSelector:@selector(textContainerInset)]){
        textView.textContainerInset = UIEdgeInsetsMake(10, 4, 0, 0);
    }else{
        [textView setValue:@"10" forKey:@"m_marginTop"];
    }
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.editable = YES;
    textView.backgroundColor = [FMThemeManager.skin backgroundColor];
    textView.textColor = [FMThemeManager.skin textColor];
    textView.frame = CGRectMake(10, 15, KProjectScreenWidth-20, 235);
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textView.layer.cornerRadius=3;
    textView.clipsToBounds=YES;
    [textView becomeFirstResponder];
    self.feedContentTextView=textView;
    [mainScrollView addSubview:textView];

    UILabel     *headerLabel = [[UILabel alloc]init];
    [headerLabel setFrame:CGRectMake(10.0f, 10.0f, 300.0f, 20.0f)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[UIFont systemFontOfSize:16.0f]];
    headerLabel.textColor = KSubNumbeiTextColor;
    [headerLabel setText:@"您的意见或建议"];
    [textView addSubview:headerLabel];
    self.feedLabel = headerLabel;
    //监测输入文本变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification object:nil];
    
    UITextField *userPhoneNumberText = [[UITextField alloc] initWithFrame:CGRectMake(10, 260,KProjectScreenWidth-20, 50.0f)];
    userPhoneNumberText.backgroundColor=[UIColor whiteColor];
    [userPhoneNumberText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [userPhoneNumberText setReturnKeyType:UIReturnKeyNext];
    [userPhoneNumberText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [userPhoneNumberText setFont:[UIFont systemFontOfSize:16.0f]];
    [userPhoneNumberText setBorderStyle:UITextBorderStyleNone];
    [userPhoneNumberText setPlaceholder:@" 您的手机号"];
    [userPhoneNumberText setDelegate:self];
    [userPhoneNumberText setKeyboardType:UIKeyboardTypePhonePad];
    [userPhoneNumberText becomeFirstResponder];
    userPhoneNumberText.layer.cornerRadius=3;
    userPhoneNumberText.clipsToBounds=YES;
    self.userPhoneNumberText=userPhoneNumberText;
    
    [mainScrollView addSubview:userPhoneNumberText];

    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                            forState:UIControlStateNormal];
    [finishButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                            forState:UIControlStateHighlighted];
    [finishButton setTitle:@"提交"
                  forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [finishButton setFrame:CGRectMake(20.0f, 330, KProjectScreenWidth-40, 43.0f)];
    [finishButton.layer setBorderWidth:0.5f];
    [finishButton.layer setCornerRadius:5.0f];
    [finishButton.layer setMasksToBounds:YES];
    [finishButton setBackgroundColor:KDefaultOrNightBackGroundColor];
    [finishButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [finishButton addTarget:self action:@selector(bottombtnClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:finishButton];
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)bottombtnClick
{

    if (IsStringEmptyOrNull(self.feedContentTextView.text)) {
        
        ShowImportErrorAlertView(@"反馈内容不能为空");
        
        return;
    }
    if (!IsNormalMobileNum(self.userPhoneNumberText.text)) {
        
        ShowImportErrorAlertView(@"手机号格式不正确");
        
        return;
    }
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary(self.feedContentTextView.text, @"neirong", parameters);
    AddObjectForKeyIntoDictionary(self.userPhoneNumberText.text, @"shoujihao", parameters);
    AddObjectForKeyIntoDictionary([CurrentUserInformation sharedCurrentUserInfo].userId, @"user_id", parameters);
    
    WaittingMBProgressHUD(HUIKeyWindow, @"提交中...");
    [FMHTTPClient FeedBackWithUserId:parameters completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                
                SuccessMBProgressHUD(HUIKeyWindow, @"提交成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                FailedMBProgressHUD(HUIKeyWindow, @"提交失败");
            }
            
        });
    }];


}
-(void)textChanged:(NSNotification *)notification{

    if (IsStringEmptyOrNull(self.feedContentTextView.text)) {
        
        [self.feedLabel setHidden:NO];
        
    }
    else
    {
        [self.feedLabel setHidden:YES];
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
