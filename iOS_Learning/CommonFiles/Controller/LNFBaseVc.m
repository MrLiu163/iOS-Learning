//
//  LNFBaseVc.m
//  iOS_Learning
//
//  Created by liuningfei on 05/12/2017.
//  Copyright © 2017 interstellar. All rights reserved.
//

#import "LNFBaseVc.h"

@interface LNFBaseVc ()

@property (nonatomic, copy) NavTapAction navRightAction;

@end

@implementation LNFBaseVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonConfigure];
}

- (void)commonConfigure
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.navigationController.viewControllers.count > 1) {
        [self addBackBtnItemWithImageName:kLNFCommonLeftBackNavItemPictureName];
    }
}

/** 添加导航栏右边按钮(图片) */
- (void)addRightItemWithImageName:(NSString *)imageName tapAction:(NavTapAction)tapAction
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navRightBtnAction:)];
    self.navRightAction = tapAction;
}

/** 添加导航栏右边按钮(文字) */
- (void)addRightItemWithTitle:(NSString *)title tapAction:(NavTapAction)tapAction
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(navRightBtnAction:)];
    self.navRightAction = tapAction;
}

/** 添加导航栏左边返回按钮(图片) */
- (void)addBackBtnItemWithImageName:(NSString *)imageName
{
    imageName = imageName ? imageName : kLNFCommonLeftBackNavItemPictureName;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 15, 20);
    [backBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backTapAction) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIView *backContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backContentView];
    [backContentView addSubview:backBtn];
    CGPoint center = backBtn.center;
    center.y = backContentView.center.y;
    backBtn.center = center;
    UITapGestureRecognizer *backContentTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapAction)];
    [backContentView addGestureRecognizer:backContentTapGesture];
    
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(backTapAction)];
    //    self.navRightAction = tapAction;
}

/** 添加导航栏左边返回按钮(文字) */
- (void)addBackBtnItemWithBackTitle:(NSString *)backTitle
{
    backTitle = backTitle ? : @"取消";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.titleLabel.font = kLNFSystemFont16;
    backBtn.frame = CGRectMake(0, 0, 40, 21);
    [backBtn setTitle:backTitle forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backTapAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

/** 添加导航栏左边返回按钮(图片+文字) */
- (void)addBackBtnItemWithImageName:(NSString *)imageName backTitle:(NSString *)backTitle
{
    imageName = imageName ? imageName : @"backBtn";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 55, 20);
    [backBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    backTitle = backTitle ? backTitle : @"返回";
    backBtn.titleLabel.font = kLNFSystemFont16;
    [backBtn setTitle:backTitle forState:UIControlStateNormal];
    [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(backTapAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

#pragma mark - 私有方法
// 右边按钮点击
- (void)navRightBtnAction:(UIBarButtonItem *)item
{
    if (self.navRightAction) {
        self.navRightAction(item);
    }
}

// 返回按钮点击
- (void)backTapAction
{
    NSInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 重写dealloc
- (void)dealloc
{
    kLNFLog(@"---->>>>%@销毁了", self);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
