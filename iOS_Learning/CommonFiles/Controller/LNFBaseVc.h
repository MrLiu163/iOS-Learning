//
//  LNFBaseVc.h
//  iOS_Learning
//
//  Created by MrLiu on 05/12/2017.
//  Copyright © 2017 interstellar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNFNetworkingHelper;
typedef void(^NavTapAction)(UIBarButtonItem *item);
@interface LNFBaseVc : UIViewController

/** 网络请求管理者 */
@property (nonatomic, strong) LNFNetworkingHelper *manager;

/** 添加导航栏右边按钮(图片) */
- (void)addRightItemWithImageName:(NSString *)imageName tapAction:(NavTapAction)tapAction;
/** 添加导航栏右边按钮(文字) */
- (void)addRightItemWithTitle:(NSString *)title tapAction:(NavTapAction)tapAction;
/** 添加导航栏左边返回按钮(图片) */
- (void)addBackBtnItemWithImageName:(NSString *)imageName;
/** 添加导航栏左边返回按钮(文字) */
- (void)addBackBtnItemWithBackTitle:(NSString *)backTitle;
/** 添加导航栏左边返回按钮(图片+文字) */
- (void)addBackBtnItemWithImageName:(NSString *)imageName backTitle:(NSString *)backTitle;


/** 点击左边返回 */
- (void)backTapAction;

@end
