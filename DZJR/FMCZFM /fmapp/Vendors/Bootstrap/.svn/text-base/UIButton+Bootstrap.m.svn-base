//
//  UIButton+Bootstrap.m
//  UIButton+Bootstrap
//
//  Created by Oskur on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//
#import "UIButton+Bootstrap.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+FontAwesome.h"

@implementation UIButton (Bootstrap)

-(void)bootstrapStyle{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:self.titleLabel.font.pointSize]];
}

-(void)defaultStyle{
    [self bootstrapStyle];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)primaryStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:66/255.0 green:139/255.0 blue:202/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:53/255.0 green:126/255.0 blue:189/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:51/255.0 green:119/255.0 blue:172/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)successStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:92/255.0 green:184/255.0 blue:92/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:76/255.0 green:174/255.0 blue:76/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:69/255.0 green:164/255.0 blue:84/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)infoStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:91/255.0 green:192/255.0 blue:222/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:70/255.0 green:184/255.0 blue:218/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:57/255.0 green:180/255.0 blue:211/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)warningStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:173/255.0 blue:78/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:162/255.0 blue:54/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:237/255.0 green:155/255.0 blue:67/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)dangerStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:63/255.0 blue:58/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:210/255.0 green:48/255.0 blue:51/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)grayStyle{
    [self bootstrapStyle];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]] forState:UIControlStateHighlighted];
}
-(void)tranStyle{

    [self setAdjustsImageWhenHighlighted:NO];
    [self.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:self.titleLabel.font.pointSize]];
    self.backgroundColor = [UIColor clearColor];
}

-(void)simpleButtonWithImageColor:(UIColor* )color
{
    [self setAdjustsImageWhenHighlighted:NO];
    self.backgroundColor = [UIColor clearColor];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:[self getGrayColor:color]
               forState:UIControlStateHighlighted];
}
-(void)frameButtonWithImageColor:(UIColor* )color
{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [color CGColor];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:[self getGrayColor:color]
               forState:UIControlStateHighlighted];
    
}
-(void)solidButtonWithImageColor:(UIColor* )color
                       backgroud:(UIColor* )bkColor
              backgoundHighlight:(UIColor* )bkColorHighlight
{
    [self setAdjustsImageWhenHighlighted:NO];
    self.backgroundColor = [UIColor clearColor];
    [self setBackgroundImage:[self buttonImageFromColor:bkColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[self buttonImageFromColor:bkColorHighlight] forState:UIControlStateHighlighted];

    [self setTitleColor:color forState:UIControlStateNormal];
;
}
- (void)setAwesomeIcon:(FMIconFont)icon
{
    NSString *iconString = [NSString fontAwesomeIconStringForEnum:icon];
    NSString *title = [NSString stringWithFormat:@"%@", iconString];
    
    self.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName
                                           size:self.titleLabel.font.pointSize];
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)addAwesomeIcon:(FMIconFont)icon beforeTitle:(BOOL)before
{
    NSString *iconString = [NSString fontAwesomeIconStringForEnum:icon];
    self.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName
                                           size:self.titleLabel.font.pointSize];
    
    NSString *title = [NSString stringWithFormat:@"%@", iconString];
    
    if(self.titleLabel.text) {
        if(before)
            title = [title stringByAppendingFormat:@" %@", self.titleLabel.text];
        else
            title = [NSString stringWithFormat:@"%@    %@", self.titleLabel.text, iconString];
    }
    [self setTitle:title forState:UIControlStateNormal];
}

- (UIImage *) buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIColor* )getGrayColor:(UIColor* )color
{
    CGFloat gray = 0.5;
    CGFloat a = 1.0;
    if (CGColorGetNumberOfComponents([color CGColor]) == 2) {
        const CGFloat *colorComponents = CGColorGetComponents([color CGColor]);
        gray = 0.299*colorComponents[0] + 0.587 * colorComponents[0] + 0.114*colorComponents[0];
        a = colorComponents[0];
    }
    else if (CGColorGetNumberOfComponents([color CGColor]) == 4) {
        const CGFloat * colorComponents = CGColorGetComponents([color CGColor]);
        gray = 0.299*colorComponents[0] + 0.587 * colorComponents[1] + 0.114*colorComponents[2];
        a = colorComponents[3];
    }
    gray = 1.0 - gray;
    if (gray < 0.3) {
        gray = 0.3;
    }else if(gray > 0.7){
        gray = 0.7;
    }
    return [UIColor colorWithRed:gray green:gray blue:gray alpha:a*0.6];
}
@end
