//
//  FMTabBarController.h
//  fmapp
//
//  Created by 李 喻辉 on 14-5-8.
//  Copyright (c) 2014年 yk. All rights reserved.
//
#import "FMTabBarController.h"
#import "CurrentUserInformation.h"

#define kTableHintPointTag    200

@interface FMTabBarController ()

@end

@implementation FMTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    //去掉当前选择button上的阴影
    if ([self.tabBar respondsToSelector:@selector(setSelectionIndicatorImage:)]) {
        self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"TabItem_SelectionIndicatorImage.png"];//设置选中时图片
    }
    
    //去掉顶部阴影条
    if ([UITabBar instancesRespondToSelector:@selector(setShadowImage:)]) {// > iOS 6.0
        [self.tabBar setShadowImage:[UIImage imageNamed:@"TabItem_SelectionIndicatorImage"]];
    }
        
    //设置背景
    [FMThemeManager applySkinToTabBar:self.tabBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)addButtonWithNormalImage:(UIImage *)normalImage
                   selectedImage:(UIImage*)selectedImage
        forViewControllerAtIndex:(NSInteger)index
{
    if (index >= [self.viewControllers count])
        return;
    
    
    //width of button
    NSInteger viewCount = self.viewControllers.count;
    CGFloat width = self.view.bounds.size.width / viewCount;
    CGFloat height = 49;
    
    
    //create button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(index * width,
                           0,
                           width, height);
    
    
    btn.tag = index + kTableButtonBaseTag;
    
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(tableButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:btn];
}
- (void)tableButtonPressed:(UIButton *)tableButton
{
    //if tapped on current selected button, do not respond
    NSInteger oldIndex = self.selectedIndex;
    NSInteger newIndex = tableButton.tag - kTableButtonBaseTag;
    if (oldIndex == newIndex){
        if (newIndex != 1) {
            return;
        }
    }
    
    self.selectedIndex = newIndex;
    
    UIButton *oldButton = (UIButton *)[self.tabBar viewWithTag:kTableButtonBaseTag + oldIndex];
    
    if (self.tableClickBlock) {
        self.tableClickBlock(oldButton,tableButton);
    }
}

+ (UITabBarItem* )addButtonWithNormalImage:(UIImage *)normalImage
                           selectedImage:(UIImage*)selectedImage
                                   title:(NSString* )title
{
    UITabBarItem *tabBarItem = nil;

    if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage tag:0];
        [tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
    } else {
        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
        [tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
        [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    }
    return tabBarItem;
    
}
+ (UIImage *)scaleImage:(UIImage *)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)showHintPoint:(NSInteger)buttonIndex showOrHide:(BOOL)bShow
{
    if(buttonIndex >= [self.tabBar.items count])
        return;
    
    CGFloat w = self.tabBar.frame.size.width / [self.tabBar.items count];
    
    UIImageView* hintPoint = (UIImageView* )[self.tabBar viewWithTag:kTableHintPointTag + buttonIndex];
    if(hintPoint == nil){
        if (bShow == NO) {
            return;
        }
        hintPoint = [[UIImageView alloc] initWithImage:kImgHintPointImage];
        hintPoint.tag = kTableHintPointTag + buttonIndex;
        hintPoint.frame = CGRectMake(70 + buttonIndex * w, 6, 10, 10);
        [self.tabBar addSubview:hintPoint];
    }
    if (bShow) {
        hintPoint.hidden = NO;
    }else{
        hintPoint.hidden = YES;
    }

}

@end
