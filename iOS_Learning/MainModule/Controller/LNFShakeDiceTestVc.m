//
//  LNFShakeDiceTestVc.m
//  iOS_Learning
//
//  Created by mrliu on 2019/5/6.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFShakeDiceTestVc.h"

@interface LNFShakeDiceTestVc ()

@property (weak, nonatomic) IBOutlet UILabel *diceNumLabel;
@property (weak, nonatomic) IBOutlet UIStepper *diceNumStepper;
@property (weak, nonatomic) IBOutlet UILabel *shakeNumLabel;
@property (weak, nonatomic) IBOutlet UIStepper *shakeNumStepper;
@property (weak, nonatomic) IBOutlet UITableView *resultShowTable;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *resultValueList; // 所有可能的结果
@property (nonatomic, strong) NSMutableArray<NSNumber *> *resultTimeList; // 出现结果的次数
@property (nonatomic, strong) LNFTableViewDataSourceHelper *dataSourceHelper;
@property (nonatomic, strong) LNFTableViewDelegateHelper *delegateHepler;

@end

@implementation LNFShakeDiceTestVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    kLNFWeakSelf;
    self.navigationItem.title = @"摇骰子实验";
    
    // 右上刷新按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshResultsItemAction:)];
    
    // 表视图配置
    TableViewCellConfigureBlock cellConfigureBlock = ^(UITableViewCell *cell, NSNumber *item) {
        
        
    };
    TableViewCellConfigureBlockAndIndexPath configureCellBlockAndIndexPath = ^(UITableViewCell *cell, NSNumber *item, NSIndexPath *indexPath) {
        NSNumber *resultTime = weakSelf.resultTimeList[indexPath.row];
        NSString *resultSumStr = [NSString stringWithFormat:@"结果为%@/次数%@", item, resultTime];
        cell.textLabel.text = resultSumStr;
    };
    TableViewDidSelectRowConfigureBlock didSelectRowBlock = ^(NSIndexPath *indexPath) {
        
    };
    LNFTableViewDataSourceHelper *dataSourceHelper = [[LNFTableViewDataSourceHelper alloc] initWithItems:@[] cellIdentifier:kLNFUITableViewCellIndetifier configureCellBlock:cellConfigureBlock];
    dataSourceHelper.configureCellBlockAndIndexPath = configureCellBlockAndIndexPath;
    self.dataSourceHelper = dataSourceHelper;
    
    LNFTableViewDelegateHelper *delegateHepler = [[LNFTableViewDelegateHelper alloc] init];
    delegateHepler.cellHeight = 44;
    delegateHepler.didSelectRowBlock = didSelectRowBlock;
    self.delegateHepler = delegateHepler;
    
    self.resultShowTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.resultShowTable.dataSource = dataSourceHelper;
    self.resultShowTable.delegate = delegateHepler;
    self.resultShowTable.tableFooterView = [UIView new];
    [self.resultShowTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kLNFUITableViewCellIndetifier];
}

#pragma mark - Private Method
// 刷新结果按钮
- (void)refreshResultsItemAction:(UIBarButtonItem *)item
{
    [self calTheRandomResultAndShow];
}

// 计算随机产生的结果并展示
- (void)calTheRandomResultAndShow
{
    // 骰子数量
    NSInteger diceNum = self.diceNumStepper.value;
    // 摇骰次数
    NSInteger shakeNum = self.shakeNumStepper.value;
    // 结果最大最小值
    NSInteger minResult = diceNum * 1;
    NSInteger maxResult = diceNum * 6;
    // 所有可能出现的结果
    [self.resultValueList removeAllObjects];
    for (NSInteger i = minResult; i <= maxResult; i++) {
        [self.resultValueList addObject:@(i)];
    }
    // 初始化结果次数数组
    [self.resultTimeList removeAllObjects];
    for (NSInteger i = 0; i < self.resultValueList.count; i++) {
        [self.resultTimeList addObject:@(0)];
    }
    // 按摇骰次数模拟摇骰
    NSArray<NSNumber *> *mayBeResultList = @[@(1), @(2), @(3), @(4), @(5), @(6)];
    for (NSInteger i = 0; i < shakeNum; i++) {
        NSInteger diceSumValue = 0; // 几个骰子点求和
        for (NSInteger j = 0; j < diceNum; j++) {
            NSInteger randomIndex = arc4random_uniform(6); // 0 - 5
            NSNumber *diceResult = mayBeResultList[randomIndex];
            diceSumValue += [diceResult integerValue];
        }
        // 结果次数数组下标
        NSInteger timeListIndex = diceSumValue - diceNum;
        NSInteger tempTimeValue = [self.resultTimeList[timeListIndex] integerValue];
        tempTimeValue += 1;
        [self.resultTimeList replaceObjectAtIndex:timeListIndex withObject:@(tempTimeValue)];
    }
    // 刷新表示图
    self.dataSourceHelper.items = self.resultValueList;
    [self.resultShowTable reloadData];
    kLNFLog(@"---->>>>%@", @"Test");
}

#pragma mark - Getter
- (NSMutableArray<NSNumber *> *)resultValueList
{
    if (!_resultValueList) {
        self.resultValueList = [NSMutableArray array];
    }
    return _resultValueList;
}
- (NSMutableArray<NSNumber *> *)resultTimeList
{
    if (!_resultTimeList) {
        self.resultTimeList = [NSMutableArray array];
    }
    return _resultTimeList;
}

#pragma mark - IBAction

- (IBAction)diceNumStepperAction:(UIStepper *)sender
{
    self.diceNumLabel.text = [NSString stringWithFormat:@"%@", @(sender.value)];
}
- (IBAction)shakeNumStepperAction:(UIStepper *)sender
{
    self.shakeNumLabel.text = [NSString stringWithFormat:@"%@", @(sender.value)];
}

@end
