//
//  LNFDeleteStyleCollectionCell.m
//  iOS_Learning
//
//  Created by mrliu on 2019/5/31.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFDeleteStyleCollectionCell.h"

#define kDeleteBtnWidth 120.0

@interface LNFDeleteStyleCollectionCell () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, assign) BOOL shouldRight;
@property (nonatomic, assign) CGPoint originCenter;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat rate;

@end

@implementation LNFDeleteStyleCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.originCenter = self.contentView.center;
    
    // 判断是否需要切上边或下边两个圆角
    if (self.makeUpCornerRadius) {
        CGFloat cornerRadius = 8.0;
        [self makeFixedDirectionCornerRadiusWithCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    } else if (self.makeBottomCornerRadius) {
        CGFloat cornerRadius = 8.0;
        [self makeFixedDirectionCornerRadiusWithCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
}

- (void)setup
{
    self.origin = CGPointZero;
    self.isLeft = NO;
//    self.shouldRight = YES;
//    self.originCenter = CGPointZero;
    self.distance = 0;
    self.rate = 1.0;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesterDidPan:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
    
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
//    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
//    [self addGestureRecognizer:swipeGesture];
    
    // 商品图片
    UIImageView *proPicView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:proPicView];
    [proPicView sd_setImageWithURL:[NSURL URLWithString:@""]];
    [proPicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.width.and.height.mas_equalTo(45);
    }];
    
    // 商品货号和名称
    UILabel *proNumberAndNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:proNumberAndNameLabel];
    proNumberAndNameLabel.font = [UIFont systemFontOfSize:15];
    proNumberAndNameLabel.numberOfLines = 2;
    proNumberAndNameLabel.text = @"";
    [proNumberAndNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(proPicView.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    // 增加一个删除按钮
    UIView *deleteBtnView = [[UIView alloc] initWithFrame:CGRectZero];
    [self insertSubview:deleteBtnView belowSubview:self.contentView];
    deleteBtnView.backgroundColor = [UIColor redColor];
    [deleteBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(kDeleteBtnWidth);
    }];
    UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [deleteBtnView addSubview:deleteLabel];
    deleteLabel.font = [UIFont systemFontOfSize:16.0];
    deleteLabel.text = @"删除";
    deleteLabel.textColor = [UIColor whiteColor];
    deleteLabel.textAlignment = NSTextAlignmentCenter;
    [deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(deleteBtnView).offset(5.0);
        make.right.mas_equalTo(deleteBtnView).offset(-5.0);
        make.centerY.mas_equalTo(0);
    }];
    
}

/*
- (void)panGesterDidPan:(UIPanGestureRecognizer *)panGesture {
    __block CGPoint originCenter = panGesture.view.center;
    CGPoint origin = CGPointZero;
    BOOL isLeft = NO;
    __block BOOL shouldRight = NO;
    CGFloat distance = 0;
    CGFloat kDeleteBtnWidth = 120.0;
    CGFloat rate = 1.0;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            origin = [panGesture translationInView:self];
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
            CGPoint translation = [panGesture translationInView:self];
            isLeft = (translation.x - origin.x < 0);
            
            if ((isLeft && shouldRight) || (!isLeft && !shouldRight)) {
                return;
            }
            
            CGFloat maxDistance = isLeft ? kDeleteBtnWidth - 2 : kDeleteBtnWidth;
            
            distance = (fabs(translation.x) < kDeleteBtnWidth ? translation.x : (translation.x < 0 ? - maxDistance : maxDistance));
            
            distance = isLeft ? MIN(0, distance) : MAX(0, distance);
            
            self.contentView.center = CGPointMake(originCenter.x + rate * distance, self.contentView.center.y);
 
            
        }
            break;
        case UIGestureRecognizerStateEnded:
            
            if ((isLeft && shouldRight) || (!isLeft && !shouldRight)) {
                return;
            }
            
            if (distance - kDeleteBtnWidth < 6) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.contentView.center = CGPointMake(originCenter.x + (isLeft ? - kDeleteBtnWidth : kDeleteBtnWidth), self.contentView.center.y);
                } completion:^(BOOL finished) {
                    originCenter = self.contentView.center;
                    shouldRight = isLeft;
                }];
            }
            
            break;
        default:
            break;
            
    }
}
*/

- (void)panGesterDidPan:(UIPanGestureRecognizer *)panGesture
{
    /*
    CGPoint origin = CGPointZero;
    BOOL isLeft = NO;
    __block BOOL shouldRight = YES;
    __block CGPoint originCenter = CGPointZero;
    CGFloat distance = 0;
    CGFloat rate = 1.0;
    
    CGPoint translationPoint = [panGesture translationInView:self];
    NSValue *translationPointValue = [NSValue valueWithCGPoint:translationPoint];
    UIGestureRecognizerState gestureState = panGesture.state;
    if (UIGestureRecognizerStateBegan == gestureState) { // 一次滑动走一次
        origin = [panGesture translationInView:self];
        originCenter = self.contentView.center; /////
        
        kLNFLog(@"---->>>>%@", @"2");
        kLNFLog(@"---- 2 >>>>%@", translationPointValue);
    } else if (UIGestureRecognizerStateChanged == gestureState) {
        CGPoint translation = [panGesture translationInView:self];
        isLeft = (translation.x - origin.x < 0);
        if ((isLeft && shouldRight) || (!isLeft && !shouldRight)) {
            return;
        }
        CGFloat maxDistance = isLeft ? kDeleteBtnWidth - 2 : kDeleteBtnWidth;
        distance = (fabs(translation.x) < kDeleteBtnWidth ? translation.x : (translation.x < 0 ? - maxDistance : maxDistance));
        distance = isLeft ? MIN(0, distance) : MAX(0, distance);
        self.contentView.center = CGPointMake(originCenter.x + rate * distance, self.contentView.center.y);
        
        kLNFLog(@"---->>>>%@", @"3");
        kLNFLog(@"---- 3 >>>>%@", translationPointValue);
        kLNFLog(@"---->>>> rate * distance = %f", rate * distance);
    } else if (UIGestureRecognizerStateEnded == gestureState) { // 一次滑动走一次
        if ((isLeft && shouldRight) || (!isLeft && !shouldRight)) {
            return;
        }
        
        if (distance - kDeleteBtnWidth < 6) {
            [UIView animateWithDuration:0.25 animations:^{
                self.contentView.center = CGPointMake(originCenter.x + (isLeft ? - kDeleteBtnWidth : kDeleteBtnWidth), self.contentView.center.y);
            } completion:^(BOOL finished) {
                originCenter = self.contentView.center;
                shouldRight = isLeft;
            }];
        }
        
        kLNFLog(@"---->>>>%@", @"4");
        kLNFLog(@"---- 4 >>>>%@", translationPointValue);
    } else {
        kLNFLog(@"---->>>>%@", @"1");
    }
    
    */
    
    UIGestureRecognizerState gestureState = panGesture.state;
    if (UIGestureRecognizerStateBegan == gestureState) { // 一次滑动走一次
        self.origin = [panGesture translationInView:self];
        self.originCenter = self.contentView.center; /////
        
        kLNFLog(@"---->>>>%@", @"2");
    } else if (UIGestureRecognizerStateChanged == gestureState) {
        CGPoint translation = [panGesture translationInView:self];
        self.isLeft = (translation.x - self.origin.x < 0);
        if ((self.isLeft && self.shouldRight) || (!self.isLeft && !self.shouldRight)) {
            return;
        }
        CGFloat maxDistance = self.isLeft ? kDeleteBtnWidth - 2 : kDeleteBtnWidth;
        self.distance = (fabs(translation.x) < kDeleteBtnWidth ? translation.x : (translation.x < 0 ? - maxDistance : maxDistance));
        self.distance = self.isLeft ? MIN(0, self.distance) : MAX(0, self.distance);
        self.contentView.center = CGPointMake(self.originCenter.x + self.rate * self.distance, self.contentView.center.y);
        
        kLNFLog(@"---->>>>%@", @"3");
        kLNFLog(@"---->>>> rate * distance = %f", self.rate * self.distance);
    } else if (UIGestureRecognizerStateEnded == gestureState) { // 一次滑动走一次
        if ((self.isLeft && self.shouldRight) || (!self.isLeft && !self.shouldRight)) {
            return;
        }
        
        if (self.distance - kDeleteBtnWidth < 20.0) {
            [UIView animateWithDuration:0.25 animations:^{
                self.contentView.center = CGPointMake(self.originCenter.x + (self.isLeft ? - kDeleteBtnWidth : kDeleteBtnWidth), self.contentView.center.y);
            } completion:^(BOOL finished) {
                self.originCenter = self.contentView.center;
                self.shouldRight = self.isLeft;
            }];
        }
        
        kLNFLog(@"---->>>>%@", @"4");
    } else {
        kLNFLog(@"---->>>>%@", @"1");
    }
}

- (void)swipeGestureAction:(UISwipeGestureRecognizer *)swipeGesture
{
    CGPoint point = [swipeGesture locationInView:swipeGesture.view];
    kLNFLog(@"---->>>>%@", [NSValue valueWithCGPoint:point]);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:[UICollectionView class]]) {
        UIView *otherView = otherGestureRecognizer.view;
        UIView *thisView = gestureRecognizer.view;
        if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            CGPoint otherTranslation = [(UIPanGestureRecognizer *)otherGestureRecognizer translationInView:otherGestureRecognizer.view];
            CGPoint thisTranslation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
            NSString *newCreate = @""; // 方便断点查看
            // requireGestureRecognizerToFail 前面是要不执行的手势
//            [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
//            [gestureRecognizer requireGestureRecognizerToFail:otherGestureRecognizer];
        }
        return YES;
    } else {
        UIView *otherView = otherGestureRecognizer.view;
        UIView *thisView = gestureRecognizer.view;
        NSString *newCreate = @""; // 方便断点查看
    }
    return NO;
}



@end
