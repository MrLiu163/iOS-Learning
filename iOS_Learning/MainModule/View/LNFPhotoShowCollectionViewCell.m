//
//  LNFPhotoShowCollectionViewCell.m
//  iOS_Learning
//
//  Created by MrLiu on 2018/9/3.
//  Copyright © 2018年 interstellar. All rights reserved.
//

#import "LNFPhotoShowCollectionViewCell.h"
#import "LNFZoomPictureView.h"

@implementation LNFPhotoShowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    LNFZoomPictureView *photoPictureView = [[LNFZoomPictureView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:photoPictureView];
    [photoPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.and.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(2);
        make.right.mas_equalTo(self.contentView).offset(-2);
        make.top.mas_equalTo(self.contentView).offset(2);
        make.bottom.mas_equalTo(self.contentView).offset(-2);
    }];
    photoPictureView.backgroundColor = [UIColor blackColor];
    photoPictureView.contentMode = UIViewContentModeScaleAspectFill;
    photoPictureView.image = [UIImage imageNamed:kLNFPictureName_CommonPlaceholder];
    self.photoPictureView = photoPictureView;
    [self.photoPictureView setContentScaleFactor:1]; //
    self.photoPictureView.clipsToBounds  = YES;
    
    // check pic
    UIView *checkPictureContentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:checkPictureContentView];
    [checkPictureContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.right.mas_equalTo(self.contentView);
        make.width.and.height.mas_equalTo(40);
    }];
    UIImageView *checkPictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [checkPictureContentView addSubview:checkPictureView];
    checkPictureView.image = [UIImage imageNamed:kLNFPictureName_CommonCheckNotChoose];
    checkPictureView.userInteractionEnabled = YES;
    [checkPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(0);
        make.width.and.height.mas_equalTo(20);
    }];
    self.checkPictureView = checkPictureView;
    
    UITapGestureRecognizer *checkPictureTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPictureTapGestureAction:)];
    [checkPictureContentView addGestureRecognizer:checkPictureTapGesture];
}

- (void)setPictureSelect:(BOOL)pictureSelect
{
    if (pictureSelect) {
        self.checkPictureView.image = [UIImage imageNamed:kLNFPictureName_CommonCheckChoose];
    } else {
        self.checkPictureView.image = [UIImage imageNamed:kLNFPictureName_CommonCheckNotChoose];
    }
}

- (void)checkPictureTapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    if (self.checkBlock) {
        self.checkBlock(self);
    }
}

@end
