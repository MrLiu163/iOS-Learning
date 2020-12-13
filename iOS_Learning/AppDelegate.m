//
//  AppDelegate.m
//  iOS_Learning
//
//  Created by MrLiu on 05/12/2017.
//  Copyright © 2017 interstellar. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

// !!!:Test
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier keepTaskId;
@property (nonatomic, strong) NSTimer *keepTimer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.tag = kLNFKeyWindowTag;
    
    // 开启电池电量电量监控
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    // 电池条颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 状态栏网络请求标识
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // 设置根视图
    [LNFAppHelper setRootViewController];
    
    kLNFLog(@"---->>>> %@", NSHomeDirectory());
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // !!!:Test
    self.keepTaskId = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台时间用完的时候调用这个block
        // 此时我们需要结束后台任务，
        [self endKeepTask];
    }];
    [self.keepTimer invalidate];
    self.keepTimer = nil;
    self.keepTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(keepTimerTask:) userInfo:nil repeats:YES];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.keepTimer invalidate];
    self.keepTimer = nil;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// 停止keep timer
- (void)endKeepTask
{
    if (self.keepTimer || self.keepTimer.isValid) {
        [self.keepTimer invalidate];
        self.keepTimer = nil;
        // 结束后台任务
        [[UIApplication sharedApplication] endBackgroundTask:self.keepTaskId];
        self.keepTaskId = UIBackgroundTaskInvalid;
        kLNFLog(@"---->>>>%@", @"停止Timer");
    }
}
// 模拟任务
- (void)keepTimerTask:(NSTimer *)timer
{
    // 系统预留时间
    NSTimeInterval timeInterval = [[UIApplication sharedApplication] backgroundTimeRemaining];
    kLNFLog(@"---->>>>距离系统处理时间=%.2f", timeInterval);
}


@end
