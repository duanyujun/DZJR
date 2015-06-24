//
//  CommonSelectController.m
//  fmapp
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "CommonSelectController.h"

@interface CommonSelectController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSArray    *dataArr;
@property (nonatomic,copy)  NSString   *titleStr;
@property (nonatomic , weak)    UITableView                 *tableView;

@end

@implementation CommonSelectController

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrNightScrollViewColor;
}

-(id)initWithDataArr:(NSArray *)dataArr WithTltle:(NSString *)title
{
    self=[super init];
    if (self) {
        
        self.dataArr=dataArr;
        self.titleStr=title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingNavTitle:self.titleStr];
    
    //添加列表视图
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight-64) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView setBackgroundColor:[UIColor clearColor]];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = mainTableView;
    [self.view addSubview:self.tableView];

}
#pragma mark -
#pragma mark -UITableViewDelegate UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init] ;
        
    }
    
    //设置选中Cell后的背景图
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.bounds];
    [selectedView setBackgroundColor:KDefaultOrNightCellSelected];
    cell.selectedBackgroundView = selectedView;
    
    NSDictionary *dic=[self.dataArr objectAtIndex:indexPath.row];
    //名称
    UILabel *cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12.5, 200, 20)];
    cityNameLabel.textColor = KDefaultOrNightTextColor;
    cityNameLabel.backgroundColor = [UIColor clearColor];
    cityNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    cityNameLabel.text=StringForKeyInUnserializedJSONDic(dic, @"title");
    [cell.contentView addSubview:cityNameLabel];
    
    //分割线
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5f, 320, 0.5f)];
    separatorView.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    [cell.contentView addSubview:separatorView];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中
    
    NSDictionary *dic=[self.dataArr objectAtIndex:indexPath.row];
    
    [self.delegate codeSelectedSucceedWithselectDic:dic andTitle:self.titleStr];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
