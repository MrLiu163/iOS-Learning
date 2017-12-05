//
//  LNFMainModuleVc.m
//  iOS_Learning
//
//  Created by liuningfei on 05/12/2017.
//  Copyright © 2017 interstellar. All rights reserved.
//

#import "LNFMainModuleVc.h"
#import "LNFMainModuleListCell.h"

#define kLNFMainModuleListCellIdentifier @"LNFMainModuleListCell"
@interface LNFMainModuleVc () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainModuleCollectionView;
@property (nonatomic, strong) NSArray *vcList;

@end

@implementation LNFMainModuleVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    self.navigationItem.title = @"效果";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加集合视图
    NSArray *mainModuleVcList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kLNFMainModuleInfoPlistFileName ofType:nil]];
    self.vcList = mainModuleVcList;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *mainModuleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:mainModuleCollectionView];
    mainModuleCollectionView.backgroundColor = [UIColor whiteColor];
    mainModuleCollectionView.dataSource = self;
    mainModuleCollectionView.delegate = self;
    [mainModuleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.bottom.and.right.mas_equalTo(self.view);
    }];
    self.mainModuleCollectionView = mainModuleCollectionView;
    
    // 注册cell
    [self.mainModuleCollectionView registerClass:[LNFMainModuleListCell class] forCellWithReuseIdentifier:kLNFMainModuleListCellIdentifier];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.vcList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LNFMainModuleListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLNFMainModuleListCellIdentifier forIndexPath:indexPath];
    cell.titleName = self.vcList[indexPath.row][@"titleName"];
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vcName = self.vcList[indexPath.row][@"vcName"];
    if (vcName.length) {
        UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kLNFScreenWidth, 44);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
