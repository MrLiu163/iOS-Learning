//
//  LNFPhotoLibraryPhotoAlbumListCell.h
//  iOS_Learning
//
//  Created by MrLiu on 2018/9/3.
//  Copyright © 2018年 interstellar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNFFetchPhotoAlbumListHelpModel;
@interface LNFPhotoLibraryPhotoAlbumListCell : UITableViewCell

@property (nonatomic, strong) LNFFetchPhotoAlbumListHelpModel *albumHelpModel;
@property (nonatomic, strong) UIImageView *albumPictureView;
- (void)configureCellWithHelpModel:(LNFFetchPhotoAlbumListHelpModel *)helpModel;

@end
