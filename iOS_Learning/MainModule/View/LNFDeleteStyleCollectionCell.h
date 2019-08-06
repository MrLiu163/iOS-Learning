//
//  LNFDeleteStyleCollectionCell.h
//  iOS_Learning
//
//  Created by mrliu on 2019/5/31.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNFDeleteStyleCollectionCell : UICollectionViewCell

/** 切上部分两个圆角 */
@property (nonatomic, assign) BOOL makeUpCornerRadius;

/** 切下部分两个圆角 */
@property (nonatomic, assign) BOOL makeBottomCornerRadius;

@end

NS_ASSUME_NONNULL_END
