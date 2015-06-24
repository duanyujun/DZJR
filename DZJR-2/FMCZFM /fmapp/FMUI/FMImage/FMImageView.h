//
//  FMImageView.h
//  FM_CZFW
//
//  Created by 张利广 on 14-4-17.
//  Copyright (c) 2014年 Ma Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FMImageClickBlock)();

@interface FMImage : NSObject
@property (nonatomic, copy) NSString    *url_thumb;    //缩略图URL
@property (nonatomic, copy) NSString    *url;          //大图URL
@property (nonatomic,assign) Boolean    isShowLarge;   //是否已显示大图
@property (nonatomic,assign) CGSize     imageSize;     //缩略图大小
@property (nonatomic,assign) Boolean    bSaved;        //是否已保存
@end

/** 扩展图片内容
 
 *@See 根据图片类别、地址字符串及图片大小设置点击后的发达效果
 *@Warning 该扩展为ARC模式下图片扩展
 **/
@interface FMImageView : UIImageView

//如果指定了clickBlock, 点击图片将不会自动变大
@property (copy) FMImageClickBlock      clickBlock;
@property (nonatomic,weak)CALayer   *    backLayer;

//从加载图片服务器图片
//isThumb = TRUE 时，点击自动放大
- (void)setServerImageWithKey:(NSString *)imageKey
                      isThumb:(Boolean)isThumb
                    holdImage:(UIImage* )holdImage;

/** 为放大图片设置图片数据内容
 
 *@param (NSString *)urlString 大图图片地址
 *@return void
 **/
- (void)setImageViewWithURL:(NSString* )imageUrl
                   largeUrl:(NSString *)largeUrl
                  holdImage:(UIImage* )holdImage;

//从图片服务器加载相册
//index 当前显示图片在相册内的索引
- (void)setAlbum:(NSArray* )imageKeyList currentIndex:(NSInteger)index;


@end