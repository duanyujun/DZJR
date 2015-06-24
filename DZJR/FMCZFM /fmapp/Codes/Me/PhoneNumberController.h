//
//  PhoneNumberController.h
//  fmapp
//
//  Created by apple on 15/3/7.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "FMViewController.h"
typedef enum  {
    UserRegisterOperationStyle = 1,     /**< UserOutOfDate = 1,开通会员*/
    UserFindPasswordStyle = 2,          /**< UserPersonalSetupPasswordStyle = 3,用户进行找回密码操作   */
}UserPhoneNumOperationStyle;

@interface PhoneNumberController : FMViewController
- (id)initWithUserOperationStyle:(UserPhoneNumOperationStyle)m_OperationStyle;

@end
