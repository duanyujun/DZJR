//
//  StationLettersController.m
//  fmapp
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "StationLettersController.h"
#import "HTTPClient+ExploreModules.h"
#import "CurrentUserInformation.h"
#import "ShareViewController.h"

#define KTitleLabelTag           10000
#define KContentLabelTag         10001
#define KTimeLabelTag            10002
#define KLineView                10003
#define KUnreadLabelTag          10004

@interface StationLettersController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,weak)UISegmentedControl   *segmentedControl;
@property (readwrite, strong) DataPage                  *dataSource;            //列表的数据源
@property (nonatomic, weak)   AFHTTPRequestOperation    *requestDataOperation;  //请求列表数据的操作
@property (nonatomic,weak)    HUILoadMoreCell           *loadMoreCell;
@property (nonatomic, weak)   UITableView                 *tableView;
@property (nonatomic,assign)  BOOL                        loadMore;

@end

@implementation StationLettersController

- (id)init{
    self = [super init];
    if (self) {
        self.enableCustomNavbarBackButton=FALSE;
        self.dataSource = [DataPage page];

    }
    
    return self;
}

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrNightScrollViewColor;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.segmentedControl setHidden:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavView];
    
    UITableView* tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.backgroundColor = [UIColor clearColor];
    tbView.dataSource = self;
    tbView.delegate = self;
    [self.view addSubview:tbView];
    self.tableView = tbView;
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^(void){
        [weakSelf refreshListData];
    }];
    ConfiguratePullToRefreshViewAppearanceForScrollView(self.tableView);
    [self.tableView triggerPullToRefresh];

}
- (void)refreshListData
{
    
    self.loadMore=NO;
    //停掉当前未完成的请求操作
    [self.requestDataOperation cancel];
    //清空当前数据源中所有数据
    [self.dataSource cleanAllData];
    [self.tableView reloadData];
    [self loadMoreListData];
}
- (void)loadMoreListData
{
    
    __weak __typeof(&*self)weakSelf = self;
    
    self.requestDataOperation=[FMHTTPClient getLetterId:[CurrentUserInformation sharedCurrentUserInfo].userId letterStyle:[NSString stringWithFormat:@"%d",(int)self.segmentedControl.selectedSegmentIndex+1] pageIndex:[self.dataSource nextPageIndex] pageSize:[self.dataSource pageSize] completion:^(WebAPIResponse *response) {
        
            Log(@"%@",response.responseObject);
        if (weakSelf.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading)
        {
            UpdateLastRefreshDataForPullToRefreshViewOnView([weakSelf tableView]);
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                
                NSMutableArray *questionList = [NSMutableArray array];
                NSArray* dataList = [response.responseObject objectForKey:kDataKeyData];
                if ([dataList isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in dataList)
                    {
                    [questionList addObject:dic];
                            
                    }
                }
                [weakSelf.dataSource appendPage:questionList];
                [weakSelf.tableView reloadData];

                //避免服务器返回数据异常导致loadmore循环加载
                if ([questionList count] >=6) {
                    
                    self.loadMore=YES;
                    
                }
            }
            else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
            }
            
        });
        
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count] + 1; //添加一行显示“正在加载”或“加载完毕”;
}
- (UITableViewCell *)createCellWithIdentifier:(NSString *)cellIdentifier
{
    if ([cellIdentifier isEqualToString:kHUILoadMoreCellIdentifier])
    {
        return CreateLoadMoreCell();
        
    }
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    UILabel *introLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, KProjectScreenWidth-26-80, 16)];
    introLable.font = [UIFont systemFontOfSize:16.0f];
    [introLable setTextColor:KContentTextColor];
    [introLable setBackgroundColor:[UIColor clearColor]];
    introLable.text=@"系统消息";
    [cell addSubview:introLable];
    
    UILabel *unreadLabel = [[UILabel alloc]init];
    [unreadLabel setBackgroundColor:[UIColor colorWithRed:251.0f/255.0f
                                                    green:58.0f/255.0f
                                                     blue:67.0f/255.0f
                                                    alpha:1.0]];
    [unreadLabel setTextAlignment:NSTextAlignmentCenter];
    [unreadLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [unreadLabel setTextColor:[UIColor whiteColor]];
    [unreadLabel.layer setCornerRadius:3.0f];
    [unreadLabel.layer setMasksToBounds:YES];
    unreadLabel.tag=KUnreadLabelTag;
    [cell addSubview:unreadLabel];

    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, KProjectScreenWidth-35, 16)];
    titleLable.font = [UIFont systemFontOfSize:17.0f];
    [titleLable setTextColor:KContentTextColor];
    [titleLable setBackgroundColor:[UIColor clearColor]];
    titleLable.tag=KTitleLabelTag;
    [cell addSubview:titleLable];
    
    UILabel *contentLable = [[UILabel alloc] init];
    contentLable.font = [UIFont systemFontOfSize:14.0f];
    [contentLable setTextColor:KSubTitleContentTextColor];
    [contentLable setBackgroundColor:[UIColor clearColor]];
    contentLable.numberOfLines=0;
    contentLable.tag=KContentLabelTag;
    [cell addSubview:contentLable];
    
    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(KProjectScreenWidth-20-150, 18, 150, 15)];
    timeLable.font = [UIFont systemFontOfSize:14.0f];
    [timeLable setTextColor:KSubTitleContentTextColor];
    [timeLable setBackgroundColor:[UIColor clearColor]];
    timeLable.textAlignment=NSTextAlignmentRight;
    timeLable.numberOfLines=0;
    timeLable.tag=KTimeLabelTag;
    [cell addSubview:timeLable];
    
    UIView *lineView=[[UIView alloc]init];
    lineView.backgroundColor=KSepLineColorSetup;
    lineView.tag=KLineView;
    [cell addSubview:lineView];

    
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"QuestionCell";
    BOOL isLoadMoreCell = [self _isLoadMoreCellAtIndexPath:indexPath];
    cellIdentifier = isLoadMoreCell? kHUILoadMoreCellIdentifier: cellIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [self createCellWithIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (!isLoadMoreCell)
        [self _configureCell:cell forRowAtIndexPath:indexPath];
    else
    {
        self.loadMoreCell = (HUILoadMoreCell*)cell;
        if (self.loadMore)
        {
            
            __weak __typeof(&*self)weakSelf = self;
            [(HUILoadMoreCell*)cell setLoadMoreOperationDidStartedBlock:^{
                [weakSelf loadMoreListData];
            }];
            [(HUILoadMoreCell*)cell startLoadMore];
        }
        else
        {
            if (self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading) {
                cell.textLabel.text = LOADMORE_LOADING;
            }else{
                cell.textLabel.text = LOADMORE_LOADOVER;
            }
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self _isLoadMoreCellAtIndexPath:indexPath])
        return;
    
    NSDictionary *dic = [self.dataSource.data objectAtIndex:(indexPath.row)];

    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    int style=IntForKeyInUnserializedJSONDic(dic, @"zhuangtai");
    
    if (style==0) {
        [self DidReadWithMessageDic:dic WithCell:cell];
        return;
    }
    
    [self.segmentedControl setHidden:YES];
    NSString *url=[NSString stringWithFormat:@"http://p2p.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zhanneixinshow?mess_id=%@",StringForKeyInUnserializedJSONDic(dic, @"mess_id")];
    ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:StringForKeyInUnserializedJSONDic(dic, @"biaoti") AndWithShareUrl:url];
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];


    
}

- (void)DidReadWithMessageDic:(NSDictionary *)dic WithCell:(UITableViewCell *)cell
{
    UILabel *unreadLabel=(UILabel *)[cell viewWithTag:KUnreadLabelTag];
    
    [FMHTTPClient DidReadMessageId:StringForKeyInUnserializedJSONDic(dic, @"mess_id") completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
        
            if (response.code==WebAPIResponseCodeSuccess) {
                
                [self.segmentedControl setHidden:YES];
                [unreadLabel setHidden:YES];

                NSString *url=[NSString stringWithFormat:@"http://p2p.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zhanneixinshow?mess_id=%@",StringForKeyInUnserializedJSONDic(dic, @"mess_id")];
                ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:StringForKeyInUnserializedJSONDic(dic, @"biaoti") AndWithShareUrl:url];
                viewController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else
            {
                
                ShowAutoHideMBProgressHUD(HUIKeyWindow, @"读取失败");
            }
            
            
        });
    }];

}

- (void)_configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.dataSource.data count]) {
        return;
    }
    
    NSDictionary *dic = [self.dataSource.data objectAtIndex:(indexPath.row)];
    
    UILabel *titleLabel=(UILabel *)[cell viewWithTag:KTitleLabelTag];
    titleLabel.text=StringForKeyInUnserializedJSONDic(dic, @"biaoti");
    
    UILabel *unreadLabel=(UILabel *)[cell viewWithTag:KUnreadLabelTag];
    int style=IntForKeyInUnserializedJSONDic(dic, @"zhuangtai");
        
    if (style) {
        [unreadLabel setHidden:YES];
    }
    else
    {
        [unreadLabel setHidden:NO];
        [unreadLabel setFrame:CGRectMake(5, 18.0f,6, 6.0f)];
    }
    
    UILabel *contentLabel=(UILabel *)[cell viewWithTag:KContentLabelTag];
    NSString *content=StringForKeyInUnserializedJSONDic(dic, @"neirong");
    CGSize size=[content sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(KProjectScreenWidth-35, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    contentLabel.text=content;
    contentLabel.frame=CGRectMake(15, titleLabel.frame.origin.y+20, size.width, size.height);
    
    UILabel *timeLabel=(UILabel *)[cell viewWithTag:KTimeLabelTag];
    timeLabel.text=StringForKeyInUnserializedJSONDic(dic, @"shijian");
    
    UIView *lineView=[cell viewWithTag:KLineView];
    lineView.frame=CGRectMake(0, 35+20+size.height+16, KProjectScreenWidth, 0.5f);
}

#pragma mark - UITableViewDelegate
- (BOOL)_isLoadMoreCellAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == [self.dataSource count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self _isLoadMoreCellAtIndexPath:indexPath])
        return kSizeLoadMoreCellHeight;
    if (indexPath.row < [self.dataSource.data count]) {
    
        NSDictionary *dic = [self.dataSource.data objectAtIndex:(indexPath.row)];
        NSString *content=StringForKeyInUnserializedJSONDic(dic, @"neirong");
        CGSize size=[content sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(KProjectScreenWidth-35, 1000) lineBreakMode:NSLineBreakByWordWrapping];

        return 35+20+size.height+16+0.5f;
    }
    return 40.0;
}


- (void)createNavView
{
    [self setLeftNavButtonFA:FMIconLeftArrow withFrame:CGRectMake(0, 0, 30, 44) actionTarget:self action:@selector(backPreviousView)];

    
    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"全部",@"未读",@"已读", nil]];
    [segmentedControl setFrame:CGRectMake((KProjectScreenWidth-240)/2, 7, 240, 30)];
    [segmentedControl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex=0;
    self.segmentedControl=segmentedControl;
//    self.navigationItem.titleView=segmentedControl;
    [self.navigationController.navigationBar addSubview:segmentedControl];
}
- (void)backPreviousView
{
    [self.segmentedControl removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentedControlChange:(id)sender
{
    UISegmentedControl *seg=(UISegmentedControl *)sender;
    Log(@"%ld",(long)seg.selectedSegmentIndex);
    
    [self refreshListData];
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
