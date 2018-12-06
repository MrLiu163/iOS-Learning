//
//  LNFCommonMethodHelper.m
//  iOS_Learning
//
//  Created by mrliu on 2018/12/6.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import "LNFCommonMethodHelper.h"

@implementation LNFCommonMethodHelper

/** 含Unicode字符串转中文 */
+ (NSString *)transformToChineseCharacterFromUnicodeStr:(NSString *)unicodeStr
{
    if (![unicodeStr length]) {
        return nil;
    }
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}
/** 含中文字符串转Unicode */
+ (NSString *)transformToUnicodeFromChineseCharacterStr:(NSString *)characterStr
{
    NSUInteger length = [characterStr length];
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    for (NSInteger i = 0;i < length; i++){
        NSMutableString *s = [NSMutableString stringWithCapacity:0];
        unichar _char = [characterStr characterAtIndex:i];
        // 判断是否为英文和数字
        if (_char <= '9' && _char >='0') {
            [s appendFormat:@"%@",[characterStr substringWithRange:NSMakeRange(i,1)]];
        } else if (_char >='a' && _char <= 'z') {
            [s appendFormat:@"%@",[characterStr substringWithRange:NSMakeRange(i,1)]];
        } else if (_char >='A' && _char <= 'Z') {
            [s appendFormat:@"%@",[characterStr substringWithRange:NSMakeRange(i,1)]];
        } else {
            // 中文和字符
            [s appendFormat:@"\\u%x",[characterStr characterAtIndex:i]];
            // 不足位数补0 否则解码不成功
            if(s.length == 4) {
                [s insertString:@"00" atIndex:2];
            } else if (s.length == 5) {
                [s insertString:@"0" atIndex:2];
            }
        }
        [str appendFormat:@"%@", s];
    }
    return str;
}

@end
