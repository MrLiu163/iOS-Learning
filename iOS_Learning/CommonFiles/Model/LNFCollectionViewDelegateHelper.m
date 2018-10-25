//
//  LNFCollectionViewDelegateHelper.m
//  iOS_Learning
//
//  Created by mrliu on 2018/10/24.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import "LNFCollectionViewDelegateHelper.h"

@implementation LNFCollectionViewDelegateHelper

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(indexPath);
    }
}

@end
