//
//  LNFBaseEntrySelectVc.h
//  iOS_Learning
//
//  Created by mrliu on 2020/12/7.
//  Copyright © 2020 interstellar. All rights reserved.
//

// 简单列表选择跳转基类控制器，默认有一个列表视图，子类继承后给出标题和类名数组，点击会跳转至对应的控制器界面。

#import "LNFBaseVc.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNFBaseEntrySelectVc : LNFBaseVc

/** 左边标题文字数组 */
@property (nonatomic, strong) NSArray<NSString *> *entryTitles;
/** 右边详情文字数组 */
@property (nonatomic, strong) NSArray<NSString *> *entryDetails;
/** 对应控制器名称数组 */
@property (nonatomic, strong) NSArray<NSString *> *entryClasses;
/** 控制的KVC字典 */
@property (nonatomic, strong) NSArray<NSDictionary *> *entryKVCInfos;
/** 每行行高 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 导航标题 */
@property (nonatomic, copy) NSString *naviItemTitle;

/** 初始化选择进入控制器、文字等相关 */
- (void)initEntries;

@end

NS_ASSUME_NONNULL_END
