//
//  LNFPictureLoadShowCollectionCell.m
//  iOS_Learning
//
//  Created by mrliu on 2018/10/24.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import "LNFPictureLoadShowCollectionCell.h"

@implementation LNFPictureLoadShowCollectionCell

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
    // 仅一张图片控件
    UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:picView];
    picView.contentMode = UIViewContentModeTopLeft;
    picView.contentMode = UIViewContentModeScaleAspectFit;
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.contentView);
    }];
    self.picView = picView;
}

@end
