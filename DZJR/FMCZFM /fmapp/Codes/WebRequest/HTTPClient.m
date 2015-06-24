//
//  HTTPClient.m
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2013年 ETelecom. All rights reserved.
//

#import "HTTPClient.h"
#import <CommonCrypto/CommonDigest.h>
#import "CurrentUserInformation.h"

@implementation HTTPClient

//声明静态实例
+ (HTTPClient *)sharedHTTPClient
{
    static HTTPClient *_sharedHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHTTPClient = [[HTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseAPIURL]];
    });
    
    return _sharedHTTPClient;

}
+ (HTTPClient *)sharedImageClient
{
    static HTTPClient *_sharedImageClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedImageClient = [[HTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMediaServerURL]];
    });
    
    return _sharedImageClient;
    
}
- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self == nil)
        return nil;
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    //只接受JSON格式的返回数据, 向服务器传消息也用JSON数据
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"Content-Type" value:@"application/json"];
    //如果使用JSON格式请求RESTFUL API,打开此选项
    //[self setParameterEncoding:AFJSONParameterEncoding];
    
    return self;
}
- (AFHTTPRequestOperation*)getPath:(NSString *)path
                      parameters:(NSDictionary *)parameters
                      completion:(WebAPIRequestCompletionBlock)completionBlock

{
	NSURLRequest *request = [self requestWithMethod:@"GET" path:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                         parameters:parameters];
    
    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
                                    if (httpResponse.statusCode == 200) {
                                        if (completionBlock) {
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                completionBlock([WebAPIResponse responseWithUnserializedJSONDic:responseObject]);
                                            });
                                        }
                                    } else {
                                        if (completionBlock) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
                                            });
                                        }
                                    }
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    if (completionBlock) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
                                        });
                                    }
                                   }];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)postPath:(NSString *)path
                          parameters:(NSDictionary *)parameters
                          completion:(WebAPIRequestCompletionBlock)completionBlock
{
    
    
    Log(@"param is %@",parameters);
    

	NSURLRequest *request = [self requestWithMethod:@"POST" path:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                         parameters:parameters];
    
    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
                                      
                                      
                                      
                                      
                                if (httpResponse.statusCode == 200) {
                                    
                                          if (completionBlock) {
                                              

                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  completionBlock([WebAPIResponse responseWithUnserializedJSONDic:responseObject]
                                                                  );
                                              });
                                          }
                                      } else {

                                          if (completionBlock) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
                                              });
                                          }
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"Received: %@", [error localizedDescription]);
                                      if (completionBlock) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
                                              
                                              NSLog(@"error=%@",error);
                                          });
                                      }
                                  }];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}
//图片上传
- (AFHTTPRequestOperation *)imageUpload:(UIImage *)image
                              imageType:(NSString *)type
                             completion:(WebAPIRequestCompletionBlock)completionBlock
{
    //提取图片裸数据(IMAGE->JPEG)
    NSData *imageData = UIImageJPEGRepresentation(image,0.6);
    if (imageData == nil) {
        return nil;
    }
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST"
                                                                   path:[kImageUpload stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                             parameters:nil
                                              constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                [formData appendPartWithFileData:imageData
                                                                            name:@"media"
                                                                        fileName:type
                                                                        mimeType:@"image/jpeg"];
                                              }];
    
    
    
    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
                                      if (httpResponse.statusCode == 200) {
                                          if (completionBlock) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  completionBlock([WebAPIResponse responseWithUnserializedJSONDic:responseObject]);
                                              });
                                          }
                                      } else {
                                          if (completionBlock) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
                                              });
                                          }
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"Received: %@", [error localizedDescription]);
                                      if (completionBlock) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
                                          });
                                      }
                                  }];
    [self enqueueHTTPRequestOperation:operation];
    return operation;

}

#pragma mark -
#pragma mark - 音频源上传处理接口
- (AFHTTPRequestOperation *)audioUpload:(NSData *)audioData
                             completion:(WebAPIRequestCompletionBlock)completionBlock{
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST"
                                                                   path:[kImageUpload stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                             parameters:nil
                                              constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                  [formData appendPartWithFileData:audioData
                                                                              name:@"media"
                                                                          fileName:@"audio.amr"
                                                                          mimeType:@"audio/amr"];
                                              }];
    AFHTTPRequestOperation *operation =
    [self HTTPRequestOperationWithRequest:request
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
                                      if (httpResponse.statusCode == 200) {
                                          if (completionBlock) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  completionBlock([WebAPIResponse responseWithUnserializedJSONDic:responseObject]);
                                              });
                                          }
                                      } else {
                                          if (completionBlock) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
                                              });
                                          }
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"Received: %@", [error localizedDescription]);
                                      if (completionBlock) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
                                          });
                                      }
                                  }];
    [self enqueueHTTPRequestOperation:operation];
    return operation;

}
- (BOOL)isWiFiConnection
{
    return (self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi);
}
//取消当前所有AFHTTPRequestOperation
- (void)_cancelAllHTTPOperations
{
    for (NSOperation *operation in [self.operationQueue operations])
    {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]])
            continue;
        
        [operation cancel];
    }
}
@end