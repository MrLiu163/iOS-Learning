//
//  LNFTableViewDataSourceHelper.h
//  iOS_Learning
//
//  Created by LNF on 16/11/2017.
//  Copyright © 2017 LNF. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);
typedef void (^TableViewCellConfigureBlockAndIndexPath)(id cell, id item, id indexPath);
typedef void (^TableViewMoveRowConfigureBlock)(id fromIndexPath, id toIndexPath);
typedef UITableViewCell*(^TableViewCellForRowAtIndexPathConfigureBlock)(UITableView *tableView, id indexPath);
@interface LNFTableViewDataSourceHelper : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic, copy) TableViewCellConfigureBlockAndIndexPath configureCellBlockAndIndexPath;
@property (nonatomic, copy) TableViewMoveRowConfigureBlock moveRowBlock;
@property (nonatomic, copy) TableViewCellForRowAtIndexPathConfigureBlock cellForRowAtIndexPathBlock;
@property (nonatomic, assign) BOOL multipleSections;

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;

@end
