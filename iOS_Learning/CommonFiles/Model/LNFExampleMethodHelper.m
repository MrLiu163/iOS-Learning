//
//  LNFExampleMethodHelper.m
//  iOS_Learning
//
//  Created by mrliu on 2018/12/6.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import "LNFExampleMethodHelper.h"

@implementation LNFExampleMethodHelper

/** 字符串UTF8编码解码 */
+ (void)stringUTF8EncodeAndDecode
{
    // (& %26) (= %3D) (/ %2F) (, %2C)
    // @"!*'();:@&=+ $,./?%#[]"
    // 两种编码方法
    NSString *originalStr = @"Hello英文标点&=/,.中文标点，、。";
    NSString *encodeStr_00 = [originalStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // 此方法只能对其中的中文进行编码(包括中文标点符号)
    NSString *encodeStr_01 = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)originalStr, NULL, (CFStringRef)@"!*'();:@&=+ $,./?%#[]", kCFStringEncodingUTF8)); // 此方法可以将中文文字、中文标点符号、英文、英文标点符号进行编码
    // 两种解码方法
    NSString *decodeStr_00 = [encodeStr_00 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *decodeStr_01 = [encodeStr_01 stringByRemovingPercentEncoding];
    // 多层编码
    NSString *originInitStr = @"type=1&code=1";
    NSString *encodeInitStr_1 = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)originInitStr, NULL, (CFStringRef)@"!*'();:@&=+ $,./?%#[]", kCFStringEncodingUTF8));
    NSString *encodeInitStr_2 = [NSString stringWithFormat:@"level=2,%@", encodeInitStr_1];
    NSString *encodeInitStr_3 = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)encodeInitStr_2, NULL, (CFStringRef)@"!*'();:@&=+ $,./?%#[]", kCFStringEncodingUTF8));
    NSString *encodeInitStr_4 = [NSString stringWithFormat:@"range=3,%@", encodeInitStr_3];
    NSString *encodeInitStr_5 = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)encodeInitStr_4, NULL, (CFStringRef)@"!*'();:@&=+ $,./?%#[]", kCFStringEncodingUTF8));
    // 多层解码
    NSString *decodeInitStr_3 = [encodeInitStr_5 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *decodeInitStr_2 = [decodeInitStr_3 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *decodeInitStr_1 = [decodeInitStr_2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    kLNFLog(@"origin:%@\ndecode:%@", originalStr);
}

/** 正则表达式使用 测试 */
+ (void)regexUseForGetHTMLInfo
{
    /*
     // User MV Collect List
    NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MVHTML" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    NSRegularExpression *regexRegex_Labels = [NSRegularExpression regularExpressionWithPattern:@"<a data-res-action=\"bilog\"[^>]+>" options:NSRegularExpressionCaseInsensitive error:&error];
    // /<.*>/   /\b([a-z]+) \1\b/
    NSArray<NSTextCheckingResult *> *resultList_Labels = [regexRegex_Labels matchesInString:htmlStr options:0 range:NSMakeRange(0, [htmlStr length])];
    NSMutableArray<NSString *> *infoStrList = [NSMutableArray array]; // 存放所有的信息字串
    for (NSTextCheckingResult *result_Labels in resultList_Labels) {
        // 获得整个<a>
        NSString *getStr_Labels = [htmlStr substringWithRange:result_Labels.range];
        // 过滤出title字段
        NSRegularExpression *regexRegex_Title = [NSRegularExpression regularExpressionWithPattern:@"title=\"[^<>\"]+\"" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *result_Title = [regexRegex_Title firstMatchInString:getStr_Labels options:0 range:NSMakeRange(0, [getStr_Labels length])];
        NSString *getStr_Title = [getStr_Labels substringWithRange:result_Title.range];
        // 过滤出href字段
        NSRegularExpression *regexRegex_Href = [NSRegularExpression regularExpressionWithPattern:@"href=\"[^<>\"]+\"" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *result_Href = [regexRegex_Href firstMatchInString:getStr_Labels options:0 range:NSMakeRange(0, [getStr_Labels length])];
        NSString *getStr_Href = [getStr_Labels substringWithRange:result_Href.range];
        // 过滤出名称和id
        NSRegularExpression *regexRegex_Title_Name_Id = [NSRegularExpression regularExpressionWithPattern:@"\"[^\"]+\"" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *result_Title_Name = [regexRegex_Title_Name_Id firstMatchInString:getStr_Title options:0 range:NSMakeRange(0, [getStr_Title length])];
        NSString *getStr_Title_Name = [getStr_Title substringWithRange:result_Title_Name.range];
        NSTextCheckingResult *result_Href_Id = [regexRegex_Title_Name_Id firstMatchInString:getStr_Href options:0 range:NSMakeRange(0, [getStr_Href length])];
        NSString *getStr_Href_Id = [getStr_Href substringWithRange:result_Href_Id.range];
        // 剔除字符串中的\"
        getStr_Title_Name = [getStr_Title_Name stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        getStr_Href_Id = [getStr_Href_Id stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        // 拼接名称和Id
        NSString *infoStr = [NSString stringWithFormat:@"%@|%@", getStr_Title_Name, getStr_Href_Id];
        [infoStrList addObject:infoStr];
        kLNFLog(@"---->>>>%@", infoStr);
    }
    [LNFCommonMethodHelper writeToFileWithArray:infoStrList fileName:@"MVInfoList.txt"];
    */
    NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MVHTML" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSError *error = nil;
    NSRegularExpression *regexRegex_Labels_Title = [NSRegularExpression regularExpressionWithPattern:@"<b title=[^>]+>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *> *resultList_Labels_Title = [regexRegex_Labels_Title matchesInString:htmlStr options:0 range:NSMakeRange(0, [htmlStr length])];
    for (NSTextCheckingResult *result_Label in resultList_Labels_Title) {
        NSString *getStr_Label = [htmlStr substringWithRange:result_Label.range];
        kLNFLog(@"---->>>>%@", getStr_Label);
    }
    NSRegularExpression *regexRegex_Labels_Hrefs = [NSRegularExpression regularExpressionWithPattern:@"<a href=\"/song[^>]+>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *> *resultList_Labels_Hrefs = [regexRegex_Labels_Hrefs matchesInString:htmlStr options:0 range:NSMakeRange(0, [htmlStr length])];
    for (NSTextCheckingResult *result_Label in resultList_Labels_Hrefs) {
        NSString *getStr_Label = [htmlStr substringWithRange:result_Label.range];
        kLNFLog(@"---->>>>%@", getStr_Label);
    }
}

@end
