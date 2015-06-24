//
//  SafetySetController.m
//  fmapp
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "SafetySetController.h"
#import "SelfButton.h"
#import "UserPhoneViewController.h"
#import "SetUpPasswordController.h"
#import "PeopleConfirmController.h"
#import "CurrentUserInformation.h"
#import "ShareViewController.h"

#define KLeftWidth      10
#define KBtnHeight      47
#define KBtnTag         10000


@interface SafetySetController ()
@property (nonatomic,assign)ViewOperationStyle  viewStyle;
@property (nonatomic,strong)UIScrollView      *mainScrollView;
@end

@implementation SafetySetController

-(id)initWithButtonStyle:(ViewOperationStyle)viweStyle
{
    self=[super init];
    if (self) {
        
        self.viewStyle=viweStyle;
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
    self.mainScrollView=mainScrollView;
    [self.view addSubview:mainScrollView];
    
    if (self.viewStyle==SafetySetupStyle) {
        
        [self createSafetyManagerView];
        
    }else if (self.viewStyle==HelpCenterStyle)
    {
        [self createHelpCenterView];
    }
    
    
}
-(void)createHelpCenterView
{
    [self settingNavTitle:@"帮助中心"];
    NSArray *titleArr=[[NSArray alloc]initWithObjects:@"出借人帮助",@"借款人帮助",@"出借流程",@"借款流程",@"名词解释", nil];
    
    for(int i=0;i<5;i++)
    {
        SelfButton *btn=[[SelfButton alloc]initWithHelpCenterTitle:titleArr[i] AndWithBtnTag:KBtnTag+i];
        [btn setFrame:CGRectMake(KLeftWidth, 15+(KBtnHeight +0.5f)*i, KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
        [self.mainScrollView addSubview:btn];
    }
}

-(void)createSafetyManagerView
{
    [self settingNavTitle:@"安全管理"];
    NSArray *titleArr=[[NSArray alloc]initWithObjects:@"实名认证",@"手机认证",@"修改登录密码", nil];
    
    for(int i=0;i<3;i++)
    {
        SelfButton *btn=[[SelfButton alloc]initWithTitle:titleArr[i] AndWithBtnTag:KBtnTag+i];
        [btn setFrame:CGRectMake(KLeftWidth, 15+(KBtnHeight +0.5f)*i, KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
        [btn addTarget:self action:@selector(safetyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mainScrollView addSubview:btn];
        
        if (i==0) {
//            if ([CurrentUserInformation sharedCurrentUserInfo].shiming==1) {
//                
//                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-160-8, 8.5, 140, 30)];
//                label.backgroundColor=[UIColor clearColor];
//                label.textAlignment=NSTextAlignmentRight;
//                label.text=@"已认证";
//                label.textColor=KSubTitleContentTextColor;
//                label.font=[UIFont systemFontOfSize:15.0f];
//                [btn addSubview:label];
//            }
//            else
//            {
                UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-40, 16.5, 10, 14)];
                arrowImage.image=[UIImage imageNamed:@"More_CellArrow.png"];
                [btn addSubview:arrowImage];
        }

    }
}

- (void)safetyBtnClick:(UIButton *)btn
{
    if (btn.tag==KBtnTag) {
        
//        PeopleConfirmController *viewController=[[PeopleConfirmController alloc]init];
//        [self.navigationController pushViewController:viewController animated:YES];
        
//        if ([CurrentUserInformation sharedCurrentUserInfo].shiming==1) {
//            
//            ShowImportErrorAlertView(@"您已通过实名认证");
//        }
//        else
//        {
            ///
            NSString *url=[NSString stringWithFormat:@"http://p2p.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/kaihu?user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].userId];
            ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"实名认证" AndWithShareUrl:url];
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
//        }

    }
    else if (btn.tag==KBtnTag+1)
    {
        UserPhoneViewController *viewController=[[UserPhoneViewController alloc]initWithUserOperationStyle:UserJiechuPhoneStyle];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (btn.tag==KBtnTag+2)
    {
        SetUpPasswordController *viewController=[[SetUpPasswordController alloc]init];
        [self.navigationController pushViewController:viewController animated:YES];
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
