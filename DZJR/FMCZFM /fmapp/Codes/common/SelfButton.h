//
//  SelfButton.h
//  fmapp
//
//  Created by apple on 15/2/26.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfButton : UIButton

-(id)initWithImageStr:(NSString *)imageStr AndWithTitle:(NSString *)title AndWithBtnTag:(NSInteger)tag;

-(id)initWithTitle:(NSString *)title AndWithBtnTag:(NSInteger)tag;

-(id)initWithHelpCenterTitle:(NSString *)title AndWithBtnTag:(NSInteger)tag;

@end
