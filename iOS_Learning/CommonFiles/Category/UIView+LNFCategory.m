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

- (void)setLnf_x:(CGFloat)lnf_x
{
    CGRect frame = self.frame;
    frame.origin.x = lnf_x;
    self.frame = frame;
}


- (CGFloat)lnf_x
{
    return self.frame.origin.x;
}

- (void)setLnf_y:(CGFloat)lnf_y
{
    CGRect frame = self.frame;
    frame.origin.y = lnf_y;
    self.frame = frame;
}

- (CGFloat)lnf_y
{
    return self.frame.origin.y;
}

- (void)setLnf_c_x:(CGFloat)lnf_c_x
{
    CGPoint center = self.center;
    center.x = lnf_c_x;
    self.center = center;
}

- (CGFloat)lnf_c_x
{
    return self.center.x;
}

- (void)setLnf_c_y:(CGFloat)lnf_c_y
{
    CGPoint center = self.center;
    center.y = lnf_c_y;
    self.center = center;
}

- (CGFloat)lnf_c_y
{
    return self.center.y;
}

- (void)setLnf_w:(CGFloat)lnf_w
{
    CGRect frame = self.frame;
    frame.size.width = lnf_w;
    self.frame = frame;
}

- (CGFloat)lnf_w
{
    return self.frame.size.width;
}

- (void)setLnf_h:(CGFloat)lnf_h
{
    CGRect frame = self.frame;
    frame.size.height = lnf_h;
    self.frame = frame;
}

- (CGFloat)lnf_h
{
    return self.frame.size.height;
}

- (void)setLnf_size:(CGSize)lnf_size
{
    CGRect frame = self.frame;
    frame.size = lnf_size;
    self.frame = frame;
}

- (CGSize)lnf_size
{
    return self.frame.size;
}

- (void)setLnf_origin:(CGPoint)lnf_origin
{
    CGRect frame = self.frame;
    frame.origin = lnf_origin;
    self.frame = frame;
}

- (CGPoint)lnf_origin
{
    return self.frame.origin;
}

/** 切固定方向的圆角 */
- (void)makeFixedDirectionCornerRadiusWithCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
