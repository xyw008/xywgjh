//
//  MoreNewVC.m
//  Find lawyer
//
//  Created by leo on 14-10-20.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "MoreNewVC.h"

@interface MoreNewVC ()
{
    UIWebView           *_webView;
}
@end

@implementation MoreNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initWebView
{
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [_webView loadRequest:nil];
}


@end
