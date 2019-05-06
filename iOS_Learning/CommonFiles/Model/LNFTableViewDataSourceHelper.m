//
//  LNFTableViewDataSourceHelper.m
//  iOS_Learning
//
//  Created by LNF on 16/11/2017.
//  Copyright © 2017 LNF. All rights reserved.
//

#import "LNFTableViewDataSourceHelper.h"

@interface LNFTableViewDataSourceHelper ()

@property (nonatomic, copy) NSString *cellIdentifier;

@end

@implementation LNFTableViewDataSourceHelper

- (id)init
{
    return nil;
}
- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock
{
    self = [super init];
    if (self) {
        self.items = items;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = [configureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.multipleSections) {
        return self.items[indexPath.section][indexPath.row];
    } else {
        return self.items[indexPath.row];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.multipleSections ? self.items.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == self.items.count) return 0;
    
    if (self.multipleSections) {
        return ((NSArray *)self.items[section]).count;
    } else {
        return self.items.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellForRowAtIndexPathBlock) {
        return self.cellForRowAtIndexPathBlock(tableView, indexPath);
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
        NSObject *item = [self itemAtIndexPath:indexPath];
        if (self.configureCellBlockAndIndexPath) {
            self.configureCellBlockAndIndexPath(cell, item, indexPath);
        } else if (self.configureCellBlock) {
            self.configureCellBlock(cell, item);
        }
        return cell;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (self.moveRowBlock) {
        self.moveRowBlock(sourceIndexPath, destinationIndexPath);
    }
}

@end
