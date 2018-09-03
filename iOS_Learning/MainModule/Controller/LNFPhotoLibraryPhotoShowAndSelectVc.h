//
//  LNFPhotoLibraryPhotoShowAndSelectVc.h
//  iOS_Learning
//
//  Created by 刘宁飞 on 2018/9/3.
//  Copyright © 2018年 interstellar. All rights reserved.
//

#import "LNFBaseVc.h"

typedef void(^PhotoSelectDoneBlock)(UIImage *photo);
typedef void(^MutiplePhotoSelectDoneBlock)(NSArray<UIImage *> *photoList);
@class LNFFetchPhotoAlbumListHelpModel;
@interface LNFPhotoLibraryPhotoShowAndSelectVc : LNFBaseVc

@property (nonatomic, strong) LNFFetchPhotoAlbumListHelpModel *helpModel;
@property (nonatomic, copy) PhotoSelectDoneBlock selectDoneBlock;

@property (nonatomic, assign) BOOL allowMutipleSelect;
@property (nonatomic, copy) MutiplePhotoSelectDoneBlock mutipleSelectDoneBlock;

@property (nonatomic, assign) NSInteger maxSelectPicCount; // 最大选择数

@end
