//
//  HTTPClient+Interaction.m
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//

#import "HTTPClient+RoadCondition.h"

@implementation HTTPClient (RoadCondition)

- (AFHTTPRequestOperation *)getFirstViewTopImagesWithcompletion:(WebAPIRequestCompletionBlock)completion
{
    return [self postPath:KLunBoPicURL
               parameters:nil
               completion:completion];
}

@end
