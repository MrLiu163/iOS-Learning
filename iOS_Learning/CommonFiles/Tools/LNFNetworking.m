//
//  LNFNetworking.m
//  iOS_Learning
//
//  Created by mrliu on 2018/10/31.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import "LNFNetworking.h"

@interface LNFNetworking ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation LNFNetworking

/** 单例创建 */
+ (LNFNetworking *)shareInstance
{
    static LNFNetworking *single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[self alloc] init];
    });
    return single;
}
- (instancetype)init
{
    if (self = [super init])
    {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 设置超时时间
        self.manager.requestSerializer.timeoutInterval = 12;
    }
    return self;
}

/** 下载文件 */
- (void)downloadFileWithRequestUrl:(NSString *)requestUrl destination:(Destination)destination progress:(Progress)progress completion:(CompletionHandler)completion;
{
    NSURL *downloadURL = [NSURL URLWithString:requestUrl];
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:downloadURL];
    NSURLSessionDownloadTask *dowloadTask = [self.manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (destination) {
            return destination(targetPath, response);
        } else {
            return nil;
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completion) {
            completion(response, filePath, error);
        }
    }];
    [dowloadTask resume];
}

@end
