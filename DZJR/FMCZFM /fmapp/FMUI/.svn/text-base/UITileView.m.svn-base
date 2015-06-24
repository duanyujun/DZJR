//
//  UITileView.m
//  fmapp
//
//  Created by lyh on 14-5-5.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import "UITileView.h"
#import <QuartzCore/QuartzCore.h>

#define TITLE_FONT_SIZE                    14
#define kFontTileTitle                     [UIFont systemFontOfSize:TITLE_FONT_SIZE]

#define TITLE_PADDING 8.0

@interface UITileView ()

@property (nonatomic,copy)      UILabel *title;
@property (nonatomic,weak)      UIImageView *icon;
@property (nonatomic,copy)      void(^actionBlock)(void);
@end

@implementation UITileView


- (id) initWithFrame:(CGRect)frame
               title:(NSString *)titleText
             bkColor:(UIColor *)backgroundColor
             andIcon:(UIImage *)icon
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tileTapped:)]];
        
        if(backgroundColor == nil){
            self.backgroundColor = [UIColor clearColor];
        }else{
            self.backgroundColor = backgroundColor;
        }
        
        if (icon) {
            UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
            [self addSubview:iconView];
            self.icon = iconView;
        }
        if (![titleText isEqualToString:@""]) {
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = titleText;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = UITextAlignmentLeft;
            titleLabel.font = kFontTileTitle;
            [self addSubview:titleLabel];
            _title = titleLabel;
        }
    }
    return self;
}


- (void)layoutSubviews
{
    if (self.icon) {
        
        //如果图标大于view.frame进行裁剪，否则居中显示
        if (self.icon.image.size.width > self.frame.size.width ||
            self.icon.image.size.height > self.frame.size.height)
            self.contentMode = UIViewContentModeScaleAspectFill;
        else
            self.contentMode = UIViewContentModeCenter;
        
        [self.icon setFrame:CGRectMake((self.frame.size.width - self.icon.image.size.width) / 2,
                                      (self.frame.size.height - self.icon.image.size.height) /2,
                                      self.icon.image.size.width,
                                      self.icon.image.size.height)];
    }
    if (self.title) {
        
        [self.title setFrame :CGRectMake(TITLE_PADDING,
                                        self.frame.size.height - TITLE_PADDING - TITLE_FONT_SIZE,
                                        self.frame.size.width - (TITLE_PADDING * 2),
                                        TITLE_FONT_SIZE)];
    }
}


- (void)_tileTapped:(UITapGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateEnded)
        return;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2
                                               delay:0.2
                                             options: UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                                          }
                                          completion:^(BOOL finished){
                                              // DO NOTHING
                                          }];
                     }];
    
    
    
    if ([self.delegate respondsToSelector:@selector(didTileViewTouched:)]) {
        [self.delegate didTileViewTouched:self.tag];
    }
}


@end
