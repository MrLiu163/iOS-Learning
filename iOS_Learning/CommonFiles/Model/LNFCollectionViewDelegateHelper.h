//
//  LNFCollectionViewDelegateHelper.h
//  iOS_Learning
//
//  Created by mrliu on 2018/10/24.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LNFCollectionViewDidSelectItemConfigureBlock)(id indexPath);
@interface LNFCollectionViewDelegateHelper : NSObject <UICollectionViewDelegate>

@property (nonatomic, copy) LNFCollectionViewDidSelectItemConfigureBlock didSelectItemBlock;

@end

NS_ASSUME_NONNULL_END
