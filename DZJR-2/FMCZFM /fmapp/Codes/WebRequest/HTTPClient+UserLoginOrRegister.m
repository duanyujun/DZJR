//
//  HTTPClient+UserLoginOrRegister.m
//  fmapp
//
//  Created by 张利广 on 14-5-15.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "HTTPClient+UserLoginOrRegister.h"
#import "CurrentUserInformation.h"

@implementation HTTPClient (UserLoginOrRegister)

- (AFHTTPRequestOperation *)getUserRegisterWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber
                                                              WithType:(NSInteger)type
                                                            completion:(WebAPIRequestCompletionBlock)completion
{
    if (!IsNormalMobileNum(m_userPhoneNumber)) {
        return nil;
    }
    
    NSDictionary *parameters = @{@"tel": m_userPhoneNumber,@"leixing":[NSNumber numberWithInteger:type]};
    return [self postPath:KUserFatelcodeURL
               parameters:parameters
               completion:completion];

}
///验证手机验证码（注册时）
- (AFHTTPRequestOperation *)getUserRegisterWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber       WithCode:(NSString *)code
                                                              WithType:(NSInteger)type
                                                            completion:(WebAPIRequestCompletionBlock)completion
{
    NSDictionary *parameters = @{@"tel": m_userPhoneNumber,@"sjcode":code,@"leixing":[NSNumber numberWithInteger:type]};
    return [self postPath:KUserCktelcode
               parameters:parameters
               completion:completion];
  
}
///注册
- (AFHTTPRequestOperation *)getUserRegisterWithUserWithUserName:(NSString *)userName WithPassword:(NSString *)password WithSecondPassword:(NSString *)spassword PersonalPhoneNumber:(NSString *)m_userPhoneNumber   withRecommendPeople:(NSString *)recommendStr
                                                     completion:(WebAPIRequestCompletionBlock)completion
{
    NSDictionary *parameters=nil;
    if(IsStringEmptyOrNull(recommendStr))
    {
    parameters = @{@"user_name":userName,@"password1":password,@"password2":spassword,@"tel": m_userPhoneNumber};
    }
    else
    {
    parameters = @{@"user_name":userName,@"password1":password,@"password2":spassword,@"tel": m_userPhoneNumber,@"tuijianren":recommendStr};
    }
    return [self postPath:KUserRegisterURL
               parameters:parameters
               completion:completion];
  
}
///找回密码
- (AFHTTPRequestOperation *)getUserFindPasswordWithUserWithDic:(NSDictionary *)parameters   completion:(WebAPIRequestCompletionBlock)completion
{
    return [self postPath:KUserFindPassWordURL
               parameters:parameters
               completion:completion];
}
- (AFHTTPRequestOperation *)getUserLoginInforWithUser:(NSString *)userName
                                     withUserPassword:(NSString *)userPassword
                                           completion:(WebAPIRequestCompletionBlock)completion
{
    NSDictionary *parameters = @{@"user_name": userName,@"password":userPassword};
    return [self postPath:KUserLoginURL
               parameters:parameters
               completion:completion];
 
}

- (AFHTTPRequestOperation *)sendCodeWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber
                                                           type:(NSInteger)type
                                                     completion:(WebAPIRequestCompletionBlock)completion;

{
    NSDictionary *parameters = @{@"tel": m_userPhoneNumber,@"leixing":[NSNumber numberWithInteger:type]};
    return [self postPath:KUserFatelcodeURL
               parameters:parameters
               completion:completion];

}
- (AFHTTPRequestOperation *)confirmCodeWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber       WithCode:(NSString *)code
                                                        WithUserId:(NSString *)userId
                                                        completion:(WebAPIRequestCompletionBlock)completion
{
    NSDictionary *parameters = @{@"tel": m_userPhoneNumber,@"sjcode":code,@"user_id":userId};
    return [self postPath:KUserCkoldshoujiURL
               parameters:parameters
               completion:completion];
}
- (AFHTTPRequestOperation *)changeTelWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber       WithCode:(NSString *)code
                                                      completion:(WebAPIRequestCompletionBlock)completion
{
    NSString *userId=[CurrentUserInformation sharedCurrentUserInfo].userId;
    NSDictionary *parameters = @{@"tel": m_userPhoneNumber,@"sjcode":code,@"user_id":userId};
    return [self postPath:KUserCktelcodeURL
               parameters:parameters
               completion:completion];
}
@end
