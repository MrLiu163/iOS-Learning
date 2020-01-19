//
//  LNFFootprintBrowseEffectVc.m
//  iOS_Learning
//
//  Created by MrLiuu on 2019/12/25.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFFootprintBrowseEffectVc.h"
#import "LNFProductBrowseFootprintView.h"

@interface LNFFootprintBrowseEffectVc () <UIScrollViewDelegate>

@property (nonatomic, strong) LNFTableViewDataSourceHelper *dataSourceHelper;
@property (nonatomic, strong) LNFTableViewDelegateHelper *delegateHepler;
@property (nonatomic, strong) UITableView *productTable;
@property (nonatomic, strong) LNFProductBrowseFootprintView *footprintView;

@end

@implementation LNFFootprintBrowseEffectVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"浏览足迹效果";
    
    TableViewCellConfigureBlock cellConfigureBlock = ^(UITableViewCell *cell, NSString *item) {
        cell.textLabel.text = item;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    };
    TableViewDidSelectRowConfigureBlock didSelectRowBlock = ^(NSIndexPath *indexPath) {
        
    };
    LNFTableViewDataSourceHelper *dataSourceHelper = [[LNFTableViewDataSourceHelper alloc] initWithItems:@[@"商品0", @"商品1", @"商品2"] cellIdentifier:kLNFUITableViewCellIndetifier configureCellBlock:cellConfigureBlock];
    self.dataSourceHelper = dataSourceHelper;
    
    LNFTableViewDelegateHelper *delegateHepler = [[LNFTableViewDelegateHelper alloc] init];
    delegateHepler.cellHeight = 44;
    delegateHepler.didSelectRowBlock = didSelectRowBlock;
    self.delegateHepler = delegateHepler;
    
    UITableView *productTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:productTable];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLNFScreenWidth, 0)];
    productTable.tableHeaderView = headerView;
    productTable.dataSource = dataSourceHelper;
    productTable.delegate = delegateHepler;
    productTable.tableFooterView = [UIView new];
    [productTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kLNFUITableViewCellIndetifier];
    [productTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    self.productTable = productTable;
    
    // 下拉刷新
    kLNFWeakSelf;
    [UIView addMJRefreshHeaderWithScrollView:productTable refreshBlock:^{
        [weakSelf showBrowseFootPrintView];
        [weakSelf.productTable.mj_header endRefreshing];
    }];
}

#pragma mark - Private Method
// 创建、展示浏览足迹控件
- (void)showBrowseFootPrintView
{
    if (!self.footprintView) {
        LNFProductBrowseFootprintView *footprintView = [[LNFProductBrowseFootprintView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:footprintView];
        [footprintView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
        }];
        self.footprintView = footprintView;
    }
    [self.footprintView showFootprintViewWithAnimation];
}

@end
