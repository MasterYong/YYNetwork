//
//  YYAFHTTPSessionManager.m
//  YYUniversalApp
//
//  Created by 杨世擎 on 2019/9/10.
//  Copyright © 2019 YSQ. All rights reserved.
//

#import "YYAFHTTPSessionManager.h"

@implementation YYAFHTTPSessionManager

+ (instancetype)HTTPSessionManagerWithRequestThreadType:(HTTPRequestThreadType)type
{
    if (type == HTTPRequestThreadType_Main)
    {
        return [self HTTPSessionManager_NoBaseURL_Main];
    }
    else if (type == HTTPRequestThreadType_Child)
    {
        return [self HTTPSessionManager_NoBaseURL_ChildThread];
    }
    
    return [self HTTPSessionManager_NoBaseURL_Main];
}
+ (instancetype)HTTPSessionManager_NoBaseURL_Main
{
    static YYAFHTTPSessionManager *HTTPSessionManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        HTTPSessionManager = [[YYAFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        
        [self setRequestHeader:HTTPSessionManager];
        //        [self setHttpsCer:HTTPSessionManager];
    });
    return HTTPSessionManager;
}
//默认回到子线程
+ (instancetype)HTTPSessionManager_NoBaseURL_ChildThread
{
    static YYAFHTTPSessionManager *HTTPSessionManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        HTTPSessionManager = [[YYAFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        HTTPSessionManager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        HTTPSessionManager.operationQueue.maxConcurrentOperationCount = 3;
        [self setRequestHeader:HTTPSessionManager];
    });
    
    return HTTPSessionManager;
}
// 设置请求头 默认
+ (void)setRequestHeader:(YYAFHTTPSessionManager *)tools
{
    
    tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",nil];
    [tools.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    tools.requestSerializer.timeoutInterval = 20.f;
    [tools.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [tools.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [tools.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];  // 此处设置content-Type生效了，
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *currentBundleId = infoDict[@"CFBundleIdentifier"];
    if (currentBundleId) {
        [tools.requestSerializer setValue:currentBundleId forHTTPHeaderField:@"pkgName"];
    }
    [tools.requestSerializer setValue:SoftwareVersion forHTTPHeaderField:@"versionName"];//app版本
    [tools.requestSerializer setValue:@"ios" forHTTPHeaderField:@"platform"];
    [tools.requestSerializer setValue:KSID forHTTPHeaderField:@"appId"];
    
}

+ (void)cancelAFNetWork {
    //    [self->tasks makeObjectsPerformSelector:@selector(cancel)];
    static YYAFHTTPSessionManager *HTTPSessionManager;
    [HTTPSessionManager.tasks makeObjectsPerformSelector:@selector(cancelAll)];
}
@end
