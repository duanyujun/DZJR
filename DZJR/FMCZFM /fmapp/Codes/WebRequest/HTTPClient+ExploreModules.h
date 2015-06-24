//
//  HTTPClient+ExploreModules.h
//  fmapp
//
//  Created by 张利广 on 14-5-28.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "HTTPClient.h"


@interface HTTPClient (ExploreModules)

- (AFHTTPRequestOperation *)getLetterId:(NSString *)letterId
                            letterStyle:(NSString *)style
                                  pageIndex:(NSUInteger)pageIndex
                                   pageSize:(NSUInteger)pageSize
                                 completion:(WebAPIRequestCompletionBlock)completion;
- (AFHTTPRequestOperation *)getShouyiquxianWithUserId:(NSString *)userId
                             completion:(WebAPIRequestCompletionBlock)completion;

- (AFHTTPRequestOperation *)getMyShouyiWithUserId:(NSString *)userId
                                     WithUserName:(NSString *)userName
                                           completion:(WebAPIRequestCompletionBlock)completion;

///实名认证获取数据
- (AFHTTPRequestOperation *)getAuthenticateWithUserId:(NSString *)userId
                                                    completion:(WebAPIRequestCompletionBlock)completion;
///实名认证提交数据
- (AFHTTPRequestOperation *)AuthenticateWithUserId:(NSString *)userId
                                      withUserName:(NSString *)userName
                                    WithUserIdCard:(NSString *)userIdCard
                                        completion:(WebAPIRequestCompletionBlock)completion;

- (AFHTTPRequestOperation *)getRongZiQiXianWithcompletion:(WebAPIRequestCompletionBlock)completion;

- (AFHTTPRequestOperation *)getRongZiFangShiWithcompletion:(WebAPIRequestCompletionBlock)completion;

- (AFHTTPRequestOperation *)borrowWithUserId:(NSDictionary *)dic
                                           completion:(WebAPIRequestCompletionBlock)completion;
- (AFHTTPRequestOperation *)FeedBackWithUserId:(NSDictionary *)dic
                                  completion:(WebAPIRequestCompletionBlock)completion;

- (AFHTTPRequestOperation *)DidReadMessageId:(NSString *)messageId
                                    completion:(WebAPIRequestCompletionBlock)completion;

@end
