//
//  ImageBrowse.m
//  fmapp
//
//  Created by 李 喻辉 on 14-6-9.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "ImageBrowse.h"
#import "ImageContentScrollView.h"
#import "FMImageToolbar.h"

#define kPadding 5
#define kImageTagBase 10001
///水印图片默认大小
#define KMaskImageWidth     252.0f
#define KMaskImageHeight    78.0f

@interface ImageBrowse ()<UIScrollViewDelegate,FMImageViewDelegate,FMImageToolbarDelegate>
{
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
}
@property (nonatomic,copy)NSArray                               *imageList;
@property (nonatomic,strong)UIScrollView                        *imageScrollView;
@property (nonatomic,strong)FMImageToolbar                      *toolbar;

@end

@implementation ImageBrowse
{
    CALayer *_backLayer;
}

#pragma mark - Lifecycle
- (void)loadView
{
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
	self.view.backgroundColor = [UIColor blackColor];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self createView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // 1.创建UIScrollView
    [self createScrollView];
    
    // 2.创建工具条
    [self createToolbar];
}

//夜间模式
-(void)createView
{
    _backLayer= [CALayer layer];
    
    _backLayer.frame= self.view.bounds;//设置layer的区域
    
    [self.view.layer addSublayer:_backLayer];
    
    if(ThemeCategory==5)
    {
        _backLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
    }
    else
    {
        _backLayer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0].CGColor;
    }
}
#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = self.view.bounds;
    //frame.origin.x -= kPadding;
    //frame.size.width += (2 * kPadding);
	_imageScrollView = [[UIScrollView alloc] initWithFrame:frame];
	_imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_imageScrollView.pagingEnabled = YES;
	_imageScrollView.delegate = self;
	_imageScrollView.showsHorizontalScrollIndicator = NO;
	_imageScrollView.showsVerticalScrollIndicator = NO;
	_imageScrollView.backgroundColor = [UIColor clearColor];

	[self.view addSubview:_imageScrollView];

}
#pragma mark 创建工具条
- (void)createToolbar
{
    CGFloat barHeight = 60;
    CGFloat barY = self.view.frame.size.height - barHeight;
    _toolbar = [[FMImageToolbar alloc] init];
    _toolbar.frame = CGRectMake(0, barY, self.view.frame.size.width, barHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolbar.delegate = self;
    [self.view addSubview:_toolbar];

}
#pragma mark 设置相册
- (void)showPhotos:(NSArray* )images srcRect:(CGRect)rect currentIndex:(NSInteger)currentIndex
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    
    self.toolbar.photoCount = [images count];
    CGRect rc = self.view.bounds;
    self.imageScrollView.contentSize = CGSizeMake(rc.size.width * [images count], 0);
    self.imageScrollView.contentOffset = CGPointMake(currentIndex * rc.size.width, 0);
    int i = 0;
    rect.origin.x -= kPadding;
    for (FMImage* im in images) {
        CGRect rcImage = CGRectMake(i * rc.size.width, 0, rc.size.width, rc.size.height);
        rcImage.origin.x += kPadding;
        rcImage.size.width -= 2 * kPadding;
        im.isShowLarge = NO;
        ImageContentScrollView* imageContentView = [[ImageContentScrollView alloc] initWithFrame:rcImage];
        if (currentIndex == i) {
            [imageContentView showInitImage:im.url_thumb srcRect:rect withAnimate:YES];
        }else{
            [imageContentView showInitImage:im.url_thumb srcRect:rect withAnimate:NO];
        }
        [imageContentView setTag:kImageTagBase+i];
        imageContentView.imageDelegate = self;
        [self.imageScrollView addSubview:imageContentView];
        i++;
    }
    self.imageList = images;
    [self showPhotoViewAtIndex:currentIndex];
}
#pragma mark 显示大图
- (void)showPhotoViewAtIndex:(int)index
{
    FMImage* im = [self.imageList objectAtIndex:index];
    if(im == nil)
        return;
    [self updateTollbarState];
    if(im.isShowLarge)
        return;
    ImageContentScrollView* imageContentView = (ImageContentScrollView* )[self.imageScrollView viewWithTag:kImageTagBase+index];
    if (imageContentView == nil) {
        return;
    }
    [imageContentView startLoadImageWithUrlStr:im.url];
    //NSLog(@"offset=%lf,frame = %lf",self.imageScrollView.contentOffset.x,imageContentView.frame.origin.x);
    im.isShowLarge = YES;

}
#pragma mark 更新toolbar状态
- (void)updateTollbarState
{
    self.toolbar.currentPhotoIndex = self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)clickImageSave
{
    NSInteger index = self.toolbar.currentPhotoIndex = self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width;
    ImageContentScrollView* imageContentView = (ImageContentScrollView* )[self.imageScrollView viewWithTag:kImageTagBase+index];
    if (imageContentView == nil) {
        return;
    }
    FMImage* im = (FMImage* )[self.imageList objectAtIndex:index];
    if (im == nil || im.bSaved) {
        return;
    }
    im.bSaved = YES;
    WaittingMBProgressHUD(HUIKeyWindow,@"正在保存到相册...");
    
    UIImage *userImage = imageContentView.imageView.image;
//    UIImage *maskImage = [UIImage imageNamed:waterMarkImage];
//    UIImage *saveImage = [self addImage: userImage addMsakImage:maskImage];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:userImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

/**
 加半透明水印
 @param useImage 需要加水印的图片
 @param addImage1 水印
 @returns 加好水印的图片
 */
- (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage
{
    UIGraphicsBeginImageContext(useImage.size);
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    //四个参数为水印图片的位置
    
    ///若图片宽度大于600则使用大图
    if (useImage.size.width >= 640.0f) {
        [maskImage drawInRect:CGRectMake(useImage.size.width - (KMaskImageWidth+20.0f), useImage.size.height-(KMaskImageHeight+15.0f), KMaskImageWidth, KMaskImageHeight)];
    }
    ///若图片宽度<= 600则将水印缩小一半
    else{
        [maskImage drawInRect:CGRectMake(useImage.size.width - (KMaskImageWidth/2+20.0f), useImage.size.height-(KMaskImageHeight/2+15.0f), KMaskImageWidth/2, KMaskImageHeight/2)];
    }
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        FailedMBProgressHUD(HUIKeyWindow, @"保存失败");
    } else {
        SuccessMBProgressHUD(HUIKeyWindow, @"保存成功");
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger pageWidth = self.imageScrollView.bounds.size.width;
    NSInteger curIndex = self.imageScrollView.contentOffset.x / pageWidth;//floor((self.imageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self showPhotoViewAtIndex:curIndex];
}

#pragma mark - FMImageView Delegate
- (void)photoViewSingleTap:(ImageContentScrollView *)imageView
{
    [UIApplication sharedApplication].statusBarHidden = _statusBarHiddenInited;
    self.view.backgroundColor = [UIColor clearColor];
    // 移除工具条
    [self.toolbar removeFromSuperview];
}

- (void)photoViewHidden:(ImageContentScrollView *)imageView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (void)photoViewImageFinishLoad:(ImageContentScrollView *)imageView
{
    //_toolbar.currentPhotoIndex = _currentPhotoIndex;
}
@end
