//
//  LNFBaseEntrySelectVc.m
//  iOS_Learning
//
//  Created by mrliu on 2020/12/7.
//  Copyright © 2020 interstellar. All rights reserved.
//

#import "LNFBaseEntrySelectVc.h"

@interface LNFBaseEntrySelectVc ()

@property (nonatomic, strong) LNFTableViewDataSourceHelper *dataSourceHelper;
@property (nonatomic, strong) LNFTableViewDelegateHelper *delegateHepler;
@property (nonatomic, strong) UITableView *entryTable;

@end

@implementation LNFBaseEntrySelectVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initEntries];
    
    [self initEntryTable];
}

#pragma mark - Pivate Method
- (void)initEntryTable
{
    kLNFWeakSelf;
    TableViewCellForRowAtIndexPathConfigureBlock cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *mainCellIdentifier = @"com.mr.mainCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mainCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.numberOfLines = 0;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
            cell.detailTextLabel.textColor = [UIColor grayColor];
            cell.detailTextLabel.numberOfLines = 0;
        }
        cell.textLabel.text = weakSelf.entryTitles[indexPath.row];
        cell.detailTextLabel.text = weakSelf.entryDetails[indexPath.row];
        return cell;
    };
    TableViewDidSelectRowConfigureBlock didSelectRowBlock = ^(NSIndexPath *indexPath) {
        [weakSelf.entryTable deselectRowAtIndexPath:indexPath animated:YES];
        
        NSString *className = weakSelf.entryClasses[indexPath.row];
        
        UIViewController *subViewController = [[NSClassFromString(className) alloc] init];
        subViewController.title = weakSelf.entryTitles[indexPath.row]; // 仅指用系统导航栏情况
        subViewController.hidesBottomBarWhenPushed = YES;
        if (indexPath.row < weakSelf.entryKVCInfos.count) { // 通过KVC给控制器属性赋值
            NSDictionary *kvcInfo = weakSelf.entryKVCInfos[indexPath.row];
            for (NSString *key in kvcInfo) {
                NSObject *value = kvcInfo[key];
                [subViewController setValue:value forKey:key]; // KVC异常已经在控制器基类中判断
            }
        }
        [weakSelf.navigationController pushViewController:subViewController animated:YES];
    };
    LNFTableViewDataSourceHelper *dataSourceHelper = [[LNFTableViewDataSourceHelper alloc] initWithItems:self.entryTitles cellIdentifier:kLNFUITableViewCellIndetifier configureCellBlock:nil];
    dataSourceHelper.cellForRowAtIndexPathBlock = cellForRowAtIndexPathBlock;
    self.dataSourceHelper = dataSourceHelper;
    
    LNFTableViewDelegateHelper *delegateHepler = [[LNFTableViewDelegateHelper alloc] init];
    delegateHepler.cellHeight = self.cellHeight ? : 44;
    delegateHepler.didSelectRowBlock = didSelectRowBlock;
    self.delegateHepler = delegateHepler;
    
    UITableView *entryTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:entryTable];
    entryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLNFScreenWidth, 0)];
    entryTable.tableHeaderView = headerView;
    entryTable.dataSource = dataSourceHelper;
    entryTable.delegate = delegateHepler;
    entryTable.tableFooterView = [UIView new];
    //    [entryTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kLNFUITableViewCellIndetifier];
    [entryTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    self.entryTable = entryTable;
}

#pragma mark - 子类必须重载此方法，创建entryTitles， entryDetails, entryClasses
- (void)initEntries
{
    
}

@end
