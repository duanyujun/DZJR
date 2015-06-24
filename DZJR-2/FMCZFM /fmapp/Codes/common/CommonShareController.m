//
//  CommonShareController.m
//  fmapp
//
//  Created by apple on 15/3/30.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "CommonShareController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface CommonShareController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *shareUrl;
@property (nonatomic , weak) UIWebView           *webShareWebView;
///进度条内容
@property (nonatomic , copy)    NJKWebViewProgress  *progressProxy;
@property (nonatomic , copy)    NJKWebViewProgressView *progressView;

@end

@implementation CommonShareController

-(id)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl
{
    self=[super init];
    if (self) {
        self.title=title;
        self.shareUrl=shareUrl;
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
    
    [self setLeftNavButtonFA:FMIconLeftArrow
                   withFrame:kNavButtonRect
                actionTarget:self
                      action:@selector(initWithUserDismissModalViewControllerAnimated)];
    
    
    [self settingNavTitle:self.title];
    //添加WebView
    UIWebView *mainWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    mainWebView.opaque = NO;
    [mainWebView setOpaque:YES];
    mainWebView.scalesPageToFit = YES;
    [mainWebView setUserInteractionEnabled:YES];
    mainWebView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    for (UIView *subView in [mainWebView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView *shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
            }
        }
    }
    [mainWebView setBackgroundColor:[UIColor clearColor]];
    self.webShareWebView = mainWebView ;
    [self.view addSubview:self.webShareWebView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.webShareWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.0f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    Log(@"web Url is %@",self.shareUrl);
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.shareUrl]];
    [self.webShareWebView loadRequest:urlRequest];
    
}

- (void)initWithUserDismissModalViewControllerAnimated{
    
    
    if ([self.webShareWebView canGoBack]) {
        [self.webShareWebView goBack];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillLayoutSubviews
{
    CGRect rc = self.view.bounds;
    self.webShareWebView.frame = rc;
    
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *webTtitleString = [[NSString alloc]initWithFormat:@"%@",[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    Log(@"self.webShareTtitleString is %@",webTtitleString);
    
    if (!IsStringEmptyOrNull(webTtitleString)) {
        [self settingNavTitle:webTtitleString];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    BOOL shouldStartLoad = YES;
    
    
    return shouldStartLoad;
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
