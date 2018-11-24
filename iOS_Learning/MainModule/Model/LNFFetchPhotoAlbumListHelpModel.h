//
//  LNFFetchPhotoAlbumListHelpModel.h
//  iOS_Learning
//
//  Created by MrLiu on 2018/9/3.
//  Copyright © 2018年 interstellar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@class LNFAssetRequestImageHelpModel;
@interface LNFFetchPhotoAlbumListHelpModel : NSObject

@property (nonatomic, assign) PHAssetCollectionSubtype subType;
@property (nonatomic, strong) PHFetchResult<PHAsset *> *assetsFetchResult;
@property (nonatomic, strong) NSArray<PHAsset *> *albumAssets;
@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, strong) NSArray<UIImage *> *albumImages;
@property (nonatomic, strong) NSArray<LNFAssetRequestImageHelpModel *> *requestHelpModelList;

@end
