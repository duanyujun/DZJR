//
//  ImageContentScrollView.m
//  ArtAuthority
//
//  Created by Ma Yiming on 13-7-31.
//  Copyright (c) 2013年 Ma Yiming. All rights reserved.
//

#import "ImageContentScrollView.h"


#define kSaveImageToAlbumButtonTag 80001

#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].applicationFrame)


@implementation ImageContentScrollView

- (id) initWithFrame:(CGRect)frame
{    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.delegate = self;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.minimumZoomScale = 0.6;//最小缩放比例
        self.maximumZoomScale = 10;//最大缩放比例
        self.zoomScale = 0.4f;
        
        self.backgroundColor = [UIColor clearColor];//设置背景颜色
        
        //self.layer.borderWidth = 2.0f;
        //self.layer.borderColor = [[UIColor redColor] CGColor];
        
        //图片
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        
        self.imageView = imageView;

        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [self addSubview:imageView];
    }
    
    return self;
}
- (void)showInitImage:(NSString*)url srcRect:(CGRect)rect withAnimate:(Boolean)bAnimate
{
    _srcImageRect = rect;
    __weak __typeof(&*self)weakSelf = self;
    [self.imageView setImageWithURL:[NSURL URLWithString:url]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                              [weakSelf adjustFrame:rect withAnimate:bAnimate];
                          }];
}
#pragma mark 调整frame
- (void)adjustFrame:(CGRect)srcRect withAnimate:(Boolean)bAnimate
{
	if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
	
	// 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
    minScale = MIN(minScale,boundsHeight / imageHeight);
	if (minScale > 1) {
		minScale = 1.0;
	}
	CGFloat maxScale = 2.0;
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
	} else {
        imageFrame.origin.y = 0;
	}
    if (bAnimate) {
        _imageView.frame = srcRect;
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.frame = imageFrame;
        } completion:^(BOOL finished) {

        }];
    } else {
        _imageView.frame = imageFrame;
    }
}

#pragma mark -
#pragma mark -自定义方法

#pragma mark -开始加载图片
- (void) startLoadImageWithUrlStr:(NSString *) urlStr
{
    
    //self.minimumZoomScale = 1;//最小缩放比例
    //self.maximumZoomScale = 1;//最大缩放比例
    
    LoadProgressView *loadProgressView = [[LoadProgressView alloc] initWithFrame:CGRectMake(110,
                                                                                            ((HUIIsIPhone5() ?568 : 480) - 10)/2.0f,
                                                                                            100,
                                                                                            10)];
    [self addSubview:loadProgressView];
    self.loadProgressView = loadProgressView;

    __weak __typeof(&*self)weakSelf = self;
    [_imageView setImageWithURL:[NSURL URLWithString:urlStr]
                   placeholderImage:_imageView.image
                            options:0
                           progress:^(NSInteger receivedSize, NSInteger expectedSize){
                               if (expectedSize > 0) {
                                   loadProgressView.progressPercentValue = ((GLfloat)receivedSize)/expectedSize;
                                   [loadProgressView setNeedsDisplay];
                               }
                             }
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                              //weakSelf.minimumZoomScale = 0.6;//最小缩放比例
                              //weakSelf.maximumZoomScale = 10;//最大缩放比例
                              [weakSelf adjustFrame:weakSelf.imageView.frame withAnimate:NO];
                              //移除进度条
                              [loadProgressView removeFromSuperview];
                          }];
    
}
#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.3 animations:^{
        _imageView.frame = _srcImageRect;
        
        // 通知代理
        if ([self.imageDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
            [self.imageDelegate photoViewSingleTap:self];
        }
    } completion:^(BOOL finished) {
        
        // 通知代理
        if ([self.imageDelegate respondsToSelector:@selector(photoViewHidden:)]) {
            [self.imageDelegate photoViewHidden:self];
        }
    }];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {

    CGPoint touchPoint = [tap locationInView:self];
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	}
}


#pragma mark -
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
