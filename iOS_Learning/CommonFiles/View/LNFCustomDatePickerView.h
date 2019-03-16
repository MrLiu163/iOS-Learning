//
//  LNFCustomDatePickerView.h
//  iOS_Learning
//
//  Created by mrliu on 2019/3/16.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LNFCustomDatePickerType) {
    LNFCustomDatePickerTypeDefault = 0, // 默认就是年月日选择, 不限制选择以后
};

@interface LNFCustomDatePickerView : UIView

/** 选择器类型，必须指定 */
@property (nonatomic, assign) LNFCustomDatePickerType datePickerType;

@end

NS_ASSUME_NONNULL_END
