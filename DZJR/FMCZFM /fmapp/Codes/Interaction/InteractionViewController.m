//
//  InteractionViewController.m
//  fmapp
//
//  Created by 李 喻辉 on 14-5-8.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "InteractionViewController.h"
#import "FMNavigateMenu.h"
#import "FontAwesome.h"
#import "HTTPClient+Interaction.h"
#import "CurrentUserInformation.h"
#import "ProjectCell.h"
#import "ProjectModel.h"
#import "ClaimsAreaController.h"
#import "ZhongChouController.h"
#import "PiaoJuController.h"
#import "ZhengQuanController.h"

#define kbtnTag   10009

#define KBtnWidth      KProjectScreenWidth/2.0f
#define KBtnHeight     KProjectScreenWidth*150/320.0f

@interface InteractionViewController ()
@property (nonatomic,weak)UIButton                      *navTitleButton;        //问题类型按钮
@property (nonatomic,assign)ProjectResquestType         projectType;
@property (readwrite, strong) DataPage                  *dataSource;            //列表的数据源
@property (nonatomic, weak)   AFHTTPRequestOperation    *requestDataOperation;  //请求列表数据的操作
@property (nonatomic,weak)    HUILoadMoreCell           *loadMoreCell;
@property (nonatomic, weak)   UITableView                 *tableView;
@property (nonatomic,assign)  BOOL                        loadMore;
@property (nonatomic,weak)   UIScrollView                *mainScrollView;

@end


@implementation InteractionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.enableCustomNavbarBackButton = FALSE;
        self.projectType=ProjectResquestTypeAll;
        self.dataSource = [DataPage page];
    }
    return self;
    
}
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KProjectBackGroundViewColor;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self settingNavTitle:@"发现"];
    
    [self createMainView];
    
    
    
}
- (void)createMainView
{
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +60.0f);
    if(KProjectScreenHeight>568)
    {
        mainScrollView.contentSize = CGSizeMake(KProjectScreenWidth, mainScrollView.frame.size.height+30);
    }
    self.mainScrollView=mainScrollView;
    [self.view addSubview:mainScrollView];

    
    NSArray *titleArr=[[NSArray alloc]initWithObjects:@"大众众筹",@"大众理财",@"票据理财",@"大众证券",@"基金理财",@"保险理财", nil];
    NSArray *subTitleArr=[[NSArray alloc]initWithObjects:@"大众众筹 即将起航",@"大众众筹 即将起航",@"大众众筹 即将起航",@"大众众筹 即将起航",@"大众众筹 即将起航",@"大众众筹 即将起航", nil];
    
    int index=0;
    for(int i=0;i<3;i++)
    {
        for(int j=0;j<2;j++)
        {
            UIButton  *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(j*KBtnWidth, i*KBtnHeight, KBtnWidth, KBtnHeight)];
            btn.layer.borderColor=[KSepLineColorSetup CGColor];
            [btn setBackgroundImage:createImageWithColor([UIColor whiteColor]) forState:UIControlStateNormal];
            btn.layer.borderWidth=0.5f;
            btn.tag=kbtnTag+index;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.mainScrollView addSubview:btn];
            
            UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake((KBtnWidth-30)/2.0f, 30, 30, 30)];
            image.image=createImageWithColor(KUIImageViewDefaultColor);
            [btn addSubview:image];
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, image.frame.origin.y+image.frame.size.height+20, KBtnWidth, 25)];
            titleLabel.textColor=KContentTextColor;
            if (index>3) {
                titleLabel.textColor=KSubNumbeiTextColor;
            }
            titleLabel.text=titleArr[index];
            titleLabel.font=[UIFont systemFontOfSize:17.0f];
            titleLabel.textAlignment=NSTextAlignmentCenter;
            [btn addSubview:titleLabel];
            
            UILabel *subTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height+5, KBtnWidth, 15)];
            subTitleLabel.textColor=KSubTitleContentTextColor;
            if (index>3) {
                subTitleLabel.textColor=KSubNumbeiTextColor;
            }
            subTitleLabel.text=subTitleArr[index];
            subTitleLabel.font=[UIFont systemFontOfSize:12.0f];
            subTitleLabel.textAlignment=NSTextAlignmentCenter;
            [btn addSubview:subTitleLabel];
            
            
            index++;
        }
    }
}

- (void)btnClick:(UIButton *)btn
{
    NSInteger selectIndex=btn.tag-kbtnTag;
    if (selectIndex==0) {
        ZhongChouController *viewController=[[ZhongChouController alloc]init];
        viewController.tabbarIndex=FMShareSetting.tabbarSelectIndex;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if(selectIndex==1)
    {
        ClaimsAreaController *viewController=[[ClaimsAreaController alloc]init];
        viewController.tabbarIndex=FMShareSetting.tabbarSelectIndex;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if(selectIndex==2)
    {
        PiaoJuController *viewController=[[PiaoJuController alloc]init];
        viewController.tabbarIndex=FMShareSetting.tabbarSelectIndex;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if(selectIndex==3)
    {
        ZhengQuanController *viewController=[[ZhengQuanController alloc]init];
        viewController.tabbarIndex=FMShareSetting.tabbarSelectIndex;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        ShowImportErrorAlertView(@"即将上线，敬请期待");
    }

}
@end
