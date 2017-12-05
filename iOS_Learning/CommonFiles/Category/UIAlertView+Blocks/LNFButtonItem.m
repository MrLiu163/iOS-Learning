//
//  LNFButtonItem.m
//  iOS_Learning
//
//  Created by LNF on 2017/2/15.
//  Copyright © 2017年 NF_Liu. All rights reserved.
//

#import "LNFButtonItem.h"

@implementation LNFButtonItem

@synthesize label;
@synthesize action;

+ (instancetype)item
{
    return [self new];
}

+ (instancetype)itemWithLabel:(NSString *)inLabel
{
    LNFButtonItem *newItem = [self item];
    [newItem setLabel:inLabel];
    return newItem;
}

+ (instancetype)itemWithLabel:(NSString *)inLabel  action:(LNFButtonItemActionBlock)actionHandler
{
    LNFButtonItem *newItem = [self itemWithLabel:inLabel];
    [newItem setAction:actionHandler];
    return newItem;
}

@end
