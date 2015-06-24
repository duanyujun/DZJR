//
//  WebAPIResponse.h
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -WebAPIResponseCode(服务器WebAPI响应状态代码)
//From: 服务器端下发文档
typedef NS_ENUM(NSInteger, WebAPIResponseCode)
{

    WebAPIResponseCodeSuccess              = 0,       //服务器返回成功
    WebAPIResponseCodeFailed               = 1,       //服务器返回失败
    
    WebAPIResponseCodeNetError             =1,
    WebAPIResponseCodeParamError           =1
};

@interface WebAPIResponse : NSObject

/*  code:   表示API操作的结果状态, 见WebAPIResponseCode
 */
@property (nonatomic, assign) WebAPIResponseCode     code;

/*  codeDescription:   是对code的解释说明. 文本内容几乎都是由服务器端返回
 */
@property (nonatomic, strong) NSString  *codeDescription;

/*  responseObject:    服务器返回的数据对象
 */
@property (nonatomic, strong) NSDictionary  *responseObject;

/*
 successedResponse
 返回code==WebAPIResponseCodeSuccess的WebAPIResponseCode对象
 */
+ (id)successedResponse;


/*
 invalidArgumentsResonse
 返回code==WebAPIResponseCodeParamError的WebAPIResponseCode对象
 */
+ (id)invalidArgumentsResonse;

+ (id)responseWithCode:(WebAPIResponseCode)code;
+ (id)responseWithCode:(WebAPIResponseCode)code description:(NSString *)codeDescription;


/*
//根据返回JSON数据，构建response
 */
+ (id)responseWithUnserializedJSONDic:(id)returnData;

@end
