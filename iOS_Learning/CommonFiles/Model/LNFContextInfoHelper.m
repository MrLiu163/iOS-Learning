//
//  LNFContextInfoHelper.m
//  iOS_Learning
//
//  Created by mrliu on 2019/7/31.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFContextInfoHelper.h"

@implementation LNFContextInfoHelper

/** 设备名称 e.g. iPhone Xʀ */
+ (NSString *)deviceName
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceName = [device name];
    return deviceName;
}

/** 设备系统名称 e.g. iOS */
+ (NSString *)deviceSystemName
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceSystemName = [device systemName];
    return deviceSystemName;
}

/** 设备系统版本 e.g. */
+ (NSString *)deviceSystemVersion
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceSysVersion = [device systemVersion];
    return deviceSysVersion;
}

/** 设备型号 e.g. iPhone */
+ (NSString *)deviceModel
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceModel = [device model];
    return deviceModel;
}

/** 设备地方型号（国际化区域名称）e.g. iPhone */
+ (NSString *)deviceLocalizedModel
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceLocalizedModel = [device localizedModel];
    return deviceLocalizedModel;
}

/** 设备电池电量 e.g. 0.0(没电)或0.8(80%)或1.0(满电)或正在充电或已充满或无法识别 */
+ (NSString *)deviceBatteryLevel
{
    UIDeviceBatteryState batteryState = [UIDevice currentDevice].batteryState; // 模拟器一般就是UIDeviceBatteryStateUnknown
    NSString *batteryStateStr = @"";
    if (UIDeviceBatteryStateUnknown != batteryState) { // 不是模拟器或者坏手机
        float batteryLevel = [UIDevice currentDevice].batteryLevel; // 0.0 ~ 1.0
        batteryStateStr = [NSString stringWithFormat:@"%@", @(batteryLevel)];
        if (UIDeviceBatteryStateCharging == batteryState) { // 不在充电状态下
            batteryStateStr = [batteryStateStr stringByAppendingString:@"正在充电"];
        } else if (UIDeviceBatteryStateFull == batteryState) {
            batteryStateStr = [batteryStateStr stringByAppendingString:@"正在充电，已充满"];
        }
    } else {
        batteryStateStr = @"无法识别";
    }
    return batteryStateStr;
}

/** App名称 e.g. 童库 */
+ (NSString *)appDisplayName
{
    NSDictionary *bundleInfoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appDisplayName = [bundleInfoDict objectForKey:@"CFBundleDisplayName"];
    return appDisplayName;
}

/** App版本 e.g. 1.7.0 */
+ (NSString *)appVersion
{
    NSDictionary *bundleInfoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [bundleInfoDict objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

/** App Build版本 e.g. 2.0 */
+ (NSString *)appBuild
{
    NSDictionary *bundleInfoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appBuild = [bundleInfoDict objectForKey:@"CFBundleVersion"];
    return appBuild;
}

/** 屏幕大小 e.g. */
+ (CGSize)screenSize
{
    UIScreen *screen = [UIScreen mainScreen];
    CGSize screenSize = [screen bounds].size;
    return screenSize;
}

/** 屏幕像素密度 e.g. 1或2或3 */
+ (CGFloat)screenScale
{
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat screenScale = [screen scale];
    return screenScale;
}


@end
