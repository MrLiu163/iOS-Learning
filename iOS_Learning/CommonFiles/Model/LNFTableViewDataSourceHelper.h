//
//  LNFTableViewDataSourceHelper.h
//  iOS_Learning
//
//  Created by LNF on 16/11/2017.
//  Copyright © 2017 LNF. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);
typedef void (^TableViewMoveRowConfigureBlock)(id fromIndexPath, id toIndexPath);
@interface LNFTableViewDataSourceHelper : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic, copy) TableViewMoveRowConfigureBlock moveRowBlock;

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;

@end
