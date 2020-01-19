//
//  LNFProductBrowseFootprintView.m
//  iOS_Learning
//
//  Created by MrLiuu on 2020/1/19.
//  Copyright © 2020 interstellar. All rights reserved.
//

#import "LNFProductBrowseFootprintView.h"

@interface LNFProductBrowseFootprintView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *footprintScrollView;
@property (nonatomic, assign) NSInteger proCellBaseTagValue;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, strong) NSArray<NSString *> *imgUrlList;
@property (nonatomic, assign) CGFloat minAlpha;
@property (nonatomic, assign) CGFloat leftRightInset;
@property (nonatomic, assign) CGFloat topBottomInset;
@property (nonatomic, assign) BOOL masFirstAnimationDone; // 标记是否是第一次动画
@property (nonatomic, assign) CGFloat whiteContainerHeight; // 白色容器高度
@property (nonatomic, strong) UIView *backgroundView; // 黑透背景
@property (nonatomic, strong) UIView *whiteContainerView; // 白色容器框
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, assign) NSInteger pageIndex; // 记录当前是第几张

@end

@implementation LNFProductBrowseFootprintView

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
    self.whiteContainerHeight = 300.0;
    self.proCellBaseTagValue = 54321;
    self.itemWidth = 200.0;
    self.itemHeight = 100.0;
    self.minAlpha = 0.6;
    self.leftRightInset = 30.0;
    self.topBottomInset = 15.0;
    self.imgUrlList = @[@"http://dingyue.nosdn.127.net/To375uHiC7RYuP8fPwbuV4buTMLRrGlaIcjHqbNz0L07c1540425164144.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/24/1ad6b00ee7ee4810975d33b1be4c517e.png", @"http://cms-bucket.nosdn.127.net/2018/10/23/85c14bc8ca4c4c08957cccf3f6becddf.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/25/6b889f78cd98483ab35a566f61675717.png", @"http://cms-bucket.nosdn.127.net/2018/10/25/04283175001f41a19727cec0eed857e2.png", @"http://cms-bucket.nosdn.127.net/2018/10/23/f4e1ccc84b32413abf5b2988a29177c9.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/23/8840fb799a3f44409a3e3ef6c2a67334.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/24/615d5325fd644093ad261bc987ecd441.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/24/f4d8580fea674ecbb25e10e69e4aec30.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/24/5f7c4366f61749e88060cce28da83480.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/24/ef2d7c320e9049099f0745a7bbba1339.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/24/98e7a978f74a4a659fe79aad5ff3e487.png", @"http://cms-bucket.nosdn.127.net/2018/10/23/a19d071eff0f4063becbde7b1499a11b.png", @"http://cms-bucket.nosdn.127.net/2018/10/22/e23f3d14e8084a209af319a55d95f7e6.jpeg"];
    
    // 黑透背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self);
    }];
    backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.backgroundView = backgroundView;
    UITapGestureRecognizer *backgroundTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapGestureAction:)];
    [backgroundView addGestureRecognizer:backgroundTapGesture];
    
    // 白色框框容器(主要容器)
    UIView *whiteContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:whiteContainerView];
    whiteContainerView.clipsToBounds = YES; // 内部UIScrollView的clipsToBounds为NO
    [whiteContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.height.mas_equalTo(self.whiteContainerHeight);
        make.top.mas_equalTo(self).offset(-self.whiteContainerHeight);
    }];
    whiteContainerView.backgroundColor = [UIColor whiteColor];
    self.whiteContainerView = whiteContainerView;
    
    // 我的足迹
    CGFloat tipsFontSize = 16.0;
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [whiteContainerView addSubview:tipsLabel];
    tipsLabel.font = [UIFont boldSystemFontOfSize:tipsFontSize];
    tipsLabel.text = @"我的足迹";
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteContainerView).offset(22.0);
        make.top.mas_equalTo(whiteContainerView).offset(35.0);
        make.height.mas_equalTo(tipsFontSize);
    }];
    self.tipsLabel = tipsLabel;
    
    // 盛放滚动视图的容器
    UIView *showContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [whiteContainerView addSubview:showContainerView];
    [showContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(whiteContainerView);
        make.height.mas_equalTo(self.itemHeight);
    }];
    // 滚动视图容器点击手势
    UITapGestureRecognizer *showContainerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showContainerTapGestureAction:)];
    [showContainerView addGestureRecognizer:showContainerTapGesture];
    
    // 滚动视图
    UIScrollView *footprintScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [showContainerView addSubview:footprintScrollView];
    footprintScrollView.clipsToBounds = NO;
    footprintScrollView.pagingEnabled = YES;
    footprintScrollView.showsHorizontalScrollIndicator = NO;
    footprintScrollView.delegate = self;
    footprintScrollView.backgroundColor = [UIColor lightGrayColor];
    [footprintScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(self.itemWidth);
        make.height.mas_equalTo(self.itemHeight);
    }];
    self.footprintScrollView = footprintScrollView;
    // 滚动范围
    NSInteger imgCount = self.imgUrlList.count;
    UIView *scrollContentSizeView = [[UIView alloc] initWithFrame:CGRectZero];
    [footprintScrollView addSubview:scrollContentSizeView];
    [scrollContentSizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(footprintScrollView);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(footprintScrollView).multipliedBy(imgCount / 1.0);
    }];
    // 遍历添加图片控件
    for (NSInteger i = 0; i < imgCount; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgView.tag = self.proCellBaseTagValue + i;
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgUrlList[i]] placeholderImage:nil options:SDWebImageRetryFailed];
        [scrollContentSizeView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scrollContentSizeView).offset(i * self.itemWidth);
            make.top.and.bottom.and.height.mas_equalTo(scrollContentSizeView);
            make.width.mas_equalTo(footprintScrollView);
        }];
        imgView.userInteractionEnabled = YES;
        // 图片点击手势
        UITapGestureRecognizer *imgTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapGestureAction:)];
        [imgView addGestureRecognizer:imgTapGesture];
    }
    
    [self refreshVisibleCellAppearance];
}

#pragma mark - Public Method
/** TK 动画展示控件 */
- (void)showFootprintViewWithAnimation
{
    if (!self.masFirstAnimationDone) {
        [self.superview layoutIfNeeded]; // 防止masonry做动画头一次出现不是从底部弹出
        self.masFirstAnimationDone = YES;
    }
    [self bounceSelectViewAnimationWithShow:YES]; // 弹出动画
}
/** TK 动画收起控件 */
- (void)hideFootprintViewWithAnimation
{
    [self bounceSelectViewAnimationWithShow:NO];
}

#pragma mark - Private Method
// 更新cell样式
- (void)refreshVisibleCellAppearance
{
    [self.footprintScrollView layoutIfNeeded];
    
    CGFloat offset = self.footprintScrollView.contentOffset.x;
    CGSize pageSize = CGSizeMake(self.itemWidth, self.itemHeight);
    for (NSInteger i = 0; i < self.imgUrlList.count; i++) {
        UIImageView *imgView = [self.footprintScrollView viewWithTag:i + self.proCellBaseTagValue];
        CGFloat origin = imgView.frame.origin.x;
        CGFloat delta = fabs(origin - offset);
        CGRect originCellFrame = CGRectMake(pageSize.width * i, 0, pageSize.width, pageSize.height);//如果没有缩小效果的情况下的本该的Frame
        if (delta < pageSize.width) {
            imgView.alpha = self.minAlpha / (delta / pageSize.width);
            
            CGFloat leftRightInset = self.leftRightInset * delta / pageSize.width;
            CGFloat topBottomInset = self.topBottomInset * delta / pageSize.width;
            imgView.layer.transform = CATransform3DMakeScale((pageSize.width - leftRightInset * 2) / pageSize.width, (pageSize.height - topBottomInset * 2) / pageSize.height, 1.0);
            imgView.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(topBottomInset, leftRightInset, topBottomInset, leftRightInset));
        } else {
            imgView.alpha = self.minAlpha;
            
            imgView.layer.transform = CATransform3DMakeScale((pageSize.width - self.leftRightInset * 2) / pageSize.width, (pageSize.height - self.topBottomInset * 2) / pageSize.height, 1.0);
            imgView.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(self.topBottomInset, self.leftRightInset, self.topBottomInset, self.leftRightInset));
        }
    }
}

/** 主要内容隐藏展示动画 */
- (void)bounceSelectViewAnimationWithShow:(BOOL)show
{
    CGFloat animationTime = 0.3;
    if (show) {
        self.hidden = NO;
        [self.whiteContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
        }];
        [UIView animateWithDuration:animationTime animations:^{
            self.backgroundView.alpha = 1.0;
            [self layoutIfNeeded];
        }];
    } else {
        [self.whiteContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(-self.whiteContainerHeight);
        }];
        [UIView animateWithDuration:animationTime animations:^{
            self.backgroundView.alpha = 0;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
    // 回收输入键盘
    [self endEditing:YES];
}

// 黑透背景点击
- (void)backgroundTapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    [self bounceSelectViewAnimationWithShow:NO];
}
// 图片点击手势
- (void)imgTapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    UIImageView *imgView = (UIImageView *)tapGesture.view;
    [self.footprintScrollView scrollRectToVisible:imgView.frame animated:YES];
}
// 白色容器点击手势
- (void)showContainerTapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:tapGesture.view];
    CGFloat minX = CGRectGetMinX(self.footprintScrollView.frame);
    CGFloat maxX = CGRectGetMaxX(self.footprintScrollView.frame);
    if (tapPoint.x < minX) {
        NSInteger toIndex = self.pageIndex - 1;
        if (toIndex < 0) return;
        
        [self.footprintScrollView setContentOffset:CGPointMake(toIndex * self.footprintScrollView.bounds.size.width, 0) animated:YES];
        self.pageIndex = toIndex;
    } else if (tapPoint.x > maxX) {
        NSInteger toIndex = self.pageIndex + 1;
        if (toIndex >= self.imgUrlList.count) return;
        
        [self.footprintScrollView setContentOffset:CGPointMake(toIndex * self.footprintScrollView.bounds.size.width, 0) animated:YES];
        self.pageIndex = toIndex;
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算页数
    NSInteger index = (NSInteger)round(scrollView.contentOffset.x / scrollView.bounds.size.width);
    self.pageIndex = index;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self refreshVisibleCellAppearance];
}

@end
