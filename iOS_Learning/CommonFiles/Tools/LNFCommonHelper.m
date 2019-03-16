//
//  LNFCommonHelper.m
//  iOS_Learning
//
//  Created by mrliu on 2019/3/16.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFCommonHelper.h"

@implementation LNFCommonHelper

/** 获取一个日期字符串 传入 formatterStr 和 NSDate */
+ (NSString *)getDateStrFromDate:(NSDate *)date formatterStr:(NSString *)formatterStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    return [formatter stringFromDate:date];
}

@end
