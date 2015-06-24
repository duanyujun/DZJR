//
//  CommonSelectController.h
//  fmapp
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "FMViewController.h"

@protocol selectCodeDelegate <NSObject>


- (void)codeSelectedSucceedWithselectDic:(NSDictionary *)selectDic andTitle:(NSString *)titleStr;


@end

@interface CommonSelectController : FMViewController

@property (nonatomic,weak)id<selectCodeDelegate>  delegate;

-(id)initWithDataArr:(NSArray *)dataArr WithTltle:(NSString *)title;
@end
