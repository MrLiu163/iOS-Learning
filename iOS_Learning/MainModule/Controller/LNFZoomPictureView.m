//
//  LNFZoomPictureView.m
//  iOS_Learning
//
//  Created by 刘宁飞 on 2018/9/3.
//  Copyright © 2018年 interstellar. All rights reserved.
//

#import "LNFZoomPictureView.h"

@interface LNFZoomPictureView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *bigPictureView;
@property (nonatomic, strong) UIScrollView *backScrollView;

@end

@implementation LNFZoomPictureView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // 添加手势
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *pictureTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureTapGestureAction:)];
    [self addGestureRecognizer:pictureTapGesture];
}

// 图片点击手势事件
- (void)pictureTapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    // 如果有 PHAsset 属性对象 考虑是相册缩略图
    if (self.asset) {
        CGSize size = CGSizeMake(self.asset.pixelWidth, self.asset.pixelHeight);
        [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            dispatch_async( dispatch_get_main_queue(), ^{
                /*
                 The cell may have been recycled by the time this handler gets called so we should only
                 set the cell's thumbnail image only if it's still showing the same asset.
                 */
                if ( result != nil ) {
                    self.image = result;
                    if (self.bigPictureView) {
                        self.bigPictureView.image = result;
                    }
                }
            } );
        }];
    }
    
    // 添加scrollView控件
    UIScrollView *backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kLNFScreenWidth, kLNFScreenHeight)];
    backScrollView.backgroundColor = [UIColor blackColor];
    [[LNFAppHelper toastWindow] addSubview:backScrollView];
    self.backScrollView = backScrollView;
    
    // 背景点击
    UITapGestureRecognizer *backGroundViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundViewTapGestureAction:)];
    [backScrollView addGestureRecognizer:backGroundViewTapGesture];
    
    // 图片视图 考虑放大超过屏幕大小之后边缘处理
    CGRect sFrame = CGRectZero;
    CGFloat imageRatio_height_divide_width = self.image.size.height / self.image.size.width;
    if (imageRatio_height_divide_width > kLNFCurrentScreenRatio_Height_Divide_Width) {
        sFrame = CGRectMake(0, 0, kLNFScreenHeight / imageRatio_height_divide_width, kLNFScreenHeight);
    } else {
        sFrame = CGRectMake(0, 0, kLNFScreenWidth, kLNFScreenWidth * imageRatio_height_divide_width);
    }
    //    UIImageView *bigPictureView = [[UIImageView alloc] initWithFrame:backScrollView.bounds];
    UIImageView *bigPictureView = [[UIImageView alloc] initWithFrame:sFrame];
    bigPictureView.center = backScrollView.center;
    bigPictureView.image = self.image;
    
    bigPictureView.contentMode = UIViewContentModeTopLeft;
    bigPictureView.contentMode = UIViewContentModeScaleAspectFit;
    [backScrollView addSubview:bigPictureView];
    
    // 修改图片的方向问题
    bigPictureView.image = [UIImage fixOrientation:bigPictureView.image];
    self.bigPictureView = bigPictureView;
    
    // contentSize 必须设置,否则无法滚动，当前设置为图片大小
    backScrollView.contentSize = bigPictureView.frame.size;
    
    // 实现缩放：maxinumZoomScale必须大于minimumZoomScale 同时实现viewForZoomingInScrollView方法
    backScrollView.minimumZoomScale = 1;
    backScrollView.maximumZoomScale = 3;
    
    //设置代理
    backScrollView.delegate = self;
    
    // 隐藏滚动条
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    
    // 禁用弹簧效果
    //    backScrollView.bounces = YES;
    
}

// 背景点击手势事件 从父视图移除
- (void)backGroundViewTapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    [tapGesture.view removeFromSuperview];
}

#pragma mark - 实现缩放视图代理方法，不实现此方法无法缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.bigPictureView;
}

#pragma mark - 当图片小于屏幕宽高时缩放后让图片显示到屏幕中间
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize originalSize = self.backScrollView.bounds.size;
    CGSize contentSize = self.backScrollView.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    self.bigPictureView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
}

@end
