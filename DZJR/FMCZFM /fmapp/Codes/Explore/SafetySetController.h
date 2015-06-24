//
//  SafetySetController.h
//  fmapp
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "FMViewController.h"

typedef enum  {
    SafetySetupStyle = 1,          /**< UserOutOfDate = 1,安全管理*/
    HelpCenterStyle = 2,           /**< 帮助中心*/
}ViewOperationStyle;

@interface SafetySetController : FMViewController

-(id)initWithButtonStyle:(ViewOperationStyle)viweStyle;

@end
