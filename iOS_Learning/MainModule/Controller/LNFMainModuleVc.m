//
//  LNFMainModuleVc.m
//  iOS_Learning
//
//  Created by liuningfei on 05/12/2017.
//  Copyright © 2017 interstellar. All rights reserved.
//

#import "LNFMainModuleVc.h"
#import "LNFChangeBaseUrlVc.h"
#import "LNFPasswordGenerateVc.h"

#define kLNFMainItemName_ChangeBaseUrl                      @"Change BaseUrl"
#define kLNFMainItemName_BezierRoundAnimation               @"贝塞尔切环动画"
#define kLNFMainItemName_GeneratePassword                   @"生成密码"
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
    
    NSArray *itemList = @[kLNFMainItemName_GeneratePassword, kLNFMainItemName_ChangeBaseUrl, kLNFMainItemName_BezierRoundAnimation];
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
    } else if ([itemName isEqualToString:kLNFMainItemName_BezierRoundAnimation]) {
        
    } else if ([itemName isEqualToString:kLNFMainItemName_GeneratePassword]) {
        LNFPasswordGenerateVc *passwordGenerateVc = [[LNFPasswordGenerateVc alloc] init];
        passwordGenerateVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:passwordGenerateVc animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
