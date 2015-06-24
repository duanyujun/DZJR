//
//  UITileView.h
//  fmapp
//
//  Created by lyh on 14-5-5.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITileViewDelegate <NSObject>
- (void)didTileViewTouched:(NSUInteger)tag;
@end

@interface UITileView : UIView

@property (weak, nonatomic) id<UITileViewDelegate> delegate;

//初始化TILE
- (id) initWithFrame:(CGRect)frame
               title:(NSString *)titleText
             bkColor:(UIColor *)backgroundColor
             andIcon:(UIImage *)icon;


@end
