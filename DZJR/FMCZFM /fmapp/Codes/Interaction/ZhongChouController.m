//
//  ZhongChouController.m
//  fmapp
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ZhongChouController.h"
#import "FMNavigationGestureRecognizer.h"
#import "ZhongChouTableView.h"

#define KMainScrollViewTag         10005

#define KNearByMerchantBaseTag 1930111


@interface ZhongChouController ()<GestureRecognizerDelegate,UIScrollViewDelegate>
///头部导航操作视图
@property (nonatomic , strong)    FMNavigationGestureRecognizer   *headerNavigationView;

@property (nonatomic,assign) CGFloat        heightScale;
@property (nonatomic , strong)UIScrollView                        *tableScorllView;

@end

@implementation ZhongChouController
- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KProjectBackGroundViewColor;
}
- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.heightScale=(CGFloat)KProjectScreenHeight/568;
    
    if(self.heightScale<1)
    {
        self.heightScale=1;
    }
    
    [self settingNavTitle:@"大众众筹"];
    
    
    [self createheaderScorllView];
}
-(void)createheaderScorllView
{
    ///头部界面
    self.headerNavigationView = [[FMNavigationGestureRecognizer alloc]initWithFrame:CGRectMake(0.0f,
                                                                                               0.0f,
                                                                                               self.view.frame.size.width,
                                                                                               35.0f*self.heightScale)
                                                                      withViewContr:self
                                                                   withBtnNameArray:@[@"综合推荐",@"最新上线",@"金额最高",@"支持最多"]
                                                                       withDelegate:self];
    
    [self.view addSubview:self.headerNavigationView];
    
    self.tableScorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 35.0f*self.heightScale, KProjectScreenWidth, KProjectScreenHeight-64 - 35.0f*self.heightScale)];
    self.tableScorllView.pagingEnabled = YES;
    self.tableScorllView.showsHorizontalScrollIndicator = NO;
    self.tableScorllView.contentSize = CGSizeMake(KProjectScreenWidth*4, self.tableScorllView.frame.size.height);
    self.tableScorllView.tag=KMainScrollViewTag;
    self.tableScorllView.delegate = self;
    [self.view addSubview:self.tableScorllView];
    
    for(int i=1;i<=4;i++)
    {
        ZhongChouTableView *tableView=[[ZhongChouTableView alloc]initWithFrame:CGRectMake((i - 1)*KProjectScreenWidth, 0.0f, KProjectScreenWidth,
                                                                                        KProjectScreenHeight-64 - 35.0f*self.heightScale-44) withDataStyle:i withModuleStyle:1];
        [tableView setTag:KNearByMerchantBaseTag +1];
        [self.tableScorllView addSubview:tableView];
        
        
        
    }


}
#pragma mark - 用户操作控制协议，用于作为数据传出的依据
- (void)initWithUserGestureRecognizerOperationButtonEvent:(id)sender{
    UIButton    *button = (UIButton *)sender;
    NSInteger   viewTag  =  button.tag - KGestureButtonBaseTag;
    
    if (viewTag >=0 && viewTag <4) {
        __weak typeof(self) weakSelf = self;
        [weakSelf.tableScorllView scrollRectToVisible:CGRectMake(KProjectScreenWidth * viewTag, 0, KProjectScreenWidth, weakSelf.tableScorllView.frame.size.height)
                                             animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag==KMainScrollViewTag) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        NSInteger selectedBtnTag = page+KGestureButtonBaseTag;
        [self.headerNavigationView initWithChangedWithUserSelectedIndex:selectedBtnTag];
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
