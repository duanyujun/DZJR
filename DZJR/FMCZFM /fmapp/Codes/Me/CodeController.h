//
//  CodeController.h
//  fmapp
//
//  Created by apple on 15/3/7.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "FMViewController.h"
typedef enum  {
    UserRegisterCodeOperationStyle = 1,        /**< UserOutOfDate = 1,开通会员*/
    UserFindPasswordCodeStyle = 2,     /**< UserPersonalSetupPasswordStyle = 3,用户进行找回密码操作   */
}UserPhoneCodeOperationStyle;
@interface CodeController : FMViewController
- (id)initWithUserOperationStyle:(UserPhoneCodeOperationStyle)m_OperationStyle WithPhoneNumber:(NSString *)phoneNumber;
@end
