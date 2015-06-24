//
//  FMViewController.m
//  fmapp
//
//  Created by 李 喻辉 on 14-5-8.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "FMViewController.h"
#import "HTTPClient.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "LocalDataManagement.h"
#import "CurrentUserInformation.h"
#import "OpenUDID.h"
#import "JSONKit.h"


#define KRightButtonRedPointImageTag INT_MAX

@interface FMViewController ()
@property (nonatomic,weak) UIActivityIndicatorView*  indicatorView;

@end

@implementation FMViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.enableCustomNavbarBackButton = YES;
        self.navButtonSize = 24.0;
    }
    return self;
}
- (void)loadView
{
    

    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor whiteColor];//[[ThemeManager sharedThemeManager].skin backgroundColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[SliderViewController sharedSliderController].canShowLeft=NO;
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navButtonSize = KNavSize;

    if (self.enableCustomNavbarBackButton)
    {
        [self setLeftNavButtonFA:FMIconLeftArrow
                       withFrame:kNavButtonRect
                    actionTarget:self
                          action:@selector(_backToPrevController)];
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    
    [self updateNaviTheme];
    
}

- (void) settingNavTitle:(NSString *)title
{

    CGRect rcTileView = CGRectMake(90, 0, 320 - 2*90, 44);
    
    UILabel *titleTextLabel = [[UILabel alloc] initWithFrame: rcTileView];
    titleTextLabel.backgroundColor = [UIColor clearColor];
    titleTextLabel.textAlignment = UITextAlignmentCenter;
    titleTextLabel.textColor = [UIColor blackColor];
    if (self.tabbarIndex==2) {
        titleTextLabel.textColor = [UIColor whiteColor];
    }
    [titleTextLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [titleTextLabel setText:title];
    CGSize sizeTitle = [title sizeWithFont:titleTextLabel.font];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.frame = CGRectMake(rcTileView.size.width/2+sizeTitle.width/2+10, 12, 20, 20);
    [indicatorView setHidesWhenStopped:YES];
    [titleTextLabel addSubview:indicatorView];
    self.indicatorView = indicatorView;
    self.navigationItem.titleView = titleTextLabel;
    

}
- (void) setLeftNavButtonFA:(NSInteger)buttonType withFrame:(CGRect) frame actionTarget:(id)target action:(SEL) action
{
    if (target == nil && action == nil)
        return;
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    navButton.titleLabel.font = [UIFont systemFontOfSize:self.navButtonSize];
    navButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    UIColor *btnColor=[FMThemeManager.skin navigationTextColor];
    if (self.tabbarIndex==2) {
        btnColor=[UIColor whiteColor];
    }
    [navButton simpleButtonWithImageColor:btnColor];
    [navButton addAwesomeIcon:buttonType beforeTitle:YES];
    
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){//iOS 7以上
        navButton.contentEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    }else{
        navButton.contentEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    }
    self.navigationItem.leftBarButtonItem = navItem;
    
}
- (void) setLeftNavButton:(UIImage* )btImage withFrame:(CGRect) frame actionTarget:(id)target action:(SEL) action
{
    if (target == nil && action == nil)
        return;
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    [navButton setImage:btImage forState:UIControlStateNormal];
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){//iOS 7以上
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -6;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, navItem, nil] animated:NO];
    }else{
        self.navigationItem.leftBarButtonItem = navItem;
    }
    
}
- (void) setRightNavButton:(UIImage* )btImage withFrame:(CGRect) frame actionTarget:(id)target action:(SEL) action
{
    if (target == nil && action == nil)
        return;
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    [navButton setImage:btImage forState:UIControlStateNormal];
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){//iOS 7以上
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -6;
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, navItem, nil] animated:NO];
    }else{
        self.navigationItem.rightBarButtonItem = navItem;
    }
    
}

- (void)setRightNavButtonFA:(NSInteger)buttonType withFrame:(CGRect) frame actionTarget:(id)target action:(SEL) action
{
    if (target == nil && action == nil)
        return;
    
    
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    navButton.titleLabel.font = [UIFont systemFontOfSize:self.navButtonSize];
    navButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [navButton simpleButtonWithImageColor:[FMThemeManager.skin navigationTextColor]];
    [navButton addAwesomeIcon:buttonType beforeTitle:YES];
    
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){//iOS 7以上
        navButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -8);
    }else{
        navButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
    }
    self.navigationItem.rightBarButtonItem = navItem;
}


- (void)setEnableCustomNavbarBackButton:(BOOL)enableCustomNavbarBackButton
{
    _enableCustomNavbarBackButton = enableCustomNavbarBackButton;
    if (!_enableCustomNavbarBackButton)
        self.navigationItem.leftBarButtonItems = nil;
}

- (void)_backToPrevController
{
    if (self.navBackButtonRespondBlock)
    {
        self.navBackButtonRespondBlock();
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) startWaitting
{
    [self.indicatorView startAnimating];
}

-(void) stopWaitting
{
    [self.indicatorView stopAnimating];
}

- (void) updateNaviTheme
{
    //标题
    id tileView = self.navigationItem.titleView;
    if ([tileView isKindOfClass:[UILabel class]]) {
        if (self.tabbarIndex==2) {
            [tileView setTextColor:[UIColor whiteColor]];
        }
        else
        {
        [tileView setTextColor:[UIColor blackColor]];
        }
    }
    
    UIColor *btnColor=[FMThemeManager.skin navigationTextColor];
    if (self.tabbarIndex==2) {
        btnColor=[UIColor whiteColor];
    }

    //导航栏按钮
    UIButton* leftButton = (UIButton* )self.navigationItem.leftBarButtonItem.customView;
    if([leftButton isKindOfClass:[UIButton class]])
    {
        [leftButton simpleButtonWithImageColor:btnColor];
    }
    UIButton* rightButton = (UIButton* )self.navigationItem.rightBarButtonItem.customView;
    if([rightButton isKindOfClass:[UIButton class]])
    {
        [rightButton simpleButtonWithImageColor:btnColor];
    }
    
    [self applySkinToNavigationBar:self.navigationController.navigationBar];

}
- (void)applySkinToNavigationBar:(UINavigationBar *)navigationBarOrAppearance {
    
    if (!navigationBarOrAppearance) {
        navigationBarOrAppearance = [UINavigationBar appearance];
    }
    
    UIColor *navColor=[UIColor whiteColor];
    if (self.tabbarIndex==2) {
        navColor=[UIColor colorWithRed:0.99 green:0.37 blue:0.34 alpha:1];
    }
    //设置背景
    UIImage* img = createImageWithColor(navColor);
    if(img){
        if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
            [navigationBarOrAppearance setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        }else{
            [navigationBarOrAppearance setBackgroundImage:img
                                           forBarPosition:UIBarPositionTopAttached
                                               barMetrics:UIBarMetricsDefault];
            
        }
    }else{
        UIColor* color = navColor;
        if (color) {
            if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
                navigationBarOrAppearance.tintColor = color;
            }else{
                navigationBarOrAppearance.barTintColor = color;
            }
            
        }
    }
    //设置返回按钮颜色
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){
        
        [navigationBarOrAppearance setTintColor:[FMThemeManager.skin navigationTextColor]];
    }
}

- (void)setRightNavBarButtonRedPointAnnotation:(BOOL)displayAnnotation{
    
    int m = INT_MAX;
    Log(@" m is %d\n is KRightButtonRedPointImageTag %d",m,KRightButtonRedPointImageTag)
    UIButton *rightButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    UIImageView *redPointImage = (UIImageView *)[rightButton viewWithTag:KRightButtonRedPointImageTag];
    if (redPointImage) {
        if (displayAnnotation == YES) {
            [redPointImage setHidden:NO];
        }else{
            [redPointImage setHidden:YES];
        }
    }
    else{
        if (displayAnnotation == YES) {
            redPointImage= [[UIImageView alloc]init];
            [redPointImage setFrame:CGRectMake(55.0f , 10.5f, 7.0f, 7.0f)];
//            if (HUISystemVersionBelowOrIs(kHUISystemVersion_7_0)) {
//                [redPointImage setFrame:CGRectMake(47.0f , 10.5f, 7.0f, 7.0f)];
//            }
            Log(@"KRightButtonRedPointImageTag is %d",KRightButtonRedPointImageTag)
            [redPointImage setTag:KRightButtonRedPointImageTag];
            [redPointImage setImage:kImgHintPointImage];
            [rightButton addSubview:redPointImage];
        }
    }
}
@end
