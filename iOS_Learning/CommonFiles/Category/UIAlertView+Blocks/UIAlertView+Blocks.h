//
//  UIAlertView+Blocks.h
//  iOS_Learning
//
//  Created by LNF on 2017/2/15.
//  Copyright © 2017年 NF_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNFButtonItem.h"
@class LNFButtonItem;
@interface UIAlertView (Blocks)

/** 第三方创建UIAlertView */
- (instancetype)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(LNFButtonItem *)inCancelButtonItem otherButtonItems:(LNFButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)addButtonItem:(LNFButtonItem *)item;

@end
