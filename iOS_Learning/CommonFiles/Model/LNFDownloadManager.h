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

@end
