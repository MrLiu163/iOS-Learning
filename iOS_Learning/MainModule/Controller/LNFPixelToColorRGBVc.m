//
//  LNFPixelToColorRGBVc.m
//  iOS_Learning
//
//  Created by mrliu on 2020/11/13.
//  Copyright © 2020 interstellar. All rights reserved.
//

#import "LNFPixelToColorRGBVc.h"

@interface LNFPixelToColorRGBVc ()

@end

@implementation LNFPixelToColorRGBVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *sampleImage = [UIImage imageNamed:@"PixelSample"];
    NSMutableString *writeStr = [NSMutableString string];
    CGSize imageSize = sampleImage.size;
    NSInteger totalWidth = imageSize.width;
    
    CGImageRef imgref = sampleImage.CGImage;
    // 获取图片宽高（总像素数）
    size_t width = CGImageGetWidth(imgref);
    size_t height = CGImageGetHeight(imgref);
    // 每行像素的总字节数
    size_t bytesPerRow = CGImageGetBytesPerRow(imgref);
    // 每个像素多少位(RGBA每个8位，所以这里是32位) ps:（一个字节8位）
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imgref);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imgref);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);// 图片数据的首地址
    // 遍历
    for (int j = 0; j < height; j++) {
        for (int i = 0; i < width; i++) {
            // 每个像素的首地址
            UInt8 *pt = buffer + j * bytesPerRow + i * (bitsPerPixel/8);
            UInt8 red = *pt;
            UInt8 green = *(pt+1); // 指针向后移动一个字节
            UInt8 blue = *(pt+2);
            UInt8 alpha = *(pt+3);
            NSString *cellColor = [NSString stringWithFormat:@"{%zd#%zd#%zd}", red*red*1L, green*green*1L, blue*blue*1L];
            [writeStr appendFormat:@"%@", cellColor ? : @""];
            if ((i > 0) && ((i % totalWidth) == (totalWidth - 1))) {
                [writeStr appendFormat:@"\n"];
            } else {
                [writeStr appendFormat:@","];
            }
            NSLog(@"red:%d, green:%d,blue:%d,alpha:%d",red,green,blue,alpha);
        }
    }
    
    // 内存会有问题
//    [UIView searchEveryPixelForImage:sampleImage everyPixelForBlock:^(UInt8 R, UInt8 G, UInt8 B, UInt8 A, int H, int W) {
//        NSString *cellColor = [NSString stringWithFormat:@"{%zd#%zd#%zd}", R*R*1L, G*G*1L, B*B*1L];
//        [writeStr appendFormat:@"%@", cellColor ? : @""];
//        if ((W > 0) && ((W % totalWidth) == (totalWidth - 1))) {
//            [writeStr appendFormat:@"\n"];
//        } else {
//            [writeStr appendFormat:@","];
//        }
//    }];
    NSString *filePath = [@"/Users/mrliu/Desktop" stringByAppendingPathComponent:@"TestCSVFile.csv"];
    // ,(英文逗号)代表下一单元格 \n(换行)代表换行
    NSError *error = nil;
    [writeStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        kLNFLog(@"---->>>>%@", @"csv写入出现错误");
    } else {
        kLNFLog(@"---->>>>%@", @"csv写入成功");
    }
}


@end
