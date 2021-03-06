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

// 完美解决失真模糊
+ (UIImage *)convertViewToImage:(UIView *)view
{
    CGSize s = view.bounds.size;
    // 第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 添加头部刷新控件 */
+ (void)addMJRefreshHeaderWithScrollView:(UIScrollView *)scrollView refreshBlock:(MJRefreshComponentRefreshingBlock)refreshBlock
{
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshBlock];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    scrollView.mj_header = refreshHeader;
}

/** 添加底部刷新控件 */
+ (void)addMJRefreshFooterWithScrollView:(UIScrollView *)scrollView refreshBlock:(MJRefreshComponentRefreshingBlock)refreshBlock
{
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshBlock];
    scrollView.mj_footer = refreshFooter;
}

/** 遍历图片的每个像素 */
+  (void)searchEveryPixelForImage:(UIImage *)image everyPixelForBlock:(EveryPixelForBlock)everyPixelForBlock {
    CGImageRef imgref = image.CGImage;
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
            if (everyPixelForBlock) {
                everyPixelForBlock(red, green, blue, alpha, j, i);
            }
            NSLog(@"red:%d, green:%d,blue:%d,alpha:%d",red,green,blue,alpha);
        }
    }
}

@end
