//
//  NSAttributedString+Height.h
//  CoreTextDemo
//
//  Created by MaYiming on 13-11-18.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Height)

//根据高度获取属性文本的宽度
- (CGFloat)boundingWidthForHeight:(CGFloat)inHeight;

//根据宽度获取属性文本的高度
- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth;

@end
