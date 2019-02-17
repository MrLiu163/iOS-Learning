//
//  LNFLetterToMovieVc.m
//  iOS_Learning
//
//  Created by mrliu on 2019/2/17.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFLetterToMovieVc.h"

@interface LNFLetterToMovieVc ()

@property (nonatomic, strong) LNFTableViewDataSourceHelper *dataSourceHelper;
@property (nonatomic, strong) LNFTableViewDelegateHelper *delegateHepler;
@property (nonatomic, strong) UITableView *movieNameTable;

@end

@implementation LNFLetterToMovieVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    kLNFWeakSelf;
    self.navigationItem.title = @"致电影的一封情书";

    NSArray<NSString *> *movieNameList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MovieListResult" ofType:@"plist"]];
    TableViewCellConfigureBlock cellConfigureBlock = ^(UITableViewCell *cell, NSString *item) {
        NSInteger index = [weakSelf.dataSourceHelper.items indexOfObject:item];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.text = [NSString stringWithFormat:@"%03zd-%@", index, item];
    };
    TableViewDidSelectRowConfigureBlock didSelectRowBlock = ^(NSIndexPath *indexPath) {
        
    };
    LNFTableViewDataSourceHelper *dataSourceHelper = [[LNFTableViewDataSourceHelper alloc] initWithItems:movieNameList cellIdentifier:kLNFUITableViewCellIndetifier configureCellBlock:cellConfigureBlock];
    self.dataSourceHelper = dataSourceHelper;
    
    LNFTableViewDelegateHelper *delegateHepler = [[LNFTableViewDelegateHelper alloc] init];
    delegateHepler.cellHeight = 44;
    delegateHepler.didSelectRowBlock = didSelectRowBlock;
    self.delegateHepler = delegateHepler;
    
    UITableView *movieNameTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:movieNameTable];
    movieNameTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLNFScreenWidth, 0)];
    movieNameTable.tableHeaderView = headerView;
    movieNameTable.dataSource = dataSourceHelper;
    movieNameTable.delegate = delegateHepler;
    movieNameTable.tableFooterView = [UIView new];
    [movieNameTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kLNFUITableViewCellIndetifier];
    [movieNameTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    self.movieNameTable = movieNameTable;
    
    kLNFLog(@"---->>>>%@", @"Test");
}

@end
