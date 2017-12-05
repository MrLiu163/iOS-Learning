//
//  LNFMainModuleListCell.m
//  iOS_Learning
//
//  Created by liuningfei on 05/12/2017.
//  Copyright © 2017 interstellar. All rights reserved.
//

#import "LNFMainModuleListCell.h"

@interface LNFMainModuleListCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation LNFMainModuleListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // 标题
    UILabel *titleNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:titleNameLabel];
    titleNameLabel.text = @"名称";
    titleNameLabel.textAlignment = NSTextAlignmentLeft;
    titleNameLabel.font = kLNFSystemFont13;
    [titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    self.titleNameLabel = titleNameLabel;
    
    // 分隔线
    UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:seperatorLine];
    seperatorLine.backgroundColor = kLNFTableViewSeperatorColor;
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(self.contentView);
    }];
}

#pragma mark - setter
- (void)setTitleName:(NSString *)titleName
{
    _titleName = titleName;
    self.titleNameLabel.text = titleName;
}

@end
