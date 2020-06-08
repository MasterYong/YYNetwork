//
//  YYNetworkManager.h
//  YYUniversalApp
//
//  Created by 杨世擎 on 2019/9/10.
//  Copyright © 2019 YSQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYAFHTTPSessionManager.h"
NS_ASSUME_NONNULL_BEGIN
#ifndef YIsNetwork
#define YIsNetwork     [YYNetworkManager isNetwork]  // 一次性判断是否有网的宏
#endif

#ifndef YIsWWANNetwork
#define YIsWWANNetwork [YYNetworkManager isWWANNetwork]  // 一次性判断是否为手机网络的宏
#endif

#ifndef YIsWiFiNetwork
#define YIsWiFiNetwork [YYNetworkManager isWiFiNetwork]  // 一次性判断是否为WiFi网络的宏
#endif

/**
网络请求成功
 */
#define NetWorkSucceed [responseObject[@"code"] integerValue] == 200

typedef NS_ENUM(NSUInteger, YYNetworkStatusType) {
    /** 未知网络*/
    YYNetworkStatusUnknown,
    /** 无网络*/
    YYNetworkStatusNotReachable,
    /** 手机网络*/
    YYNetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    YYNetworkStatusReachableViaWiFi
};
/** 请求成功的Block */
typedef void(^HttpRequestSuccess)(id responseObject);

/** 请求失败的Block */
typedef void(^HttpRequestFailed)(NSError *error);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^HttpProgress)(NSProgress *progress);

/** 网络状态的Block*/
typedef void(^YYNetworkStatus)(YYNetworkStatusType status);

@interface YYNetworkManager : NSObject
/**
 有网YES, 无网:NO
 */
+ (BOOL)isNetwork;
/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(YYNetworkStatus)networkStatus;
/**
 *  GET请求,回到子线程
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)GET_Child:(NSString *)URLString parameters:(id _Nullable)parameters success:(HttpRequestSuccess)success
         failure:(HttpRequestFailed)failure;
/**
 *  GET请求,回到主线程
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)GET_Main:(NSString *)URLString parameters:(id _Nullable)parameters success:(HttpRequestSuccess)success
         failure:(HttpRequestFailed)failure;
/**
 *  POST请求,回到子线程
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)POST_Child:(NSString *)URLString parameters:(id _Nullable)parameters success:(HttpRequestSuccess)success
          failure:(HttpRequestFailed)failure;
/**
 *  POST请求,回到主线程
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)POST_Main:(NSString *)URLString parameters:(id _Nullable)parameters success:(HttpRequestSuccess)success
          failure:(HttpRequestFailed)failure;

/**
 *  GET请求
 *
 * @param type  线程类型 主线程/子线程
 *  @param BaseURL    主域名地址
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)GET_WithCanReloadRequestThreadType:(HTTPRequestThreadType)type
                                    BaseURL:(NSString *)BaseURL
                                  URLString:(NSString *)URLString
                                 parameters:(id _Nullable)parameters
                                    success:(HttpRequestSuccess)success
/**
* POST请求
*
* @param type  线程类型 主线程/子线程
*  @param BaseURL    主域名地址
*  @param URLString  请求地址
*  @param parameters 请求参数
*  @param success    请求成功的回调
*  @param failure    请求失败的回调
*/                                   failure:(HttpRequestFailed)failure;
+ (void)POST_WithCanReloadRequestThreadType:(HTTPRequestThreadType)type
                                    BaseURL:(NSString *)BaseURL
                                    URLString:(NSString *)URLString
                                    parameters:(id _Nullable)parameters
                                    success:(HttpRequestSuccess)success
                                    failure:(HttpRequestFailed)failure;
/**
 取消所有HTTP请求
 */
+ (void)cacelAFNetworkRequest;
@end

NS_ASSUME_NONNULL_END
