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

/** 直接下载可用链接视频 */
+ (void)downloadVideoFilesDirectFromTextURLs
{
    NSArray<NSString *> *videoOriginLinkList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WEBVideoList" ofType:@"txt"]];
    NSMutableArray<NSString *> *linkList = [NSMutableArray array];
    NSMutableArray<NSString *> *nameList = [NSMutableArray array];
    for (NSInteger i = 0; i < videoOriginLinkList.count; i++) {
        NSString *originLinkStr = videoOriginLinkList[i];
        
        NSArray<NSString *> *components_00 = [originLinkStr componentsSeparatedByString:@"|"];
        NSString *nameStr = components_00.firstObject;
        NSString *linkStr = components_00.lastObject;
        [linkList addObject:linkStr];
        [nameList addObject:nameStr];
    }
    NSMutableArray<NSBlockOperation *> *blockOperationList = [NSMutableArray array];
    for (NSInteger i = 0; i < linkList.count; i++) {
        NSString *downloadStr = linkList[i];
        NSBlockOperation *tempBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
            
            NSString *indexStr = [NSString stringWithFormat:@"%zd", i];
            NSString *filePath = [kLNFSanboxDirectoriesPath_Caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", nameList[i] ? : indexStr]];
            BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (!isFileExist) {
                if (downloadStr.length) {
                    dispatch_semaphore_t semaphore_download = dispatch_semaphore_create(0);
                    __block NSInteger logFlag = 0;
                    [[LNFNetworking shareInstance] downloadFileWithRequestUrl:downloadStr destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                        NSString *filePath = [kLNFSanboxDirectoriesPath_Caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", nameList[i] ? : indexStr]];
                        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
                        return fileURL;
                    } progress:^(NSProgress * _Nullable downloadProgress) {
                        logFlag += 1;
                        if (100 == logFlag) {
                            kLNFLog(@"----%@>>>>已完成 %.2f，%.2fM，共%.2fM", nameList[i], downloadProgress.completedUnitCount / 1.0 / downloadProgress.totalUnitCount, downloadProgress.completedUnitCount / 1.0 / 1000 / 1000, downloadProgress.totalUnitCount/ 1.0 / 1000 / 1000);
                            logFlag = 0;
                        }
                    } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                        if (error) {
                            kLNFLog(@"----%@>>>>%@", nameList[i], @"下载出错");
                        }
                        dispatch_semaphore_signal(semaphore_download);
                    }];
                    dispatch_semaphore_wait(semaphore_download, DISPATCH_TIME_FOREVER);
                } else {
                    kLNFLog(@"----%@>>>>%@", nameList[i], @"未获取到链接");
                }
            } else {
                kLNFLog(@"----%@>>>>%@", nameList[i], @"文件已经下载");
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
+ (void)divideYouVideoHTMLContentIntoTextFiles
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

/** 分解MVHTML获取标签内容到Text */
+ (void)divideWangMVHTMLContentIntoTextFiles
{
    /*
     * Singer Default
    NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MVHTML" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray<NSString *> *components_00 = [htmlStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    NSMutableArray<NSString *> *fullInfoStrList = [NSMutableArray array];
    for (NSString *tempComponentsStr in components_00) {
        if ([tempComponentsStr containsString:@"tit f-thide s-fc0"]) {
            NSArray<NSString *> *components_01 = [tempComponentsStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
            NSString *hrefStr = components_01[3];
            NSString *videoNameStr = components_01[4];
            NSArray<NSString *> *components_02 = [hrefStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
            NSString *idStr = components_02[1];
            NSString *fullInfoStr = [NSString stringWithFormat:@"%@|%@", videoNameStr, idStr];
            [fullInfoStrList addObject:fullInfoStr];
            kLNFLog(@"---->>>>%@", @"分解HTML");
        }
    }
    NSString *filePath = [kLNFSanboxDirectoriesPath_Caches stringByAppendingPathComponent:@"WangMVVideoList.txt"];
    NSString *descriptionStr = fullInfoStrList.description;
    // 经过description转化后中文会变为unicode编码
    descriptionStr = [LNFCommonMethodHelper transformToChineseCharacterFromUnicodeStr:descriptionStr];
    [descriptionStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    */
    // User List
    NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MVHTML" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray<NSString *> *components_00 = [htmlStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSMutableArray<NSString *> *fullInfoStrList = [NSMutableArray array];
    for (NSString *tempComponentsStr in components_00) {
        if ([tempComponentsStr containsString:@"s-fc0"]) {
            NSArray<NSString *> *components_01 = [tempComponentsStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
            NSString *videoNameStr = components_01[11];
            NSString *idStr = components_01[7];
            NSString *fullInfoStr = [NSString stringWithFormat:@"%@|%@", videoNameStr, idStr];
            [fullInfoStrList addObject:fullInfoStr];
            kLNFLog(@"---->>>>%@", @"分解HTML");
        }
    }
    NSString *filePath = [kLNFSanboxDirectoriesPath_Caches stringByAppendingPathComponent:@"WangMVVideoList.txt"];
    NSString *descriptionStr = fullInfoStrList.description;
    // 经过description转化后中文会变为unicode编码
    descriptionStr = [LNFCommonMethodHelper transformToChineseCharacterFromUnicodeStr:descriptionStr];
    [descriptionStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    kLNFLog(@"---->>>>%@", @"分解HTML");
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
