//
//  HTTPClient+ExploreModules.m
//  fmapp
//
//  Created by 张利广 on 14-5-28.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "HTTPClient+ExploreModules.h"

@implementation HTTPClient (ExploreModules)

- (AFHTTPRequestOperation *)getLetterId:(NSString *)letterId
                            letterStyle:(NSString *)style
                              pageIndex:(NSUInteger)pageIndex
                               pageSize:(NSUInteger)pageSize
                             completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageIndex], kDataKeyPageIndex, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageSize], kDataKeyPageSize, parameters);
    AddObjectForKeyIntoDictionary(letterId, @"user_id", parameters);
    AddObjectForKeyIntoDictionary(style, @"zhuangtai", parameters);
    
        return [self postPath:KletterURL
                   parameters:parameters
                   completion:completion];

}
- (AFHTTPRequestOperation *)getShouyiquxianWithUserId:(NSString *)userId
                                           completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary(userId, @"user_id", parameters);
    return [self postPath:KQuxianURL
               parameters:parameters
               completion:completion];
}
- (AFHTTPRequestOperation *)getMyShouyiWithUserId:(NSString *)userId
                                     WithUserName:(NSString *)userName
                                       completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary(userId, @"user_id", parameters);
    AddObjectForKeyIntoDictionary(userId, @"user_name", parameters);
    return [self postPath:KMyShouYiURL
               parameters:parameters
               completion:completion];
 
}
- (AFHTTPRequestOperation *)AuthenticateWithUserId:(NSString *)userId
                                    withUserName:(NSString *)userName
                                    WithUserIdCard:(NSString *)userIdCard
                                        completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary(userId, @"user_id", parameters);
    AddObjectForKeyIntoDictionary(userName, @"zhenshixingming", parameters);
    AddObjectForKeyIntoDictionary(userIdCard, @"shenfenzhenghao", parameters);
    return [self postPath:KUserPostZhenshi
               parameters:parameters
               completion:completion];

}
- (AFHTTPRequestOperation *)getAuthenticateWithUserId:(NSString *)userId
                                        completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary(userId, @"user_id", parameters);
    return [self postPath:KUserGetZhenshi
               parameters:parameters
               completion:completion];

}

- (AFHTTPRequestOperation *)getRongZiQiXianWithcompletion:(WebAPIRequestCompletionBlock)completion
{
    return [self postPath:KRongZiQiXianURL
               parameters:nil
               completion:completion];

}

- (AFHTTPRequestOperation *)getRongZiFangShiWithcompletion:(WebAPIRequestCompletionBlock)completion
{
    return [self postPath:KRongZiFangShiURL
               parameters:nil
               completion:completion];
 
}

- (AFHTTPRequestOperation *)borrowWithUserId:(NSDictionary *)dic
                                  completion:(WebAPIRequestCompletionBlock)completion
{
    return [self postPath:KRongZiFangShiURL
               parameters:dic
               completion:completion];
 
}
- (AFHTTPRequestOperation *)FeedBackWithUserId:(NSDictionary *)dic
                                    completion:(WebAPIRequestCompletionBlock)completion
{
    return [self postPath:KFeedBackURL
               parameters:dic
               completion:completion];
}
- (AFHTTPRequestOperation *)DidReadMessageId:(NSString *)messageId
                                  completion:(WebAPIRequestCompletionBlock)completion
{
    
    NSDictionary *parameters=@{@"mess_id":messageId};
    return [self postPath:KDidMessageURL
               parameters:parameters
               completion:completion];
}

@end
