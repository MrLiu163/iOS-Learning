//
//  LNFTableViewDelegateHelper.m
//  iOS_Learning
//
//  Created by LNF on 16/11/2017.
//  Copyright © 2017 LNF. All rights reserved.
//

#import "LNFTableViewDelegateHelper.h"

@implementation LNFTableViewDelegateHelper

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.heightForRowBlock) {
        return self.heightForRowBlock(indexPath);
    } else {
        return self.cellHeight ? : 44.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headerViewHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.footerViewHeight;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.rowEditActions count]) {
        return self.rowEditActions;
    } else {
//        UITableViewRowAction *noAction = [[UITableViewRowAction alloc] init];
//        return @[noAction];
        return @[];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.willDisplayCellBlock) {
        self.willDisplayCellBlock(cell, indexPath);
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(indexPath);
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.superview) {
        [scrollView.superview endEditing:YES];
    } else {
        [scrollView endEditing:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.didScrollBlock) {
        self.didScrollBlock(scrollView);
    }
}

@end
