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
@interface LNFCollectionViewDataSourceHelper : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) LNFCollectionViewCellConfigureBlock configureCellBlock;

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(LNFCollectionViewCellConfigureBlock)configureCellBlock;

@end

NS_ASSUME_NONNULL_END
