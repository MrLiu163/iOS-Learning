//
//  LNFCustomDatePickerView.m
//  iOS_Learning
//
//  Created by mrliu on 2019/3/16.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFCustomDatePickerView.h"

@interface LNFCustomDatePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *datePickerContentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIPickerView *datePickerView;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *pickerDataList; // Picker 数据
@property (nonatomic, assign) BOOL hadClearSeperatorLine; // 是否已经清除了黑线
@property (nonatomic, assign) NSInteger currentYearValue;
@property (nonatomic, assign) NSInteger currentMonthValue;
@property (nonatomic, assign) NSInteger currentDayValue;
@property (nonatomic, assign) NSInteger baseYearValue; // 最早到哪一年
@property (nonatomic, strong) NSMutableDictionary *componentSelectIndexInfoDict; // 每一束行选中的下标

@end

@implementation LNFCustomDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.baseYearValue = 1912;
    CGFloat leftMargin = [LNFUIAdapter scaleWithValue:15.0], containerViewHeight = [LNFUIAdapter scaleWithValue:350.0], titleLabelHeight = [LNFUIAdapter scaleWithValue:44.0], bottomViewHeight = [LNFUIAdapter scaleWithValue:60.0], bottomBtnHeight = [LNFUIAdapter scaleWithValue:44.0];
    // 黑透背景
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backGroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:backGroundView];
    [backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self);
    }];
    // 内容视图
    UIView *datePickerContentView = [[UIView alloc] initWithFrame:CGRectZero];
    datePickerContentView.backgroundColor = [UIColor whiteColor];
    datePickerContentView.cornerRadius = 4;
    [self addSubview:datePickerContentView];
    [datePickerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(leftMargin);
        make.right.mas_equalTo(self).offset(-leftMargin);
        make.height.mas_equalTo(containerViewHeight);
        make.centerY.mas_equalTo(0);
    }];
    self.datePickerContentView = datePickerContentView;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = kLNFThemeBlueColor;
    [datePickerContentView addSubview:titleLabel];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:[LNFUIAdapter scaleWithValue:20.0]];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.text = [LNFCommonHelper getDateStrFromDate:[NSDate date] formatterStr:@"yyyy年MM月dd日"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(datePickerContentView);
        make.right.mas_equalTo(datePickerContentView);
        make.top.mas_equalTo(datePickerContentView);
        make.height.mas_equalTo(titleLabelHeight);
    }];
    self.titleLabel = titleLabel;
    
    // 底部操作按钮
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomView.backgroundColor = [UIColor whiteColor];
    [datePickerContentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(datePickerContentView);
        make.height.mas_equalTo(bottomViewHeight);
    }];
    self.bottomView = bottomView;
    
    // 确定
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureBtn.frame = CGRectZero;
    [bottomView addSubview:ensureBtn];
    ensureBtn.backgroundColor = kLNFThemeBlueColor;
    [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    ensureBtn.cornerRadius = 3;
    [ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ensureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [ensureBtn addTarget:self action:@selector(ensureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectZero;
    [bottomView addSubview:cancelBtn];
    cancelBtn.backgroundColor = kLNFThemeBlueColor;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.cornerRadius = 3;
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 确定取消按钮布局
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomView).offset([LNFUIAdapter scaleWithValue:15.0]);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(bottomBtnHeight);
    }];
    [ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomView).offset(-[LNFUIAdapter scaleWithValue:15.0]);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(bottomBtnHeight);
        make.left.mas_equalTo(cancelBtn.mas_right).offset([LNFUIAdapter scaleWithValue:15.0]);
        make.width.mas_equalTo(cancelBtn);
    }];
    
    // 日期选择器
    UIPickerView *datePickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [datePickerContentView addSubview:datePickerView];
    datePickerView.delegate = self;
    datePickerView.dataSource = self;
    [datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(datePickerContentView);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.bottom.mas_equalTo(bottomView.mas_top);
    }];
    self.datePickerView = datePickerView;
}

#pragma mark - Private Method
// 确定按钮点击
- (void)ensureBtnAction:(UIButton *)sender
{
    self.hidden = YES;
}
// 取消按钮点击
- (void)cancelBtnAction:(UIButton *)sender
{
    self.hidden = YES;
}
// 初始化默认类型的选择器
- (void)configureDefaultDatePickerDataSource
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter_year = [[NSDateFormatter alloc] init];
    [dateFormatter_year setDateFormat:@"yyyy"];
    NSDateFormatter *dateFormatter_month = [[NSDateFormatter alloc] init];
    [dateFormatter_month setDateFormat:@"MM"];
    NSDateFormatter *dateFormatter_day = [[NSDateFormatter alloc] init];
    [dateFormatter_day setDateFormat:@"dd"];
    NSInteger thisYearValue = [[dateFormatter_year stringFromDate:nowDate] integerValue];
    NSInteger thisMonthValue = [[dateFormatter_month stringFromDate:nowDate] integerValue];
    NSInteger thisDayValue = [[dateFormatter_day stringFromDate:nowDate] integerValue];
    self.currentYearValue = thisYearValue;
    self.currentMonthValue = thisMonthValue;
    self.currentDayValue = thisDayValue;
    
    NSMutableArray<NSArray<NSString *> *> *tempDataSourceList = [NSMutableArray array];
    // 当前需要显示的所有年份（只到当前年份，最小年1）
    NSInteger forMax_year = thisYearValue + 100;
    NSMutableArray<NSString *> *tempYearArr = [NSMutableArray array];
    for (NSInteger i = self.baseYearValue; i <= forMax_year; i++) {
        NSInteger yearValue = i;
        NSString *yearStr = [NSString stringWithFormat:@"%zd年", yearValue];
        [tempYearArr addObject:yearStr];
    }
    [tempDataSourceList addObject:tempYearArr];
    
    // 当前要显示的所有月份
    NSInteger forMax_month = 12;
    NSMutableArray *tempMonthArr = [NSMutableArray array];
    for (NSInteger i = 1; i <= forMax_month; i++) {
        NSString *monthStr = [NSString stringWithFormat:@"%02zd月", i];
        [tempMonthArr addObject:monthStr];
    }
    [tempDataSourceList addObject:tempMonthArr];
    
    // 当前要显示的所有天份
    NSArray<NSString *> *tempDayArr = [self acquireDayListWithMonthValue:thisMonthValue yearValue:thisYearValue];
    [tempDataSourceList addObject:tempDayArr];
    
    // 刷新PickerView
    self.pickerDataList = tempDataSourceList;
    [self.datePickerView reloadAllComponents];
    
    // 默认选中当前年月日
    [self.datePickerView selectRow:thisYearValue - self.baseYearValue inComponent:0 animated:NO];
    [self.datePickerView selectRow:thisMonthValue - 1 inComponent:1 animated:NO];
    [self.datePickerView selectRow:thisDayValue - 1 inComponent:2 animated:NO];
}

// 根据年份、月份获取对应月天数
- (NSArray<NSString *> *)acquireDayListWithMonthValue:(NSInteger)monthValue yearValue:(NSInteger)yearValue
{
    NSMutableArray<NSString *> *tempDayList = [NSMutableArray array];
    NSInteger forMax = 0;
    switch (monthValue) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            forMax = 31;
            break;
        case 2:
            if (((0 == yearValue % 4) && (0 != yearValue % 100)) || (0 == yearValue % 400)) {
                forMax = 29;
            } else {
                forMax = 28;
            }
            break;
        default:
            forMax = 30;
            break;
    }
    for (NSInteger i = 1; i <= forMax; i++) {
        [tempDayList addObject:[NSString stringWithFormat:@"%zd日", i]];
    }
    return tempDayList;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.pickerDataList.count;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerDataList[component].count;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel *pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:[LNFUIAdapter scaleWithValue:18.0]]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
#pragma mark - UIPickerViewDelegate
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//
//}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return [LNFUIAdapter scaleWithValue:40.0];
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (!self.hadClearSeperatorLine) { // 去掉上线间隔线
        [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
        [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
        self.hadClearSeperatorLine = YES;
    }
    return self.pickerDataList[component][row];
}
//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
//{
//
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (LNFCustomDatePickerTypeDefault == self.datePickerType) {
        if (0 == component) { // 年
            NSInteger selectIndex_Month = [pickerView selectedRowInComponent:1];
            NSInteger monthValue = [self.pickerDataList[1][selectIndex_Month] integerValue];
            NSInteger yearValue = [self.pickerDataList[component][row] integerValue];
            NSMutableArray<NSArray<NSString *> *> *tempDataSourceList = [NSMutableArray arrayWithArray:self.pickerDataList];
            NSArray<NSString *> *dayList = [self acquireDayListWithMonthValue:monthValue yearValue:yearValue];
            [tempDataSourceList replaceObjectAtIndex:2 withObject:dayList];
            // 刷新日
            self.pickerDataList = tempDataSourceList;
            [pickerView reloadComponent:2];
        } else if (1 == component) { // 月
            NSInteger monthValue = [self.pickerDataList[component][row] integerValue];
            NSInteger selectIndex_Year = [pickerView selectedRowInComponent:0];
            NSInteger yearValue = [self.pickerDataList[0][selectIndex_Year] integerValue];
            NSMutableArray<NSArray<NSString *> *> *tempDataSourceList = [NSMutableArray arrayWithArray:self.pickerDataList];
            NSArray<NSString *> *dayList = [self acquireDayListWithMonthValue:monthValue yearValue:yearValue];
            [tempDataSourceList replaceObjectAtIndex:2 withObject:dayList];
            // 刷新日
            self.pickerDataList = tempDataSourceList;
            [pickerView reloadComponent:2];
        }
        NSString *yearStr = self.pickerDataList[0][[pickerView selectedRowInComponent:0]];
        NSString *monthStr = self.pickerDataList[1][[pickerView selectedRowInComponent:1]];
        NSString *dayStr = self.pickerDataList[2][[pickerView selectedRowInComponent:2]];
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@%@", yearStr, monthStr, dayStr];
    }
}

#pragma mark - Setter
// 设置选择器类型
- (void)setDatePickerType:(LNFCustomDatePickerType)datePickerType
{
    _datePickerType = datePickerType;
    if (LNFCustomDatePickerTypeDefault == datePickerType) {
        [self configureDefaultDatePickerDataSource];
    }
}

@end
