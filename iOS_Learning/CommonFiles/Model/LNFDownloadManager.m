//
//  LNFDownloadManager.m
//  iOS_Learning
//
//  Created by MrLiu on 2018/11/23.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import "LNFDownloadManager.h"

@implementation LNFDownloadManager

/** 下载Text文件中链接文件 */
+ (void)downloadFilesFromTextURLs
{
    NSArray<NSString *> *songOriginLinkList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"" ofType:@"txt"]];
    NSMutableArray<NSString *> *downloadLinkList = [NSMutableArray array];
    NSMutableArray<NSString *> *idList = [NSMutableArray array];
    NSMutableArray<NSString *> *nameList = [NSMutableArray array];
    for (NSInteger i = 0; i < songOriginLinkList.count; i++) {
        NSString *originLinkStr = songOriginLinkList[i];
        NSArray<NSString *> *components_getId = [originLinkStr componentsSeparatedByString:@"="];
        NSString *idStr = components_getId.lastObject;
        NSArray<NSString *> *components_getName = [originLinkStr componentsSeparatedByString:@"|"];
        NSString *nameStr = components_getName.firstObject;
        NSString *downloadStr = [NSString stringWithFormat:@"URL+%@", idStr ? : @""];
        [downloadLinkList addObject:downloadStr];
        [idList addObject:idStr];
        [nameList addObject:nameStr];
    }
    NSMutableArray<NSBlockOperation *> *blockOperationList = [NSMutableArray array];
    for (NSInteger i = 0; i < downloadLinkList.count; i++) {
        NSString *downloadStr = downloadLinkList[i];
        NSBlockOperation *tempBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_semaphore_t semaphore_download = dispatch_semaphore_create(0);
            [[LNFNetworking shareInstance] downloadFileWithRequestUrl:downloadStr destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSString *filePath = [kLNFSanboxDirectoriesPath_Caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", nameList[i] ? : idList[i]]];
                NSURL *fileURL = [NSURL fileURLWithPath:filePath];
                return fileURL;
            } progress:^(NSProgress * _Nullable downloadProgress) {
                kLNFLog(@"---->>>>%.1f", downloadProgress.completedUnitCount / 1.0 / downloadProgress.totalUnitCount);
            } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                dispatch_semaphore_signal(semaphore_download);
            }];
            dispatch_semaphore_wait(semaphore_download, DISPATCH_TIME_FOREVER);
        }];
        [blockOperationList addObject:tempBlockOperation];
    }
    
    NSOperationQueue *childDownloadQueue = [[NSOperationQueue alloc] init];
    for (int i = 0; i < blockOperationList.count; i++) {
        if (i < blockOperationList.count - 1) {
            NSBlockOperation *blockOperation_1 = blockOperationList[i];
            NSBlockOperation *blockOperation_2 = blockOperationList[i + 1];
            [blockOperation_2 addDependency:blockOperation_1];
        }
    }
    [childDownloadQueue addOperations:blockOperationList waitUntilFinished:NO];
}

@end
