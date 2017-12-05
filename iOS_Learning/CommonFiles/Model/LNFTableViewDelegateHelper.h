//
//  LNFTableViewDelegateHelper.h
//  iOS_Learning
//
//  Created by LNF on 16/11/2017.
//  Copyright © 2017 LNF. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewDidScrollConfigureBlock)(UIScrollView *scrollView);
typedef void (^TableViewWillDisplayCellConfigureBlock)(id cell, id indexPath);
typedef void(^TableViewDidSelectRowConfigureBlock)(id indexPath);
typedef CGFloat(^TableViewHeightForRowConfigureBlock)(id indexPath);
@interface LNFTableViewDelegateHelper : NSObject <UITableViewDelegate>

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat footerViewHeight;
@property (nonatomic, strong) NSArray<UITableViewRowAction *> *rowEditActions;
@property (nonatomic, copy) TableViewDidScrollConfigureBlock didScrollBlock;
@property (nonatomic, copy) TableViewWillDisplayCellConfigureBlock willDisplayCellBlock;
@property (nonatomic, copy) TableViewDidSelectRowConfigureBlock didSelectRowBlock;
@property (nonatomic, copy) TableViewHeightForRowConfigureBlock heightForRowBlock;

@end
