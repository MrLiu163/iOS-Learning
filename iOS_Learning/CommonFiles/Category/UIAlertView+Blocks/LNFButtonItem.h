//
//  LNFButtonItem.h
//  iOS_Learning
//
//  Created by LNF on 2017/2/15.
//  Copyright © 2017年 NF_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LNFButtonItemActionBlock)();
@interface LNFButtonItem : NSObject

{
    NSString *label;
}

@property (retain, nonatomic) NSString *label;
@property (copy) LNFButtonItemActionBlock action;

+ (instancetype)item;
/** 创建一个LNFButtonItem(文字) */
+ (instancetype)itemWithLabel:(NSString *)inLabel;
/** 创建一个LNFButtonItem(文字+绑定事件) */
+ (instancetype)itemWithLabel:(NSString *)inLabel action:(LNFButtonItemActionBlock)actionHandler;

@end
