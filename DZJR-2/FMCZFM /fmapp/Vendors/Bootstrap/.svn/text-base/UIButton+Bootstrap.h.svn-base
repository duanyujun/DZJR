//
//  UIButton+Bootstrap.h
//  UIButton+Bootstrap
//
//  Created by Oskar Groth on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"
@interface UIButton (Bootstrap)
-(void)bootstrapStyle;
-(void)defaultStyle;
-(void)primaryStyle;
-(void)successStyle;
-(void)infoStyle;
-(void)warningStyle;
-(void)dangerStyle;
-(void)grayStyle;
-(void)tranStyle;
//===============================================================
//FONT图标+文字
- (void)addAwesomeIcon:(FMIconFont)icon beforeTitle:(BOOL)before;
//FONT图标
- (void)setAwesomeIcon:(FMIconFont)icon;
//无边框，无底色普通的button
-(void)simpleButtonWithImageColor:(UIColor* )color;
//带边框，无底色button
-(void)frameButtonWithImageColor:(UIColor* )color;
//无边框，有底色button
-(void)solidButtonWithImageColor:(UIColor* )color
                       backgroud:(UIColor* )bkColor
              backgoundHighlight:(UIColor* )bkColorHighlight;
@end
