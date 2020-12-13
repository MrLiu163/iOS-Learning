//
//  LNFOtherExampleShowVc.m
//  iOS_Learning
//
//  Created by mrliu on 2020/12/12.
//  Copyright © 2020 interstellar. All rights reserved.
//

#import "LNFOtherExampleShowVc.h"
#import "LNFPhotoLibraryPhotoAlbumListVc.h"
#import <Contacts/Contacts.h>

@interface LNFOtherExampleShowVc ()

@property (nonatomic, copy) NSString *itemId_FingerAuthCheck;
@property (nonatomic, copy) NSString *itemId_AlbumPhotoSelect;
@property (nonatomic, copy) NSString *itemId_StringEncodeDecode;
@property (nonatomic, copy) NSString *itemId_DirectDownloadVideo;
@property (nonatomic, copy) NSString *itemId_CustomPickerView;
@property (nonatomic, strong) LNFTableViewDataSourceHelper *dataSourceHelper;
@property (nonatomic, strong) LNFTableViewDelegateHelper *delegateHepler;
@property (nonatomic, strong) UITableView *mainItemTable;
@property (nonatomic, strong) LNFCustomDatePickerView *customDatePicker;

@end

@implementation LNFOtherExampleShowVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    self.itemId_FingerAuthCheck = @"用户指纹验证";
    self.itemId_AlbumPhotoSelect = @"相册图片多选效果";
    self.itemId_StringEncodeDecode = @"字符UTF编码解码";
    self.itemId_DirectDownloadVideo = @"直接下载视频";
    self.itemId_CustomPickerView = @"自定义DatePicker";
    
    kLNFWeakSelf;
    NSArray *itemList = @[self.itemId_FingerAuthCheck, self.itemId_AlbumPhotoSelect, self.itemId_StringEncodeDecode, self.itemId_DirectDownloadVideo, self.itemId_CustomPickerView];
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
    if ([itemName isEqualToString:self.itemId_FingerAuthCheck]) { // 验证用户指纹
        [LNFAppHelper checkUserAuthorityByFingerprint];
    } else if ([itemName isEqualToString:self.itemId_AlbumPhotoSelect]) { // 相册照片选择
        [self showAlbumPhotoSelectController];
    } else if ([itemName isEqualToString:self.itemId_StringEncodeDecode]) { // UTF8字符串加码解码
        [LNFExampleMethodHelper stringUTF8EncodeAndDecode];
    } else if ([itemName isEqualToString:self.itemId_DirectDownloadVideo]) { // 直接下载批量视频
        [LNFDownloadManager downloadVideoFilesDirectFromTextURLs];
    } else if ([itemName isEqualToString:self.itemId_CustomPickerView]) { // 自定义日期选择器
        [self addCustomDatePickerView];
    }
    
}

// 展示相册照片选择
- (void)showAlbumPhotoSelectController
{
    LNFPhotoLibraryPhotoAlbumListVc *albumListVc = [[LNFPhotoLibraryPhotoAlbumListVc alloc] init];
    albumListVc.hidesBottomBarWhenPushed = YES;
    albumListVc.allowMutipleSelect = YES;
    albumListVc.maxSelectPicCount = 3;
    albumListVc.mutipleSelectDoneBlock = ^(NSArray<UIImage *> *photoList) {
        
    };
    LNFNavigationVc *navVc = [[LNFNavigationVc alloc] initWithRootViewController:albumListVc];
    [self presentViewController:navVc animated:YES completion:nil];
}

// 添加自定义DatePicker视图
- (void)addCustomDatePickerView
{
    if (!self.customDatePicker) {
        LNFCustomDatePickerView *datePicker = [[LNFCustomDatePickerView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:datePicker];
        [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
        }];
        datePicker.datePickerType = LNFCustomDatePickerTypeDefault;
        self.customDatePicker = datePicker;
    } else {
        self.customDatePicker.hidden = NO;
    }
}

@end
