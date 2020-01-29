//
//  LNFDownloadManager.h
//  iOS_Learning
//
//  Created by MrLiu on 2018/11/23.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNFDownloadManager : NSObject

/** 直接下载可用链接视频 */
+ (void)downloadVideoFilesDirectFromTextURLs;

/** 分解VideoHTML获取标签内容到Text */
+ (void)divideYouVideoHTMLContentIntoTextFiles;

/** 分解MVHTML获取标签内容到Text */
+ (void)divideWangMVHTMLContentIntoTextFiles;

/** 保存视频到相册 */
+ (void)saveVideoToPhotosAlbumWithFilePath:(NSURL *)filePath;

@end
