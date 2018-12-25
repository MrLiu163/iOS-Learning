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

/** 检测身份证号码合法性 */
+ (BOOL)checkIdentityCardNumberWhetherReally:(NSString *)identityCardNumber
{
    if (identityCardNumber.length == 18) {
        NSInteger int1 = [[identityCardNumber substringWithRange:NSMakeRange(0, 1)] integerValue];
        NSInteger int2 = [[identityCardNumber substringWithRange:NSMakeRange(1, 1)] integerValue];
        NSInteger int3 = [[identityCardNumber substringWithRange:NSMakeRange(2, 1)] integerValue];
        NSInteger int4 = [[identityCardNumber substringWithRange:NSMakeRange(3, 1)] integerValue];
        NSInteger int5 = [[identityCardNumber substringWithRange:NSMakeRange(4, 1)] integerValue];
        NSInteger int6 = [[identityCardNumber substringWithRange:NSMakeRange(5, 1)] integerValue];
        NSInteger int7 = [[identityCardNumber substringWithRange:NSMakeRange(6, 1)] integerValue];
        NSInteger int8 = [[identityCardNumber substringWithRange:NSMakeRange(7, 1)] integerValue];
        NSInteger int9 = [[identityCardNumber substringWithRange:NSMakeRange(8, 1)] integerValue];
        NSInteger int10 = [[identityCardNumber substringWithRange:NSMakeRange(9, 1)] integerValue];
        NSInteger int11 = [[identityCardNumber substringWithRange:NSMakeRange(10, 1)] integerValue];
        NSInteger int12 = [[identityCardNumber substringWithRange:NSMakeRange(11, 1)] integerValue];
        NSInteger int13 = [[identityCardNumber substringWithRange:NSMakeRange(12, 1)] integerValue];
        NSInteger int14 = [[identityCardNumber substringWithRange:NSMakeRange(13, 1)] integerValue];
        NSInteger int15 = [[identityCardNumber substringWithRange:NSMakeRange(14, 1)] integerValue];
        NSInteger int16 = [[identityCardNumber substringWithRange:NSMakeRange(15, 1)] integerValue];
        NSInteger int17 = [[identityCardNumber substringWithRange:NSMakeRange(16, 1)] integerValue];
        NSInteger int18 = 0;
        if ([[identityCardNumber substringWithRange:NSMakeRange(17, 1)] isEqualToString:@"X"] || [[identityCardNumber substringWithRange:NSMakeRange(17, 1)] isEqualToString:@"x"]) {
            int18 = 10;
        } else {
            int18 = [[identityCardNumber substringWithRange:NSMakeRange(17, 1)] integerValue];
        }
        NSInteger sum = int1 * 7 + int2 * 9 + int3 * 10 + int4 * 5 + int5 * 8 + int6 * 4 + int7 * 2 + int8 * 1 + int9 * 6 + int10 * 3 + int11 * 7 + int12 * 9 + int13 * 10 + int14 * 5 + int15 * 8 + int16 * 4 + int17 * 2;
        sum = sum < 11 ? sum + 11 : sum;
        NSInteger remainder = sum % 11;
        BOOL success = NO;
        switch (remainder) {
                // 1－0－X －9－8－7－6－5－4－3－2。
            case 0:
                if (1 == int18) {
                    success = YES;
                }
                break;
            case 1:
                if (0 == int18) {
                    success = YES;
                }
                break;
            case 2:
                if (10 == int18) {
                    success = YES;
                }
                break;
            case 3:
                if (9 == int18) {
                    success = YES;
                }
                break;
            case 4:
                if (8 == int18) {
                    success = YES;
                }
                break;
            case 5:
                if (7 == int18) {
                    success = YES;
                }
                break;
            case 6:
                if (6 == int18) {
                    success = YES;
                }
                break;
            case 7:
                if (5 == int18) {
                    success = YES;
                }
                break;
            case 8:
                if (4 == int18) {
                    success = YES;
                }
                break;
            case 9:
                if (3 == int18) {
                    success = YES;
                }
                break;
            case 10:
                if (2 == int18) {
                    success = YES;
                }
                break;
            default:
                break;
        }
        return success;
    } else {
        return NO;
    }
}

@end
