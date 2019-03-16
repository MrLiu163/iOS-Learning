//
//  LNFCommonHelper.h
//  iOS_Learning
//
//  Created by mrliu on 2019/3/16.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNFCommonHelper : NSObject

/** 获取一个日期字符串 传入 formatterStr 和 NSDate */
+ (NSString *)getDateStrFromDate:(NSDate *)date formatterStr:(NSString *)formatterStr;

@end

NS_ASSUME_NONNULL_END
