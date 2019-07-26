//
//  LNFDeleteStyleCollectionHeaderView.m
//  iOS_Learning
//
//  Created by mrliu on 2019/7/19.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFDeleteStyleCollectionHeaderView.h"

@implementation LNFDeleteStyleCollectionHeaderView

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
    // 勾选图片
    CGFloat checkImageHeight = 25.0;
    UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, checkImageHeight, checkImageHeight)];
    [self addSubview:checkImageView];
    checkImageView.cornerRadius = checkImageHeight / 2;
    checkImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    checkImageView.lnf_c_y = self.center.y;
    
    // 货仓名称
    UILabel *warehouseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkImageView.frame)+10, 10, 120, 30)];
    [self addSubview:warehouseNameLabel];
    warehouseNameLabel.font = [UIFont systemFontOfSize:15.0];
    warehouseNameLabel.text = @"华东仓";
//    warehouseNameLabel.lnf_c_y = self.center.y;
}

@end
