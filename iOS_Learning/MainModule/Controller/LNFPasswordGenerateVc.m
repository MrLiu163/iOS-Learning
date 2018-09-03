//
//  LNFPasswordGenerateVc.m
//  iOS_Learning
//
//  Created by MrLiu on 2018/6/28.
//  Copyright © 2018年 interstellar. All rights reserved.
//

/*
 // NSString to ASCII
 NSString *string1 = @"A";
 int asciiCode1 = [string1 characterAtIndex:0]; // 65
 // ASCII to NSString
 int asciiCode2 = 65;
 NSString *string2 = [NSString stringWithFormat:@"%c", asciiCode2]; // A
 */

#import "LNFPasswordGenerateVc.h"

#define kLNFTotalCharacterCount         26
#define kLNFTotalNumberCount            10
@interface LNFPasswordGenerateVc ()

@property (weak, nonatomic) IBOutlet UILabel *pswLengthShowLabel;
@property (weak, nonatomic) IBOutlet UILabel *pswTypeShowLabel;
@property (weak, nonatomic) IBOutlet UILabel *pswShowLabel;
@property (weak, nonatomic) IBOutlet UIStepper *pswLengthStepper;
@property (weak, nonatomic) IBOutlet UISwitch *insertDashSymbolSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *insertUnderlineSymbolSwitch;
@property (nonatomic, strong) NSArray<NSString *> *characterList_Lowercase;
@property (nonatomic, strong) NSArray<NSString *> *characterList_Uppercase;
@property (nonatomic, strong) NSArray<NSString *> *numberList;
@property (nonatomic, assign) NSInteger pswLength;
@property (nonatomic, assign) int upper_bound;

@end

@implementation LNFPasswordGenerateVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    self.navigationItem.title = @"密码生成";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *refreshPswItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPswItemAcion:)];
    self.navigationItem.rightBarButtonItems = @[refreshPswItem];
    
    self.pswLengthShowLabel.text = [NSString stringWithFormat:@"%zd", (NSInteger)self.pswLengthStepper.value];
    self.pswLength = (NSInteger)self.pswLengthStepper.value;
    self.upper_bound = 3; // 默认数字、大写字母、小写字母
    self.pswShowLabel.adjustsFontSizeToFitWidth = YES;
    
    // 0-9 48-57
    // A-Z 65-90
    // a-z 97-122
    NSMutableArray<NSString *> *characterList_Uppercase = [NSMutableArray array];
    for (int i = 0; i < kLNFTotalCharacterCount; i++) {
        int asciiCode = 65 + i;
        NSString *tempString = [NSString stringWithFormat:@"%c", asciiCode];
        [characterList_Uppercase addObject:tempString];
    }
    self.characterList_Uppercase = characterList_Uppercase;
    NSMutableArray<NSString *> *characterList_Lowercase = [NSMutableArray array];
    for (int i = 0; i < kLNFTotalCharacterCount; i++) {
        int asciiCode = 97 + i;
        NSString *tempString = [NSString stringWithFormat:@"%c", asciiCode];
        [characterList_Lowercase addObject:tempString];
    }
    self.characterList_Lowercase = characterList_Lowercase;
    NSMutableArray<NSString *> *numberList = [NSMutableArray array];
    for (int i = 0; i < kLNFTotalNumberCount; i++) {
        int asciiCode = 48 + i;
        NSString *tempString = [NSString stringWithFormat:@"%c", asciiCode];
        [numberList addObject:tempString];
    }
    self.numberList = numberList;
    
}

#pragma mark - Private Method
- (void)selectPswTypeAction
{
    UIAlertController *pswTypeAlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *pswTypeStr_NumAndChar = @"字母和数字";
    NSString *pswTypeStr_OnlyNum = @"仅数字";
    UIAlertAction *numAndCharAction = [UIAlertAction actionWithTitle:pswTypeStr_NumAndChar style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.upper_bound = 3;
        self.pswTypeShowLabel.text = pswTypeStr_NumAndChar;
    }];
    UIAlertAction *onlyNumAction = [UIAlertAction actionWithTitle:pswTypeStr_OnlyNum style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.upper_bound = 1;
        self.pswTypeShowLabel.text = pswTypeStr_OnlyNum;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [pswTypeAlertController addAction:numAndCharAction];
    [pswTypeAlertController addAction:onlyNumAction];
    [pswTypeAlertController addAction:cancelAction];
    [self presentViewController:pswTypeAlertController animated:YES completion:nil];
}
- (void)refreshPswItemAcion:(UIBarButtonItem *)item
{
    [self generatePswAndShow];
    if (self.insertDashSymbolSwitch.isOn) {
        [self changePswWithInsertDash:self.insertDashSymbolSwitch.isOn];
    } else if (self.insertUnderlineSymbolSwitch.isOn) {
        [self changePswWithInsertUnderline:self.insertUnderlineSymbolSwitch.isOn];
    }
    
}
- (void)generatePswAndShow
{
    NSString *pswStr = @"";
    for (int i = 0; i < self.pswLength; i++) {
        int odd_even = arc4random_uniform(self.upper_bound);
        int index = 0;
        if (0 == odd_even) {
            index = arc4random_uniform((int)self.numberList.count);
            pswStr = [pswStr stringByAppendingString:self.numberList[index]];
        } else if (1 == odd_even) {
            index = arc4random_uniform((int)self.characterList_Uppercase.count);
            pswStr = [pswStr stringByAppendingString:self.characterList_Uppercase[index]];
        } else if (2 == odd_even) {
            index = arc4random_uniform((int)self.characterList_Lowercase.count);
            pswStr = [pswStr stringByAppendingString:self.characterList_Lowercase[index]];
        }
    }
    self.pswShowLabel.text = pswStr;
}
- (void)changePswWithInsertDash:(BOOL)insertDash
{
    if (self.insertUnderlineSymbolSwitch.isOn) {
        if ([self.pswShowLabel.text containsString:kLNFUnderlineSymbolStr]) {
            self.pswShowLabel.text = [self.pswShowLabel.text stringByReplacingOccurrencesOfString:kLNFUnderlineSymbolStr withString:kLNFLengthZeroStr];
        }
        self.insertUnderlineSymbolSwitch.on = NO;
    }
    self.pswShowLabel.text = [self changePswWithPswStr:self.pswShowLabel.text insertStr:kLNFDashSymbolStr insert:insertDash];
}
- (void)changePswWithInsertUnderline:(BOOL)insertUnderline
{
    if (self.insertDashSymbolSwitch.isOn) {
        if ([self.pswShowLabel.text containsString:kLNFDashSymbolStr]) {
            self.pswShowLabel.text = [self.pswShowLabel.text stringByReplacingOccurrencesOfString:kLNFDashSymbolStr withString:kLNFLengthZeroStr];
        }
        self.insertDashSymbolSwitch.on = NO;
    }
    self.pswShowLabel.text = [self changePswWithPswStr:self.pswShowLabel.text insertStr:kLNFUnderlineSymbolStr insert:insertUnderline];
}
// 完成字符串插入、删除操作
- (NSString *)changePswWithPswStr:(NSString *)pswStr insertStr:(NSString *)insertStr insert:(BOOL)insert
{
    if (insert) {
        NSInteger spaceValue = 3;
        NSString *tempPswStr = pswStr;
        NSMutableArray<NSString *> *tempPswComponents = [NSMutableArray array];
        NSInteger mutipleValue = tempPswStr.length / spaceValue;
        NSInteger surplusValue = tempPswStr.length % spaceValue;
        if (0 == surplusValue) {
            for (int i = 0; i < mutipleValue; i++) {
                [tempPswComponents addObject:[tempPswStr substringWithRange:NSMakeRange(i * spaceValue, spaceValue)]];
            }
        } else {
            for (int i = 0; i < mutipleValue + 1; i++) {
                if (i == mutipleValue) {
                    [tempPswComponents addObject:[tempPswStr substringWithRange:NSMakeRange(i * spaceValue, surplusValue)]];
                } else {
                    [tempPswComponents addObject:[tempPswStr substringWithRange:NSMakeRange(i * spaceValue, spaceValue)]];
                }
            }
        }
        NSString *finalPswStr = [tempPswComponents componentsJoinedByString:insertStr];
        return finalPswStr;
    } else {
        NSString *tempPswStr = pswStr;
        NSString *finalPswStr = [tempPswStr stringByReplacingOccurrencesOfString:insertStr withString:kLNFLengthZeroStr];
        return finalPswStr;
    }
}
#pragma mark - IBAction
- (IBAction)passwordTypeSelectTapAction:(UITapGestureRecognizer *)sender
{
    [self selectPswTypeAction];
}
- (IBAction)passwordLengthStepperAction:(UIStepper *)sender
{
    self.pswLengthShowLabel.text = [NSString stringWithFormat:@"%zd", (NSInteger)self.pswLengthStepper.value];
    self.pswLength = (NSInteger)self.pswLengthStepper.value;
}
- (IBAction)pswCopyTapAction:(UITapGestureRecognizer *)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.pswShowLabel.text;
    NSString *alertMessageStr = pasteboard.string;
    [[[UIAlertView alloc] initWithTitle:@"已复制" message:alertMessageStr cancelButtonItem:[LNFButtonItem itemWithLabel:kLNFUserSelectOptionStr_Ensure_En] otherButtonItems:nil] show];
}
// 加破折号
- (IBAction)insertDashSymbolSwitchAction:(UISwitch *)sender
{
    if (0 == self.pswShowLabel.text.length) {
        NSString *alertMessageStr = @"Insert For What";
        [[[UIAlertView alloc] initWithTitle:kLNFUserSelectOptionStr_Title_En message:alertMessageStr cancelButtonItem:[LNFButtonItem itemWithLabel:kLNFUserSelectOptionStr_Ensure_En] otherButtonItems:nil] show];
        return;
    }
    [self changePswWithInsertDash:sender.isOn];
}
// 加下划线
- (IBAction)insertUnderlineSymbolSwitchAction:(UISwitch *)sender
{
    if (0 == self.pswShowLabel.text.length) {
        NSString *alertMessageStr = @"Insert For What";
        [[[UIAlertView alloc] initWithTitle:kLNFUserSelectOptionStr_Title_En message:alertMessageStr cancelButtonItem:[LNFButtonItem itemWithLabel:kLNFUserSelectOptionStr_Ensure_En] otherButtonItems:nil] show];
        return;
    }
    [self changePswWithInsertUnderline:sender.isOn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
