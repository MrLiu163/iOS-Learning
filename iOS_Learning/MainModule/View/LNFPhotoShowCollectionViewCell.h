//
//  LNFPhotoShowCollectionViewCell.h
//  iOS_Learning
//
//  Created by MrLiu on 2018/9/3.
//  Copyright © 2018年 interstellar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNFZoomPictureView;
typedef void(^CheckPictureTapGestureBlock)(UICollectionViewCell *cell);
@interface LNFPhotoShowCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) LNFZoomPictureView *photoPictureView;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, strong) UIImageView *checkPictureView;
@property (nonatomic, assign) BOOL pictureSelect;
@property (nonatomic, copy) CheckPictureTapGestureBlock checkBlock;

@end
