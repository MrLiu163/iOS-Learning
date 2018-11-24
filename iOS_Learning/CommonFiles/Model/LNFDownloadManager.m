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
+ (void)downloadMP3FilesFromTextURLs
{
    NSArray<NSString *> *songOriginLinkList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SongList" ofType:@"txt"]];
    NSMutableArray<NSString *> *downloadLinkList = [NSMutableArray array];
    NSMutableArray<NSString *> *idList = [NSMutableArray array];
    NSMutableArray<NSString *> *nameList = [NSMutableArray array];
    for (NSInteger i = 0; i < songOriginLinkList.count; i++) {
        NSString *originLinkStr = songOriginLinkList[i];
        NSArray<NSString *> *components_getId = [originLinkStr componentsSeparatedByString:@"="];
        NSString *idStr = components_getId.lastObject;
        NSArray<NSString *> *components_getName = [originLinkStr componentsSeparatedByString:@"|"];
        NSString *nameStr = components_getName.firstObject;
        NSString *downloadPrefixStr = @"";
        NSString *downloadStr = [NSString stringWithFormat:@"%@?id=%@.mp3", downloadPrefixStr, idStr ? : @""];
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
                kLNFLog(@"---->>>>已完成 %.2f，%.2fM，共%.2fM", downloadProgress.completedUnitCount / 1.0 / downloadProgress.totalUnitCount, downloadProgress.completedUnitCount / 1.0 / 1000 / 1000, downloadProgress.totalUnitCount/ 1.0 / 1000 / 1000);
            } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                if (error) {
                    kLNFLog(@"---->>>>%@", @"下载出错");
                }
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

/** 下载Text文件中MV链接文件 */
+ (void)downloadMVFilesFromTextURLs
{
    NSArray<NSString *> *mvOriginLinkList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MVList" ofType:@"txt"]];
    NSMutableArray<NSString *> *detailInfoLinkList = [NSMutableArray array];
    NSMutableArray<NSString *> *idList = [NSMutableArray array];
    NSMutableArray<NSString *> *nameList = [NSMutableArray array];
    for (NSInteger i = 0; i < mvOriginLinkList.count; i++) {
        NSString *originLinkStr = mvOriginLinkList[i];
        NSArray<NSString *> *components_getId = [originLinkStr componentsSeparatedByString:@"="];
        NSString *idStr = components_getId.lastObject;
        NSArray<NSString *> *components_getName = [originLinkStr componentsSeparatedByString:@"|"];
        NSString *nameStr = components_getName.firstObject;
        NSString *detailInfoPrefixStr = @"";
        NSString *detailInfoStr = [NSString stringWithFormat:@"%@?id=%@&type=mp4", detailInfoPrefixStr, idStr ? : @""];
        [detailInfoLinkList addObject:detailInfoStr];
        [idList addObject:idStr];
        [nameList addObject:nameStr];
    }
    NSMutableArray<NSBlockOperation *> *blockOperationList = [NSMutableArray array];
    for (NSInteger i = 0; i < detailInfoLinkList.count; i++) {
        NSString *detailInfoStr = detailInfoLinkList[i];
        NSBlockOperation *tempBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
            
            dispatch_semaphore_t semaphore_getInfo = dispatch_semaphore_create(0);
            __block NSString *downloadStr = @"";
            [[LNFNetworking shareInstance] getRequestUrl:detailInfoStr parameters:@{} showHUD:NO success:^(id  _Nullable responseObject) {
                
                NSDictionary *downloadLinkDict = responseObject[@"data"][@"brs"];
                downloadStr = downloadLinkDict.allValues.lastObject;
                dispatch_semaphore_signal(semaphore_getInfo);
            } failure:^(NSError * _Nullable error) {
                dispatch_semaphore_signal(semaphore_getInfo);
            }];
            dispatch_semaphore_wait(semaphore_getInfo, DISPATCH_TIME_FOREVER);
            
            if (downloadStr.length) {
                dispatch_semaphore_t semaphore_download = dispatch_semaphore_create(0);
                [[LNFNetworking shareInstance] downloadFileWithRequestUrl:downloadStr destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    NSString *filePath = [kLNFSanboxDirectoriesPath_Caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", nameList[i] ? : idList[i]]];
                    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
                    return fileURL;
                } progress:^(NSProgress * _Nullable downloadProgress) {
                    kLNFLog(@"---->>>>已完成 %.2f，%.2fM，共%.2fM", downloadProgress.completedUnitCount / 1.0 / downloadProgress.totalUnitCount, downloadProgress.completedUnitCount / 1.0 / 1000 / 1000, downloadProgress.totalUnitCount/ 1.0 / 1000 / 1000);
                } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    if (error) {
                        kLNFLog(@"---->>>>%@", @"下载出错");
                    }
                    dispatch_semaphore_signal(semaphore_download);
                }];
                dispatch_semaphore_wait(semaphore_download, DISPATCH_TIME_FOREVER);
            } else {
                kLNFLog(@"---->>>>%@", @"未获取到链接");
            }
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
