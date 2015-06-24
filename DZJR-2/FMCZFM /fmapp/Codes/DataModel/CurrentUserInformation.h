//
//  CurrentUserInformation.h
//  F103CZFW
//
//  Created by 张利广 on 13-5-21.
//  Copyright (c) 2013年 zhang liguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUserInformation : NSObject<NSCoding>

@property (nonatomic,copy)NSString       *userName;
@property (nonatomic,copy)NSString       *userId;
@property (nonatomic,copy)NSString       *licaishu;
@property (nonatomic,copy)NSString       *shoujihao;
@property (nonatomic,copy)NSString       *nich;
@property (nonatomic,copy)NSString       *wexinbangdingopenid;
@property (nonatomic,copy)NSString       *touxiang;
@property (nonatomic,copy)NSString       *zhenshixingming;
@property (nonatomic,copy)NSString       *zongzichan;
@property (nonatomic,copy)NSString       *zuorishouyi;
@property (nonatomic,copy)NSString       *zxbao;

///用户登录状态
@property (nonatomic, assign) NSInteger userLoginState;

+(CurrentUserInformation *)sharedCurrentUserInfo;

+(void)initializaionUserInformation:(NSDictionary *)userInfoDic;

@end
