//
//  LNFAppHelper.m
//  iOS_Learning
//
//  Created by MrLiu on 05/12/2017.
//  Copyright © 2017 interstellar. All rights reserved.
//

#import "LNFAppHelper.h"
#import <LocalAuthentication/LocalAuthentication.h> // 指纹验证
#import <UserNotifications/UserNotifications.h>

@interface LNFAppHelper () <UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *pushMessageAlert;
@property (nonatomic, strong) NSDictionary *userInfo; // 推送消息的信息

@end

@implementation LNFAppHelper

/** 单例创建 */
+ (LNFAppHelper *)shareAppHelper
{
    static LNFAppHelper *single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[self alloc] init];
    });
    return single;
}

/** 设置根视图 */
+ (void)setRootViewController
{
    LNFTabBarController *rootViewController = [[LNFTabBarController alloc] init];
    [self keyWindow].rootViewController = rootViewController;
}

// toastWindow
+ (UIWindow *)toastWindow
{
    return [UIApplication sharedApplication].windows.firstObject;
}

// 主窗口
+ (UIWindow *)keyWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (window.tag != kLNFKeyWindowTag)
    {
        NSArray<UIWindow *> *windows = [UIApplication sharedApplication].windows;
        // 遍历找window
        for (UIWindow *win in windows)
        {
            if (kLNFKeyWindowTag == win.tag)
            {
                window = win;
                break;
            }
        }
    }
    return window;
}

// 拨打电话
+ (void)callTelNum:(NSString *)telNum
{
    NSString *telNumStr = [NSString stringWithFormat:@"tel://%@", telNum];
    NSURL *url = [NSURL URLWithString:telNumStr];
    [[UIApplication sharedApplication] openURL:url];
}

/** 当前导航控制器 */
+ (UINavigationController *)currentNavController
{
    UIViewController *rootVc = [self keyWindow].rootViewController;
    if (rootVc.presentedViewController) {
        rootVc = rootVc.presentedViewController;
        if ([rootVc isKindOfClass:[UINavigationController class]]) {
            rootVc = [(UINavigationController *)rootVc visibleViewController];
            return rootVc.navigationController;
        }
    } else {
        if ([rootVc isKindOfClass:[LNFTabBarController class]]) {
            rootVc = [(LNFTabBarController *)rootVc selectedViewController];
            return (UINavigationController *)rootVc;
        } else if ([rootVc isKindOfClass:[LNFNavigationVc class]]) {
            return (UINavigationController *)rootVc;
        }
    }
    return nil;
}
/** 当前控制器视图 */
+ (UIView *)currentViewControllerView
{
    return [self currentNavController].topViewController.view;
}
/** 电池条样式 */
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    [UIApplication sharedApplication].statusBarStyle = statusBarStyle;
}


/**
 *
 * 1、将前面的身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。
 2、将这17位数字和系数相乘的结果相加。
 3、用加出来和除以11，看余数是多少？
 4、余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字。其分别对应的最后一位身份证的号码为1－0－X －9－8－7－6－5－4－3－2。(即馀数0对应1，馀数1对应0，馀数2对应X...)
 5、通过上面得知如果余数是3，就会在身份证的第18位数字上出现的是9。如果对应的数字是2，身份证的最后一位号码就是罗马数字x。
 例如：某男性的身份证号码为【53010219200508011x】， 我们看看这个身份证是不是合法的身份证。
 首先我们得出前17位的乘积和【(5*7)+(3*9)+(0*10)+(1*5)+(0*8)+(2*4)+(1*2)+(9*1)+(2*6)+(0*3)+(0*7)+(5*9)+(0*10)+(8*5)+(0*8)+(1*4)+(1*2)】是189，然后用189除以11得出的结果是189/11=17----2，也就是说其余数是2。最后通过对应规则就可以知道余数2对应的检验码是X。所以，可以判定这是一个正确的身份证号码。
 */
/** 检测身份证号码合法性 */
+ (BOOL)checkIdentifierWhetherReally:(NSString *)identifierStr
{
    if (identifierStr.length == 18) {
        NSInteger int1 = [[identifierStr substringWithRange:NSMakeRange(0, 1)] integerValue];
        NSInteger int2 = [[identifierStr substringWithRange:NSMakeRange(1, 1)] integerValue];
        NSInteger int3 = [[identifierStr substringWithRange:NSMakeRange(2, 1)] integerValue];
        NSInteger int4 = [[identifierStr substringWithRange:NSMakeRange(3, 1)] integerValue];
        NSInteger int5 = [[identifierStr substringWithRange:NSMakeRange(4, 1)] integerValue];
        NSInteger int6 = [[identifierStr substringWithRange:NSMakeRange(5, 1)] integerValue];
        NSInteger int7 = [[identifierStr substringWithRange:NSMakeRange(6, 1)] integerValue];
        NSInteger int8 = [[identifierStr substringWithRange:NSMakeRange(7, 1)] integerValue];
        NSInteger int9 = [[identifierStr substringWithRange:NSMakeRange(8, 1)] integerValue];
        NSInteger int10 = [[identifierStr substringWithRange:NSMakeRange(9, 1)] integerValue];
        NSInteger int11 = [[identifierStr substringWithRange:NSMakeRange(10, 1)] integerValue];
        NSInteger int12 = [[identifierStr substringWithRange:NSMakeRange(11, 1)] integerValue];
        NSInteger int13 = [[identifierStr substringWithRange:NSMakeRange(12, 1)] integerValue];
        NSInteger int14 = [[identifierStr substringWithRange:NSMakeRange(13, 1)] integerValue];
        NSInteger int15 = [[identifierStr substringWithRange:NSMakeRange(14, 1)] integerValue];
        NSInteger int16 = [[identifierStr substringWithRange:NSMakeRange(15, 1)] integerValue];
        NSInteger int17 = [[identifierStr substringWithRange:NSMakeRange(16, 1)] integerValue];
        NSInteger int18 = 0;
        if ([[identifierStr substringWithRange:NSMakeRange(17, 1)] isEqualToString:@"X"] || [[identifierStr substringWithRange:NSMakeRange(17, 1)] isEqualToString:@"x"]) {
            int18 = 10;
        } else {
            int18 = [[identifierStr substringWithRange:NSMakeRange(17, 1)] integerValue];
        }
        NSInteger sum = int1 * 7 + int2 * 9 + int3 * 10 + int4 * 5 + int5 * 8 + int6 * 4 + int7 * 2 + int8 * 1 + int9 * 6 + int10 * 3 + int11 * 7 + int12 * 9 + int13 * 10 + int14 * 5 + int15 * 8 + int16 * 4 + int17 * 2;
        sum = sum < 11 ? sum + 11 : sum;
        NSInteger remainder = sum % 11;
        BOOL success = NO;
        switch (remainder) {
                // 1－0－X －9－8－7－6－5－4－3－2。
            case 0:
                if (1 == int18) {
                    success = YES;
                }
                break;
            case 1:
                if (0 == int18) {
                    success = YES;
                }
                break;
            case 2:
                if (10 == int18) {
                    success = YES;
                }
                break;
            case 3:
                if (9 == int18) {
                    success = YES;
                }
                break;
            case 4:
                if (8 == int18) {
                    success = YES;
                }
                break;
            case 5:
                if (7 == int18) {
                    success = YES;
                }
                break;
            case 6:
                if (6 == int18) {
                    success = YES;
                }
                break;
            case 7:
                if (5 == int18) {
                    success = YES;
                }
                break;
            case 8:
                if (4 == int18) {
                    success = YES;
                }
                break;
            case 9:
                if (3 == int18) {
                    success = YES;
                }
                break;
            case 10:
                if (2 == int18) {
                    success = YES;
                }
                break;
            default:
                break;
        }
        return success;
    } else {
        return NO;
    }
}

/** 验证用户指纹权限 */
+ (void)checkUserAuthorityByFingerprint
{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"通过Home键验证已有手机指纹";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
            if (success) {
                // User authenticated successfully, take appropriate action
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 回调或者说是通知主线程刷新
                    [[[UIAlertView alloc] initWithTitle:kLNFUserSelectOptionStr_Title message:@"验证成功" cancelButtonItem:[LNFButtonItem itemWithLabel:kLNFUserSelectOptionStr_Ensure] otherButtonItems: nil] show];
                });
            } else {
                // User did not authenticate successfully, look at error and take appropriate action
                [self dealWithUserAuthorityByFingerprintError:error];
            }
        }];
    } else {
        // Could not evaluate policy; look at authError and present an appropriate message to user
        [self dealWithUserAuthorityByFingerprintError:authError];
    }
}

// 判断用户是否开启APNS推送权限
+ (void)getNotificationAuthorizationStatus
{
    // 检查手机是否开启推送权限
    if (@available(iOS 10, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (UNAuthorizationStatusDenied == settings.authorizationStatus) {
                
            } else if (UNAuthorizationStatusAuthorized == settings.authorizationStatus) {
                [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    
                }];
            } else if (UNAuthorizationStatusNotDetermined == settings.authorizationStatus) {
                
            }
        }];
    } else if (@available(iOS 8, *)) {
        UIUserNotificationSettings *notiSetting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (notiSetting.types == UIUserNotificationTypeNone) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
        
    } else {
        UIRemoteNotificationType notiType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (notiType == UIUserNotificationTypeNone) {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound];
        }
    }
}

#pragma mark - Private Method
// 根据指纹验证错误进行提示处理
+ (void)dealWithUserAuthorityByFingerprintError:(NSError *)error
{
    NSString *errroMessage = @"";
    switch (error.code) {
        case LAErrorAuthenticationFailed:
            errroMessage = @"授权失败，指纹不对";
            break;
        case LAErrorUserCancel:
            errroMessage = @"用户点击了取消验证";
            break;
        case LAErrorUserFallback: // ???
            errroMessage = @"授权撤回";
            break;
        case LAErrorSystemCancel:
            errroMessage = @"系统取消了授权,其他应用切入";
            break;
        case LAErrorPasscodeNotSet:
            errroMessage = @"没有设置密码";
            break;
        case LAErrorTouchIDNotAvailable:
            errroMessage = @"用户没有开启指纹验证";
            break;
        case LAErrorTouchIDNotEnrolled:
            errroMessage = @"没有录入Touch ID指纹";
            break;
        case LAErrorTouchIDLockout:
            errroMessage = @"Touch ID被锁，需要用户输入密码";
            break;
        case LAErrorAppCancel:
            errroMessage = @"用户不能控制情况下APP被挂起";
            break;
        case LAErrorInvalidContext:
            errroMessage = @"LAContext 传给这次调用之前已经失效";
            break;
        default:
            break;
    }
    // 通知主线程刷新
    if ([[NSThread currentThread].name isEqualToString:[NSThread mainThread].name]) { // 是主线程
        [[[UIAlertView alloc] initWithTitle:kLNFUserSelectOptionStr_Title message:errroMessage cancelButtonItem:[LNFButtonItem itemWithLabel:kLNFUserSelectOptionStr_Ensure] otherButtonItems: nil] show];
    } else { // 子线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:kLNFUserSelectOptionStr_Title message:errroMessage cancelButtonItem:[LNFButtonItem itemWithLabel:kLNFUserSelectOptionStr_Ensure] otherButtonItems: nil] show];
        });
    }
}


@end
