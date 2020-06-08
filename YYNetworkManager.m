//
//  YYNetworkManager.m
//  YYUniversalApp
//
//  Created by 杨世擎 on 2019/9/10.
//  Copyright © 2019 YSQ. All rights reserved.
//

#import "YYNetworkManager.h"
#import <AFNetworking.h>
//#import "YYUUIDManager.h"
@implementation YYNetworkManager
+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
#pragma mark - 开始监听网络
/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
+ (void)networkStatusWithBlock:(YYNetworkStatus)networkStatus {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(YYNetworkStatusUnknown) : nil;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(YYNetworkStatusNotReachable) : nil;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(YYNetworkStatusReachableViaWWAN) : nil;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(YYNetworkStatusReachableViaWiFi) : nil;
                    break;
            }
        }];
    });
}
+ (void)GET_Child:(NSString *)URLString parameters:(id)parameters success:(HttpRequestSuccess)success
          failure:(HttpRequestFailed)failure{
                NSString *urlStr = [NSString stringWithFormat:@"%@%@", MainInfoUrl, URLString];
                urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
               
              [[YYAFHTTPSessionManager HTTPSessionManagerWithRequestThreadType:HTTPRequestThreadType_Child]GET:urlStr parameters:parameters headers:[self header] progress:^(NSProgress * _Nonnull downloadProgress) {
              } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSLog(@"responseObject = %@",[self jsonToString:responseObject]);
                  success ? success(responseObject) : nil;
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"error = %@",error.localizedFailureReason);
                   failure ? failure(error) : nil;
              }];
             
          }

+ (void)GET_Main:(NSString *)URLString parameters:(id _Nullable)parameters success:(HttpRequestSuccess)success
         failure:(HttpRequestFailed)failure{
             NSString *urlStr = [NSString stringWithFormat:@"%@%@", MainInfoUrl, URLString];
             urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
             [[YYAFHTTPSessionManager HTTPSessionManagerWithRequestThreadType:HTTPRequestThreadType_Main]GET:urlStr parameters:parameters headers:[self header] progress:^(NSProgress * _Nonnull downloadProgress) {
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"responseObject = %@",[self jsonToString:responseObject]);
                 success ? success(responseObject) : nil;
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure ? failure(error) : nil;
             }];
            
       
}

+ (void)POST_Child:(NSString *)URLString parameters:(id _Nullable)parameters success:(HttpRequestSuccess)success
           failure:(HttpRequestFailed)failure{
           NSString *urlStr = [NSString stringWithFormat:@"%@%@", MainInfoUrl, URLString];
          
           urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
           [[YYAFHTTPSessionManager HTTPSessionManagerWithRequestThreadType:HTTPRequestThreadType_Child]POST:urlStr parameters:parameters headers:[self header] progress:^(NSProgress * _Nonnull uploadProgress) {
               
           } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"urlStr = %@",urlStr);
                      NSLog(@"responseObject = %@",[self jsonToString:responseObject]);
                success ? success(responseObject) : nil;
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               NSLog(@"error = %@",error.localizedFailureReason);
                failure ? failure(error) : nil;
           }];
}

+ (void)POST_Main:(NSString *)URLString parameters:(id _Nullable)parameters success:(HttpRequestSuccess)success
          failure:(HttpRequestFailed)failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", MainInfoUrl, URLString];
//     NSLog(@"urlStr = %@",urlStr);
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[YYAFHTTPSessionManager HTTPSessionManagerWithRequestThreadType:HTTPRequestThreadType_Main]POST:urlStr parameters:parameters headers:[self header] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"urlStr = %@",urlStr);
               NSLog(@"responseObject = %@",[self jsonToString:responseObject]);
         success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.localizedFailureReason);
         failure ? failure(error) : nil;
    }];
}
//以下是两个自由使用的请求，为了适用多个baseUrl情况
+ (void)GET_WithCanReloadRequestThreadType:(HTTPRequestThreadType)type
                                   BaseURL:(NSString *)BaseURL
                                 URLString:(NSString *)URLString
                                parameters:(id _Nullable)parameters
                                   success:(HttpRequestSuccess)success
                                   failure:(HttpRequestFailed)failure{
       NSString *urlStr = [NSString stringWithFormat:@"%@%@", BaseURL, URLString];
       urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
       [[YYAFHTTPSessionManager HTTPSessionManagerWithRequestThreadType:type]GET:urlStr parameters:parameters headers:[self header] progress:^(NSProgress * _Nonnull downloadProgress) {
           
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject = %@",[self jsonToString:responseObject]);
                  success ? success(responseObject) : nil;
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"error = %@",error.localizedFailureReason);
           failure ? failure(error) : nil;
       }];
                                       
}
+ (void)POST_WithCanReloadRequestThreadType:(HTTPRequestThreadType)type
                                    BaseURL:(NSString *)BaseURL
                                  URLString:(NSString *)URLString
                                 parameters:(id _Nullable)parameters
                                    success:(HttpRequestSuccess)success
                                    failure:(HttpRequestFailed)failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BaseURL, URLString];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[YYAFHTTPSessionManager HTTPSessionManagerWithRequestThreadType:type]POST:urlStr parameters:parameters headers:[self header] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"urlStr = %@",urlStr);
               NSLog(@"responseObject = %@",[self jsonToString:responseObject]);
         success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.localizedFailureReason);
         failure ? failure(error) : nil;
    }];
             
}

+ (void)cacelAFNetworkRequest {
    [YYAFHTTPSessionManager cancelAFNetWork];
}
/**
 *  json转字符串
 */
+ (NSString *)jsonToString:(id)data {
    if(data == nil) { return nil; }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
//动态请求头
+(NSDictionary *)header{
    if (![NSString isEmpWith:TOKEN] ) {
         NSString *token = [NSString stringWithFormat:@"%@",TOKEN];
        return @{@"UUID":SAFE_STR(@"rr"),@"accessToken":token};
    }
    return @{@"UUID":SAFE_STR(@"rr")};
}
@end
