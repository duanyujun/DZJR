//
//  RoadMainViewController.m
//  fmapp
//
//  Created by 张利广 on 14-10-10.
//  Copyright (c) 2014年 yk. All rights reserved.
//


#import "RoadMainViewController.h"
#import "FMNavigationGestureRecognizer.h"
#import "LoginController.h"
#import "CurrentUserInformation.h"
#import "HTTPClient+RoadCondition.h"
#import "ShareViewController.h"
#import "BorrowViewController.h"
#import "HTTPClient+Interaction.h"
#import "ProjectModel.h"
#import "APAvatarImageView.h"


#define KCellViewHeight      208.0f                              ///购物支付的高度

#define KUserLoginButtonTag             1630111         ///右侧登录按键
#define KUserLogoutButtonTag            1630112         ///右侧退出按键

#define KTopBtnTag                      10000
#define KHeaderScrollViewTag       10004
#define KMainScrollViewTag         10005

#define KCellImageTag              20001


@interface RoadMainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , weak)        UITableView             *tableView;
@property (nonatomic , strong)      DataPage                *dataSource;
@property (nonatomic , weak)        HUILoadMoreCell         *loadMoreCell;

@property (nonatomic , assign)      NSInteger               animationIntegerNumber;
@property (nonatomic , assign)      BOOL                    animationUpOrdown;
@property (nonatomic , weak)        UIImageView             *animationUpOrdownImageView;
@property (nonatomic , weak)        NSTimer                 *animationNStimer;
///扫描结果内容
@property (nonatomic , strong)      NSString                *scanQRCodeResultString;

@property (nonatomic,weak)          UIView                  *headerBackView;

@end

@implementation RoadMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KProjectBackGroundViewColor;
}
- (id)init{
    self = [super init];
    if (self) {
        self.dataSource = [DataPage page];
        self.enableCustomNavbarBackButton = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [self settingNavTitle:@"今日"];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(leftloginNotification:)
                                                 name: FMUserLoginNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(leftloginOutNotification:)
                                                 name: FMUserLogoutNotification
                                               object: nil];

    self.navButtonSize = KNavSize;
    
    [self setRightNavButtonFA:FMIconQRCode
                    withFrame:kNavButtonRect
                 actionTarget:self
                       action:@selector(initWithRightBarButtonEvent)];
    

    [self createMainView];
}
- (void) leftloginNotification:(NSNotification *) notification{
    
    [self createHeaderView];
}

- (void) leftloginOutNotification:(NSNotification *) notification{
    
    [self createHeaderView];
}

- (void) createMainView
{
    
    UITableView* payTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    payTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [payTableView setDelegate:self];
    [payTableView setDataSource:self];
    [payTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [payTableView setBackgroundColor:[UIColor clearColor]];
    self.tableView = payTableView;
    [self.view addSubview:self.tableView];

    [self refreshListData];
    
    
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 220)];
    backView.backgroundColor=[UIColor whiteColor];
    self.headerBackView=backView;

    [self createHeaderView];
    
}

- (void)createHeaderView
{
    for(UIView *v in self.headerBackView.subviews)
    {
        [v removeFromSuperview];
    }
    
    UIView *inforView=[[UIView alloc]init];
    inforView.backgroundColor=[UIColor colorWithRed:0.95 green:0.93 blue:0.93 alpha:1];
    [self.headerBackView addSubview:inforView];
    
    UIView *midBtnView=[[UIView alloc]init];
    midBtnView.backgroundColor=[UIColor whiteColor];
    [self.headerBackView addSubview:midBtnView];


    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState==0) {
        
        
        self.navigationItem.leftBarButtonItem=nil;
        
        self.headerBackView.frame=CGRectMake(0, 0, KProjectScreenWidth, 220+100);
        inforView.frame=CGRectMake(0, 0, KProjectScreenWidth, 220);
        midBtnView.frame=CGRectMake(0, inforView.frame.origin.y+inforView.frame.size.height, KProjectScreenWidth, 100);
        
        UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake((KProjectScreenWidth-70)/2, 30, 70, 70)];
        logo.image=[UIImage imageNamed:@"DefaultCarLogo.png"];
        [self.headerBackView addSubview:logo];

        
        UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        loginBtn.titleLabel.font=[UIFont boldSystemFontOfSize:22.0f];
        [loginBtn setFrame:CGRectMake((KProjectScreenWidth-150)/2.0f, logo.frame.origin.y+logo.frame.size.height+15, 150, 30)];
        [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.headerBackView addSubview:loginBtn];
        
        
        UILabel *subTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, loginBtn.frame.origin.y+loginBtn.frame.size.height+15, KProjectScreenWidth, 15)];
        subTitleLabel.textColor=KContentTextColor;
        subTitleLabel.text=@"开 启 财 富 之 旅";
        subTitleLabel.font=[UIFont systemFontOfSize:16.0f];
        subTitleLabel.textAlignment=NSTextAlignmentCenter;
        [self.headerBackView addSubview:subTitleLabel];
        
    }
    else
    {
        self.headerBackView.frame=CGRectMake(0, 0, KProjectScreenWidth, 133+100);
        inforView.frame=CGRectMake(0, 0, KProjectScreenWidth, 133);
        midBtnView.frame=CGRectMake(0, inforView.frame.origin.y+inforView.frame.size.height, KProjectScreenWidth, 100);
        UILabel *shouyiLabel=[[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth-100)/2, 20, 100, 15)];
        shouyiLabel.textColor=KSubTitleContentTextColor;
        shouyiLabel.text=@"昨日收益（元）";
        shouyiLabel.font=[UIFont systemFontOfSize:10.0f];
        shouyiLabel.textAlignment=NSTextAlignmentCenter;
        [self.headerBackView addSubview:shouyiLabel];
        
        UILabel *shouyiContentLabel=[[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth-150)/2.0f, shouyiLabel.frame.origin.y+shouyiLabel.frame.size.height+15, 150, 40)];
        shouyiContentLabel.textColor=KContentTextColor;
        shouyiContentLabel.text=[CurrentUserInformation sharedCurrentUserInfo].zuorishouyi;
        shouyiContentLabel.font=[UIFont boldSystemFontOfSize:35.0f];
        shouyiContentLabel.textAlignment=NSTextAlignmentCenter;
        [self.headerBackView addSubview:shouyiContentLabel];
        
        APAvatarImageView *apImage=[[APAvatarImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30) borderColor:[UIColor whiteColor] borderWidth:0.5f];
        apImage.image=[UIImage imageNamed:@"DefaultCarLogo.png"];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 30, 30)];
        [btn setBackgroundImage:apImage.image forState:UIControlStateNormal];
        UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
        [self.navigationItem setLeftBarButtonItem:barItem];

    }
    
    CGFloat width=KProjectScreenWidth/3.0f;
    NSArray *iconArr=[[NSArray alloc]initWithObjects:@"",@"",@"", nil];
    NSArray *btnNameArr=[[NSArray alloc]initWithObjects:@"理财",@"众筹",@"智信宝", nil];
    for(int i=0;i<3;i++)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*width, 0, width, 0)];
        [btn setBackgroundImage:createImageWithColor([UIColor clearColor]) forState:UIControlStateNormal];
        [midBtnView addSubview:btn];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((width-30)/2.0f, 25, 30, 30)];
        imageView.image=createImageWithColor(KUIImageViewDefaultColor);
        [btn addSubview:imageView];
        
        UILabel *subTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height+10, width, 15)];
        subTitleLabel.textColor=KContentTextColor;
        subTitleLabel.text=btnNameArr[i];
        subTitleLabel.font=[UIFont systemFontOfSize:12.0f];
        subTitleLabel.textAlignment=NSTextAlignmentCenter;
        [btn addSubview:subTitleLabel];
        
    }
    self.tableView.tableHeaderView=self.headerBackView;

}

- (void)loginBtnClick
{
    LoginController *registerController = [[LoginController alloc] init];
    FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
    [self presentModalViewController:navController animated:YES];
}
- (void)refreshListData
{
    [self.dataSource cleanAllData];
    [self.tableView reloadData];
    
    [self loadMoreListData];
}
- (void)loadMoreListData
{
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient getFirstViewTopImagesWithcompletion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                Log(@"%@",response.responseObject);
                
                NSMutableArray *questionList = ObjForKeyInUnserializedJSONDic(response.responseObject, kDataKeyData);
                [self.dataSource appendPage:questionList];
                [self.tableView reloadData];

            }
            else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
            }
            
        });
    }];

}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count]+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self _isLoadMoreCellAtIndexPath:indexPath]) {
        return kSizeLoadMoreCellHeight;
    }
    return KCellViewHeight;
}
#pragma mark - UITableViewDelegate
- (BOOL)_isLoadMoreCellAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == [self.dataSource count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdetify = @"LeftTableViewCell";
    BOOL isLoadMoreCell = [self _isLoadMoreCellAtIndexPath:indexPath];
    reuseIdetify = isLoadMoreCell? kHUILoadMoreCellIdentifier: reuseIdetify;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];;
    
    if (!cell)
    {
        if ([reuseIdetify isEqualToString:kHUILoadMoreCellIdentifier])
        {
            cell =  CreateLoadMoreCell();
        }else{

            cell = [self createCellWithIdentifier:reuseIdetify];
            
        }
    }
    if (!isLoadMoreCell){
        [self _configureCell:cell forRowAtIndexPath:indexPath];
    }
    else
    {
        self.loadMoreCell = (HUILoadMoreCell*)cell;
        if ([self.dataSource canLoadMore])
        {
//            __weak __typeof(&*self)weakSelf = self;
//            [self.loadMoreCell setLoadMoreOperationDidStartedBlock:^{
//                [weakSelf loadMoreListData];
//            }];
//            [self.loadMoreCell startLoadMore];
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
- (UITableViewCell *)createCellWithIdentifier:(NSString *)cellIdentifier
{
    if ([cellIdentifier isEqualToString:kHUILoadMoreCellIdentifier])
    {
        return CreateLoadMoreCell();
        
    }
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KCellViewHeight-0.5f)];
    imageView.tag=KCellImageTag;
    [cell.contentView addSubview:imageView];
    return cell;
}

- (void)_configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.dataSource.data count]) {
        return;
    }
    NSDictionary *dic=[self.dataSource.data objectAtIndex:indexPath.row];
    UIImageView *image=(UIImageView *)[cell.contentView viewWithTag:KCellImageTag];
    [image setImageWithURL:[NSURL URLWithString:StringForKeyInUnserializedJSONDic(dic, @"pic")] placeholderImage:createImageWithColor(KUIImageViewDefaultColor)];
}

#pragma mark - 设置右侧按键点击事件
- (void)initWithRightBarButtonEvent{
    
    if ([[CurrentUserInformation sharedCurrentUserInfo] userLoginState] == 0) {//注册
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentModalViewController:navController animated:YES];
    }else{
        [self initWithUserSetupCameraWithScanQRCode];
    }
}

#pragma mark -
#pragma mark - =======================设置二维码扫描模块操作内容==================
- (void)initWithUserSetupCameraWithScanQRCode{
#if !TARGET_IPHONE_SIMULATOR
    ///IOS一下使用扫描设置
    self.animationIntegerNumber = 0;
    self.animationUpOrdown = NO;
    
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
    reader.showsHelpOnFail = YES;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, (KProjectScreenWidth - 40), 40)];
    label.text = @"请将扫描的二维码至于下面的框内！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(50, 120, (KProjectScreenWidth - 100), (KProjectScreenWidth - 100));
    [view addSubview:image];
    
    
    UIImageView  *animationLineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, (KProjectScreenWidth - 120), 2)];
    animationLineView.image = [UIImage imageNamed:@"line.png"];
    self.animationUpOrdownImageView = animationLineView;
    [image addSubview:self.animationUpOrdownImageView];
    //定时器，设定时间过1.5秒，
    self.animationNStimer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(initWithSetUpCameraWithAnimation) userInfo:nil repeats:YES];
    
    [self presentViewController:reader animated:YES completion:^{
        
    }];
#endif
}

//TODO: 2.设置相机扫描动画
- (void)initWithSetUpCameraWithAnimation{
    if (self.animationUpOrdown == NO) {
        self.animationIntegerNumber ++;
        self.animationUpOrdownImageView.frame = CGRectMake(10, 10+2*self.animationIntegerNumber, (KProjectScreenWidth - 120.0f), 2);
        if (2*self.animationIntegerNumber == (KProjectScreenWidth-120)) {
            self.animationUpOrdown = YES;
        }
    }
    else {
        self.animationIntegerNumber --;
        self.animationUpOrdownImageView.frame = CGRectMake(10, 10+2*self.animationIntegerNumber, (KProjectScreenWidth - 120.0f), 2);
        if (self.animationIntegerNumber == 0) {
            self.animationUpOrdown = NO;
        }
    }
}
//TODO: 3.取消扫描设置
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.animationNStimer invalidate];
    self.animationUpOrdownImageView.frame = CGRectMake(60, 10, (KProjectScreenWidth - 100.0f), 2);
    self.animationIntegerNumber = 0;
    self.animationUpOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}

- (void)initWithResultUserScanningWithQRCode:(NSString *)m_resultForQRCode{
    
    if (self.scanQRCodeResultString) {
        self.scanQRCodeResultString = nil;
    }
    
    self.scanQRCodeResultString = [[NSString alloc]initWithFormat:@"%@",m_resultForQRCode];
    
    if (IsStringEmptyOrNull(self.scanQRCodeResultString )) {
        return;
    }
    if ([self.scanQRCodeResultString hasPrefix:@"{"]) {
        NSDictionary *codeResultDictionary = [[NSDictionary alloc]initWithDictionary:(NSDictionary *)[self.scanQRCodeResultString objectFromJSONString]];
        
        if (codeResultDictionary.count > 0 ) {
            
            
        }
    }
    
}




- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
#if !TARGET_IPHONE_SIMULATOR
    
    [self.animationNStimer invalidate];
    self.animationUpOrdownImageView.frame = CGRectMake(60, 10, (KProjectScreenWidth - 100), 2);
    self.animationIntegerNumber = 0;
    self.animationUpOrdown = NO;
    __weak __typeof(&*self)weakSelf = self;
    
    
    ShowAutoHideMBProgressHUD(HUIKeyWindow, @"正在解码...");
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
            
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [weakSelf initWithResultUserScanningWithQRCode:result];
        });
        
    }];
#endif
}

@end
