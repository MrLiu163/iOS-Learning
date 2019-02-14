//
//  LNFCommonMethodHelper.h
//  iOS_Learning
//
//  Created by mrliu on 2018/12/6.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNFCommonMethodHelper : NSObject

/** 含Unicode字符串转中文 */
+ (NSString *)transformToChineseCharacterFromUnicodeStr:(NSString *)unicodeStr;

/** 含中文字符串转Unicode */
+ (NSString *)transformToUnicodeFromChineseCharacterStr:(NSString *)characterStr;

/** 检测身份证号码合法性 */
+ (BOOL)checkIdentityCardNumberWhetherReally:(NSString *)identityCardNumber;

/** 将数组写入到一个Text文件 fileName 格式 xxx.xxx */
+ (void)writeToFileWithArray:(NSArray *)aArray fileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
