//
//  LNFDeviceAndAppInfoShowVc.m
//  iOS_Learning
//
//  Created by mrliu on 2019/5/16.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFDeviceAndAppInfoShowVc.h"

@interface LNFDeviceAndAppInfoShowVc ()

@property (nonatomic, strong) LNFTableViewDataSourceHelper *dataSourceHelper;
@property (nonatomic, strong) LNFTableViewDelegateHelper *delegateHepler;
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) NSArray<NSString *> *rightValueList;

@end

@implementation LNFDeviceAndAppInfoShowVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self acquireDeviceAndAppInfo];
}

- (void)initUI
{
    kLNFWeakSelf;
    self.navigationItem.title = @"手机设备和App信息";
    
    TableViewCellConfigureBlock cellConfigureBlock = ^(UITableViewCell *cell, NSObject *item) {
        NSInteger index = [weakSelf.dataSourceHelper.items indexOfObject:item];
        NSString *rightValueStr = weakSelf.rightValueList[index];
        NSString *showStr = [NSString stringWithFormat:@"%@----%@", item ? : @"", rightValueStr ? : @""];
        cell.textLabel.text = showStr;
    };
    TableViewDidSelectRowConfigureBlock didSelectRowBlock = ^(NSIndexPath *indexPath) {
        
    };
    LNFTableViewDataSourceHelper *dataSourceHelper = [[LNFTableViewDataSourceHelper alloc] initWithItems:@[] cellIdentifier:kLNFUITableViewCellIndetifier configureCellBlock:cellConfigureBlock];
    self.dataSourceHelper = dataSourceHelper;
    
    LNFTableViewDelegateHelper *delegateHepler = [[LNFTableViewDelegateHelper alloc] init];
    delegateHepler.cellHeight = 44;
    delegateHepler.didSelectRowBlock = didSelectRowBlock;
    self.delegateHepler = delegateHepler;
    
    UITableView *infoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:infoTableView];
    infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLNFScreenWidth, 0)];
    infoTableView.tableHeaderView = headerView;
    infoTableView.dataSource = dataSourceHelper;
    infoTableView.delegate = delegateHepler;
    infoTableView.tableFooterView = [UIView new];
    [infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLNFUITableViewCellIndetifier];
    [infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    self.infoTableView = infoTableView;
    
}

#pragma mark - Private Method
// 获取手机设备和App信息
- (void)acquireDeviceAndAppInfo
{
    // 设备别名
    NSString *device_name = [LNFContextInfoHelper deviceName];
    // 设备系统名称
    NSString *device_sysName = [LNFContextInfoHelper deviceSystemName];
    // 设备系统版本
    NSString *device_sysVersion = [LNFContextInfoHelper deviceSystemVersion];
    // 设备型号
    NSString *device_model = [LNFContextInfoHelper deviceModel];
    // 设备地方型号（国际化区域名称）
    NSString *device_localModel = [LNFContextInfoHelper deviceLocalizedModel];
    // 电池电量
    NSString *batteryStateStr = [LNFContextInfoHelper deviceBatteryLevel];
    
    // App名称
    NSString *app_name = [LNFContextInfoHelper appDisplayName];
    // App版本
    NSString *app_version = [LNFContextInfoHelper appVersion];
    // App Build版本
    NSString *app_build = [LNFContextInfoHelper appBuild];
    
    // 屏幕大小
    CGSize screenSize = [LNFContextInfoHelper screenSize];
    NSString *screenSizeStr = [NSString stringWithFormat:@"%@x%@", @(screenSize.width), @(screenSize.height)];
    // 屏幕像素密度
    CGFloat screenScale = [LNFContextInfoHelper screenScale];
    NSString *screenScaleStr = [NSString stringWithFormat:@"@%@x", @(screenScale)];
    
    // 左边右边数据源
    NSArray<NSString *> *leftItemList = @[@"设备别名", @"系统名称", @"系统版本", @"设备型号", @"设备地方型号", @"电池电量", @"App名称", @"App版本", @"App Build版本", @"屏幕大小", @"屏幕像素密度"];
    NSArray<NSString *> *rightValueList = @[device_name, device_sysName, device_sysVersion, device_model, device_localModel, batteryStateStr, app_name, app_version, app_build, screenSizeStr, screenScaleStr];
    self.rightValueList = rightValueList;
    // 刷新列表显示
    self.dataSourceHelper.items = leftItemList;
    [self.infoTableView reloadData];
}

@end
