//
//  UIView+LNFCategory.m
//  iOS_Learning
//
//  Created by mrliu on 2019/3/16.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "UIView+LNFCategory.h"

@implementation UIView (LNFCategory)

@dynamic borderWidth, borderColor, cornerRadius;

// 圆角
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}
// 边框颜色
- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = self.layer.borderWidth ? self.layer.borderWidth : 1;
}
// 边框宽度
- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

@end
