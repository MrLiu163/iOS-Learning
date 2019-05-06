//
//  LNFDownloadManager.h
//  iOS_Learning
//
//  Created by MrLiu on 2018/11/23.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNFDownloadManager : NSObject

/** 下载Text文件中Mp3链接文件 */
+ (void)downloadMP3FilesFromTextURLs;

/** 下载Text文件中MV链接文件 */
+ (void)downloadMVFilesFromTextURLs;

/** 下载WEB视频 */
+ (void)downloadWEBVideoFilesFromTextURLs;

/** 直接下载可用链接视频 */
+ (void)downloadVideoFilesDirectFromTextURLs;

/** 分解VideoHTML获取标签内容到Text */
+ (void)divideYouVideoHTMLContentIntoTextFiles;

/** 分解MVHTML获取标签内容到Text */
+ (void)divideWangMVHTMLContentIntoTextFiles;

/** 保存视频到相册 */
+ (void)saveVideoToPhotosAlbumWithFilePath:(NSURL *)filePath;

@end