//
//  LNFAppHelper.h
//  iOS_Learning
//
//  Created by MrLiu on 05/12/2017.
//  Copyright © 2017 interstellar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface LNFAppHelper : NSObject

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) AFHTTPSessionManager *netManager;
@property (nonatomic, copy) NSString *openidStr;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, strong) AppDelegate *appDelegate;
/** 单例创建 */
+ (LNFAppHelper *)shareAppHelper;

/** 土司Window */
+ (UIWindow *)toastWindow;

/** KeyWindow */
+ (UIWindow *)keyWindow;

/** 设置根视图 */
+ (void)setRootViewController;

/** 当前控制器视图 */
+ (UIView *)currentViewControllerView;

/** 拨打电话 */
+ (void)callTelNum:(NSString *)telNum;

/** 当前导航控制器 */
+ (UINavigationController *)currentNavController;

/** 检测身份证号码合法性 */
+ (BOOL)checkIdentifierWhetherReally:(NSString *)identifierStr;

/** 验证用户指纹权限 */
+ (void)checkUserAuthorityByFingerprint;

@end
