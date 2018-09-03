//
//  LNFPhotoLibraryPhotoAlbumListVc.h
//  iOS_Learning
//
//  Created by 刘宁飞 on 2018/9/3.
//  Copyright © 2018年 interstellar. All rights reserved.
//

#import "LNFBaseVc.h"

typedef void(^PhotoSelectDoneBlock)(UIImage *photo);
typedef void(^MutiplePhotoSelectDoneBlock)(NSArray<UIImage *> *photoList);
@interface LNFPhotoLibraryPhotoAlbumListVc : LNFBaseVc

@property (nonatomic, assign) BOOL allowMutipleSelect;
@property (nonatomic, copy) PhotoSelectDoneBlock selectDoneBlock;
@property (nonatomic, copy) MutiplePhotoSelectDoneBlock mutipleSelectDoneBlock;
@property (nonatomic, assign) NSInteger maxSelectPicCount; // 最大选择数

@end
