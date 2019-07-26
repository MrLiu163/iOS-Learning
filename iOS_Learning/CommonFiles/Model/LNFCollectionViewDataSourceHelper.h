//
//  LNFCollectionViewDataSourceHelper.h
//  iOS_Learning
//
//  Created by mrliu on 2018/10/24.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LNFCollectionViewCellConfigureBlock)(id cell, id item);
typedef UICollectionViewCell*(^LNFCollectionViewCellForItemAtIndexPathBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);
typedef UICollectionReusableView*(^LNFCollectionViewForSupplementaryElementOfKindBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, NSString *elementKind);
@interface LNFCollectionViewDataSourceHelper : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) LNFCollectionViewCellConfigureBlock configureCellBlock; // 直接取的重用池的cell，一般是统一cell情况。
@property (nonatomic, copy) LNFCollectionViewCellForItemAtIndexPathBlock cellForItemAtIndexPathBlock; // 从外部block中返回cell，一般是cell有不同样式情况。
@property (nonatomic, copy) LNFCollectionViewForSupplementaryElementOfKindBlock viewForSupplementaryElementOfKindBlock; // 从外部block中返回区头区尾
@property (nonatomic, assign) BOOL multipleSections; // 是否是多分区情况，默认否(即只有一个分区)。

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(LNFCollectionViewCellConfigureBlock)configureCellBlock;

@end

NS_ASSUME_NONNULL_END
