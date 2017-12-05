//
//  LNFNavigationVc.m
//  iOS_Learning
//
//  Created by liuningfei on 05/12/2017.
//  Copyright © 2017 interstellar. All rights reserved.
//

#import "LNFNavigationVc.h"

@interface LNFNavigationVc () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation LNFNavigationVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavBarStyle];
    
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}

- (void)setNavBarStyle
{
    // 设置导航栏主题
    UINavigationBar *navBar = self.navigationBar;
    navBar.translucent = NO;
    // 设置导航栏颜色
    [navBar setBarTintColor:kLNFThemeBlueColor];
    // 设置导航栏上item颜色
    [navBar setTintColor:[UIColor whiteColor]];
    
    NSDictionary *attris = @{NSFontAttributeName:kLNFSystemFont18, NSForegroundColorAttributeName:[UIColor whiteColor]};
    [navBar setTitleTextAttributes:attris];
    
    // 去掉导航栏下边黑线
    [navBar  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[[UIImage alloc] init]];
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    } else {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
