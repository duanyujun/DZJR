//
//  GesturerViewController.m
//  fmapp
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "GesturerViewController.h"
#import "SelfButton.h"
#import "AppDelegate.h"
#import "LocalDataManagement.h"
#import "FMSettings.h"

#define KOpenAlerViewTag    10001
#define KCloseAlerViewTag   10002

@interface GesturerViewController ()
@property (nonatomic,weak)UISwitch *gesSwitch;
@end

@implementation GesturerViewController

- (id)init
{
    if (self=[super init]) {
        
        self.enterStyleForPush=YES;
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
    
    [self settingNavTitle:@"手势密码"];
    
    if (!self.enterStyleForPush) {
        
        [self setLeftNavButtonFA:FMIconCancelCross
                       withFrame:kNavButtonRect
                    actionTarget:self
                          action:@selector(initWithUserDismissModalViewControllerAnimated)];

    }
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    [self.view addSubview:mainScrollView];
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 20.0f,self.view.bounds.size.width-20, 94.5f)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.layer.borderWidth = 0.5f;
    backGroundView.layer.borderColor = [KDefaultOrNightSepratorColor CGColor];
    [mainScrollView addSubview:backGroundView];

    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10.5, 200, 19)];
    label.backgroundColor=[UIColor clearColor];
    label.text=@"手势密码";
    label.textColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    label.font=[UIFont systemFontOfSize:17.0f];
    [backGroundView addSubview:label];
    
    UISwitch *displayUserSelfLocationSwitch = [[UISwitch alloc] init];
    if (ThemeCategory==5) {
        displayUserSelfLocationSwitch.alpha=0.6;
    }
    self.gesSwitch=displayUserSelfLocationSwitch;
    [displayUserSelfLocationSwitch setOn:YES animated:YES];
    [displayUserSelfLocationSwitch addTarget:self
                                      action:@selector(gestureSwitchValueChanged:)
                            forControlEvents:UIControlEventTouchUpInside];
    
    if (FMShareSetting.agreeGestures) {//同意公开位置
        [displayUserSelfLocationSwitch setOn:YES];//打开
    }else{
        [displayUserSelfLocationSwitch setOn:NO];//关闭
    }

    if (HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)) {
        displayUserSelfLocationSwitch.frame = CGRectMake(KProjectScreenWidth-25-51, 9, 51, 31);
    }else{
        displayUserSelfLocationSwitch.frame = CGRectMake(KProjectScreenWidth-25-79, 11, 79, 27);
    }
    [backGroundView addSubview:displayUserSelfLocationSwitch];
    
    UIView *seperatorView=[[UIView alloc]initWithFrame:CGRectMake(0, 47, KProjectScreenWidth-20, 0.5f)];
    seperatorView.backgroundColor=KSepLineColorSetup;
    [backGroundView addSubview:seperatorView];
    
    SelfButton *btn=[[SelfButton alloc]initWithHelpCenterTitle:@"修改手势密码" AndWithBtnTag:1000];
    [btn setFrame:CGRectMake(0, 47.5f, KProjectScreenWidth-20, 47)];
    [btn addTarget:self action:@selector(changeGestureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backGroundView addSubview:btn];

    
}
- (void)initWithUserDismissModalViewControllerAnimated{

    [self dismissViewControllerAnimated:NO completion:nil];
    [ShareAppDelegate showLockView];

}
- (void) changeGestureBtnClick
{
    if (!self.enterStyleForPush) {

        [self dismissViewControllerAnimated:NO completion:nil];
    }
    if (FMShareSetting.agreeGestures) {
            [ShareAppDelegate showLLLockViewController:LLLockViewTypeModify];
        }else{
            ShowImportErrorAlertView(@"请先创建手势");
        }

//    [ShareAppDelegate showLLLockViewController:LLLockViewTypeModify];
}

- (void) gestureSwitchValueChanged:(id) sender{

    
    NSInteger itemIndex = 0;
    UISwitch *displaySwitch = (UISwitch *)sender;
    if (displaySwitch.isOn) {
        UIAlertView *openAlerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"开启手势密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        openAlerView.alertViewStyle=UIAlertViewStyleSecureTextInput;
        openAlerView.tag=KOpenAlerViewTag;
        [openAlerView show];
    }else{
        UIAlertView *closeAlerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"关闭手势密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        closeAlerView.alertViewStyle=UIAlertViewStyleSecureTextInput;
        closeAlerView.tag=KCloseAlerViewTag;
        [closeAlerView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textFiled=[alertView textFieldAtIndex:0];
    NSString  *text=textFiled.text;
    Log(@"%@",text);
    
    LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
    NSString *password=nil;
    if ([dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]) {//用户登录文件存在
        //用户登录字典
        NSDictionary *userLoginDic = [[NSDictionary alloc] initWithDictionary:[dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]];
        password = [NSString stringWithFormat:@"%@",[userLoginDic objectForKey:@"Password"]];//密码
        
    }
    if (alertView.tag==KCloseAlerViewTag) {
        
        [self.gesSwitch setOn:YES];
        if (buttonIndex == 1) {
            
            if ([password isEqualToString:text]) {
                
                [self.gesSwitch setOn:NO];
                FMShareSetting.agreeGestures=NO;
                [LLLockPassword saveLockPassword:nil];
                
            }else
            {
                ShowImportErrorAlertView(@"密码不正确");
            }
        }
    }
    else
    {
        [self.gesSwitch setOn:NO];

        if (buttonIndex == 1) {
            
            if ([password isEqualToString:text]) {
                
                [ShareAppDelegate showLLLockViewController:LLLockViewTypeCreate];
                [self.gesSwitch setOn:YES];
                FMShareSetting.agreeGestures=YES;
                
            }else
            {
                ShowImportErrorAlertView(@"密码不正确");
            }
            
        }

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
