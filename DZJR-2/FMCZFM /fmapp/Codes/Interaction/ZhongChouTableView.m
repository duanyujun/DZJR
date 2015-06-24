//
//  ZhongChouTableView.m
//  fmapp
//
//  Created by apple on 15/5/8.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ZhongChouTableView.h"
#import "HTTPClient+Interaction.h"
#import "ProjectModel.h"
#import "ProjectCell.h"

@interface ZhongChouTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , assign)      NSInteger   dataStyleType;

@property (nonatomic , weak)        UITableView *tableView;

@property (nonatomic , assign)      NSInteger   dataModuleStyleType;

@property (nonatomic , strong)      DataPage    *dataSource;

@property (nonatomic , strong)      AFHTTPRequestOperation *requestInformation;

@property (nonatomic,weak)    HUILoadMoreCell           *loadMoreCell;

@property (nonatomic,assign)  BOOL                        loadMore;

@end

@implementation ZhongChouTableView
- (id)initWithFrame:(CGRect)frame withDataStyle:(NSInteger)m_dataStyle withModuleStyle:(NSInteger)m_moduleStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataModuleStyleType = m_moduleStyle;
        self.dataStyleType = m_dataStyle;
        self.dataSource = [DataPage page];
        [self initWithTableViewFrame];
    }
    return self;
}
- (void)initWithTableViewFrame{
    
    //添加TableView
    CGSize tableSize = self.frame.size;
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableSize.width, tableSize.height)];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView = mainTableView;
    [self addSubview:self.tableView];
    
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^(void){
        [weakSelf refreshListData];
    }];
    ConfiguratePullToRefreshViewAppearanceForScrollView(self.tableView);
    [self.tableView triggerPullToRefresh];
    
}
- (void)refreshListData
{
    //停掉当前未完成的请求操作
    [self.requestInformation cancel];
    //清空当前数据源中所有数据
    [self.dataSource cleanAllData];
    [self.tableView reloadData];
    [self loadMoreListData];
}
- (void)loadMoreListData
{

    if (self.dataModuleStyleType == 1) {
        [self requestZhongChouListByType:self.dataStyleType];
    }
}
- (void)requestZhongChouListByType:(NSInteger)type
{
    __weak __typeof(&*self)weakSelf = self;
    
    self.requestInformation=[FMHTTPClient getZhongChouListType:type pageIndex:[self.dataSource nextPageIndex] pageSize:[self.dataSource pageSize] completion:^(WebAPIResponse *response) {
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
//                [weakSelf.dataSource appendPage:questionList];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
