//
//  LNFTabBarController.m
//  iOS_Learning
//
//  Created by MrLiu on 05/12/2017.
//  Copyright © 2017 interstellar. All rights reserved.
//

#import "LNFTabBarController.h"
#import "LNFMainModuleVc.h"

@interface LNFTabBarController ()

@end

@implementation LNFTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureUI];
}

#pragma mark - Private Method
- (void)configureUI
{
    LNFNavigationVc *firstNavVc = [[LNFNavigationVc alloc] initWithRootViewController:[[LNFMainModuleVc alloc] init]];
    firstNavVc.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:62017];
    self.viewControllers = @[firstNavVc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
