//
//  HTTPClient+UserLoginOrRegister.h
//  fmapp
//
//  Created by 张利广 on 14-5-15.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "HTTPClient.h"

@interface HTTPClient (UserLoginOrRegister)
///发送验证码（注册时）
- (AFHTTPRequestOperation *)getUserRegisterWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber
                                                              WithType:(NSInteger)type
                                                            completion:(WebAPIRequestCompletionBlock)completion;
///验证手机验证码（注册时）
- (AFHTTPRequestOperation *)getUserRegisterWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber       WithCode:(NSString *)code
                                                              WithType:(NSInteger)type
                                                            completion:(WebAPIRequestCompletionBlock)completion;
///注册
- (AFHTTPRequestOperation *)getUserRegisterWithUserWithUserName:(NSString *)userName WithPassword:(NSString *)password WithSecondPassword:(NSString *)spassword PersonalPhoneNumber:(NSString *)m_userPhoneNumber   withRecommendPeople:(NSString *)recommendStr
                                                            completion:(WebAPIRequestCompletionBlock)completion;
///登录
- (AFHTTPRequestOperation *)getUserLoginInforWithUser:(NSString *)userName
                                     withUserPassword:(NSString *)userPassword
                                                                       completion:(WebAPIRequestCompletionBlock)completion;
///找回密码
- (AFHTTPRequestOperation *)getUserFindPasswordWithUserWithDic:(NSDictionary *)parameters   completion:(WebAPIRequestCompletionBlock)completion;



///修改手机

- (AFHTTPRequestOperation *)sendCodeWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber
                                                           type:(NSInteger)type
                                                            completion:(WebAPIRequestCompletionBlock)completion;

- (AFHTTPRequestOperation *)confirmCodeWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber       WithCode:(NSString *)code
                                                              WithUserId:(NSString *)userId
                                                            completion:(WebAPIRequestCompletionBlock)completion;
- (AFHTTPRequestOperation *)changeTelWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber       WithCode:(NSString *)code
                                                        completion:(WebAPIRequestCompletionBlock)completion;
@end
