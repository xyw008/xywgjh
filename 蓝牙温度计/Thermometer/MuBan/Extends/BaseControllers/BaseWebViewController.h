//
//  BaseWebViewController.h
//  Sephome
//
//  Created by swift on 15/1/18.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "BaseNetworkViewController.h"

@interface BaseWebViewController : BaseNetworkViewController <UIWebViewDelegate>

@property (nonatomic, copy)             NSString *navTitleStr;
@property (nonatomic, assign) BOOL      isSelfRequest;           // default is NO(如果为NO则是webView直接加载URL,否则请求自己服务器的接口返回HTML的富文本然后再用webView加载)
@property (nonatomic, readonly, strong) UIWebView *webView;

- (id)initWithUrl:(NSURL *)url;

@end
