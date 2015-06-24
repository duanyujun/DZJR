//
//  ClaimsAreaController.m
//  fmapp
//
//  Created by apple on 15/3/21.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ClaimsAreaController.h"
#import "FMNavigateMenu.h"
#import "FontAwesome.h"
#import "HTTPClient+Interaction.h"
#import "CurrentUserInformation.h"
#import "ProjectCell.h"
#import "ProjectModel.h"
#import "MXPullDownMenu.h"

@interface ClaimsAreaController ()<UITableViewDataSource, UITableViewDelegate,MXPullDownMenuDelegate>

@property (nonatomic,weak)UIButton                      *navTitleButton;        //问题类型按钮
@property (readwrite, strong) DataPage                  *dataSource;            //列表的数据源
@property (nonatomic, weak)   AFHTTPRequestOperation    *requestDataOperation;  //请求列表数据的操作
@property (nonatomic,weak)    HUILoadMoreCell           *loadMoreCell;
@property (nonatomic, weak)   UITableView                 *tableView;
@property (nonatomic,assign)  BOOL                        loadMore;

@property (nonatomic,assign)  NSInteger                   dateInt;
@property (nonatomic,assign)  NSInteger                   styleInt;

@end

@implementation ClaimsAreaController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataSource = [DataPage page];
        self.dateInt=0;
        self.styleInt=0;
    }
    return self;
    
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KProjectBackGroundViewColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingNavTitle:@"大众理财"];
    
    UITableView* tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 36, KProjectScreenWidth, KProjectScreenHeight-36) style:UITableViewStylePlain];
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

    [self createTopBtnView];
    
}
- (void)createTopBtnView
{
    NSArray *testArray;
    testArray = @[ @[@"全部", @"票据",@"信托",@"资管",@"财政",@"投资"], @[@"全部",@"30天以下",@"30~60天",@"60~100天",@"100~365天",@"365天以上"]];
    
    
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor colorWithRed:0.18 green:0.56 blue:0.89 alpha:1] WithArray:[NSArray arrayWithObjects:@"类型",@"期限", nil]];
    menu.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    menu.delegate = self;
    menu.frame = CGRectMake(0, 0, menu.frame.size.width, menu.frame.size.height);
    [self.view addSubview:menu];
    
}

- (void)refreshListData
{
    
    self.loadMore=YES;
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
    
    self.requestDataOperation=[FMHTTPClient getQuestionDateType:self.dateInt projectType:self.styleInt pageIndex:[self.dataSource nextPageIndex] pageSize:[self.dataSource pageSize] completion:^(WebAPIResponse *response) {
        Log(@"%@",response.responseObject);
        if (weakSelf.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading)
        {
            UpdateLastRefreshDataForPullToRefreshViewOnView([weakSelf tableView]);
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                
                NSDictionary *data=ObjForKeyInUnserializedJSONDic(response.responseObject, kDataKeyData);
                NSMutableArray *questionList = [NSMutableArray array];
                
                NSArray* dataList = [data objectForKey:@"list"];
                
                if ([dataList isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in dataList)
                    {
                        ProjectModel *question = [ProjectModel initProjectInforWithUnserializedJSONDic:dic];
                        if (question) {
                            
                            [questionList addObject:question];
                            
                        }
                    }
                }
                //避免服务器返回数据异常导致loadmore循环加载
                if ([questionList count] == 0) {
                    
                    self.loadMore=NO;
                }
                [weakSelf.dataSource appendPage:questionList];
                [weakSelf.tableView reloadData];
                
            }
            else
            {
                //                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                
                if (self.loadMoreCell) {
                    [self.loadMoreCell stopLoadingAnimation];
                    self.loadMoreCell.textLabel.text = LOADMORE_LOADOVER;
                }
                
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
    ProjectCell* cell = [[ProjectCell alloc] init];
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
        if (self.loadMore&&[self.dataSource count])
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
    
}
- (void)_configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.dataSource.data count]) {
        return;
    }
    
    ProjectModel *question = [self.dataSource.data objectAtIndex:(indexPath.row)];
    ProjectCell* questionCell = (ProjectCell* )cell;
    [questionCell displayQuestion:question];
    
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
        
        return 140;
    }
    return 40.0;
}
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    Log(@"%d -- %d", column, row);
    
    if (column==0) {
        self.dateInt=row;
    }
    else if (column==1)
    {
        self.styleInt=row;
    }
    
    [self.tableView triggerPullToRefresh];
    
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
