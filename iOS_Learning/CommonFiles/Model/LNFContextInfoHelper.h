//
//  LNFContextInfoHelper.h
//  iOS_Learning
//
//  Created by mrliu on 2019/7/31.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNFContextInfoHelper : NSObject

/** 设备名称 e.g. iPhone Xʀ */
+ (NSString *)deviceName;

/** 设备系统名称 e.g. iOS */
+ (NSString *)deviceSystemName;

/** 设备系统版本 e.g. */
+ (NSString *)deviceSystemVersion;

/** 设备型号 e.g. iPhone */
+ (NSString *)deviceModel;

/** 设备地方型号（国际化区域名称）e.g. iPhone */
+ (NSString *)deviceLocalizedModel;

/** 设备电池电量 e.g. 0.0(没电)或0.8(80%)或1.0(满电)或正在充电或已充满或无法识别 */
+ (NSString *)deviceBatteryLevel;

/** App名称 e.g. 童库 */
+ (NSString *)appDisplayName;

/** App版本 e.g. 1.7.0 */
+ (NSString *)appVersion;

/** App Build版本 e.g. 2.0 */
+ (NSString *)appBuild;

/** 屏幕大小 e.g. */
+ (CGSize)screenSize;

/** 屏幕像素密度 e.g. 1或2或3 */
+ (CGFloat)screenScale;

@end

NS_ASSUME_NONNULL_END
