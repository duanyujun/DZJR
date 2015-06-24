//
//  HTTPClient+MeModulesSetup.h
//  fmapp
//
//  Created by 张利广 on 14-5-15.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "HTTPClient.h"

@interface HTTPClient (MeModulesSetup)

///关于我们

- (AFHTTPRequestOperation *)getAboutUsWithcompletion:(WebAPIRequestCompletionBlock)completion;


///修改密码
- (AFHTTPRequestOperation *)getUserSetupPersonalPasswordWithUserId:(NSString *)m_userID
                                                      withPassword:(NSString *)m_password
                                                        withnewPwd:(NSString *)m_newPwd
                                               withConfirmPassword:(NSString *)m_confirmPassword
                                                        completion:(WebAPIRequestCompletionBlock)completion;


@end
