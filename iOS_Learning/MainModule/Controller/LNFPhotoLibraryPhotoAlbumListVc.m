//
//  LNFPhotoLibraryPhotoAlbumListVc.m
//  iOS_Learning
//
//  Created by 刘宁飞 on 2018/9/3.
//  Copyright © 2018年 interstellar. All rights reserved.
//

#import "LNFPhotoLibraryPhotoAlbumListVc.h"
#import "LNFPhotoLibraryPhotoAlbumListCell.h"
#import <Photos/Photos.h>
#import "LNFFetchPhotoAlbumListHelpModel.h"
#import "LNFPhotoLibraryPhotoShowAndSelectVc.h"
#import "LNFAssetRequestImageHelpModel.h"

#define kLNFPhotoAlbumName_photoLibrary      @"相机胶卷"
#define kLNFPhotoAlbumName_myPhotoStream     @"我的照片流"
#define kLNFPhotoAlbumName_screenshots       @"屏幕快照"
#define kLNFPhotoAlbumName_recentlyAdded     @"最近添加"
#define kLNFPhotoLibraryPhotoAlbumListCellIdentifier     @"LNFPhotoLibraryPhotoAlbumListCell"
@interface LNFPhotoLibraryPhotoAlbumListVc () <PHPhotoLibraryChangeObserver>

@property (nonatomic, copy) TableViewCellConfigureBlock cellConfigureBlock;
@property (nonatomic, strong) UITableView *photoAlbumTable;
@property (nonatomic, strong) LNFTableViewDataSourceHelper *dataSourceHelper;
@property (nonatomic, strong) LNFTableViewDelegateHelper *delegateHepler;

@property (nonatomic) PHCachingImageManager *imageManager;
@property (nonatomic) PHFetchResult<PHAsset *> *assetsFetchResult;
@property (nonatomic) PHImageRequestID assetRequestID;
@property (nonatomic) CGRect previousPreheatRect;
@property (nonatomic, strong) NSArray<PHFetchResult<PHAsset *> *> *assetsFetchResultList;
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSNumber *> *> *fetchAssetCollectionsSubtypeList;
@property (nonatomic, strong) NSArray<LNFFetchPhotoAlbumListHelpModel *> *albumHelpModelList;
@property (nonatomic, assign) NSInteger helpCount;

@end

@implementation LNFPhotoLibraryPhotoAlbumListVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self reportPhotosAuthorizationStatus];
}

- (void)initUI
{
    self.navigationItem.title = @"照片";
    self.view.backgroundColor = [UIColor whiteColor];
    self.maxSelectPicCount = self.maxSelectPicCount ? : NSIntegerMax;
    kLNFWeakSelf;
    self.fetchAssetCollectionsSubtypeList = @[@{kLNFPhotoAlbumName_photoLibrary : @(PHAssetCollectionSubtypeSmartAlbumUserLibrary)}, @{kLNFPhotoAlbumName_screenshots : @(PHAssetCollectionSubtypeSmartAlbumScreenshots)}, @{kLNFPhotoAlbumName_recentlyAdded : @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded)}]; // @{@"视频" : @(PHAssetCollectionSubtypeSmartAlbumVideos)}
    
    UIBarButtonItem *cancelPickPictureItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPickPictureItemAction:)];
    self.navigationItem.rightBarButtonItems = @[cancelPickPictureItem];
    
    // 代理配置
    TableViewCellConfigureBlock cellConfigureBlock = ^(LNFPhotoLibraryPhotoAlbumListCell *cell, LNFFetchPhotoAlbumListHelpModel *item) {
        [cell configureCellWithHelpModel:item];
    };
    self.cellConfigureBlock = cellConfigureBlock;
    TableViewDidSelectRowConfigureBlock didSelectRowBlock = ^(NSIndexPath *indexPath) {
        LNFPhotoLibraryPhotoShowAndSelectVc *albumPhotosVc = [[LNFPhotoLibraryPhotoShowAndSelectVc alloc] init];
        albumPhotosVc.helpModel = weakSelf.dataSourceHelper.items[indexPath.row];
        albumPhotosVc.hidesBottomBarWhenPushed = YES;
        albumPhotosVc.maxSelectPicCount = weakSelf.maxSelectPicCount ? : NSIntegerMax;
        if (self.allowMutipleSelect) {
            albumPhotosVc.allowMutipleSelect = YES;
            albumPhotosVc.mutipleSelectDoneBlock = ^(NSArray<UIImage *> *photoList) {
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    if (weakSelf.mutipleSelectDoneBlock) {
                        weakSelf.mutipleSelectDoneBlock(photoList);
                    }
                }];
            };
        } else {
            albumPhotosVc.selectDoneBlock = ^(UIImage *photo) {
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    if (weakSelf.selectDoneBlock) {
                        weakSelf.selectDoneBlock(photo);
                    }
                }];
            };
        }
        [weakSelf.navigationController pushViewController:albumPhotosVc animated:YES];
    };
    LNFTableViewDataSourceHelper *dataSourceHelper = [[LNFTableViewDataSourceHelper alloc] initWithItems:@[] cellIdentifier:kLNFPhotoLibraryPhotoAlbumListCellIdentifier configureCellBlock:cellConfigureBlock];
    self.dataSourceHelper = dataSourceHelper;
    
    LNFTableViewDelegateHelper *delegateHepler = [[LNFTableViewDelegateHelper alloc] init];
    delegateHepler.cellHeight = 100;
    delegateHepler.didSelectRowBlock = didSelectRowBlock;
    self.delegateHepler = delegateHepler;
    
    UITableView *photoAlbumTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:photoAlbumTable];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLNFScreenWidth, 0)];
    photoAlbumTable.tableHeaderView = headerView;
    photoAlbumTable.dataSource = dataSourceHelper;
    photoAlbumTable.delegate = delegateHepler;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLNFScreenWidth, 40)];
    photoAlbumTable.tableFooterView = footerView;
    [photoAlbumTable registerClass:[LNFPhotoLibraryPhotoAlbumListCell class] forCellReuseIdentifier:kLNFPhotoLibraryPhotoAlbumListCellIdentifier];
    [photoAlbumTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    self.photoAlbumTable = photoAlbumTable;
    
    UILabel *myAlbumPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [footerView addSubview:myAlbumPlaceholderLabel];
    myAlbumPlaceholderLabel.text = @"我的相簿";
    myAlbumPlaceholderLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [myAlbumPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(footerView).offset(15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(90);
    }];
}

#pragma mark - Private Method
- (BOOL)reportPhotosAuthorizationStatus {
    /*
     We can ask the photo library ahead of time what the authorization status
     is for our bundle and take the appropriate action.
     */
    NSString *statusText = nil;
    if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        statusText = NSLocalizedString(@"UNDETERMINED", @"");
    } else if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted) {
        statusText = NSLocalizedString(@"RESTRICTED", @"");
    } else if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
        statusText = NSLocalizedString(@"DENIED", @"");
    } else if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        statusText = NSLocalizedString(@"GRANTED", @"");
    }
    if ([statusText isEqualToString:@"GRANTED"]) {
        [self setUpPhotoLibrary];
        return YES;
    } else if ([statusText isEqualToString:@"RESTRICTED"] || [statusText isEqualToString:@"DENIED"]) {
        statusText = @"请允许iOS-App访问您的相册，可进入【设置】->【隐私】->【照片】进行设置";
        [[[UIAlertView alloc] initWithTitle:@"提示" message:statusText cancelButtonItem:[LNFButtonItem itemWithLabel:@"取消"] otherButtonItems:[LNFButtonItem itemWithLabel:@"确定" action:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }], nil] show];
        
        return NO;
    } else if ([statusText isEqualToString:@"UNDETERMINED"]) {
        [self requestPhotosAccessUsingPhotoLibrary];
        return NO;
    }
    statusText = @"请允许iOS-App访问您的相册，可进入【设置】->【隐私】->【照片】进行设置";
    [[[UIAlertView alloc] initWithTitle:nil message:statusText delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    return NO;
}
- (void)requestPhotosAccessUsingPhotoLibrary {
    /*
     There are two ways to prompt the user for permission to access photos.
     This one will not display the photo picker UI. See the
     UIImagePickerController example in this file for the other way to
     request photo access.
     */
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reportPhotosAuthorizationStatus];
        });
    }];
}
- (void)setUpPhotoLibrary
{
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self resetCachedAssets];
    
    
    NSMutableArray *tempFetchResultsList = [NSMutableArray array];
    NSMutableArray *identifierStrList = [NSMutableArray array];
    for (int i = 0; i < self.fetchAssetCollectionsSubtypeList.count; i++) {
        NSDictionary *dict = self.fetchAssetCollectionsSubtypeList[i];
        NSString *key = dict.allKeys.firstObject;
        NSNumber *value = dict[key];
        PHAssetCollectionSubtype collectionSubType = [value integerValue];
        PHFetchResult<PHAssetCollection *> *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:collectionSubType options:nil]; // PHAssetCollectionSubtypeSmartAlbumUserLibrary PHAssetCollectionTypeSmartAlbum
        PHAssetCollection *smartAlbum = smartAlbumsFetchResult.firstObject;
        LNFFetchPhotoAlbumListHelpModel *helpModel = [LNFFetchPhotoAlbumListHelpModel new];
        helpModel.subType = collectionSubType;
        helpModel.albumName = key;
        if (smartAlbum) {
            PHFetchOptions *fetchOption = [PHFetchOptions new];
            fetchOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            helpModel.assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:smartAlbum options:fetchOption];
            PHAsset *asset = nil;
            NSInteger rowIndex = i;
            // 去除非图片类型的
            NSMutableArray<PHAsset *> *tempAssets_forModel = [NSMutableArray array];
            for (PHAsset *tempAsset in helpModel.assetsFetchResult) {
                if (tempAsset.mediaType == PHAssetMediaTypeImage) {
                    [tempAssets_forModel addObject:tempAsset];
                } else {
                    kLNFLog(@"---->>>>%@", @"Other type media");
                }
            }
            helpModel.albumAssets = tempAssets_forModel;
            if (helpModel.albumAssets.count) {
                for (NSInteger j = helpModel.albumAssets.count - 1; j > 0; j--) {
                    if ((PHAssetMediaTypeImage == asset.mediaType) || (PHAssetMediaTypeUnknown == asset.mediaType)) {
                        asset = helpModel.albumAssets[j];
                        break;
                    } else {
                        kLNFLog(@"---->>>>%@", @"other type media");
                    }
                }
            } else {
                self.helpCount += 1;
            }
            rowIndex = i - self.helpCount;
            if (asset) {
                [tempFetchResultsList addObject:helpModel];
                NSString *representedAssetIdentifier = asset.localIdentifier;
                [identifierStrList addObject:representedAssetIdentifier];
                [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(kLNFScreenWidth, kLNFScreenWidth) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                    dispatch_async( dispatch_get_main_queue(), ^{
                        /*
                         The cell may have been recycled by the time this handler gets called so we should only
                         set the cell's thumbnail image only if it's still showing the same asset.
                         */
                        kLNFLog(@"---->>>>info: %@ id: %@", info, asset.localIdentifier);
                        if ( result != nil ) {
                            LNFPhotoLibraryPhotoAlbumListCell *cell = [self.photoAlbumTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
                            cell.albumPictureView.image = result;
                        }
                    });
                }];
            }
        }
    }
    self.albumHelpModelList = tempFetchResultsList;
    self.dataSourceHelper.items = self.albumHelpModelList;
    [self.photoAlbumTable reloadData];
    
    self.assetRequestID = PHInvalidImageRequestID;
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}
- (void)cancelPickPictureItemAction:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Photo Library
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    
}
#pragma mark Asset Management
- (void)resetCachedAssets
{
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
