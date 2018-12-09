//
//  LNFDownloadManager.m
//  iOS_Learning
//
//  Created by MrLiu on 2018/11/23.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import "LNFDownloadManager.h"

/**
 * 链接文本中必须有""，否则不能解析为数组
 * 每一行中间不能出现""，会和外部包裹的""冲突
 * 文件名称中不能出现...会导致判断文件已存在
 * 文件名中不能出现使用的分隔符(=|)
 */

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

/** 下载WEB视频 */
+ (void)downloadWEBVideoFilesFromTextURLs
{
    NSArray<NSString *> *videoOriginLinkList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WEBVideoList" ofType:@"txt"]];
    NSMutableArray<NSString *> *detailInfoLinkList = [NSMutableArray array];
    NSMutableArray<NSString *> *idList = [NSMutableArray array];
    NSMutableArray<NSString *> *nameList = [NSMutableArray array];
    for (NSInteger i = 0; i < videoOriginLinkList.count; i++) {
        NSString *originLinkStr = videoOriginLinkList[i];
        NSArray<NSString *> *components_getId = [originLinkStr componentsSeparatedByString:@"="];
        NSString *idStr = components_getId.lastObject;
        NSArray<NSString *> *components_getName = [originLinkStr componentsSeparatedByString:@"|"];
        NSString *nameStr = components_getName.firstObject;
        NSString *detailInfoStr = [NSString stringWithFormat:@"#STR000#%@", idStr ? : @""]; // Combine Video Info Url
        [detailInfoLinkList addObject:detailInfoStr];
        [idList addObject:idStr];
        [nameList addObject:nameStr];
    }
    NSMutableArray<NSBlockOperation *> *blockOperationList = [NSMutableArray array];
    for (NSInteger i = 0; i < detailInfoLinkList.count; i++) {
        NSString *detailInfoStr = detailInfoLinkList[i];
        NSBlockOperation *tempBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
            
            NSString *filePath = [kLNFSanboxDirectoriesPath_Caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", nameList[i] ? : idList[i]]];
            BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (!isFileExist) {
                __block NSString *downloadStr = @"";
                NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:detailInfoStr]];
                NSString *dataStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                NSArray<NSString *> *urlComponents = [dataStr componentsSeparatedByString:@"&"];
                for (NSString *targetStr in urlComponents) {
                    if ([targetStr hasPrefix:@"#STR001#"]) { // Find Target String
                        NSString *mapInfoStr = [targetStr componentsSeparatedByString:@"="].lastObject;
                        mapInfoStr = [mapInfoStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        NSMutableArray<NSDictionary *> *videoInfoList = [NSMutableArray array];
                        NSArray<NSString *> *urlComponents = [mapInfoStr componentsSeparatedByString:@","];
                        for (NSString *urlInfoStr in urlComponents) {
                            NSArray<NSString *> *urlInfoComponents = [urlInfoStr componentsSeparatedByString:@"&"];
                            NSMutableDictionary *videoInfoDict = [NSMutableDictionary dictionary];
                            for (NSString *urlInfoComponentStr in urlInfoComponents) {
                                NSArray<NSString *> *videoInfoComponents = [urlInfoComponentStr componentsSeparatedByString:@"="];
                                NSString *keyStr = videoInfoComponents.firstObject;
                                NSString *valueStr = videoInfoComponents.lastObject;
                                valueStr = [valueStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                [videoInfoDict setObject:valueStr forKey:keyStr];
                            }
                            [videoInfoList addObject:videoInfoDict];
                        }
                        downloadStr = videoInfoList.firstObject[@"url"];
                        // 缓存下载信息到沙盒
                        NSString *cachedDictPath = [kLNFSanboxDirectoriesPath_Caches stringByAppendingPathComponent:@"downloadDict.plist"];
                        NSDictionary *cachedDict = [[NSDictionary alloc] initWithContentsOfFile:cachedDictPath];
                        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:cachedDict];
                        if (![tempDict.allKeys containsObject:idList[i]]) {
                            [tempDict setObject:videoInfoList forKey:idList[i]];
                            [tempDict writeToFile:cachedDictPath atomically:YES];
                        }
                    }
                }
                
                if (downloadStr.length) {
                    dispatch_semaphore_t semaphore_download = dispatch_semaphore_create(0);
                    __block NSInteger logFlag = 0;
                    [[LNFNetworking shareInstance] downloadFileWithRequestUrl:downloadStr destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                        NSString *filePath = [kLNFSanboxDirectoriesPath_Caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", nameList[i] ? : idList[i]]];
                        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
                        return fileURL;
                    } progress:^(NSProgress * _Nullable downloadProgress) {
                        logFlag += 1;
                        if (100 == logFlag) {
                            kLNFLog(@"----%@>>>>已完成 %.2f，%.2fM，共%.2fM", idList[i], downloadProgress.completedUnitCount / 1.0 / downloadProgress.totalUnitCount, downloadProgress.completedUnitCount / 1.0 / 1000 / 1000, downloadProgress.totalUnitCount/ 1.0 / 1000 / 1000);
                            logFlag = 0;
                        }
                    } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                        if (error) {
                            kLNFLog(@"----%@>>>>%@", idList[i], @"下载出错");
                        }
                        dispatch_semaphore_signal(semaphore_download);
                    }];
                    dispatch_semaphore_wait(semaphore_download, DISPATCH_TIME_FOREVER);
                } else {
                    kLNFLog(@"----%@>>>>%@", idList[i], @"未获取到链接");
                }
            } else {
                kLNFLog(@"----%@>>>>%@", idList[i], @"文件已经下载");
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

/** 分解HTML获取标签内容到Text */
+ (void)divideHTMLContentIntoTextFiles
{
    NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"VideoHTML" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray<NSString *> *components_00 = [htmlStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSMutableArray<NSString *> *aLabelList = [NSMutableArray array];
    for (NSString *tempStr_00 in components_00) {
        if ([tempStr_00 containsString:@"id=\"video-title\""]) {
            NSArray<NSString *> *components_01 = [tempStr_00 componentsSeparatedByString:@"\""];
            NSMutableArray<NSString *> *helpList = [NSMutableArray arrayWithArray:components_01];
            for (NSString *tempStr_01 in components_01) {
                if ((0 == tempStr_01.length) || ([tempStr_01 containsString:@"="] && ![tempStr_01 containsString:@"?"])) {
                    [helpList removeObject:tempStr_01];
                }
            }
            NSString *videoNameStr = helpList[3];
            NSString *videoUrlStr = helpList[4];
            videoNameStr = [videoNameStr stringByReplacingOccurrencesOfString:@"|" withString:@""]; // 去除名称中的竖直符号
            videoNameStr = [videoNameStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // 替换名称中的&amp;
            videoUrlStr = [videoUrlStr componentsSeparatedByString:@"&"].firstObject; // 后面可能会有&拼接
            videoUrlStr = [NSString stringWithFormat:@"%@", videoUrlStr];
            NSString *finalStr = [NSString stringWithFormat:@"%@|%@", videoNameStr, videoUrlStr];
            [aLabelList addObject:finalStr];
        }
    }
    // 分解成多个数组，最终转换为多个Text文件
    NSInteger groupNumber = 30;
    NSInteger multiNumber = aLabelList.count / groupNumber;
    NSInteger surplusCount = aLabelList.count % groupNumber;
    NSMutableArray<NSArray<NSString *> *> *textTotalList = [NSMutableArray array];
    for (NSInteger i = 0; i < multiNumber; i++) {
        [textTotalList addObject:[aLabelList subarrayWithRange:NSMakeRange(i * groupNumber, groupNumber)]];
    }
    if (surplusCount) {
        [textTotalList addObject:[aLabelList subarrayWithRange:NSMakeRange(groupNumber * multiNumber, surplusCount)]];
    }
    for (NSInteger i = 0; i < textTotalList.count; i++) {
        NSString *filePath = [kLNFSanboxDirectoriesPath_Caches stringByAppendingPathComponent:[NSString stringWithFormat:@"WEBVideoList-%zd.txt", i]];
        NSArray<NSString *> *textList = textTotalList[i];
        NSString *descriptionStr = textList.description;
        // 经过description转化后中文会变为unicode编码
        descriptionStr = [LNFCommonMethodHelper transformToChineseCharacterFromUnicodeStr:descriptionStr];
        [descriptionStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

/** 下载文件，通过下载链接 */
+ (void)downloadFileWithDownloadUrl:(NSString *)downloadUrl fileName:(NSString *)fileName
{
    fileName = fileName.length ? fileName : downloadUrl.lastPathComponent;
    [[LNFNetworking shareInstance] downloadFileWithRequestUrl:downloadUrl destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:fileName];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        return fileURL;
    } progress:^(NSProgress *downloadProgress) {
        
        kLNFLog(@"---->>>>%.1f", downloadProgress.completedUnitCount / 1.0 / downloadProgress.totalUnitCount);
        
    } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        kLNFLog(@"---->>>>%@", @"下载完成");
    }];
}
/** 保存视频到相册 */
+ (void)saveVideoToPhotosAlbumWithFilePath:(NSURL *)filePath
{
    BOOL canSave = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([filePath path]);
    if (canSave) {
        UISaveVideoAtPathToSavedPhotosAlbum([filePath path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    } else {
        kLNFLog(@"---->>>>%@", @"不能进行保存");
    }
}
// 视频保存回调
+ (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *alertMessage = nil;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage cancelButtonItem:[LNFButtonItem itemWithLabel:@"确定"] otherButtonItems:nil];
    if (error) {
        alertMessage = error.description;
    } else {
        alertMessage = @"保存成功";
    }
    alertView.message = alertMessage;
    [alertView show];
}

@end
