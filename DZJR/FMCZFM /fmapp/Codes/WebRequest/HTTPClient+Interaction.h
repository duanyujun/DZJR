//
//  HTTPClient+Interaction.h
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//

#import "HTTPClient.h"

@interface HTTPClient (Interaction)

- (AFHTTPRequestOperation *)getQuestionDateType:(NSInteger)dateType
                                    projectType:(NSUInteger)projectType
                                      pageIndex:(NSUInteger)pageIndex
                                       pageSize:(NSUInteger)pageSize
                                     completion:(WebAPIRequestCompletionBlock)completion;

- (AFHTTPRequestOperation *)getQuestionId:(NSString *)projectId
                                 completion:(WebAPIRequestCompletionBlock)completion;


- (AFHTTPRequestOperation *)getClaimAreaMoney:(NSUInteger)money
                         withEndDate:(NSInteger)endDate
                           withStyle:(NSInteger)style
                           withTitle:(NSInteger)title
                                  pageIndex:(NSUInteger)pageIndex
                                   pageSize:(NSUInteger)pageSize
                                 completion:(WebAPIRequestCompletionBlock)completion;

- (AFHTTPRequestOperation *)getClaimId:(NSString *)claimId
                               completion:(WebAPIRequestCompletionBlock)completion;

- (AFHTTPRequestOperation *)getClaimAreaUserId:(NSString *)userId
                                  withProject:(NSInteger)projectType
                                    withTouzi:(NSInteger)TouziType
                                    withZhuanrang:(NSInteger)zhanrangType
                                    pageIndex:(NSUInteger)pageIndex
                                     pageSize:(NSUInteger)pageSize
                                   completion:(WebAPIRequestCompletionBlock)completion;


///大众众筹
- (AFHTTPRequestOperation *)getZhongChouListType:(NSUInteger)type
                                  pageIndex:(NSUInteger)pageIndex
                                   pageSize:(NSUInteger)pageSize
                                 completion:(WebAPIRequestCompletionBlock)completion;

@end