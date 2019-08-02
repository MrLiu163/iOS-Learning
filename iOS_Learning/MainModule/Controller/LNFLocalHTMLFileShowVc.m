//
//  LNFLocalHTMLFileShowVc.m
//  iOS_Learning
//
//  Created by mrliu on 2019/8/1.
//  Copyright © 2019 interstellar. All rights reserved.
//

#import "LNFLocalHTMLFileShowVc.h"
#import <WebKit/WebKit.h>

@interface LNFLocalHTMLFileShowVc ()

@property (nonatomic, strong) WKWebView *showWebView;

@end

@implementation LNFLocalHTMLFileShowVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    self.navigationItem.title = @"本地HTML文件";
    
    WKWebView *showWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:showWebView];
    [showWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    
    if (@available(iOS 9.0, *)) {
        NSURL *url = [NSURL fileURLWithPath:self.htmlFilePath];
        [showWebView loadFileURL:url allowingReadAccessToURL:url];
    } else {
        // Fallback on earlier versions
    }
    self.showWebView = showWebView;
}

@end
