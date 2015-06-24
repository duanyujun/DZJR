//
//  HTTPClient+MeModulesSetup.m
//  fmapp
//
//  Created by 张利广 on 14-5-15.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "HTTPClient+MeModulesSetup.h"

@implementation HTTPClient (MeModulesSetup)

- (AFHTTPRequestOperation *)getAboutUsWithcompletion:(WebAPIRequestCompletionBlock)completion
{
    return [self postPath:KAboutUsURL parameters:nil completion:completion];
  
}
- (AFHTTPRequestOperation *)getUserSetupPersonalPasswordWithUserId:(NSString *)m_userID
                                                      withPassword:(NSString *)m_password
                                                        withnewPwd:(NSString *)m_newPwd
                                               withConfirmPassword:(NSString *)m_confirmPassword
                                                        completion:(WebAPIRequestCompletionBlock)completion
{
    
    
    NSDictionary *parameters = @{@"user_id": m_userID,
                                 @"nowpassword":m_password,
                                 @"newpassword":m_newPwd,
                                 @"newpassword1":m_confirmPassword};
    return [self postPath:KMeSetupPasswordURL
               parameters:parameters
               completion:completion];
    

}

@end
