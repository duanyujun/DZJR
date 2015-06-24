//
//  CurrentUserInformation.m
//  F103CZFW
//
//  Created by 张利广 on 13-5-21.
//  Copyright (c) 2013年 zhang liguang. All rights reserved.
//

#import "CurrentUserInformation.h"

@implementation CurrentUserInformation

//声明静态实例
static CurrentUserInformation       *userInfor = nil;

-(id)init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}
/** 获取用户本地通用数据信息
 
 *
 *  @return paras 用户信息实体类，单例模式
 */
+(CurrentUserInformation *)sharedCurrentUserInfo{
    
    @synchronized(self){
        if (!userInfor) {
            userInfor = [[self alloc]init];
        }
    }
    return userInfor;
}
+(void)initializaionUserInformation:(NSDictionary *)userInfoDic
{
    
    Log(@"userData=%@",userInfoDic);
    CurrentUserInformation *currentUserInfo = [CurrentUserInformation sharedCurrentUserInfo];
    currentUserInfo.userName=StringForKeyInUnserializedJSONDic(userInfoDic, @"username");
    currentUserInfo.userId=StringForKeyInUnserializedJSONDic(userInfoDic, @"user_id");
    currentUserInfo.touxiang=StringForKeyInUnserializedJSONDic(userInfoDic, @"touxiang");
    currentUserInfo.licaishu=StringForKeyInUnserializedJSONDic(userInfoDic, @"licaishu");
    currentUserInfo.nich=StringForKeyInUnserializedJSONDic(userInfoDic, @"nich");
    currentUserInfo.shoujihao=StringForKeyInUnserializedJSONDic(userInfoDic, @"shoujihao");
    currentUserInfo.wexinbangdingopenid=StringForKeyInUnserializedJSONDic(userInfoDic, @"wexinbangdingopenid");
    currentUserInfo.zhenshixingming=StringForKeyInUnserializedJSONDic(userInfoDic, @"zhenshixingming");
    currentUserInfo.zongzichan=StringForKeyInUnserializedJSONDic(userInfoDic, @"zongzichan");
    currentUserInfo.zuorishouyi=StringForKeyInUnserializedJSONDic(userInfoDic, @"zuorishouyi");
    currentUserInfo.zxbao=StringForKeyInUnserializedJSONDic(userInfoDic, @"zxbao");

    
    [[NSUserDefaults standardUserDefaults] setValue:StringForKeyInUnserializedJSONDic(userInfoDic, @"touxiang") forKey:@"userLogo"];
    [[NSUserDefaults standardUserDefaults] setValue:StringForKeyInUnserializedJSONDic(userInfoDic, @"username") forKey:@"userName"];

    currentUserInfo.userLoginState=1;
}


@end
