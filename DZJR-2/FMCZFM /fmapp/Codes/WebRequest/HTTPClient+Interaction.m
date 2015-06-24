//
//  HTTPClient+Interaction.m
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//

#import "HTTPClient+Interaction.h"

@implementation HTTPClient (Interaction)

- (AFHTTPRequestOperation *)getQuestionDateType:(NSInteger)dateType
                                  projectType:(NSUInteger)projectType
                                  pageIndex:(NSUInteger)pageIndex
                                   pageSize:(NSUInteger)pageSize
                                 completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageIndex], kDataKeyPageIndex, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageSize], kDataKeyPageSize, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:dateType], @"qixian", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:projectType], @"leixing", parameters);

        return [self postPath:KLendLiebiaoURL
                   parameters:parameters
                   completion:completion];
}
- (AFHTTPRequestOperation *)getQuestionId:(NSString *)projectId
                               completion:(WebAPIRequestCompletionBlock)completion
{
    if ([projectId length]<=0) {
        return nil;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary(projectId, @"jie_id", parameters);
    return [self postPath:KProjectDetailURL
               parameters:parameters
               completion:completion];

}
- (AFHTTPRequestOperation *)getClaimAreaMoney:(NSUInteger)money
                         withEndDate:(NSInteger)endDate
                           withStyle:(NSInteger)style
                           withTitle:(NSInteger)title
                           pageIndex:(NSUInteger)pageIndex
                            pageSize:(NSUInteger)pageSize
                          completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageIndex], kDataKeyPageIndex, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageSize], kDataKeyPageSize, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:money], @"jinershu", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:endDate], @"qixianshu", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:style], @"shouyishu", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:title], @"leixingshu", parameters);
    

    return [self postPath:KLendZhaiquanURL
               parameters:parameters
               completion:completion];

 
}
- (AFHTTPRequestOperation *)getClaimId:(NSString *)claimId
                            completion:(WebAPIRequestCompletionBlock)completion
{
    if ([claimId length]<=0) {
        return nil;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary(claimId, @"zhai_id", parameters);
    return [self postPath:KClaimAreaURL
               parameters:parameters
               completion:completion];
 
}
- (AFHTTPRequestOperation *)getClaimAreaUserId:(NSString *)userId
                                   withProject:(NSInteger)projectType
                                     withTouzi:(NSInteger)TouziType
                                 withZhuanrang:(NSInteger)zhanrangType
                                     pageIndex:(NSUInteger)pageIndex
                                      pageSize:(NSUInteger)pageSize
                                    completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageIndex], kDataKeyPageIndex, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageSize], kDataKeyPageSize, parameters);
    AddObjectForKeyIntoDictionary(userId, @"user_id", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:projectType], @"xmlx", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:TouziType], @"txlx", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:zhanrangType], @"zrzt", parameters);
    
    
    return [self postPath:KMyClaimURL
               parameters:parameters
               completion:completion];
 
}


- (AFHTTPRequestOperation *)getZhongChouListType:(NSUInteger)type
                                       pageIndex:(NSUInteger)pageIndex
                                        pageSize:(NSUInteger)pageSize
                                      completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageIndex], kDataKeyPageIndex, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageSize], kDataKeyPageSize, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithInteger:type], @"paixu", parameters);
    AddObjectForKeyIntoDictionary(@"0", @"leixing", parameters);
    
    //    if (type==0) {
    return [self postPath:KZhongChouURL
               parameters:parameters
               completion:completion];
}

@end
