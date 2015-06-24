//
//  HTTPClient+Interaction.h
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//

#import "HTTPClient.h"

@interface HTTPClient (RoadCondition)

///首页轮播
- (AFHTTPRequestOperation *)getFirstViewTopImagesWithcompletion:(WebAPIRequestCompletionBlock)completion;

@end
