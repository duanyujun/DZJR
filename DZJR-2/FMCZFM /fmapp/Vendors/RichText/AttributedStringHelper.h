//
//  AttributedStringHelper.h
//  CoreTextDemo
//
//  Created by MaYiming on 13-11-18.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttributedStringHelper : NSObject

- (NSAttributedString *) getAttributedStringWithNSString:(NSString *) str textColor:(UIColor *)textColor;

- (CGFloat) heightForString:(NSString *) string withWidth:(CGFloat)inWidth;

-(void)initStringSystemFontOfSize:(CGFloat )stringFont withSetupFont:(BOOL)setFontBool;

@end
