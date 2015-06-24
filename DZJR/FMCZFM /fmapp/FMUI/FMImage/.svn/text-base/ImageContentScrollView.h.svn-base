//
//  ImageContentScrollView.h
//  ArtAuthority
//
//  Created by Ma Yiming on 13-7-31.
//  Copyright (c) 2013年 Ma Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadProgressView.h"

@class ImageContentScrollView;

@protocol FMImageViewDelegate <NSObject>
- (void)photoViewImageFinishLoad:(ImageContentScrollView *)imageView;
- (void)photoViewSingleTap:(ImageContentScrollView *)imageView;
- (void)photoViewHidden:(ImageContentScrollView *)imageView;
@end

@interface ImageContentScrollView : UIScrollView<UIScrollViewDelegate>
{
    CGRect _srcImageRect;            //缩略图位置
}
@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) LoadProgressView *loadProgressView;
@property (nonatomic,weak)id<FMImageViewDelegate> imageDelegate;

- (void) showInitImage:(NSString*)url srcRect:(CGRect)rect withAnimate:(Boolean)bAnimate;
- (void) startLoadImageWithUrlStr:(NSString *) urlStr;

@end
