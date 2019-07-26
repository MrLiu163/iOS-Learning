//
//  LNFCollectionViewDataSourceHelper.m
//  iOS_Learning
//
//  Created by mrliu on 2018/10/24.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import "LNFCollectionViewDataSourceHelper.h"

@interface LNFCollectionViewDataSourceHelper ()

@property (nonatomic, copy) NSString *cellIdentifier;

@end

@implementation LNFCollectionViewDataSourceHelper

- (id)init
{
    return nil;
}
- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(LNFCollectionViewCellConfigureBlock)configureCellBlock
{
    self = [super init];
    if (self) {
        self.items = items;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = [configureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.multipleSections) {
        return self.items[indexPath.section][indexPath.row];
    } else {
        return self.items[indexPath.row];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (0 == self.items.count) return 0;
    
    if (self.multipleSections) {
        return ((NSArray *)self.items[section]).count;
    } else {
        return self.items.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.multipleSections ? self.items.count : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellForItemAtIndexPathBlock) { // 将集合视图和下标回调到外部，从外部生成cell
        return self.cellForItemAtIndexPathBlock(collectionView, indexPath);
    } else { // 直接通过重用池获取到cell，将cell和item回调至外部
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
        NSObject *item = [self itemAtIndexPath:indexPath];
        if (self.configureCellBlock) {
            self.configureCellBlock(cell, item);
        }
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewForSupplementaryElementOfKindBlock) {
        return self.viewForSupplementaryElementOfKindBlock(collectionView, indexPath, kind);
    } else {
        return nil;
    }
}

@end
