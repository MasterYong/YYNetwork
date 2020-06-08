//
//  YYAFHTTPSessionManager.h
//  YYUniversalApp
//
//  Created by 杨世擎 on 2019/9/10.
//  Copyright © 2019 YSQ. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,HTTPRequestThreadType){
    /**默认回到主线程*/
    HTTPRequestThreadType_Main = 0,
    /**默认回到子线程*/
    HTTPRequestThreadType_Child,
};
@interface YYAFHTTPSessionManager : AFHTTPSessionManager
+ (instancetype)HTTPSessionManagerWithRequestThreadType:(HTTPRequestThreadType)type;
+ (void)cancelAFNetWork;
@end

NS_ASSUME_NONNULL_END 
