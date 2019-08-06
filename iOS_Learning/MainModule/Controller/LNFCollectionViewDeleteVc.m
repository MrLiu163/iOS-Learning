//
//  LNFCollectionViewDeleteVc.m
//  iOS_Learning
//
//  Created by mrliu on 2019/5/31.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFCollectionViewDeleteVc.h"
#import "LNFDeleteStyleCollectionCell.h"
#import "LNFDeleteStyleCollectionHeaderView.h"

@interface LNFCollectionViewDeleteVc () <UIScrollViewDelegate>

@property (nonatomic, strong) LNFCollectionViewDataSourceHelper *dataSourceHelper;
@property (nonatomic, strong) LNFCollectionViewDelegateHelper *delegateHelper;
@property (nonatomic, strong) UICollectionView *learnCollectionView;

@end

@implementation LNFCollectionViewDeleteVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    self.navigationItem.title = @"集合视图删除效果";
    kLNFWeakSelf;
    NSArray<NSArray<NSString *> *> *dataList = @[@[@"", @"", @"", @"", @"", @""], @[@"", @"", @"", @"", @"", @""]];
    NSString *headerIdentifier = @"HeaderID";
//    NSArray<NSString *> *dataList = @[@""];
    
    LNFCollectionViewCellForItemAtIndexPathBlock cellForItemAtIndexPathBlock = ^UICollectionViewCell *(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath) {
        LNFDeleteStyleCollectionCell *baseParaCell = [collectionView dequeueReusableCellWithReuseIdentifier:kLNFUICollectionViewCellIndetifier forIndexPath:indexPath];
        baseParaCell.contentView.backgroundColor = [UIColor whiteColor];
        // 第一个和最后一个分别切圆角
        NSArray *sectionModelList = weakSelf.dataSourceHelper.items[indexPath.section];
        if (0 == indexPath.row) {
            baseParaCell.makeUpCornerRadius = YES;
        } else if ((sectionModelList.count - 1) == indexPath.row) {
            baseParaCell.makeBottomCornerRadius = YES;
        }
        return baseParaCell;
    };
    LNFCollectionViewDidSelectItemConfigureBlock didSelectBlock = ^(NSIndexPath *indexPath) {
        
    };
    LNFCollectionViewForSupplementaryElementOfKindBlock viewForSupplementaryElementOfKindBlock = ^UICollectionReusableView *(UICollectionView *theCollectionView, NSIndexPath *indexPath, NSString *elementKind) {
        LNFDeleteStyleCollectionHeaderView *headerView = [theCollectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    };
    LNFCollectionViewDataSourceHelper *dataSourceHelper = [[LNFCollectionViewDataSourceHelper alloc] initWithItems:dataList cellIdentifier:kLNFUICollectionViewCellIndetifier configureCellBlock:nil];
    dataSourceHelper.multipleSections = YES;
    dataSourceHelper.cellForItemAtIndexPathBlock = cellForItemAtIndexPathBlock;
    dataSourceHelper.viewForSupplementaryElementOfKindBlock = viewForSupplementaryElementOfKindBlock;
    self.dataSourceHelper = dataSourceHelper;
    LNFCollectionViewDelegateHelper *delegateHelper = [[LNFCollectionViewDelegateHelper alloc] init];
    delegateHelper.didSelectItemBlock = didSelectBlock;
    self.delegateHelper = delegateHelper;
    
    // 添加集合视图
    NSInteger everyLineCount = 1;
    CGFloat horizontalSpace = 10.0, verticalSpace = 10.0, itemWidth = (kLNFScreenWidth - horizontalSpace * (everyLineCount + 1)) / everyLineCount, itemHeight = 80.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *learnCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    learnCollectionView.backgroundColor = kLNFColorWithHex(0xF5F5F5);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
//    layout.minimumLineSpacing = verticalSpace;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = horizontalSpace;
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    layout.headerReferenceSize = CGSizeMake(kLNFScreenWidth, 45);
    [self.view addSubview:learnCollectionView];
//    learnCollectionView.backgroundColor = [UIColor whiteColor];
    learnCollectionView.dataSource = dataSourceHelper;
    learnCollectionView.delegate = delegateHelper;
    [learnCollectionView registerClass:[LNFDeleteStyleCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [learnCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    // 注册cell
    [learnCollectionView registerClass:[LNFDeleteStyleCollectionCell class] forCellWithReuseIdentifier:kLNFUICollectionViewCellIndetifier];
    self.learnCollectionView = learnCollectionView;
    
}


@end
