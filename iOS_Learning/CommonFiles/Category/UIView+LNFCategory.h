//
//  UIView+LNFCategory.h
//  iOS_Learning
//
//  Created by mrliu on 2019/3/16.
//  Copyright © 2019 interstellar. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIView (LNFCategory)

/** 切圆角 */
@property (nonatomic, assign) CGFloat cornerRadius;
/** 四边颜色 */
@property (nonatomic, strong) UIColor *borderColor;
/** 四边宽度 */
@property (nonatomic, assign) CGFloat borderWidth;

@property (assign, nonatomic) CGFloat lnf_x;
@property (assign, nonatomic) CGFloat lnf_y;
@property (assign, nonatomic) CGFloat lnf_c_x;
@property (assign, nonatomic) CGFloat lnf_c_y;
@property (assign, nonatomic) CGFloat lnf_w;
@property (assign, nonatomic) CGFloat lnf_h;
@property (assign, nonatomic) CGSize lnf_size;
@property (assign, nonatomic) CGPoint lnf_origin;

/** 切固定方向的圆角 */
- (void)makeFixedDirectionCornerRadiusWithCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

/** 将一个视图转换成图片 */
+ (UIImage *)convertViewToImage:(UIView *)view;

/** 添加头部刷新控件 */
+ (void)addMJRefreshHeaderWithScrollView:(UIScrollView *)scrollView refreshBlock:(MJRefreshComponentRefreshingBlock)refreshBlock;

/** 添加底部刷新控件 */
+ (void)addMJRefreshFooterWithScrollView:(UIScrollView *)scrollView refreshBlock:(MJRefreshComponentRefreshingBlock)refreshBlock;

@end

NS_ASSUME_NONNULL_END
