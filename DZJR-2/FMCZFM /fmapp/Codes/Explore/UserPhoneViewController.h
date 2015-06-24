//
//  UserPhoneViewController.h
//  fmapp
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "FMViewController.h"
typedef enum  {
    UserBindingPhoneStyle = 1,        /**用户绑定手机号*/
    UserJiechuPhoneStyle =  2,        /*用户解除绑定 */
    UserXiugaiPhoneStyle =  3         /*用户修改手机号*/
}UserPhoneSetStyle;

@interface UserPhoneViewController : FMViewController
- (id)initWithUserOperationStyle:(UserPhoneSetStyle)m_OperationStyle;

@end
