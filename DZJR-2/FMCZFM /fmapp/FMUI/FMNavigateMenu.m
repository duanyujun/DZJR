//
//  FMNavigateMenu.m
//  fmapp
//
//  Created by 李 喻辉 on 14-6-12.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "FMNavigateMenu.h"
#import "FontAwesome.h"

#define kNavigateItemBaseTag        100
#define kNavigateItemHeight         45
#define kNavigateItemWidth          141

@interface FMNavigateMenu ()

@property (nonatomic,strong) NSMutableArray         *itemList;
@property (nonatomic,weak) UIView                   *menuView;
@property (nonatomic,weak) UIView                   *menuClipView;
@property (nonatomic,assign)NSInteger               nCurItem;
@end

@implementation FMNavigateMenu

- (id)initWithNav:(UINavigationController* )navi
{
    self = [super initWithFrame:navi.view.bounds];
    if (self) {
        // Initialization code
         _nCurItem = -1;
        self.itemList = [NSMutableArray array];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(removeMenuBgView:)];
        //系统
        CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (systemVersion < 6.0) {
            tapGestureRecognizer.delegate = self;
        }
        [self addGestureRecognizer:tapGestureRecognizer];
        
        CGRect rc = navi.view.bounds;
        rc.origin.y += 64;
        rc.size.height -= 64;
        UIView* menuClipView = [[UIView alloc] initWithFrame:rc];
        menuClipView.clipsToBounds = YES;
        [self addSubview:menuClipView];
        self.menuClipView = menuClipView;
        [navi.view addSubview:self];
        //[navi.view bringSubviewToFront:navi.navigationBar];
    }
    return self;
}
#pragma mark -移除下拉菜单背景图
- (void) removeMenuBgView:(UITapGestureRecognizer *) recognizer
{
    [self.delegate didItemSelected:-1];
    [recognizer.view removeFromSuperview];
    
}
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return NO;
}

- (void)addMenuItem:(NSString* )strTitle
{
    [self.itemList addObject:[NSString stringWithFormat:@"%@",strTitle]];
}

- (void)showMenu:(CGPoint)ltPos curIndex:(NSInteger)currentIndex
{
    //菜单视图
    UIView *menuView = [[UIView alloc] init];
    //menuView.tag = kMenuViewTag;
    menuView.backgroundColor = KDefaultOrNightBackGroundColor;
    menuView.layer.shadowColor = [[UIColor blackColor] CGColor];
    menuView.layer.shadowOffset = CGSizeZero;
    menuView.layer.shadowOpacity = 0.3f;
    self.layer.shadowRadius = 2.0f;
    [menuView setFrame:CGRectMake(ltPos.x, ltPos.y - kNavigateItemHeight * [self.itemList count],
                                  KProjectScreenWidth, kNavigateItemHeight * [self.itemList count])];

    int i = 0;
    
    for (NSString *str in self.itemList) {
        UIButton *buttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonItem.tag = kNavigateItemBaseTag + i;
        [buttonItem setBackgroundImage:createImageWithColor([UIColor clearColor]) forState:UIControlStateNormal];
//        [buttonItem setBackgroundImage:createImageWithColor([[ThemeManager sharedThemeManager].skin baseTintColor])
//                               forState:UIControlStateHighlighted];
        [buttonItem setFrame:CGRectMake(0, kNavigateItemHeight * i + 5, KProjectScreenWidth, kNavigateItemHeight - 10)];
//        [buttonItem setTitle:str forState:UIControlStateNormal];
        [buttonItem addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonItem addTarget:self action:@selector(menuButtonPress:) forControlEvents:UIControlEventTouchDown];
        [buttonItem setTitleColor:KSubTitleContentTextColor forState:UIControlStateNormal];
        [buttonItem setTitleColor:KDefaultOrNightButtonHighlightColor forState:UIControlStateHighlighted];
        buttonItem.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 25)];
        label.text=str;
        label.backgroundColor=[UIColor clearColor];
        label.textColor=KContentTextColor;
        [buttonItem addSubview:label];
        
        UIView *seperatorView=[[UIView alloc]initWithFrame:CGRectMake(0, kNavigateItemHeight*i+kNavigateItemHeight-0.5f, KProjectScreenWidth, 0.5f)];
        seperatorView.backgroundColor=KSepLineColorSetup;
        [menuView addSubview:seperatorView];
        
        [menuView addSubview:buttonItem];
        i++;
    }
    self.menuView = menuView;
    [self.menuClipView addSubview:menuView];
    [self setCurrentItem:currentIndex];
    
    
    UIImageView *selectImage=[[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-40, kNavigateItemHeight-7.5f-25+currentIndex*kNavigateItemHeight, 25, 25)];
    selectImage.image=[FontAwesome imageWithIcon:FMIconSubmitSend iconColor:[UIColor colorWithRed:0.22 green:0.75 blue:0.15 alpha:1] iconSize:15.0f];
    [menuView addSubview:selectImage];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [menuView setFrame:CGRectMake(ltPos.x, ltPos.y, KProjectScreenWidth, kNavigateItemHeight * [self.itemList count])];
    [UIView commitAnimations];
    
    
}

- (void)setCurrentItem:(NSInteger)itemIndex
{
    if (itemIndex == self.nCurItem) {
        return;
    }
    UIButton *button = (UIButton *)[self.menuView viewWithTag:kNavigateItemBaseTag + itemIndex];
    if (button == nil) {
        return;
    }

//    [button setBackgroundImage:createImageWithColor([[ThemeManager sharedThemeManager].skin baseTintColor])
//                      forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //取消之前选择button
    UIButton *oldSelButton = (UIButton *)[self.menuView viewWithTag:kNavigateItemBaseTag + self.nCurItem];
    if (oldSelButton != nil && self.nCurItem >= 0) {
        [oldSelButton setBackgroundImage:createImageWithColor([UIColor clearColor])
                          forState:UIControlStateNormal];
        [oldSelButton setTitleColor:[UIColor colorWithRed:54/255.0f green:54/255.0f blue:54/255.0f alpha:1]
                           forState:UIControlStateNormal];
        [oldSelButton setNeedsDisplay];
    }
    self.nCurItem = itemIndex;
}

#pragma mark -菜单按钮点击时
- (void) menuButtonClicked:(id) sender
{
    UIButton *button = (UIButton *)sender;
    //[self setMenuButtonHighlight:button];//设置当前点击按钮为高亮
    NSInteger index = button.tag - kNavigateItemBaseTag;
    [self setCurrentItem:index];
     
    [self.delegate didItemSelected:index];
    //移除下拉视图
    [self removeFromSuperview];
}
- (void) menuButtonPress:(id) sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - kNavigateItemBaseTag;
    [self setCurrentItem:index];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
