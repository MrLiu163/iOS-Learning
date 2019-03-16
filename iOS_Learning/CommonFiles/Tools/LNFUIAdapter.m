//
//  LNFUIAdapter.m
//  iOS_Learning
//
//  Created by mrliu on 2019/3/16.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFUIAdapter.h"

@implementation LNFUIAdapter

/** 获取按比例缩放的布局数值 */
+ (CGFloat)scaleWithValue:(CGFloat)value
{
    // 比例即当前屏宽和6S屏宽比
    CGFloat scale = [UIScreen mainScreen].bounds.size.width / 375.0;
    CGFloat convertValue = value * scale;
    return convertValue;
}

@end
