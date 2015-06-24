//
//  AboutViewController.m
//  fmapp
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "AboutViewController.h"
#import "HTTPClient+MeModulesSetup.h"
#import "HTTPClient.h"
#import "SelfButton.h"
#import "CommonShareController.h"
#import "ShareViewController.h"

#define KLeftWidth      10
#define KBtnHeight      47
#define KBtnTag         10000


@interface AboutViewController ()
@property (nonatomic,copy)NSString         *contentStr;
@end

@implementation AboutViewController

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrNightScrollViewColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingNavTitle:@"关于我们"];
    [self createMainView];



}

- (void)createMainView
{
    
    self.contentStr=@"        融托金融（rongtuojinrong.com)是为个人投资者及优质中小企业搭建的高效、稳定、安全、透明的投融资普惠平台。投资收益可观，多重安全保障。合作机构实力最强，风险控制业内典范！融托金融，为您托起财富梦想！";
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    [self.view addSubview:mainScrollView];
    
    
    UILabel *contentLabel=[[UILabel alloc]init];
    contentLabel.backgroundColor=[UIColor clearColor];
    contentLabel.font=[UIFont systemFontOfSize:17.0f];
    contentLabel.numberOfLines=0;
    contentLabel.text=self.contentStr;
    contentLabel.textColor=KContentTextColor;

    CGSize size=[self.contentStr sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(KProjectScreenWidth-20, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    contentLabel.frame=CGRectMake(10, 15, size.width, size.height);
    [mainScrollView addSubview:contentLabel];
    
    NSArray *titleArr=[[NSArray alloc]initWithObjects:@"欢迎页",@"网站", nil];
    
    for(int i=0;i<2;i++)
    {
        SelfButton *btn=[[SelfButton alloc]initWithHelpCenterTitle:titleArr[i] AndWithBtnTag:KBtnTag+i];
        [btn setFrame:CGRectMake(KLeftWidth,contentLabel.frame.origin.y+contentLabel.frame.size.height+15+(KBtnHeight +0.5f)*i, KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [mainScrollView addSubview:btn];
    }

 
}

- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag==KBtnTag) {
      
        ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"欢迎" AndWithShareUrl:@"http://p2p.rongtuojinrong.com/Rongtuoxinsoc/Helpzhongxin/huanying"];
        [self.navigationController pushViewController:viewController animated:YES];
     
    }
    else if (btn.tag==KBtnTag+1)
    {
//        CommonShareController *viewController=[[CommonShareController alloc]init];
//        [self.navigationController pushViewController:viewController animated:YES];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://p2p.rongtuojinrong.com"]];
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
