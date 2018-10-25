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
    return self.items[indexPath.row];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    NSObject *item = [self itemAtIndexPath:indexPath];
    if (self.configureCellBlock) {
        self.configureCellBlock(cell, item);
    }
    return cell;
}

@end
