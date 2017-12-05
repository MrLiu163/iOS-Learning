//
//  LNFChangeBaseUrlVc.m
//  iOS_Learning
//
//  Created by liuningfei on 05/12/2017.
//  Copyright © 2017 interstellar. All rights reserved.
//

#import "LNFChangeBaseUrlVc.h"

#define kLNFUITableViewCellIdentifier       @"UITableViewCell"
@interface LNFChangeBaseUrlVc () <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray<NSString *> *urlList;
@property (nonatomic, strong) UITableView *urlListTableView;
@property (nonatomic, strong) UIAlertView *editAlertView;
@property (nonatomic, strong) UIAlertView *addAlertView;
@property (nonatomic, strong) NSIndexPath *editIndexPath;
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;
@property (nonatomic, copy) NSString *pListPath;
@property (nonatomic, strong) LNFTableViewDataSourceHelper *dataSourceHelper;
@property (nonatomic, strong) LNFTableViewDelegateHelper *delegateHelper;

@end

@implementation LNFChangeBaseUrlVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    self.navigationItem.title = @"修改";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:kLNFBaseUrlInfoPlistFileName ofType:nil];
    self.pListPath = pListPath;
    self.urlList = [[NSArray alloc] initWithContentsOfFile:pListPath];
    
    TableViewCellConfigureBlock cellConfigureBlock = ^(UITableViewCell *cell, NSString *item) {
        if ([[kLNFUserDefaults objectForKey:kLNFCustomRequestUrlkey] isEqualToString:item]) {
            cell.textLabel.textColor = kLNFThemeBlueColor;
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        cell.textLabel.font = kLNFSystemFont14;
        cell.textLabel.text = item;
    };
    TableViewDidSelectRowConfigureBlock didSelectRowBlock = ^(NSIndexPath *indexPath) {
        [kLNFUserDefaults setObject:self.urlList[indexPath.row] forKey:kLNFCustomRequestUrlkey];
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        self.editIndexPath = indexPath;
        UITextField *inputTF = [self.editAlertView textFieldAtIndex:0];
        inputTF.text = self.urlList[indexPath.row];
        [self.editAlertView show];
    }];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        self.deleteIndexPath = indexPath;
        kLNFWeakSelf;
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除?" cancelButtonItem:[LNFButtonItem itemWithLabel:@"取消"] otherButtonItems:[LNFButtonItem itemWithLabel:@"确定" action:^{
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:weakSelf.urlList];
            [tempArr removeObjectAtIndex:weakSelf.deleteIndexPath.row];
            weakSelf.urlList = tempArr;
            weakSelf.dataSourceHelper.items = weakSelf.urlList;
            [weakSelf.urlList writeToFile:weakSelf.pListPath atomically:YES];
            [weakSelf.urlListTableView reloadData];
        }], nil] show];
    }];
    
    LNFTableViewDataSourceHelper *dataSourceHelper = [[LNFTableViewDataSourceHelper alloc] initWithItems:self.urlList cellIdentifier:kLNFUITableViewCellIdentifier configureCellBlock:cellConfigureBlock];
    self.dataSourceHelper = dataSourceHelper;
    
    LNFTableViewDelegateHelper *delegateHelper = [[LNFTableViewDelegateHelper alloc] init];
    delegateHelper.rowEditActions = @[deleteAction, editAction];
    delegateHelper.didSelectRowBlock = didSelectRowBlock;
    self.delegateHelper = delegateHelper;
    
    UITableView *urlListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:urlListTableView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLNFScreenWidth, 0)];
    urlListTableView.tableHeaderView = headerView;
    urlListTableView.dataSource = dataSourceHelper;
    urlListTableView.delegate = delegateHelper;
    urlListTableView.tableFooterView = [UIView new];
    [urlListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLNFUITableViewCellIdentifier];
    [urlListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    self.urlListTableView = urlListTableView;
    
    // 右上 添加按钮
    UIAlertView *addAlertView = [[UIAlertView alloc] initWithTitle:@"请输入" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    addAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self addRightItemWithTitle:@"添加" tapAction:^(UIBarButtonItem *item) {
        [addAlertView show];
    }];
    self.addAlertView = addAlertView;
    
    // 编辑弹框
    UIAlertView *editAlertView = [[UIAlertView alloc] initWithTitle:@"请输入" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    editAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.editAlertView = editAlertView;
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.addAlertView) {
        if (1 == buttonIndex) {
            UITextField *inputTF = [alertView textFieldAtIndex:0];
            kLNFLog(@"---->>>>%@", inputTF.text);
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.urlList];
            [tempArr addObject:[NSString stringWithFormat:@"http://%@", inputTF.text]];
            self.urlList = tempArr;
            self.dataSourceHelper.items = self.urlList;
            [self.urlList writeToFile:self.pListPath atomically:YES];
            [self.urlListTableView reloadData];
        }
    } else if (alertView == self.editAlertView) {
        if (1 == buttonIndex) {
            UITextField *inputTF = [alertView textFieldAtIndex:0];
            kLNFLog(@"---->>>>%@", inputTF.text);
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.urlList];
            [tempArr replaceObjectAtIndex:self.editIndexPath.row withObject:inputTF.text];
            self.urlList = tempArr;
            self.dataSourceHelper.items = self.urlList;
            [self.urlList writeToFile:self.pListPath atomically:YES];
            [self.urlListTableView reloadData];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
