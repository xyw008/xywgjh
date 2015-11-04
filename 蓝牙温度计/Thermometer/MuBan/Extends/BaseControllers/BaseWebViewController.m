//
//  BaseWebViewController.m
//  Sephome
//
//  Created by swift on 15/1/18.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "BaseWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface BaseWebViewController () <UIWebViewDelegate>
{
    UIWebView               *_webView;
    UIBarButtonItem         *_activityItem;
    
    WebViewJavascriptBridge *_bridge;
    NSURL                   *_url;
}

@end

@implementation BaseWebViewController

- (id)initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
        
        _url = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialization];
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:_navTitleStr];
}

- (void)getNetworkData
{
    [[NetRequestManager sharedInstance] sendRequest:_url
                                       parameterDic:nil
                                         requestTag:1000
                                           delegate:self
                                           userInfo:nil];
}

- (void)initialization
{
    if (_url)
    {
        _webView = InsertWebView(self.view, self.view.bounds, self, 1000);
        [_webView keepAutoresizingInFull];
        
        if (!_isSelfRequest)
        {
            [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
        }
        else
        {
            [self getNetworkData];
        }
        
        [WebViewJavascriptBridge enableLogging];
        
        _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"ObjC received message from JS: %@", data);
            responseCallback(@"Response for message from ObjC");
        }];
        
        [_bridge registerHandler:@"productJSBack" handler:^(id data, WVJBResponseCallback responseCallback) {
            /*
             NSLog(@"testObjcCallback called: %@", data);
             responseCallback(@"Response from testObjcCallback");
             */
            /*
            NSNumber *productId = [data safeObjectForKey:@"productID"];
            
            ProductDetailVC *productDetail = [[ProductDetailVC alloc] initWithProductId:productId];
            [self pushViewController:productDetail];
             */
        }];
        
        // activityIndicatorView
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [spinner startAnimating];
        _activityItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    }
}

- (UIWebView *)theWebView
{
    return _webView;
}

- (void)backViewController
{
    if ([_webView canGoBack])
    {
        [_webView goBack];
    }
    else
    {
        [super backViewController];
    }
}

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
    if (!self.navigationItem.rightBarButtonItem)
    {
        [self.navigationItem setRightBarButtonItem:_activityItem animated:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    if (self.navigationItem.rightBarButtonItem == _activityItem)
    {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad:webView];
}

#pragma mark - NetRequestDelegate methods

- (void)netRequestDidStarted:(NetRequest *)request
{
    if (!self.navigationItem.rightBarButtonItem)
    {
        [self.navigationItem setRightBarButtonItem:_activityItem animated:YES];
    }
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    if (self.navigationItem.rightBarButtonItem == _activityItem)
    {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
    
    if (request.tag == 1000)
    {
        NSString *htmlStr = [infoObj safeObjectForKey:@"detail"];
        
        [_webView loadHTMLString:htmlStr baseURL:NO];
    }
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    DLog(@"error = %@", error);
    
    [super netRequest:request failedWithError:error];
    
    if (self.navigationItem.rightBarButtonItem == _activityItem)
    {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

@end
