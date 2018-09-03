//
//  LNFPhotoLibraryPhotoAlbumListCell.m
//  iOS_Learning
//
//  Created by 刘宁飞 on 2018/9/3.
//  Copyright © 2018年 interstellar. All rights reserved.
//

#import "LNFPhotoLibraryPhotoAlbumListCell.h"
#import "LNFFetchPhotoAlbumListHelpModel.h"

@interface LNFPhotoLibraryPhotoAlbumListCell ()

@property (nonatomic, strong) UILabel *albumNameLabel;
@property (nonatomic, strong) UILabel *albumPicCountLabel;

@end

@implementation LNFPhotoLibraryPhotoAlbumListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 相册缩略图
    UIImageView *albumPictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:albumPictureView];
    albumPictureView.backgroundColor = [UIColor darkGrayColor];
    albumPictureView.contentMode = UIViewContentModeScaleAspectFill;
    [albumPictureView setContentScaleFactor:1]; // 设置宽高比
    albumPictureView.clipsToBounds  = YES;
    albumPictureView.image = [UIImage imageNamed:kLNFPictureName_CommonPlaceholder];
    [albumPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.width.and.height.mas_equalTo(self.contentView.mas_height).valueOffset(@(-20));
    }];
    self.albumPictureView = albumPictureView;
    //
    UILabel *albumNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:albumNameLabel];
    albumNameLabel.text = @"相机胶卷";
    albumNameLabel.font = kLNFSystemFont17;
    [albumNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(albumPictureView.mas_right).offset(20);
        make.centerY.mas_equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
    self.albumNameLabel = albumNameLabel;
    
    UILabel *albumPicCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:albumPicCountLabel];
    albumPicCountLabel.text = @"8";
    albumPicCountLabel.font = kLNFSystemFont17;
    albumPicCountLabel.textColor = kLNFLightGrayFontColor;
    [albumPicCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(albumPictureView.mas_right).offset(20);
        make.centerY.mas_equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
    self.albumPicCountLabel = albumPicCountLabel;
}

- (void)configureCellWithHelpModel:(LNFFetchPhotoAlbumListHelpModel *)helpModel
{
    //    self.albumPictureView.image = helpModel.albumImages.lastObject;
    self.albumNameLabel.text = helpModel.albumName;
    self.albumPicCountLabel.text = [NSString stringWithFormat:@"%zd", helpModel.albumAssets.count];
}

@end
