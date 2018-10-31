//
//  LNFNetworking.h
//  iOS_Learning
//
//  Created by mrliu on 2018/10/31.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 下载进度 目标文件夹 完成回调 */
typedef void(^Progress)(NSProgress * _Nullable downloadProgress);
typedef NSURL*(^Destination)(NSURL *targetPath, NSURLResponse *response); // targetPath 指定文件的下载目标路径，结尾指定好文件扩展类型
typedef void(^CompletionHandler)(NSURLResponse *response, NSURL *filePath, NSError *error);
NS_ASSUME_NONNULL_BEGIN

@interface LNFNetworking : NSObject

/** 单例创建 */
+ (LNFNetworking *)shareInstance;

/** 下载文件 */
- (void)downloadFileWithRequestUrl:(NSString *)requestUrl destination:(Destination)destination progress:(Progress)progress completion:(CompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
