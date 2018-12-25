//
//  LNFMainModuleVc.m
//  iOS_Learning
//
//  Created by MrLiu on 05/12/2017.
//  Copyright © 2017 interstellar. All rights reserved.
//

#import "LNFMainModuleVc.h"
#import "LNFChangeBaseUrlVc.h"
#import "LNFPasswordGenerateVc.h"
#import "LNFPhotoLibraryPhotoAlbumListVc.h"
#import "LNFLoadPictureBySemaphoreVc.h"

#define kLNFMainItemName_ChangeBaseUrl                      @"Change BaseUrl"
#define kLNFMainItemName_BezierRoundAnimation               @"贝塞尔切环动画"
#define kLNFMainItemName_GeneratePassword                   @"生成密码"
#define kLNFMainItemName_CheckAuthorityByFingerprint        @"用户指纹验证"
#define kLNFMainItemName_PhotoLibraryMultiSelect            @"相册图片多选效果"
#define kLNFMainItemName_SemaphoreRequestQueue              @"信号量控制请求队列"
#define kLNFMainItemName_LoadingFiles                       @"下载文件"
#define kLNFMainItemName_DownloadMP3Files                   @"下载Mp3文件"
#define kLNFMainItemName_DownloadMVFiles                    @"下载MV文件"
#define kLNFMainItemName_DownloadNetVideo                   @"下载网页视频"
#define kLNFMainItemName_StringEncodeDecode                 @"字符UTF编码解码"
#define kLNFMainItemName_DivideHTMLLabel                    @"分解HTML标签"
#define kLNFMainItemName_DirectDownloadVideo                @"直接下载视频"
@interface LNFMainModuleVc ()

@property (nonatomic, strong) LNFTableViewDataSourceHelper *dataSourceHelper;
@property (nonatomic, strong) LNFTableViewDelegateHelper *delegateHepler;
@property (nonatomic, strong) UITableView *mainItemTable;

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
    kLNFWeakSelf;
    
    NSArray *itemList = @[kLNFMainItemName_GeneratePassword, kLNFMainItemName_ChangeBaseUrl, kLNFMainItemName_CheckAuthorityByFingerprint, kLNFMainItemName_PhotoLibraryMultiSelect, kLNFMainItemName_SemaphoreRequestQueue, kLNFMainItemName_LoadingFiles, kLNFMainItemName_DownloadMP3Files, kLNFMainItemName_DownloadMVFiles, kLNFMainItemName_DownloadNetVideo, kLNFMainItemName_StringEncodeDecode, kLNFMainItemName_DivideHTMLLabel, kLNFMainItemName_DirectDownloadVideo];
    TableViewCellConfigureBlock cellConfigureBlock = ^(UITableViewCell *cell, NSString *item) {
        cell.textLabel.text = item;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    };
    TableViewDidSelectRowConfigureBlock didSelectRowBlock = ^(NSIndexPath *indexPath) {
        [weakSelf didSelectCellWithItemName:weakSelf.dataSourceHelper.items[indexPath.row]];
    };
    LNFTableViewDataSourceHelper *dataSourceHelper = [[LNFTableViewDataSourceHelper alloc] initWithItems:itemList cellIdentifier:kLNFUITableViewCellIndetifier configureCellBlock:cellConfigureBlock];
    self.dataSourceHelper = dataSourceHelper;
    
    LNFTableViewDelegateHelper *delegateHepler = [[LNFTableViewDelegateHelper alloc] init];
    delegateHepler.cellHeight = 44;
    delegateHepler.didSelectRowBlock = didSelectRowBlock;
    self.delegateHepler = delegateHepler;
    
    UITableView *mainItemTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:mainItemTable];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLNFScreenWidth, 0)];
    mainItemTable.tableHeaderView = headerView;
    mainItemTable.dataSource = dataSourceHelper;
    mainItemTable.delegate = delegateHepler;
    mainItemTable.tableFooterView = [UIView new];
    [mainItemTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kLNFUITableViewCellIndetifier];
    [mainItemTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    self.mainItemTable = mainItemTable;
}
#pragma mark - Private Method
- (void)didSelectCellWithItemName:(NSString *)itemName
{
    if ([itemName isEqualToString:kLNFMainItemName_ChangeBaseUrl]) {
        LNFChangeBaseUrlVc *changeUrlVc = [[LNFChangeBaseUrlVc alloc] init];
        changeUrlVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changeUrlVc animated:YES];
    } else if ([itemName isEqualToString:kLNFMainItemName_CheckAuthorityByFingerprint]) {
        [LNFAppHelper checkUserAuthorityByFingerprint];
    } else if ([itemName isEqualToString:kLNFMainItemName_GeneratePassword]) {
        LNFPasswordGenerateVc *passwordGenerateVc = [[LNFPasswordGenerateVc alloc] init];
        passwordGenerateVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:passwordGenerateVc animated:YES];
    } else if ([itemName isEqualToString:kLNFMainItemName_PhotoLibraryMultiSelect]) {
        LNFPhotoLibraryPhotoAlbumListVc *albumListVc = [[LNFPhotoLibraryPhotoAlbumListVc alloc] init];
        albumListVc.hidesBottomBarWhenPushed = YES;
        albumListVc.allowMutipleSelect = YES;
        albumListVc.maxSelectPicCount = 3;
        albumListVc.mutipleSelectDoneBlock = ^(NSArray<UIImage *> *photoList) {
            
        };
        LNFNavigationVc *navVc = [[LNFNavigationVc alloc] initWithRootViewController:albumListVc];
        [self presentViewController:navVc animated:YES completion:nil];
    } else if ([itemName isEqualToString:kLNFMainItemName_SemaphoreRequestQueue]) {
        LNFLoadPictureBySemaphoreVc *semaphoreRequestVc = [[LNFLoadPictureBySemaphoreVc alloc] init];
        semaphoreRequestVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:semaphoreRequestVc animated:YES];
    } else if ([itemName isEqualToString:kLNFMainItemName_LoadingFiles]) {
        
    } else if ([itemName isEqualToString:kLNFMainItemName_DownloadMP3Files]) {
        [LNFDownloadManager downloadMP3FilesFromTextURLs];
    } else if ([itemName isEqualToString:kLNFMainItemName_DownloadMVFiles]) {
        [LNFDownloadManager downloadMVFilesFromTextURLs];
    } else if ([itemName isEqualToString:kLNFMainItemName_DownloadNetVideo]) {
        [LNFDownloadManager downloadWEBVideoFilesFromTextURLs];
    } else if ([itemName isEqualToString:kLNFMainItemName_StringEncodeDecode]) {
        [LNFExampleMethodHelper stringUTF8EncodeAndDecode];
    } else if ([itemName isEqualToString:kLNFMainItemName_DivideHTMLLabel]) {
        [LNFDownloadManager divideYouVideoHTMLContentIntoTextFiles];
//        [LNFDownloadManager divideWangMVHTMLContentIntoTextFiles];
    } else if ([itemName isEqualToString:kLNFMainItemName_DirectDownloadVideo]) {
        [LNFDownloadManager downloadVideoFilesDirectFromTextURLs];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
