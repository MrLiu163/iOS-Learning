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

@end

NS_ASSUME_NONNULL_END
