//
//  LNFNetworking.h
//  iOS_Learning
//
//  Created by mrliu on 2018/10/31.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 请求成功/失败 */
typedef void (^Success)(id _Nullable responseObject);
typedef void (^Failure)(NSError * _Nullable error);

/** 下载进度 目标文件夹 完成回调 */
typedef void(^Progress)(NSProgress * _Nullable downloadProgress);
typedef NSURL*_Nullable(^Destination)(NSURL * _Nullable targetPath, NSURLResponse * _Nullable response); // targetPath 指定文件的下载目标路径，结尾指定好文件扩展类型
typedef void(^CompletionHandler)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error);
NS_ASSUME_NONNULL_BEGIN

@interface LNFNetworking : NSObject

/** 单例创建 */
+ (LNFNetworking *)shareInstance;

/** 普通网络请求 POST */
- (void)postRequestdUrl:(NSString *)url parameters:(NSDictionary *)parameters showHUD:(BOOL)show success:(Success)success failure:(Failure)failure;
/** 普通网络请求 GET */
- (void)getRequestUrl:(NSString *)url parameters:(NSDictionary *)parameters showHUD:(BOOL)show success:(Success)success failure:(Failure)failure;

/** 下载文件 */
- (void)downloadFileWithRequestUrl:(NSString *)requestUrl destination:(Destination)destination progress:(Progress)progress completion:(CompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
