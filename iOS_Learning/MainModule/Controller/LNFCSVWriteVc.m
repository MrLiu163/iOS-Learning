//
//  LNFCSVWriteVc.m
//  iOS_Learning
//
//  Created by mrliu on 2019/7/26.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFCSVWriteVc.h"

@interface LNFCSVWriteVc ()

@end

@implementation LNFCSVWriteVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    self.navigationItem.title = @"生成csv文件";
    
    // 请求数据生成csv文件
//    [self requestData];
    
    // 生成csv文件示例，使用FileHandle
//    [self creatCSVExampleByFileHandle];
    
    // 读取csv文件
//    [self readCSVExample];
    
    // 创建csv文件，使用字符串直接写入write
//    [self creatCSVExampleByStringWrite];
}

// 请求数据，然后生成csv文件
- (void)requestData
{
    NSString *url = @"<#ReqUrl#>";
    [[LNFNetworking shareInstance] getRequestUrl:url parameters:@{} showHUD:NO success:^(id  _Nullable responseObject) {
        
        NSArray<NSDictionary *> *infoDictList = responseObject[@"result"];
        [self createAndWriteCSVFileWithDictList:infoDictList];
        kLNFLog(@"---->>>>%@", responseObject);
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}

// 字典数组拆分生成csv文件
- (void)createAndWriteCSVFileWithDictList:(NSArray<NSDictionary *> *)infoDictList
{
    // 文件保存路径
    NSString *filePath = [@"/Users/<#userName#>/Desktop" stringByAppendingPathComponent:@"TestCSVFile.csv"];
    
    // 生成csv文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    if (![fileManager createFileAtPath:filePath contents:nil attributes:nil]) {
        kLNFLog(@"---->>>>%@", @"不能创建文件");
        return;
    }
    
    // 将数据写入csv文件
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToEndOfFile]; // 将节点调到文件末尾
    
    NSDictionary *firstDict = infoDictList.firstObject; // 取出第一个字典获取标题
    NSArray<NSString *> *allKeys = [firstDict allKeys];
    NSString *allKeysStr = [allKeys componentsJoinedByString:@","];
    allKeysStr = [allKeysStr stringByAppendingString:@"\n"]; // 注意换行
    NSData *headerStrData = [allKeysStr dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:headerStrData]; // 写入标题数据
    NSInteger forCount = infoDictList.count;
    for (int i = 0; i < forCount; i++) { // 遍历写入所有数据
        NSDictionary *tempDict = infoDictList[i];
        NSArray<NSString *> *allValues = [tempDict allValues];
        NSString *allValuesStr = [allValues componentsJoinedByString:@","];
        allValuesStr = [allValuesStr stringByAppendingString:@"\n"]; // 注意换行
        NSData *stringData = [allValuesStr dataUsingEncoding:NSUTF8StringEncoding];
        // 追加写入数据
        [fileHandle writeData:stringData];
    }
    
    [fileHandle closeFile];
}

// 生成csv文件示例，使用FileHandle
- (void)creatCSVExampleByFileHandle
{
    // 文件保存路径
    NSString *filePath = [@"/Users/<#userName#>/Desktop" stringByAppendingPathComponent:@"TestCSVFile.csv"];
    
    // 生成csv文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    if (![fileManager createFileAtPath:filePath contents:nil attributes:nil]) {
        kLNFLog(@"---->>>>%@", @"不能创建文件");
        return;
    }
    
    // 将数据写入csv文件
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToEndOfFile]; // 将节点调到文件末尾
    
    NSString *headerStr = @"Name,Gender,Age";
    headerStr = [headerStr stringByAppendingString:@"\n"]; // 注意换行
    NSData *headerStrData = [headerStr dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:headerStrData]; // 写入标题数据
    NSInteger forCount = 50;
    NSString *contentStr = @"A,Man,20";
    contentStr = [contentStr stringByAppendingString:@"\n"]; // 注意换行
    for (int i = 0; i < forCount; i++) { // 遍历写入所有数据
        NSData *stringData = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
        // 追加写入数据
        [fileHandle writeData:stringData];
    }
    
    [fileHandle closeFile];
}

// 读取csv文件示例
- (void)readCSVExample
{
    NSString *filePath = [@"/Users/<#userName#>/Desktop" stringByAppendingPathComponent:@"TestCSVFile.csv"];
    NSError *error = nil;
    NSString *csvDataStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        kLNFLog(@"---->>>>%@", @"csv解析出现错误");
    } else {
        NSArray *csvDataList = [csvDataStr componentsSeparatedByString:@"\n"];
        kLNFLog(@"---->>>>%@", csvDataList);
    }
}

// 创建csv文件，使用字符串直接写入write
- (void)creatCSVExampleByStringWrite
{
    NSString *filePath = [@"/Users/<#userName#>/Desktop" stringByAppendingPathComponent:@"TestCSVFile.csv"];
    // ,(英文逗号)代表下一单元格 \n(换行)代表换行
    NSString *writeStr = @"Name,Gender,Age\nB,Man,20\nB,Man,20\nC,Man,20\nD,Man,20";
    NSError *error = nil;
    [writeStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        kLNFLog(@"---->>>>%@", @"csv写入出现错误");
    } else {
        kLNFLog(@"---->>>>%@", @"csv写入成功");
    }
    
}

@end
