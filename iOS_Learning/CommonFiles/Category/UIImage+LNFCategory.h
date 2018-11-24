//
//  UIImage+LNFCategory.h
//  iOS_Learning
//
//  Created by MrLiu on 2018/9/3.
//  Copyright © 2018年 interstellar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LNFCategory)

/** 通过颜色获取一张图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 对图片数据进行压缩 */
- (NSData *)imageDataScaleToMaxFileSize:(NSUInteger)maxFileSize;

/** 对图片尺寸进行压缩 单位 kb */
- (UIImage *)imageScaledToSize:(CGSize)newSize;

/** 修改图片的方向 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end
