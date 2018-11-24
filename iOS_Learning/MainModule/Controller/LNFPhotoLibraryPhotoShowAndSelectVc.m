//
//  LNFPhotoLibraryPhotoShowAndSelectVc.m
//  iOS_Learning
//
//  Created by MrLiu on 2018/9/3.
//  Copyright © 2018年 interstellar. All rights reserved.
//

#import "LNFPhotoLibraryPhotoShowAndSelectVc.h"
#import "LNFPhotoShowCollectionViewCell.h"
#import "LNFFetchPhotoAlbumListHelpModel.h"
#import "LNFZoomPictureView.h"

#define kLNFEdgeInsetsHelpValue         2
#define kLNFPhotoShowCollectionViewCellIdentifier    @"LNFPhotoShowCollectionViewCell"
@interface LNFPhotoLibraryPhotoShowAndSelectVc () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) NSIndexPath *lastSelectIndexPath;
@property (nonatomic, strong) NSMutableArray *mutipleSelectIndexPaths;
@property (nonatomic, strong) NSMutableDictionary *helpAlbumPhotoDict;

@end

@implementation LNFPhotoLibraryPhotoShowAndSelectVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    self.navigationItem.title = self.helpModel.albumName ? : @"照片";
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageManager = [[PHCachingImageManager alloc] init];
    
    UIBarButtonItem *ensurelPickPictureItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensurePickPictureItemAction:)];
    self.navigationItem.rightBarButtonItems = @[ensurelPickPictureItem];
    
    // 添加集合视图
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
    self.collectionViewLayout = collectionViewLayout;
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
    }];
    self.collectionView = collectionView;
    
    // 注册cell
    [self.collectionView registerClass:[LNFPhotoShowCollectionViewCell class] forCellWithReuseIdentifier:kLNFPhotoShowCollectionViewCellIdentifier];
}

#pragma mark - Private Method
- (void)ensurePickPictureItemAction:(UIBarButtonItem *)item
{
    if (!self.allowMutipleSelect) {
        if (!self.lastSelectIndexPath) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择一张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        } else {
            if (self.selectDoneBlock) {
                UIImage *tempImage = [self.helpAlbumPhotoDict objectForKey:[NSString stringWithFormat:@"%zd", self.lastSelectIndexPath.row]];
                self.selectDoneBlock(tempImage);
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } else {
        if (0 == self.mutipleSelectIndexPaths.count) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择一张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        } else {
            if (self.mutipleSelectDoneBlock) {
                if (1 == self.mutipleSelectIndexPaths.count) {
                    NSMutableArray<UIImage *> *imageList = [NSMutableArray array];
                    for (int i = 0; i < self.mutipleSelectIndexPaths.count; i++) {
                        UIImage *tempImage = [self.helpAlbumPhotoDict objectForKey:self.mutipleSelectIndexPaths[i]];
                        [imageList addObject:tempImage];
                    }
                    self.mutipleSelectDoneBlock(imageList);
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    NSString *alertMessage = [NSString stringWithFormat:@"确定选择这%zd张图片吗?", self.mutipleSelectIndexPaths.count];
                    kLNFWeakSelf;
                    [[[UIAlertView alloc] initWithTitle:kLNFUserSelectOptionStr_Title message:alertMessage cancelButtonItem:[LNFButtonItem itemWithLabel:kLNFUserSelectOptionStr_Cancel] otherButtonItems:[LNFButtonItem itemWithLabel:kLNFUserSelectOptionStr_Ensure action:^{
                        NSMutableArray<UIImage *> *imageList = [NSMutableArray array];
                        for (int i = 0; i < weakSelf.mutipleSelectIndexPaths.count; i++) {
                            UIImage *tempImage = [weakSelf.helpAlbumPhotoDict objectForKey:weakSelf.mutipleSelectIndexPaths[i]];
                            [imageList addObject:tempImage];
                        }
                        weakSelf.mutipleSelectDoneBlock(imageList);
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }], nil] show];
                }
            }
        }
    }
}

// 获取图片Asset原来的图片
- (void)requestTheOriginalImageForAsset:(PHAsset *)asset index:(NSInteger)index
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        //        CGSize size = CGSizeMake((100 * [UIScreen mainScreen].scale), (100 * [UIScreen mainScreen].scale));
        [self.imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            dispatch_async( dispatch_get_main_queue(), ^{
                /*
                 The cell may have been recycled by the time this handler gets called so we should only
                 set the cell's thumbnail image only if it's still showing the same asset.
                 */
                if ( result != nil ) {
                    [self.helpAlbumPhotoDict setObject:result forKey:[NSString stringWithFormat:@"%zd", index]];
                }
            } );
        }];
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.helpModel.albumAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LNFPhotoShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLNFPhotoShowCollectionViewCellIdentifier forIndexPath:indexPath];
    NSInteger invertedIndex = self.helpModel.albumAssets.count - indexPath.row - 1;
    PHAsset *asset = self.helpModel.albumAssets[invertedIndex];
    cell.photoPictureView.asset = asset;
    cell.representedAssetIdentifier = asset.localIdentifier;
    if (self.allowMutipleSelect) { // 可以多选的
        if ([self.mutipleSelectIndexPaths containsObject:[NSString stringWithFormat:@"%zd", indexPath.row]]) {
            cell.pictureSelect = YES;
        } else {
            cell.pictureSelect = NO;
        }
    } else { // 仅能单选
        if (self.lastSelectIndexPath && (indexPath.row == self.lastSelectIndexPath.row)) {
            cell.pictureSelect = YES;
        } else {
            cell.pictureSelect = NO;
        }
    }
    kLNFWeakSelf;
    // !!!: 图片勾选处理
    cell.checkBlock = ^(UICollectionViewCell *checkCell) {
        
        if (!weakSelf.allowMutipleSelect) { // 非多选
            if (!weakSelf.lastSelectIndexPath) {
                LNFPhotoShowCollectionViewCell *thisCell = (LNFPhotoShowCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                thisCell.pictureSelect = YES;
                weakSelf.lastSelectIndexPath = indexPath;
                
                [weakSelf requestTheOriginalImageForAsset:asset index:indexPath.row];
            } else {
                if (indexPath.row != weakSelf.lastSelectIndexPath.row) {
                    LNFPhotoShowCollectionViewCell *thisCell = (LNFPhotoShowCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                    LNFPhotoShowCollectionViewCell *lastCell = (LNFPhotoShowCollectionViewCell *)[collectionView cellForItemAtIndexPath:weakSelf.lastSelectIndexPath];
                    thisCell.pictureSelect = YES;
                    lastCell.pictureSelect = NO;
                    weakSelf.lastSelectIndexPath = indexPath;
                    
                    [weakSelf requestTheOriginalImageForAsset:asset index:indexPath.row];
                }
            }
        } else { // 多选
            // 多选不能超过最大选择数限制
            if (weakSelf.mutipleSelectIndexPaths.count + 1 > weakSelf.maxSelectPicCount) {
                if (![weakSelf.mutipleSelectIndexPaths containsObject:[NSString stringWithFormat:@"%zd", indexPath.row]]) {
                    NSString *alertMessageStr = [NSString stringWithFormat:@"最多选择%zd张图片", weakSelf.maxSelectPicCount];
                    [[[UIAlertView alloc] initWithTitle:kLNFUserSelectOptionStr_Title message:alertMessageStr delegate:nil cancelButtonTitle:kLNFUserSelectOptionStr_Ensure otherButtonTitles:nil] show];
                    return;
                }
            }
            
            if ([weakSelf.mutipleSelectIndexPaths containsObject:[NSString stringWithFormat:@"%zd", indexPath.row]]) {
                LNFPhotoShowCollectionViewCell *thisCell = (LNFPhotoShowCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                thisCell.pictureSelect = NO;
                [weakSelf.mutipleSelectIndexPaths removeObject:[NSString stringWithFormat:@"%zd", indexPath.row]];
            } else {
                LNFPhotoShowCollectionViewCell *thisCell = (LNFPhotoShowCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                thisCell.pictureSelect = YES;
                [weakSelf.mutipleSelectIndexPaths addObject:[NSString stringWithFormat:@"%zd", indexPath.row]];
                
                [weakSelf requestTheOriginalImageForAsset:asset index:indexPath.row];
            }
        }
        
    };
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        CGSize size = CGSizeMake((100 * [UIScreen mainScreen].scale), (100 * [UIScreen mainScreen].scale));
        [self.imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            dispatch_async( dispatch_get_main_queue(), ^{
                /*
                 The cell may have been recycled by the time this handler gets called so we should only
                 set the cell's thumbnail image only if it's still showing the same asset.
                 */
                if ( result != nil ) {
                    if ( [cell.representedAssetIdentifier isEqualToString:asset.localIdentifier] ) {
                        cell.photoPictureView.image = result;
                        [weakSelf.helpAlbumPhotoDict setObject:result forKey:[NSString stringWithFormat:@"%zd", indexPath.row]];
                    }
                }
            } );
        }];
    });
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.allowMutipleSelect) {
        if (!self.lastSelectIndexPath) {
            LNFPhotoShowCollectionViewCell *thisCell = (LNFPhotoShowCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            thisCell.checkPictureView.hidden = NO;
            self.lastSelectIndexPath = indexPath;
        } else {
            if (indexPath.row != self.lastSelectIndexPath.row) {
                LNFPhotoShowCollectionViewCell *thisCell = (LNFPhotoShowCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                LNFPhotoShowCollectionViewCell *lastCell = (LNFPhotoShowCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.lastSelectIndexPath];
                thisCell.checkPictureView.hidden= NO;
                lastCell.checkPictureView.hidden = YES;
                self.lastSelectIndexPath = indexPath;
            }
        }
    } else {
        if ([self.mutipleSelectIndexPaths containsObject:[NSString stringWithFormat:@"%zd", indexPath.row]]) {
            LNFPhotoShowCollectionViewCell *thisCell = (LNFPhotoShowCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            thisCell.checkPictureView.hidden = YES;
            [self.mutipleSelectIndexPaths removeObject:[NSString stringWithFormat:@"%zd", indexPath.row]];
        } else {
            LNFPhotoShowCollectionViewCell *thisCell = (LNFPhotoShowCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            thisCell.checkPictureView.hidden = NO;
            [self.mutipleSelectIndexPaths addObject:[NSString stringWithFormat:@"%zd", indexPath.row]];
        }
    }
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kLNFScreenWidth - kLNFEdgeInsetsHelpValue) / 4, (kLNFScreenWidth - kLNFEdgeInsetsHelpValue) / 4);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kLNFEdgeInsetsHelpValue, kLNFEdgeInsetsHelpValue, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - getter
- (NSMutableArray *)mutipleSelectIndexPaths
{
    if (!_mutipleSelectIndexPaths) {
        self.mutipleSelectIndexPaths = [NSMutableArray array];
    }
    return _mutipleSelectIndexPaths;
}
- (NSMutableDictionary *)helpAlbumPhotoDict
{
    if (!_helpAlbumPhotoDict) {
        self.helpAlbumPhotoDict = [NSMutableDictionary dictionary];
    }
    return _helpAlbumPhotoDict;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
